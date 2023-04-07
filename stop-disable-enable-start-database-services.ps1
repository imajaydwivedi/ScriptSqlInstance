# Parameters
[String[]]$Publishers = @('sqlprod1\DS1','sqldr1DS1\DRDS1','sqlprod2\DS2','sqldr1DS2\DRDS2','sqlprod3\DS3',
                            'sqldr1DS3\DRDS3','sqlprod4\DS4','sqldr1DS4\DRDS4','sqlprod5\DS5','sqldr1DS5\DRDS5','sqlprod6\DS6','sqldr1DS6\DRDS6')

#$Publishers = @('sqltest2DS1\DS1','sqltest2DRDS1\DRDS1')

# Get Service Name
Write-Host "Get SqlInstance service name using tsql" -ForegroundColor Cyan
$tsqlServiceName = "select servicename, @@SERVERNAME as srv_name from sys.dm_server_services where servicename like 'SQL Server (%'"
$resultServiceName = Invoke-DbaQuery -SqlInstance $Publishers -Query $tsqlServiceName -QueryTimeout 120

#$resultServiceName | Select-Object @{l='ComputerName';e={Get-Fqdn ((($_.srv_name).Split('\')[0]).Split('.')[0])}}, @{l='DisplayName';e={$_.servicename}}

Write-Host "Get current service state" -ForegroundColor Cyan
[System.Collections.ArrayList]$services = @()
foreach($srv in $resultServiceName)
{
    $computerName = Get-Fqdn (($srv.srv_name).Split('\')[0]).Split('.')[0]
    $SqlInstance = $srv.srv_name
    $serviceName = $srv.servicename

    # Initial State    
    $svc = Get-Service -ComputerName $computerName -DisplayName $serviceName
    $services.Add($svc) | Out-Null
}


# 01 - Script Stop Service
Write-Output "`n`n########### STOP SERVICE ##########`n"
foreach($svc in $services)
{
    $computerName = $svc.MachineName
    $svc_name = $svc.Name
    $svc_displayname = $svc.DisplayName
    @"

#Write-Host '[$computerName] => Stop service "$svc_name"' -ForegroundColor Cyan
#Set-Service -ComputerName '$computerName' -Name '$svc_name' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[$computerName] => Stop cluster service "$svc_displayname"' -ForegroundColor Cyan
Invoke-Command -ComputerName '$computerName' -ScriptBlock { param(`$servicename) Stop-ClusterResource -Name `$servicename -Wait 180 -ErrorAction Stop } -ArgumentList '$svc_displayname'

"@
    #break;
}

# 02 - Script Disable Service
Write-Output "`n`n########### DISABLE SERVICE ##########`n"
foreach($svc in $services)
{
    $computerName = $svc.MachineName
    $svc_name = $svc.Name
   
    @"

Write-Host '[$computerName] => Disable service "$svc_name"' -ForegroundColor Cyan
Set-Service -ComputerName '$computerName' -Name '$svc_name' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status

"@

}

# 03 - Script Enable Service
Write-Output "`n`n########### ENABLE SERVICE ##########`n"
foreach($svc in $services)
{
    $computerName = $svc.MachineName
    $svc_name = $svc.Name
    @"

Write-Host '[$computerName] => Enable service "$svc_name"' -ForegroundColor Green
Set-Service -ComputerName '$computerName' -Name '$svc_name' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status

"@
}


# 04 - Script Start Service
Write-Output "`n`n########### START SERVICE ##########`n"
foreach($svc in $services)
{
    $computerName = $svc.MachineName
    $svc_name = $svc.Name
    $svc_displayname = $svc.DisplayName
    $svc_agent_displayname = 'SQL Server Agent ('+ ($svc_name.Split('$')[1]) +')';
    @"

#Write-Host '[$computerName] => Start service "$svc_name"' -ForegroundColor Green
#Set-Service -ComputerName '$computerName' -Name '$svc_name' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[$computerName] => Start cluster service "$svc_displayname"' -ForegroundColor Cyan
Invoke-Command -ComputerName '$computerName' -ScriptBlock { param(`$servicename) Start-ClusterResource -Name `$servicename -Wait 180 -ErrorAction Stop } -ArgumentList '$svc_displayname'
Invoke-Command -ComputerName '$computerName' -ScriptBlock { param(`$servicename) Start-ClusterResource -Name `$servicename -Wait 180 -ErrorAction Stop } -ArgumentList '$svc_agent_displayname'

"@
    #break;
}
