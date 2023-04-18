<#  Method 01 -> Each object with its own sql file
	Script to Scriptout Databases & Objects
    Each database goes in single folder.
    Each object goes in its own sql file.

	https://www.mssqltips.com/sqlservertip/4606/generate-tsql-scripts-for-all-sql-server-databases-and-all-objects-using-powershell/
#>
$ServerName = "localhost" 

cls
$startTime = Get-Date
$timeString = ($startTime.ToString("yyyyMMdd_HHmm"))
$path = "$($env:USERPROFILE)\Documents\ScriptSQLInstance\$($ServerName.Replace('\','_'))"+"__"+"$timeString"
$logFile = "$path\$($ServerName.Replace('\','_'))"+"__"+"log.txt"
if(-not (Test-Path $logFile)) {
    New-Item $logFile -ItemType File -Force | Out-Null
}
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Log file '$logFile'.." | Write-Host -ForegroundColor Yellow

"`n`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Creating a connection for server '$ServerName'.." | Tee-Object $logFile -Append
# $personal = Get-Credential -UserName 'login' -Message 'login'
$conSqlInstance = Connect-DbaInstance -SqlInstance $ServerName -ClientName "ScriptSQLInstance.ps1" #-SqlCredential $personal

$IncludeTypes = @("Tables","StoredProcedures","Views","UserDefinedFunctions", "Triggers","UserDefinedTypes","UserDefinedDataTypes","UserDefinedTableTypes") #object you want do backup.
#$IncludeTypes = @("StoredProcedures","Views") #object you want do backup. 
$ExcludeSchemas = @("sys","Information_Schema")

$options = New-DbaScriptingOption
$options.ScriptSchema = $true
$options.ScriptForCreateDrop = $true
#$options.ScriptDrops = $true
$options.IncludeDatabaseContext  = $false
$options.IncludeHeaders = $false
$Options.NoCommandTerminator = $false
$Options.ScriptBatchTerminator = $true
$Options.AnsiFile = $true


"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Get all databases for SqlInstance '$ServerName'.." | Tee-Object $logFile -Append
$dbs = $conSqlInstance.Databases #you can change this variable for a query for filter yours databases.
$dbsFiltered = @()
$dbsFiltered += $dbs #| ? {$_.Name -in @('DBA')}
$dbCounts = $dbsFiltered.Count

$counter = 1
foreach ($db in $dbsFiltered)
{
    $dbname = "$db".replace("[","").replace("]","")
    $dbpath = "$path"+ "\"+"$dbname" + "\"
    if ( !(Test-Path $dbpath) ) {
        new-item -type directory -name "$dbname" -path "$path" | Out-Null
    }

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Scriptout database [$dbname] on path '$dbpath'.." `
            | Tee-Object $logFile -Append | Write-Host -ForegroundColor Yellow

    $OutFile = "$dbpath" + "$dbname" + ".sql"
    try {
        $db.Script($so)+"GO" | out-File $OutFile
 
        foreach ($Type in $IncludeTypes)
        {
            "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Working on $Type.." | Tee-Object $logFile -Append
            $objpath = "$dbpath" + "$Type" + "\"
            if ( !(Test-Path $objpath) ) {
                new-item -type directory -name "$Type"-path "$dbpath" | Out-Null
            }
            foreach ($objs in $db.$Type) {
                If ($ExcludeSchemas -notcontains $objs.Schema ) {
                    $ObjName = "$objs".replace("[","").replace("]","")                  
                    $OutFile = "$objpath" + "$ObjName" + ".sql"
                    try {
                        "`t`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Working on '$ObjName'.." | Tee-Object $logFile -Append
                        $objs | Export-DbaScript -FilePath $OutFile -Append -Encoding UTF8 -ScriptingOptionsObject $options -NoPrefix -EnableException | Out-Null
                    }
                    catch {
                        $errMessage = $_

                        "`t`t`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Error occurred for '$ObjName'." | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                        
                        "`t`t`t`t$('*'*20)" | Out-File $logFile -Append
                        $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t`t`t`t$_"} | Out-File $logFile -Append
                        #$($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Write-Host -ForegroundColor Red
                        "`t`t`t`t$('*'*20)" | Out-File $logFile -Append
                    }
                }
            }
        }
    }
    catch {
        $errMessage = $_

        "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred while scripting database '$dbname'." | Write-Host -ForegroundColor Red
        "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "So skipping to next database." | Write-Host -ForegroundColor Red
        $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Write-Host -ForegroundColor Red
    }
    $counter += 1
}

$endTime = Get-Date
$timeElapsed = New-TimeSpan -Start $startTime -End $endTime
"`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Total time in minutes => $($timeElapsed.TotalMinutes)" | Write-Host -ForegroundColor Green
