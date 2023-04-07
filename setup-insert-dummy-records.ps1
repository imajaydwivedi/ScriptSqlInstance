$Distributor = 'dbtest3ds1ag1agl1'
$DistributionDb = 'DistributionDB'

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

$resultGetPublications = Invoke-Sqlcmd -ServerInstance $Distributor -Database $DistributionDb -Query $tsqlGetPublications
#$resultGetPublications | ogv
$publishers = $resultGetPublications | Select-Object -ExpandProperty publisher -Unique

# Scriptout publications
<#
foreach($srv in $publishers)
{
    Write-Host "Scripting out publications from [$srv]" -ForegroundColor Yellow
    $replScriptOutPath = "C:\temp\Sql2019Upgrade\Replication\$srv"
    if(-not (Test-Path $replScriptOutPath)) {
        New-Item -Path $replScriptOutPath -ItemType Directory -Force | Out-File
    }
    
    powershell.exe -file '\\dba_share\windows\scripts\dba\Replication\script_replication.ps1' `
                   -sql_server $srv `
                   -local_folder $replScriptOutPath `
                   -ErrorAction Stop
}
#>

#$token_remarks = "Token - Post Distribution Agent Stopped - 08"
$token_remarks = "Token - Post SqlUpgrade - Distributor failed over to sqltest3B\DRDS1 - 02"
$tsqlInsertToken = @"
insert dbo.repl_table_01 (remarks)
select '$token_remarks';
"@
foreach($srv in $publishers)
{
    Write-Host "Looping through publications of server [$srv]" -ForegroundColor Yellow
    $srvPublications = $resultGetPublications | Where-Object {$_.publisher -eq $srv}
    foreach($pub in $srvPublications)
    {
        Write-Host "Inserting token in [$srv].[$($pub.publisher_db)].[dbo].[repl_table_01]"
        Invoke-Sqlcmd -ServerInstance $srv -Database $pub.publisher_db -Query $tsqlInsertToken
    }    
}


#$token_remarks = "Token - Post Distribution Agent Stopped - 06"
$token_remarks = "Token - Post LogReader Agent Stopped - 06"
$tsqlUpdateToken = @"
update [dbo].[repl_table_01]
set remarks = '$token_remarks - UPDATED'
where remarks = '$token_remarks'
"@
foreach($srv in $publishers)
{
    Write-Host "Looping through publications of server [$srv]" -ForegroundColor Yellow
    $srvPublications = $resultGetPublications | Where-Object {$_.publisher -eq $srv}
    foreach($pub in $srvPublications)
    {
        Write-Host "Updating token in [$srv].[$($pub.publisher_db)].[dbo].[repl_table_01]"
        Invoke-Sqlcmd -ServerInstance $srv -Database $pub.publisher_db -Query $tsqlUpdateToken
    }    
}


#$token_remarks = "Token - Post Distribution Agent Stopped - 07"
$token_remarks = "Token - Post LogReader Agent Stopped - 07"
$tsqlDeleteToken = @"
delete [dbo].[repl_table_01]
where remarks = '$token_remarks'
"@
foreach($srv in $publishers)
{
    Write-Host "Looping through publications of server [$srv]" -ForegroundColor Yellow
    $srvPublications = $resultGetPublications | Where-Object {$_.publisher -eq $srv}
    foreach($pub in $srvPublications)
    {
        Write-Host "Deleting token in [$srv].[$($pub.publisher_db)].[dbo].[repl_table_01]"
        Invoke-Sqlcmd -ServerInstance $srv -Database $pub.publisher_db -Query $tsqlDeleteToken
    }    
}

<#
declare @c_db_name sysname;
declare @sql nvarchar(400);
declare cur_dbs cursor local forward_only for
	select d.name from sys.databases d where d.name like 'DbaReplSub%';

open cur_dbs
fetch next from cur_dbs into @c_db_name;

while @@FETCH_STATUS = 0
begin
	set @sql = '
use ['+@c_db_name+'];
SELECT top 10 @@SERVERNAME as srv_name, DB_NAME() as [db_name], * FROM [dbo].[repl_table_01]
ORDER BY created_date_subscriber desc, id desc;
'
	exec (@sql);
	fetch next from cur_dbs into @c_db_name;
end
#>


<#

foreach($srv in $subscribers)
{
    #Write-Host "Looping through subscriptions on server [$srv]" -ForegroundColor Yellow
    $srvSubscriptions = $resultGetPublications | Where-Object {$_.subscriber -eq $srv}
    Write-Host "/* Get data on [$srv] */" -ForegroundColor Yellow;
    foreach($sub in $srvSubscriptions)
    {
        @"
select top 4 @@servername as srv_name, '$($sub.subscriber_db)' as [db_name], * from [$($sub.subscriber_db)].[dbo].[repl_table_01] order by id desc;
GO

"@
    }    
}

#>
