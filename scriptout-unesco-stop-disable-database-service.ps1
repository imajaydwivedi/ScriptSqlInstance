
########### STOP SERVICE ##########


#Write-Host '[sqlprod1.unesco.com] => Stop service "MSSQL$DS1"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqlprod1.unesco.com' -Name 'MSSQL$DS1' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod1.unesco.com] => Stop cluster service "SQL Server (DS1)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod1.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS1)'


#Write-Host '[sqldr1ds1.unesco.com] => Stop service "MSSQL$DRDS1"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqldr1ds1.unesco.com' -Name 'MSSQL$DRDS1' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds1.unesco.com] => Stop cluster service "SQL Server (DRDS1)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds1.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS1)'


#Write-Host '[sqlprod2.unesco.com] => Stop service "MSSQL$DS2"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqlprod2.unesco.com' -Name 'MSSQL$DS2' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod2.unesco.com] => Stop cluster service "SQL Server (DS2)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod2.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS2)'


#Write-Host '[sqldr1ds2.unesco.com] => Stop service "MSSQL$DRDS2"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqldr1ds2.unesco.com' -Name 'MSSQL$DRDS2' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds2.unesco.com] => Stop cluster service "SQL Server (DRDS2)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds2.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS2)'


#Write-Host '[sqlprod3.unesco.com] => Stop service "MSSQL$DS3"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqlprod3.unesco.com' -Name 'MSSQL$DS3' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod3.unesco.com] => Stop cluster service "SQL Server (DS3)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod3.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS3)'


#Write-Host '[sqldr1ds3.unesco.com] => Stop service "MSSQL$DRDS3"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqldr1ds3.unesco.com' -Name 'MSSQL$DRDS3' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds3.unesco.com] => Stop cluster service "SQL Server (DRDS3)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds3.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS3)'


#Write-Host '[sqlprod4.unesco.com] => Stop service "MSSQL$DS4"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqlprod4.unesco.com' -Name 'MSSQL$DS4' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod4.unesco.com] => Stop cluster service "SQL Server (DS4)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod4.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS4)'


#Write-Host '[sqldr1ds4.unesco.com] => Stop service "MSSQL$DRDS4"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqldr1ds4.unesco.com' -Name 'MSSQL$DRDS4' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds4.unesco.com] => Stop cluster service "SQL Server (DRDS4)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds4.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS4)'


#Write-Host '[sqlprod5.unesco.com] => Stop service "MSSQL$DS5"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqlprod5.unesco.com' -Name 'MSSQL$DS5' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod5.unesco.com] => Stop cluster service "SQL Server (DS5)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod5.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS5)'


#Write-Host '[sqldr1ds5.unesco.com] => Stop service "MSSQL$DRDS5"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqldr1ds5.unesco.com' -Name 'MSSQL$DRDS5' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds5.unesco.com] => Stop cluster service "SQL Server (DRDS5)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds5.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS5)'


#Write-Host '[sqlprod6.unesco.com] => Stop service "MSSQL$DS6"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqlprod6.unesco.com' -Name 'MSSQL$DS6' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod6.unesco.com] => Stop cluster service "SQL Server (DS6)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod6.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS6)'


#Write-Host '[sqldr1ds6.unesco.com] => Stop service "MSSQL$DRDS6"' -ForegroundColor Cyan
#Set-Service -ComputerName 'sqldr1ds6.unesco.com' -Name 'MSSQL$DRDS6' -Status Stopped -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds6.unesco.com] => Stop cluster service "SQL Server (DRDS6)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds6.unesco.com' -ScriptBlock { param($servicename) Stop-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS6)'



########### DISABLE SERVICE ##########


Write-Host '[sqlprod1.unesco.com] => Disable service "MSSQL$DS1"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqlprod1.unesco.com' -Name 'MSSQL$DS1' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds1.unesco.com] => Disable service "MSSQL$DRDS1"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqldr1ds1.unesco.com' -Name 'MSSQL$DRDS1' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod2.unesco.com] => Disable service "MSSQL$DS2"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqlprod2.unesco.com' -Name 'MSSQL$DS2' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds2.unesco.com] => Disable service "MSSQL$DRDS2"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqldr1ds2.unesco.com' -Name 'MSSQL$DRDS2' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod3.unesco.com] => Disable service "MSSQL$DS3"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqlprod3.unesco.com' -Name 'MSSQL$DS3' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds3.unesco.com] => Disable service "MSSQL$DRDS3"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqldr1ds3.unesco.com' -Name 'MSSQL$DRDS3' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod4.unesco.com] => Disable service "MSSQL$DS4"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqlprod4.unesco.com' -Name 'MSSQL$DS4' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds4.unesco.com] => Disable service "MSSQL$DRDS4"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqldr1ds4.unesco.com' -Name 'MSSQL$DRDS4' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod5.unesco.com] => Disable service "MSSQL$DS5"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqlprod5.unesco.com' -Name 'MSSQL$DS5' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds5.unesco.com] => Disable service "MSSQL$DRDS5"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqldr1ds5.unesco.com' -Name 'MSSQL$DRDS5' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod6.unesco.com] => Disable service "MSSQL$DS6"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqlprod6.unesco.com' -Name 'MSSQL$DS6' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds6.unesco.com] => Disable service "MSSQL$DRDS6"' -ForegroundColor Cyan
Set-Service -ComputerName 'sqldr1ds6.unesco.com' -Name 'MSSQL$DRDS6' -StartupType Disabled -PassThru | Select-Object -Property MachineName, Name, StartType, Status
