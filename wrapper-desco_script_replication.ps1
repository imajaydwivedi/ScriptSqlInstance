[CmdletBinding()]
Param (
    [String[]]$Publishers = @('sqlprod1\DS1','sqlprod2\DS2','sqlprod3\DS3','sqlprod4\DS4','sqlprod5\DS5'),
    [String]$OutputPath = "E:\PowerShell\Replication\Output\202103323-Distributor-Upgrade"
)

$ErrorActionPreference = "Stop"
$VerbosePreference = "SilentlyContinue"

Write-Verbose "Start parallel thread for each publisher"
$srv = $Publishers[0]
$Publishers | Start-RSJob -Name {"repl_$_"} -ScriptBlock {
    Param($OutputPath)
    $srv = $_
    $server_name = $srv.Split('\')[0]
    
    E:\PowerShell\Replication\unesco_script_replication.ps1 -sql_server $srv `
                    -local_folder "$OutputPath" `
                    -ErrorAction Stop -Verbose #-Debug
    
} -ArgumentList $OutputPath

$jobs = Get-RSJob | Where-Object {$_.Name -like 'repl*'}
$jobs | Wait-RSJob -ShowProgress
$jobs | Stop-RSJob
$jobs | Receive-RSJob
$jobs | Remove-RSJob
