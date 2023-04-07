Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; $Error.Clear()
$VerbosePreference = 'SilentlyContinue'
$WarningPreference = 'Continue'
$env:PSModulePath += ';C:\Users\Public\Documents\WindowsPowerShell\Modules'
$dbatools_latestversion = ((Get-Module dbatools -ListAvailable | Sort-Object Version -Descending | select -First 1).Version);
Import-Module dbatools -RequiredVersion $dbatools_latestversion;
Import-Module sqldbatools -DisableNameChecking

$Servers = @('dbrepl1','dbrepl2')
$OutputPath = 'C:\Users\Public\Documents\ProjectWork\sql2019upgrade\ScriptSqlInstance\'

$startTime = Get-Date
$Dtmm = $startTime.ToString('yyyy-MM-dd HH.mm.ss')

if(-not (Test-Path $OutputPath)) {
    New-Item $OutputPath -ItemType Directory -Force | Out-Null
}
Invoke-Item $OutputPath

# Step 01 -> Script out entire instance
foreach($srv in $Servers)
{
    Start-RSJob -Name "ExportDbaInstance-$srv" -ScriptBlock {
        Param($Server, $OutputPath)
        $serverOutputPath = Join-Path $OutputPath $Server
        New-Item $serverOutputPath -ItemType Directory -Force | Out-Null
        Export-DbaInstance -SqlInstance $Server -Exclude Databases -Path $serverOutputPath
    } -ArgumentList $srv, $OutputPath
}
$exportDbaInstanceJobs = Get-RSJob | Where-Object {$_.Name -like 'ExportDbaInstance*'}
$exportDbaInstanceJobs | Wait-RSJob -ShowProgress -Timeout 300


# Step 02 -> Scriptout Linked Servers with Password
foreach($srv in $Servers)
{
    $serverOutputPath = Join-Path $OutputPath $srv
    $serverOutputFilePath = Join-Path $serverOutputPath "LinkedServers_ScripOut_4_$($srv.Replace('\','-')).sql"
    Get-LinkedServer -SqlInstance $srv -ScriptOut -File $serverOutputFilePath -Verbose
}

# Step 03 -> Scriptout replication of Distributor
    # https://www.sqlservercentral.com/articles/script-sql-server-replication-with-powershell
foreach($srv in $Servers)
{
    $replSrvObj = New-Object "Microsoft.SqlServer.Replication.ReplicationServer" $srv
    $serverOutputPath = Join-Path $OutputPath $srv
    if(-not (Test-Path $serverOutputPath)) {
        New-Item $serverOutputPath -ItemType Directory -Force | Out-Null
    }

    if($replSrvObj.IsDistributor)
    {
        # Script out the distributor, distribution database, agent profiles and all jobs hosted in the distributor SQL Instance
        $ScriptOptions = [Microsoft.SqlServer.Replication.ScriptOptions]::Creation `
                -bor [Microsoft.SqlServer.Replication.ScriptOptions]::IncludeAll `
                -bor [Microsoft.SqlServer.Replication.ScriptOptions]::IncludeGo
        $replSrvObj.Script($ScriptOptions) | Out-File (Join-Path $serverOutputPath "repl_distributor_all_scriptout $Dtmm.sql")

        # Scriptout for 'Add Distributor to SQL Server Instance'
        $ScriptOptions = [Microsoft.SqlServer.Replication.ScriptOptions]::Creation `
                -bor [Microsoft.SqlServer.Replication.ScriptOptions]::IncludeGo
        $replSrvObj.ScriptInstallDistributor($srv,$ScriptOptions) `
            | Out-File (Join-Path $serverOutputPath "repl_register_distributor_scriptout $Dtmm.sql")

        # Scriptout distribution database
        $ScriptOptions = [Microsoft.SqlServer.Replication.ScriptOptions]::Creation `
                -bor [Microsoft.SqlServer.Replication.ScriptOptions]::IncludeGo
        $replSrvObj.Script($ScriptOptions) `
            | Out-File (Join-Path $serverOutputPath "repl_register_distributor_scriptout $Dtmm.sql") -Append
    }
    #break;
}


# Step 04 -> Scriptout DENY list
$tsqlDenyConnect = @"
SELECT --pr.principal_id, pr.name, pe.state_desc, pe.permission_name,
	    PermissionStatement = pe.state_desc+' '+pe.permission_name+' TO '+QUOTENAME(pr.name)+';' COLLATE DATABASE_DEFAULT
FROM sys.server_principals pr INNER JOIN sys.server_permissions pe 
  ON pr.principal_id = pe.grantee_principal_id
  WHERE pe.state_desc='DENY'
"@
foreach($srv in $Servers)
{
    $serverOutputPath = Join-Path $OutputPath $srv
    if(-not (Test-Path $serverOutputPath)) {
        New-Item $serverOutputPath -ItemType Directory -Force | Out-Null
    }
    Invoke-DbaQuery -SqlInstance $srv -Query $tsqlDenyConnect | `
            Select-Object -ExpandProperty PermissionStatement | `
                Out-File -FilePath (Join-Path $serverOutputPath "DENY_permissions $Dtmm.sql")
}


# Step 05 -> Script out Availability Group settings
foreach($srv in $Servers)
{
    Write-Host "Scripting out AG for [$srv]" -ForegroundColor Cyan
    $serverOutputPath = Join-Path $OutputPath $srv
    if(-not (Test-Path $serverOutputPath)) {
        New-Item $serverOutputPath -ItemType Directory -Force | Out-Null
    }
    
    $logFile = Join-Path -Path $serverOutputPath -ChildPath "DbaAvailabilityGroups $Dtmm.sql"
    $srvObj = Connect-DbaInstance -SqlInstance $srv
    #$ag = ($srvObj.AvailabilityGroups)[0]
    foreach ($ag in ($srvObj.AvailabilityGroups )){
        $agName = $ag.Name

        "/* Scripting Availability Group [$agName] " | Out-File -FilePath $logFile -Append -Encoding ascii
        $ag | Select-Object -Property * | Out-File -FilePath $logFile -Append -Encoding ascii
        '*/' | Out-File -FilePath $logFile -Append -Encoding ascii

        try {$ag | Export-DbaScript -FilePath $logFile -Append -Encoding ASCII -EnableException}
        catch {
            $ag.Script() | Out-File -FilePath $logFile -Append -Encoding ascii
        }
    }

    #break;
}


# Step 06 -> Script Non-AlwaysOn Databases Configurations (e.g., sandbox, tempdb, txnref_scratchpad)
$NonAgDbsJobs = $Servers | Start-RSJob -Name {"NonAgDbs-$_"} -ScriptBlock {
    Param($OutputPath,$Dtmm)
    $srv = $_
    Import-Module dbatools
    $serverOutputPath = Join-Path $OutputPath $srv
    if(-not (Test-Path $serverOutputPath)) {
        New-Item $serverOutputPath -ItemType Directory -Force | Out-Null
    }
    $srvObj = Connect-DbaInstance -SqlInstance $srv
    $tsqlNonAgDbs = @"
select name
from sys.databases d
where d.replica_id is null
and name not in ('master','model','msdb','distribution')
"@
    $NonAgDbs = Invoke-DbaQuery -SqlInstance $srvObj -Query $tsqlNonAgDbs | Select-Object -ExpandProperty name;
    foreach($db in $NonAgDbs)
    {
        $sqlInst = $srv.Split('\')[0]
        $logFile = Join-Path $serverOutputPath -ChildPath "NonAgDbs__$db $Dtmm.txt"
        $srvObj.Databases[$db].Script() | Out-File -FilePath $logFile -Force -Encoding ascii
    }    
    #"$srv => $serverOutputPath => $Dtmm" | Write-Output
} -ArgumentList $OutputPath,$Dtmm
$NonAgDbsJobs | Wait-RSJob -Timeout (20*60) -ShowProgress
$NonAgDbsJobs | Receive-RSJob
$NonAgDbsJobs | Remove-RSJob
Get-RSJob | Remove-RSJob



# Step 07 -> Save AlwaysOn Databases Configurations/MetaData
$ErrorActionPreference = 'Continue'
foreach($srv in $Servers)
{
    #$srv = $Servers_full_list[0]
    #Start-RSJob -Name "AgConfigMetaData-$srv" -ScriptBlock {
        #Param($srv,$Path)
        Write-Host "Create output path for [$srv]" -ForegroundColor Yellow
        $ExcelDir = (Join-Path $Path $srv)
        if(-not (Test-Path $ExcelDir) ) {
            [system.io.directory]::CreateDirectory($ExcelDir) | Out-Null
        }
        $excelFile = (Join-Path $ExcelDir "AlwaysOnConfigMetaData__$srv`__$Dtmm.xlsx")
        
        Write-Host "execute availability_groups" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.availability_groups' |
            Export-Excel -Path $excelFile -WorksheetName 'availability_groups'

        Write-Host "execute availability_replicas" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.availability_replicas' |
            Export-Excel -Path $excelFile -WorksheetName 'availability_replicas'

        Write-Host "execute availability_read_only_routing_lists" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.availability_read_only_routing_lists' |
            Export-Excel -Path $excelFile -WorksheetName 'availability_read_only_routing_'

        Write-Host "execute databases" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.databases' |
            Export-Excel -Path $excelFile -WorksheetName 'databases'

        Write-Host "execute dm_hadr_availability_group_states" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.dm_hadr_availability_group_states' |
            Export-Excel -Path $excelFile -WorksheetName 'dm_hadr_availability_group_stat'

        Write-Host "execute dm_hadr_availability_replica_states" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.dm_hadr_availability_replica_states' |
            Export-Excel -Path $excelFile -WorksheetName 'dm_hadr_availability_replica_st'

        Write-Host "execute dm_hadr_database_replica_states" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.dm_hadr_database_replica_states' |
            Export-Excel -Path $excelFile -WorksheetName 'dm_hadr_database_replica_states'

        Write-Host "execute dm_hadr_cluster" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.dm_hadr_cluster' |
            Export-Excel -Path $excelFile -WorksheetName 'dm_hadr_cluster'

        Write-Host "execute dm_hadr_cluster_members" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.dm_hadr_cluster_members' |
            Export-Excel -Path $excelFile -WorksheetName 'dm_hadr_cluster_members'

        Write-Host "execute availability_groups_cluster" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.availability_groups_cluster' |
            Export-Excel -Path $excelFile -WorksheetName 'availability_groups_cluster'

        Write-Host "execute dm_tcp_listener_states" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query 'select * from sys.dm_tcp_listener_states' |
            Export-Excel -Path $excelFile -WorksheetName 'dm_tcp_listener_states'

        $tsqlDbConfig = @"
-- Availability Database Configurations
SELECT ag.name AS 'AG Name'
	,ar.replica_server_name AS 'Replica Instance'
	,d.name as 'Database Name'
	,Location = CASE 
		WHEN ar_state.is_local = 1
			THEN N'LOCAL'
		ELSE 'REMOTE'
		END
	,ROLE = CASE 
		WHEN ar_state.role_desc IS NULL
			THEN N'DISCONNECTED'
		ELSE ar_state.role_desc
		END
	,ar_state.connected_state_desc AS 'Connection State'
	,ar.availability_mode_desc AS 'Mode'
	,dr_state.synchronization_state_desc AS 'State'
FROM (
	(
		sys.availability_groups AS ag JOIN sys.availability_replicas AS ar ON ag.group_id = ar.group_id
		) JOIN sys.dm_hadr_availability_replica_states AS ar_state ON ar.replica_id = ar_state.replica_id
	)
JOIN sys.dm_hadr_database_replica_states dr_state ON ag.group_id = dr_state.group_id
	AND dr_state.replica_id = ar_state.replica_id
JOIN sys.databases d ON d.database_id = dr_state.database_id
"@
        Write-Host "execute tsqlDbConfig" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query $tsqlDbConfig |
            Export-Excel -Path $excelFile -WorksheetName 'DbConfig'

        $tsqlDbHealth = @"
-- Availability Database Health States
SELECT ag.name AS 'AG Name'
	,ar.replica_server_name AS 'Replica Instance'
	,dr_state.database_id AS 'Database ID'
	,Location = CASE 
		WHEN ar_state.is_local = 1
			THEN N'LOCAL'
		ELSE 'REMOTE'
		END
	,ROLE = CASE 
		WHEN ar_state.role_desc IS NULL
			THEN N'DISCONNECTED'
		ELSE ar_state.role_desc
		END
	,dr_state.log_send_queue_size AS 'Log Send Queue Size'
	,dr_state.redo_queue_size AS 'Redo Queue Size'
	,dr_state.log_send_rate AS 'Log Send Rate'
	,dr_state.redo_rate AS 'Redo Rate'
FROM (
	(
		sys.availability_groups AS ag JOIN sys.availability_replicas AS ar ON ag.group_id = ar.group_id
		) JOIN sys.dm_hadr_availability_replica_states AS ar_state ON ar.replica_id = ar_state.replica_id
	)
JOIN sys.dm_hadr_database_replica_states dr_state ON ag.group_id = dr_state.group_id
	AND dr_state.replica_id = ar_state.replica_id;
"@
        Write-Host "execute tsqlDbHealth" -ForegroundColor DarkYellow
        Invoke-Sqlcmd -ServerInstance $srv -Query $tsqlDbHealth |
            Export-Excel -Path $excelFile -WorksheetName 'DbHealth'


        $tsqlAoLatency = @"
-- Find out AlwaysOn Latency
;WITH PR (
	database_id
	,last_commit_time
	)
AS (
	SELECT dr_state.database_id AS database_id
		,dr_state.last_commit_time
	FROM (
		(
			sys.availability_groups AS ag JOIN sys.availability_replicas AS ar ON ag.group_id = ar.group_id
			) JOIN sys.dm_hadr_availability_replica_states AS ar_state ON ar.replica_id = ar_state.replica_id
		)
	JOIN sys.dm_hadr_database_replica_states dr_state ON ag.group_id = dr_state.group_id
		AND dr_state.replica_id = ar_state.replica_id
	WHERE ar_state.role = 1
	)
SELECT ar.replica_server_name AS 'Replica Instance'
	,dr_state.database_id AS 'Database ID'
	,DATEDIFF(s, dr_state.last_commit_time, PR.last_commit_time) AS 'Seconds Behind Primary'
FROM (
	(
		sys.availability_groups AS ag JOIN sys.availability_replicas AS ar ON ag.group_id = ar.group_id
		) JOIN sys.dm_hadr_availability_replica_states AS ar_state ON ar.replica_id = ar_state.replica_id
	)
JOIN sys.dm_hadr_database_replica_states dr_state ON ag.group_id = dr_state.group_id
	AND dr_state.replica_id = ar_state.replica_id
JOIN PR ON PR.database_id = dr_state.database_id
WHERE ar_state.role != 1
	AND dr_state.synchronization_state = 1
"@
        Write-Host "execute tsqlAoLatency" -ForegroundColor DarkYellow
        $resultAoLatency = Invoke-Sqlcmd -ServerInstance $srv -Query $tsqlAoLatency
        if(-not [String]::IsNullOrEmpty($resultAoLatency)) {
            Export-Excel -Path $excelFile -WorksheetName 'AoLatency'
        }

    #} -ArgumentList $srv,$Path
}



<# Scriptout Permissions #>
$tsqlServerPrincipals = @"
SELECT pr.principal_id, pr.name, pe.state_desc, pe.permission_name
			    ,PermissionStatement = pe.state_desc+' '+pe.permission_name+' TO '+QUOTENAME(pr.name)+';' COLLATE DATABASE_DEFAULT
    FROM sys.server_principals pr INNER JOIN sys.server_permissions pe 
      ON pr.principal_id = pe.grantee_principal_id;
"@
foreach($srv in $Servers_full_list)
#foreach($srv in @('sqlprod4','sqlprod5','sqlprod4'))
{
    Write-Host "Processing [$srv].." -ForegroundColor Yellow
    $ExcelDir = (Join-Path $Path $srv)
    if(-not (Test-Path $ExcelDir) ) {
        [system.io.directory]::CreateDirectory($ExcelDir) | Out-Null
    }
    $excelFile = (Join-Path $ExcelDir "DbaPermissions__$srv`__$Dtmm.xlsx")
    
    Start-Job -Name "DbaPermission-$srv" -ScriptBlock {
        Param($srv, $excelFile)
        $srvPermissions = Get-DbaPermission -SqlInstance $srv
        $srvPermissions | Export-Excel -Path $excelFile -WorksheetName 'Permissions-All' -ShowPercent -Append
    }  -ArgumentList $srv, $excelFile

    Start-Job -Name "DbaUserPermission-$srv" -ScriptBlock {
        Param($srv, $excelFile)
        $detailedPermissions = Get-DbaUserPermission -SqlInstance $srv
        $detailedPermissions | Export-Excel -Path $excelFile -WorksheetName 'Detailed-Permissions' -Append
    } -ArgumentList $srv, $excelFile

    Start-Job -Name "PrincipalsPermission-$srv" -ScriptBlock {
         Param($srv, $excelFile, $tsqlServerPrincipals)
         $resultServerPrincipals = Invoke-Sqlcmd -ServerInstance $srv -Query $tsqlServerPrincipals
         $resultServerPrincipals | Export-Excel -Path $excelFile -WorksheetName 'Server-Principals' -Append
    } -ArgumentList $srv, $excelFile, $tsqlServerPrincipals
    
}
$jobs = Get-Job -Name *Permission*
$jobs | Wait-Job
$jobs | Where-Object {$_.State -eq 'Completed'} | Receive-Job
$jobs | Remove-Job



<# Script out DatabaseMail #>
foreach($srv in $Servers_full_list)
#foreach($srv in @('sqlprod1'))
{
    Write-Host "Processing [$srv].." -ForegroundColor Yellow
    $OutputDir = (Join-Path $Path $srv)
    if(-not (Test-Path $OutputDir) ) {
        [system.io.directory]::CreateDirectory($OutputDir) | Out-Null
    }
    $outputFile = (Join-Path $OutputDir "DatabaseMail__$srv`__$Dtmm.sql")
    $srvObj = Connect-DbaInstance -SqlInstance $srv
    $srvObj.Mail.Script() | Out-File $outputFile -Encoding ascii -Append
}



<# Script out Resource Governor #>
#foreach($srv in $Servers_full_list)
foreach($srv in $Servers_full_list)
{
    Write-Host "Processing [$srv].." -ForegroundColor Yellow
    $OutputDir = (Join-Path $Path $srv)
    if(-not (Test-Path $OutputDir) ) {
        [system.io.directory]::CreateDirectory($OutputDir) | Out-Null
    }
    $outputFile = (Join-Path $OutputDir "ResourceGovernor__$srv`__$Dtmm.sql")
    $srvObj = Connect-DbaInstance -SqlInstance $srv

    if($srvObj.ResourceGovernor.Enabled)
    {
        '/*' | Out-File -FilePath $outputFile -Encoding ascii
        $srvObj.ResourceGovernor | Out-File -FilePath $outputFile -Encoding ascii -Append
        '*/' | Out-File -FilePath $outputFile -Encoding ascii -Append
        $srvObj.ResourceGovernor.Script() | Out-File -FilePath $outputFile -Encoding ascii -Append
        "GO" | Out-File -FilePath $outputFile -Encoding ascii -Append
        '
        ' | Out-File -FilePath $outputFile -Encoding ascii -Append
        foreach($pool in $srvObj.ResourceGovernor.ResourcePools)
        {
            $pool.Script() | Out-File -FilePath $outputFile -Encoding ascii -Append
            "GO" | Out-File -FilePath $outputFile -Encoding ascii -Append
            foreach($wg in $pool.WorkloadGroups) {
                $wg.Script() | Out-File -FilePath $outputFile -Encoding ascii -Append
                "GO" | Out-File -FilePath $outputFile -Encoding ascii -Append
            }
            '
        ' | Out-File -FilePath $outputFile -Encoding ascii -Append
        }
        $classifierFunction = $srvObj.ResourceGovernor.ClassifierFunction
        $classifierFunctionBaseName = ($classifierFunction.Split('.')[1]).Replace('[','').Replace(']','')
        $srvObj.Databases['master'].UserDefinedFunctions[$classifierFunctionBaseName].Script() |
            Out-File -FilePath $outputFile -Encoding ascii -Append
        "GO" | Out-File -FilePath $outputFile -Encoding ascii -Append
    }
    else {
        "/* Resource Governor is not enabled on $srv */" | Out-File -FilePath $outputFile -Encoding ascii
    }
}



<# Script out SQL Agent properties #>
foreach($srv in $Servers_full_list)
{
    Write-Host "Processing [$srv].." -ForegroundColor Yellow
    $OutputDir = (Join-Path $Path $srv)
    if(-not (Test-Path $OutputDir) ) {
        [system.io.directory]::CreateDirectory($OutputDir) | Out-Null
    }
    $outputFile = (Join-Path $OutputDir "SqlAgentProperties__$srv`__$Dtmm.sql")
    #$srvObj = Connect-DbaInstance -SqlInstance $srv
    $srvObj.Databases['msdb'].Parent.JobServer.Script() |
        Out-File -FilePath $outputFile -Encoding ascii
    "GO" | Out-File -FilePath $outputFile -Encoding ascii -Append
}


<# Script out Data for User Objects in System Dbs #>
$systemDbs = @("master", "model", "msdb")
foreach($srv in $Servers_full_list)
{
    Write-Host "Working on [$srv]" -ForegroundColor Yellow
    $srvObj = Connect-DbaInstance -SqlInstance $srv
    $directory = (Join-Path $Path "$srv\DbaSysDbUserObjectData") #\DbaSysDbUserObjectData.sql'
    if(-not (Test-Path $directory) ) {
        [system.io.directory]::CreateDirectory($directory) | Out-Null
    }
    foreach ($db in $systemDbs) {
        $dbObj = $srvObj.databases[$db]
        $dbTables = $dbObj.Tables | Where-Object IsSystemObject -ne $true

        foreach($tbl in $dbTables) {
            Write-Host "processing table [$srv].[$db].[$($tbl.Schema)].[$($tbl.Name)]" -ForegroundColor DarkYellow
            BCP "$($tbl.Schema).$($tbl.Name)" OUT "$($directory)\DbaSysDbUserObjectData__[$db].[$($tbl.Schema)].[$($tbl.Name)].bcp" -n -T -d"$db"  -S"$srv"
        }
    }
}


<# Script out audit_login_events trigger on Non-Prods #>
$ProdServer = 'sqlprod'
$DrServer = 'sqldr1DS'
$DevServer = 'sqldev1DS'
$QaServer = 'DBCLQA1DS'
$StgServer = 'sqlstg1DS'

foreach($no in 3..5) {
    #Copy-DbaLogin -Source $ProdServer -Destination $DrServer -Verbose | Out-File "E:\unescoDrReadiness_logs\CopyDbaLogin-$ProdServer-$DrServer.txt" -Append
    foreach($srv in @($QaServer,$StgServer))
    {
        $srv = "$srv$no"
    
        Write-Host "Processing [$srv].." -ForegroundColor Yellow
        $srvObj = Connect-DbaInstance $srv
        $OutputDir = (Join-Path $Path $srv)
        if(-not (Test-Path $OutputDir) ) {
            [system.io.directory]::CreateDirectory($OutputDir) | Out-Null
        }
        $outputFile = (Join-Path $OutputDir "audit_login_events-$srv`__$Dtmm.sql")
    
        $options = New-DbaScriptingOption
        $options.ScriptDrops = $false
        #$options.WithDependencies = $true
        #$options.ScriptSchema = $true
        $options.IncludeDatabaseContext  = $true
        #$Options.NoCommandTerminator = $false
        $Options.ScriptBatchTerminator = $true
        $Options.AnsiFile = $true
    
        ($srvObj.Triggers['audit_login_events']).Script($Options) |
            Out-File -FilePath $outputFile -Encoding ascii
        "GO" | Out-File -FilePath $outputFile -Encoding ascii -Append
    }
}


<# Copy All Objects except databases from Prod to Dr #>
Import-Module dbatools -RequiredVersion 1.0.130

$no = 1
$ProdServer = "sqlprod$no"
$DrServer = "sqldr1DS$no"

#Copy-DbaLogin -Source $ProdServer -Destination $DrServer -Verbose | Out-File "E:\unescoDrReadiness_logs\CopyDbaLogin-$ProdServer-$DrServer.log" -Append
#Copy-DbaAgentJob -Source $ProdServer -Destination $DrServer -DisableOnDestination -Verbose | Out-File "E:\unescoDrReadiness_logs\CopyDbaAgentJob-$ProdServer-$DrServer.log" -Append
#Copy-DbaSysDbUserObject -Source $ProdServer -Destination $DrServer -Verbose | Out-File "E:\unescoDrReadiness_logs\CopyDbaSysDbUserObject-$ProdServer-$DrServer.log" -Append
#Copy-DbaLinkedServer -Source $ProdServer -Destination $DrServer -Verbose | Out-File "E:\unescoDrReadiness_logs\CopyDbaLinkedServer-$ProdServer-$DrServer.log" -Append
#Copy-DbaSpConfigure -Source $ProdServer -Destination $DrServer -Verbose | Out-File "E:\unescoDrReadiness_logs\CopyDbaSpConfigure-$ProdServer-$DrServer.log" -Append
Start-DbaMigration -Source $ProdServer -Destination $DrServer `
                    -DisableJobsOnDestination -ExcludeSaRename `
                    -Exclude Databases,ResourceGovernor,ServerAuditSpecifications -Verbose | Out-File "E:\unescoDrReadiness_logs\StartDbaMigration-$ProdServer-$DrServer.log" -Append

# #-KeepReplication `




<# Script out AUDIT on Prods #>
$ProdServer = 'sqlprod'
$DrServer = 'sqldr1DS'
$DevServer = 'sqldev1DS'
$QaServer = 'DBCLQA1DS'
$StgServer = 'sqlstg1DS'

foreach($no in 1..5) {
    foreach($srv in @($ProdServer))
    {
        $srv = "$srv$no"
    
        Write-Host "Processing [$srv].." -ForegroundColor Yellow
        $srvObj = Connect-DbaInstance $srv
        $OutputDir = (Join-Path $Path $srv)
        if(-not (Test-Path $OutputDir) ) {
            [system.io.directory]::CreateDirectory($OutputDir) | Out-Null
        }
        $outputFile = (Join-Path $OutputDir "AUDIT-$srv`__$Dtmm.sql")
    
        $options = New-DbaScriptingOption
        $options.ScriptDrops = $false
        #$options.WithDependencies = $true
        #$options.ScriptSchema = $true
        $options.IncludeDatabaseContext  = $true
        #$Options.NoCommandTerminator = $false
        $Options.ScriptBatchTerminator = $true
        $Options.AnsiFile = $true
    
        foreach($adt in ($srvObj.Audits)) {
            $adt | Export-DbaScript -FilePath $outputFile -ScriptingOptionsObject $options -Append
            "
            " | Out-File -FilePath $outputFile -Encoding ascii -Append
        }
    }
}


<# Compare size & file config for non-ag databases #>
$tql = '\\dba_share2\E$\Ajay\SQLDBA\Check-FileGroupUsage\srv-space-usage-all-dbs.sql'
$rs = Invoke-DbaQuery -SqlInstance $Servers_full_list -File $tql 
$rs | Export-Excel -Path '\\dba_share\windows\scripts\dba\Operations\disaster_recovery\unesco\feb2021\Copy-DbaObjects-SyncMetaData\NonAgDbsConfig-20210218.xlsx'
$rs | ogv



<#
    ## CLEANUP/COPY/MOVE ##
$Source = '\\dba_share2\E$\unescoDrReadiness_logs\'
#$Source = 'C:\Users\Public\Documents\Logs\'
$Destination = '\\dba_share\windows\scripts\dba\Operations\disaster_recovery\unesco\feb2021\'
#$Destination = 'C:\Users\Public\Documents\Logs\'
$FilePrefix = 'DbaSysDbUserObjectData'

# Get-ChildItem -Path $Source -Name *$FilePrefix* -Recurse -File

### Copy File(s) from $Source to $Destination
robocopy "$Source" "$Destination" /it /s /MT:8 /l
robocopy "$Source" "$Destination" *$FilePrefix* /it /s /MT:8

### Copy File(s) from $Source to $Destination
foreach($srv in $Servers_full_list)
{
    Write-Host "Processing server [$srv]" -ForegroundColor Yellow;
    $files = Get-ChildItem -Path (Join-Path -Path $Source -ChildPath $srv) -Name *$FilePrefix*
    #$files
    foreach($file in $files.PSChildName) {
        $filePath = (Join-Path -Path $Source -ChildPath "$srv\$file")
        Write-Host "Processing '$filePath'" -ForegroundColor DarkYellow;
        $filePath | Copy-Item -Destination (Join-Path -Path $Destination -ChildPath $srv)
    }
}
Get-ChildItem -Path $Destination -Name *$FilePrefix* -Recurse -File



### Remove File from $Source path
foreach($srv in $Servers_full_list) {
    Get-Item $Source\$srv\$FilePrefix* | Remove-Item -Confirm:$false -Verbose
}

#>