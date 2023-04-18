<#  Method 02 -> All objects in single file per database
	Script to Scriptout Databases & Objects
    Each database goes in single folder.
    Each object goes in its own sql file.

	https://www.mssqltips.com/sqlservertip/4606/generate-tsql-scripts-for-all-sql-server-databases-and-all-objects-using-powershell/
#>
cls
$startTime = Get-Date
$timeString = ($startTime.ToString("yyyyMMdd_HHmm"))
$ServerName = "localhost" #If you have a named instance, you should put the name. 
$path = "$($env:USERPROFILE)\Documents\ScriptSQLInstance\$ServerName"+"__"+"$timeString"
$logFile = "$path\$($ServerName.Replace('\','_'))"+"__"+"log.txt"
if(-not (Test-Path $logFile)) {
    New-Item $logFile -ItemType File -Force | Out-Null
}
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Log file '$logFile'.." | Write-Host -ForegroundColor Yellow

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Creating SMO for SqlInstance '$ServerName'.."
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null
$serverInstance = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $ServerName
$IncludeTypes = @("Tables","StoredProcedures","Views","UserDefinedFunctions", "Triggers","UserDefinedTypes","UserDefinedDataTypes","UserDefinedTableTypes") #object you want do backup.
#$IncludeTypes = @("StoredProcedures","Views") #object you want do backup. 
$ExcludeSchemas = @("sys","Information_Schema")
$so = new-object ('Microsoft.SqlServer.Management.Smo.ScriptingOptions')
$so.ScriptForCreateDrop = $true
$so.WithDependencies = $false

Import-Module dbatools
# $personal = Get-Credential -UserName 'MyLogin' -Message 'MyLogin'
$so = Connect-DbaInstance -SqlInstance $ServerName #-SqlCredential $personal

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Get all databases for SqlInstance '$ServerName'.." | Tee-Object $logFile -Append
$dbs = $serverInstance.Databases #you can change this variable for a query for filter yours databases.
$dbsFiltered = @()
$dbsFiltered += $dbs | Where-Object {$_.Name -notin @('')}
#$dbsFiltered += $dbs | Where-Object {$_.Name -in @('')}
$dbCounts = $dbsFiltered.Count

$counter = 1
foreach ($db in $dbsFiltered)
{
    $dbname = "$db".replace("[","").replace("]","")
    $dbpath = "$path"+ "\"+"$dbname" + "\"
    if ( !(Test-Path $dbpath) ) {
        $null = new-item -type directory -name "$dbname" -path "$path"
    }

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Scriptout database [$dbname] on path '$dbpath'.." | Tee-Object $logFile -Append | Write-Host -ForegroundColor Yellow

    $OutFile = "$dbpath" + "$dbname" + ".sql"
    try {
        $db.Script($so)+"GO" | out-File $OutFile
 
        foreach ($Type in $IncludeTypes)
        {
            "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Working on $Type.." | Tee-Object $logFile -Append
            $OutFile = "$dbpath" + "$Type" + ".sql"

            foreach ($objs in $db.$Type) 
            {
                If ($ExcludeSchemas -notcontains $objs.Schema ) 
                {
                    $ObjName = "$objs".replace("[","").replace("]","")
                    try {
                        $objs.Script($so)+"GO" | Out-File $OutFile -Append
                    }
                    catch {
                        $errMessage = $_

                        "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred while trying to script $Type '$ObjName'." | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                        $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                    }
                }
            }
        }
    }
    catch {
        $errMessage = $_

        "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred while scripting database '$dbname'." | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
        "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "So skipping to next database." | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
        $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
    }
    $counter += 1
}

$endTime = Get-Date
$timeElapsed = New-TimeSpan -Start $startTime -End $endTime
"`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Total time in minutes => $($timeElapsed.TotalMinutes)" | Tee-Object $logFile -Append | Write-Host -ForegroundColor Green
