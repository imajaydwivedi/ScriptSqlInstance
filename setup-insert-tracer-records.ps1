$Distributor = 'sqlrepl1'
$DistributionDb = 'distribution'

$tsqlGetPublications = @"
IF OBJECT_ID('tempdb..#publications') IS NOT NULL
	DROP TABLE #publications;
select srv.srvname as publisher, pl.publisher_id, pl.publisher_db, pl.publication, pl.publication_id, 
		pl.publication_type, case pl.publication_type when 0 then 'Transactional' when 1 then 'Snapshot' when 2 then 'Merge' else 'No idea' end as publication_type_desc, 
		pl.immediate_sync, pl.allow_pull, pl.allow_push, pl.description,
		pl.vendor_name, pl.sync_method, pl.allow_initialize_from_backup
into #publications
from dbo.MSpublications pl (nolock) join MSreplservers srv on srv.srvid = publisher_id
order by srv.srvname, pl.publisher_db;

if object_id('tempdb..#subscriptions') is not null
	drop table #subscriptions;
select distinct srv.srvname as subscriber, sub.subscriber_id, sub.subscriber_db, 
		sub.subscription_type, case sub.subscription_type when 0 then 'Push' when 1 then 'Pull' else 'Anonymous' end as subscription_type_desc,
		sub.publication_id, sub.publisher_db, 
		sub.sync_type, (case sub.sync_type when 1 then 'Automatic' when 2 then 'No synchronization' else 'No Idea' end) as sync_type_desc, 
		sub.status, (case sub.status when 0 then 'Inactive' when 1 then 'Subscribed' when 2 then 'Active' else 'No Idea' end) as status_desc
into #subscriptions
from dbo.MSsubscriptions sub (nolock) join dbo.MSreplservers srv on srv.srvid = sub.subscriber_id
where sub.subscriber_id >= 0;

select pl.publisher, pl.publisher_db, pl.publication, pl.publication_type_desc, sb.subscriber, sb.subscriber_db, sb.subscription_type_desc, sb.sync_type_desc, sb.status_desc
from #publications pl join #subscriptions sb on sb.publication_id = pl.publication_id and sb.publisher_db = pl.publisher_db
order by pl.publisher, pl.publisher_db, sb.subscriber, sb.subscriber_db, pl.publication;
"@

Write-Host "Get publication list for distributor [$Distributor]" -ForegroundColor Cyan
$resultGetPublications = Invoke-Sqlcmd -ServerInstance $Distributor -Database $DistributionDb -Query $tsqlGetPublications
$resultGetPublications | ogv -Title "All publications"

$publishers = $resultGetPublications | Select-Object -ExpandProperty publisher -Unique


# Insert tracer token for each publisher
$tsqlInsertToken = @"
DECLARE @publication AS sysname;
DECLARE @tokenID AS int;
SET @publication = @p_publication; 

-- Insert a new tracer token in the publication database.
EXEC sys.sp_posttracertoken 
  @publication = @publication,
  @tracer_token_id = @tokenID OUTPUT;

SELECT @@SERVERNAME as [publisher], DB_NAME() as publisher_db, getdate() as [current_time], @publication as publication, @tokenID as tokenID;
"@

Write-Host "Insert tracer token using [sp_posttracertoken]" -ForegroundColor Cyan; 
[System.Collections.ArrayList]$tokenInserted = @()
foreach($srv in $publishers)
{
    Write-Host "Looping through publications of server [$srv]" -ForegroundColor Yellow
    $srvPublications = $resultGetPublications | Where-Object {$_.publisher -eq $srv}
    $pubSrvObj = Connect-DbaInstance -SqlInstance $srv
    foreach($pub in $srvPublications)
    {
        $resultInsertToken = Invoke-DbaQuery -SqlInstance $pubSrvObj -Database $pub.publisher_db -Query $tsqlInsertToken -SqlParameters @{ p_publication = $($pub.publication)}
        $tokenInserted.Add($resultInsertToken) | Out-Null
    }
}
$tokenInserted | ogv -Title "Tokens inserted"

Write-Host "Sleep for 20 seconds" -ForegroundColor Cyan
Start-Sleep -Seconds 20

# Get token history
$tsqlGetTokenHistory = @"
DECLARE @publication AS sysname;
DECLARE @tokenID AS int;
SET @publication = @p_publication;
SET @tokenID = @p_tokenID

IF OBJECT_ID('tempdb..#tokens') IS NOT NULL
	DROP TABLE #tokens
CREATE TABLE #tokens (tracer_id int, publisher_commit datetime);

-- Return tracer token information to a temp table.
INSERT #tokens (tracer_id, publisher_commit)
EXEC sys.sp_helptracertokens @publication = @publication;

IF OBJECT_ID('tempdb..#tokenhistory') IS NOT NULL
	DROP TABLE #tokenhistory;
CREATE TABLE #tokenhistory (distributor_latency bigint, subscriber sysname, subscriber_db sysname, subscriber_latency bigint, overall_latency bigint);

-- Get history for the tracer token.
INSERT #tokenhistory
EXEC sys.sp_helptracertokenhistory 
  @publication = @publication, 
  @tracer_id = @tokenID;

IF EXISTS (SELECT * FROM #tokenhistory)
BEGIN
	select 'success' as status, @@SERVERNAME as [publisher], DB_NAME() as publisher_db, h.subscriber, h.subscriber_db, @publication as publication, @tokenID as tokenID, getdate() as [current_time], t.publisher_commit, h.distributor_latency, h.subscriber_latency, h.overall_latency
	from #tokenhistory as h join #tokens t on t.tracer_id = @tokenID
END
ELSE
BEGIN
	DECLARE @o_tokenID int
	SET @o_tokenID = (SELECT TOP 1 tracer_id FROM #tokens ORDER BY publisher_commit DESC)
	INSERT #tokenhistory
	EXEC sys.sp_helptracertokenhistory 
				  @publication = @publication, 
				  @tracer_id = @o_tokenID;

	select 'failure' as status, @@SERVERNAME as [publisher], DB_NAME() as publisher_db, h.subscriber, h.subscriber_db, @publication as publication, @o_tokenID as tokenID, getdate() as [current_time], t.publisher_commit, h.distributor_latency, h.subscriber_latency, h.overall_latency
	from #tokenhistory as h join #tokens t on t.tracer_id = @o_tokenID
END
"@

Write-Host "Fetch tracer token history" -ForegroundColor Cyan
[System.Collections.ArrayList]$tokenHistory = @()
foreach($srv in $publishers)
{
    Write-Host "Looping through publications of server [$srv]" -ForegroundColor Yellow
    $srvPublications = $tokenInserted | Where-Object {$_.publisher -eq $srv}
    $pubSrvObj = Connect-DbaInstance -SqlInstance $srv
    foreach($pub in $srvPublications)
    {
        $resultGetTokenHistory = Invoke-DbaQuery -SqlInstance $pubSrvObj -Database $pub.publisher_db -Query $tsqlGetTokenHistory -SqlParameters @{ p_publication = $($pub.publication); p_tokenID = $($pub.tokenID)}
        foreach($row in $resultGetTokenHistory) {
            $tokenHistory.Add($row) | Out-Null
        }
    }
}
$tokenHistory | ogv -Title "Token History"
