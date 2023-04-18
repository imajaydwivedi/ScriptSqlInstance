# $personal = Get-Credential -UserName 'login' -Message 'login'
$startTime = Get-Date
$timeString = ($startTime.ToString("yyyyMMdd_HHmm"))
$ServerName = "localhost" #If you have a named instance, you should put the name. 
$serverFolder = 'C:\Users\Ajay\Documents\Pramod\localhost__20230418_1106'


$logFile = "$serverFolder\$($ServerName.Replace('\','_'))"+"__$timeString"+"__RestoreLog.txt"
cls


if(-not (Test-Path $logFile)) {
    New-Item $logFile -ItemType File -Force | Out-Null
}
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Log file '$logFile'.." | Write-Host -ForegroundColor Yellow

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Detect databases for server '$ServerName'.." | Tee-Object $logFile -Append
$databases = Get-ChildItem $serverFolder -Directory | ? {$_.Name -notin @('master','model','msdb','tempdb','distribution')}
$databasesFiltered = @()
$databasesFiltered += $databases | ? {$_.Name -notin @('')}
#$databasesFiltered += $databases | ? {$_.Name -in @('')}

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Creating a connection for server '$ServerName'.." | Tee-Object $logFile -Append
$conSqlInstance = Connect-DbaInstance -SqlInstance $ServerName -SqlCredential $personal

$counter = 1;
$dbCounts = $databasesFiltered.Count
foreach($database in $databasesFiltered)
{
    #$database
    $dbName = $database.Name
    $tablesPath = "$serverFolder\$dbName\Tables"
    $triggersPath = "$serverFolder\$dbName\Triggers"
    $userDefinedFunctionsPath = "$serverFolder\$dbName\UserDefinedFunctions"
    $viewsPath = "$serverFolder\$dbName\Views"
    $userDefinedTypesPath = "$serverFolder\$dbName\UserDefinedTypes"
    $userDefinedDataTypesPath = "$serverFolder\$dbName\UserDefinedDataTypes"
    $userDefinedTableTypesPath = "$serverFolder\$dbName\UserDefinedTableTypes"
    $storedProceduresPath = "$serverFolder\$dbName\StoredProcedures"

    if($counter -eq 1) {
        "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Working on [$ServerName].[$dbName].." | Tee-Object $logFile -Append
    } else {
        "`n`n`n`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Working on [$ServerName].[$dbName].." | Tee-Object $logFile -Append
    }

    # step 00 => Create database
    "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Create blank database [$dbName] if not exists.." | Tee-Object $logFile -Append
    $sqlCreateDatabase = "if db_id('$dbName') is null create database [$dbName];"
    Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sqlCreateDatabase | Out-Null

    # step 01 => Create tables
    # step 02 => Create Triggers
    # step 03 => Create UserDefinedFunctions

    # step 04 => Create Views    
    $viewsFiles = @()
    if(Test-Path $viewsPath) { $viewsFiles += Get-ChildItem -Path $viewsPath -File }
    if ($viewsFiles.Count -gt 0) {
        $viewsCount = $viewsFiles.Count     
        "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Create $viewsCount views on database [$dbName].." | Tee-Object $logFile -Append
        foreach($file in $viewsFiles) {
            $objName = $file.BaseName            
            "`t`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Working on view '$ObjName'.." | Tee-Object $logFile -Append
            try {
                $fileSQL = (Get-Content $file.FullName | Out-String)
                $separator = "`ncreate view"
                $separatorIndex = $fileSQL.ToLower().IndexOf($separator)

                $preSQL = $fileSQL.Substring(0,$separatorIndex)
                $createSQL = $fileSQL.Substring($separatorIndex,$fileSQL.Length-$separatorIndex)
                #Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -File $file.FullName -EnableException | Out-Null
                    # Divding logic due to error "CREATE must be the first statement in a query batch."
                $sqls2Execute = $preSQL,$createSQL
                foreach($sql in $sqls2Execute) {
                    Invoke-DbaQuery -SqlInstance $conSqlInstance -Query $sql -Database $dbName -EnableException | Out-Null
                }
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

    # step 05 => Create UserDefinedTypes
    # step 06 => Create UserDefinedDataTypes
    # step 07 => Create UserDefinedTableTypes
    # step 08 => Create StoredProcedures
    
    

    $counter += 1
    break
}
