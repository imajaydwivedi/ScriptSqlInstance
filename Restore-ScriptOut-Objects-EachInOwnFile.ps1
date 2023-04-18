# $personal = Get-Credential -UserName 'login' -Message 'login'
$startTime = Get-Date
$timeString = ($startTime.ToString("yyyyMMdd_HHmm"))
$ServerName = "localhost" #If you have a named instance, you should put the name. 
$serverFolder = 'C:\Users\Ajay\Downloads\SqlInstance-Scriptout-132-182-167\196.1.115.182__20230407_0638'

$logFile = "$serverFolder\$($ServerName.Replace('\','_'))"+"__$timeString"+"__RestoreLog.txt"
cls


if(-not (Test-Path $logFile)) {
    New-Item $logFile -ItemType File -Force | Out-Null
}
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Log file '$logFile'.." | Write-Host -ForegroundColor Yellow

"`n`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Detect databases for server '$ServerName'.." | Tee-Object $logFile -Append
$databases = Get-ChildItem $serverFolder -Directory | ? {$_.Name -notin @('master','model','msdb','tempdb','distribution')}
$databasesFiltered = @()
$databasesFiltered += $databases | ? {$_.Name -notin @('')}
#$databasesFiltered += $databases | ? {$_.Name -in @('')}

"`n`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Creating a connection for server '$ServerName'.." | Tee-Object $logFile -Append
$conSqlInstance = Connect-DbaInstance -SqlInstance $ServerName -SqlCredential $personal

$counter = 1;
$dbCounts = $databasesFiltered.Count
foreach($database in $databasesFiltered)
{
    #$database
    $dbName = $database.Name

    if($counter -eq 1) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Working on [$ServerName].[$dbName].." | Tee-Object $logFile -Append
    } else {
        "`n`n`n`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Working on [$ServerName].[$dbName].." | Tee-Object $logFile -Append
    }

    # step 00 => Create database
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Create blank database [$dbName] if not exists.." | Tee-Object $logFile -Append
    $sqlCreateDatabase = "if db_id('$dbName') is null create database [$dbName];"
    Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sqlCreateDatabase | Tee-Object $logFile -Append

    # step 01 => Create tables
    $fileTables = "$serverFolder\$dbName\Tables.sql"
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Create tables of database [$dbName].." | Tee-Object $logFile -Append
    if (Test-Path $fileTables) {
        $sqlTables = @()
        $sqlTables += Get-Content $fileTables -Delimiter "`nGO"
        foreach($sql in $sqlTables) {
            try {
                Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sql -EnableException | Tee-Object $logFile -Append
            }
            catch {
                $errMessage = $_

                "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred -" | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
            }
        }
    }

    # step 02 => Create Triggers
    $fileTriggers = "$serverFolder\$dbName\Triggers.sql"
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Create Triggers of database [$dbName].." | Tee-Object $logFile -Append
    if (Test-Path $fileTriggers) {
        $sqlTriggers = @()
        $sqlTriggers += Get-Content $fileTriggers -Delimiter "`nGO"
        foreach($sql in $sqlTriggers) {
            try {
                Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sql -EnableException | Tee-Object $logFile -Append
            }
            catch {
                $errMessage = $_

                "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred -" | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
            }
        }
    }

    # step 03 => Create UserDefinedFunctions
    $fileUserDefinedFunctions = "$serverFolder\$dbName\UserDefinedFunctions.sql"
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Create UserDefinedFunctions of database [$dbName].." | Tee-Object $logFile -Append
    if (Test-Path $fileUserDefinedFunctions) {
        $sqlUserDefinedFunctions = @()
        $sqlUserDefinedFunctions += Get-Content $fileUserDefinedFunctions -Delimiter "`nGO"
        foreach($sql in $sqlUserDefinedFunctions) {
            try {
                Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sql -EnableException | Tee-Object $logFile -Append
            }
            catch {
                $errMessage = $_

                "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred -" | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
            }
        }
    }

    # step 04 => Create Views
    $fileViews = "$serverFolder\$dbName\Views.sql"
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Create Views of database [$dbName].." | Tee-Object $logFile -Append
    if (Test-Path $fileViews) {
        $sqlViews = @()
        $sqlViews += Get-Content $fileViews -Delimiter "`nGO"
        foreach($sql in $sqlViews) {
            try {
                Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sql -EnableException | Tee-Object $logFile -Append
            }
            catch {
                $errMessage = $_

                "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred -" | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
            }
        }
    }

    # step 05 => Create StoredProcedures
    $fileStoredProcedures = "$serverFolder\$dbName\StoredProcedures.sql"
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Create StoredProcedures of database [$dbName].." | Tee-Object $logFile -Append
    if (Test-Path $fileStoredProcedures) {
        $sqlStoredProcedures = @()
        $sqlStoredProcedures += Get-Content $fileStoredProcedures -Delimiter "`nGO"
        foreach($sql in $sqlStoredProcedures) {
            try {
                Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sql -EnableException | Tee-Object $logFile -Append
            }
            catch {
                $errMessage = $_

                "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred -" | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
            }
        }
    }

    # step 06 => Create UserDefinedDataTypes
    $fileUserDefinedDataTypes = "$serverFolder\$dbName\UserDefinedDataTypes.sql"
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Create UserDefinedDataTypes of database [$dbName].." | Tee-Object $logFile -Append
    if (Test-Path $fileUserDefinedDataTypes) {
        $sqlUserDefinedDataTypes = @()
        $sqlUserDefinedDataTypes += Get-Content $fileUserDefinedDataTypes -Delimiter "`nGO"
        foreach($sql in $sqlUserDefinedDataTypes) {
            try {
                Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sql -EnableException | Tee-Object $logFile -Append
            }
            catch {
                $errMessage = $_

                "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred -" | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
            }
        }
    }

    # step 07 => Create UserDefinedTableTypes
    $fileUserDefinedTableTypes = "$serverFolder\$dbName\UserDefinedTableTypes.sql"
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$counter/$dbCounts) Create UserDefinedTableTypes of database [$dbName].." | Tee-Object $logFile -Append
    if (Test-Path $fileUserDefinedTableTypes) {
        $sqlUserDefinedTableTypes = @()
        $sqlUserDefinedTableTypes += Get-Content $fileUserDefinedTableTypes -Delimiter "`nGO"
        foreach($sql in $sqlUserDefinedTableTypes) {
            try {
                Invoke-DbaQuery -SqlInstance $conSqlInstance -Database $dbName -Query $sql -EnableException | Tee-Object $logFile -Append
            }
            catch {
                $errMessage = $_

                "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Below error occurred -" | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
                $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Tee-Object $logFile -Append | Write-Host -ForegroundColor Red
            }
        }
    }

    $counter += 1
    break
}


