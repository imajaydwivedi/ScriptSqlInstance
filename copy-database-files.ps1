$Servers = @('dbrepl1','dbrepl2')
$DestinationPath = '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied'

foreach($srv in $Servers)
{
    $dbFiles = Invoke-DbaQuery -SqlInstance $srv -Query "select mf.physical_name from sys.master_files mf where mf.database_id <> DB_ID('tempdb')" | Select-Object -ExpandProperty physical_name;
    $DestinationFolder = Join-Path $DestinationPath $srv

    @"

<# ***********************************************************************
    RDP to server [$srv], and execute below powershell commands
##  ******************************************************************** #>

New-Item '$DestinationFolder' -ItemType Directory -Force | Out-Null

"@
    
    $dbFiles | ForEach-Object { @"
Write-Host "[$srv] => Copying file '$(Split-Path $_ -Leaf)'"
Copy-Item '$_' -Destination '$(Join-Path $DestinationPath $srv)';
"@ }


}