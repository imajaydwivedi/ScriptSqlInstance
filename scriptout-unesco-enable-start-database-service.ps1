

########### ENABLE SERVICE ##########


Write-Host '[sqlprod1.unesco.com] => Enable service "MSSQL$DS1"' -ForegroundColor Green
Set-Service -ComputerName 'sqlprod1.unesco.com' -Name 'MSSQL$DS1' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds1.unesco.com] => Enable service "MSSQL$DRDS1"' -ForegroundColor Green
Set-Service -ComputerName 'sqldr1ds1.unesco.com' -Name 'MSSQL$DRDS1' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod2.unesco.com] => Enable service "MSSQL$DS2"' -ForegroundColor Green
Set-Service -ComputerName 'sqlprod2.unesco.com' -Name 'MSSQL$DS2' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds2.unesco.com] => Enable service "MSSQL$DRDS2"' -ForegroundColor Green
Set-Service -ComputerName 'sqldr1ds2.unesco.com' -Name 'MSSQL$DRDS2' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod3.unesco.com] => Enable service "MSSQL$DS3"' -ForegroundColor Green
Set-Service -ComputerName 'sqlprod3.unesco.com' -Name 'MSSQL$DS3' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds3.unesco.com] => Enable service "MSSQL$DRDS3"' -ForegroundColor Green
Set-Service -ComputerName 'sqldr1ds3.unesco.com' -Name 'MSSQL$DRDS3' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod4.unesco.com] => Enable service "MSSQL$DS4"' -ForegroundColor Green
Set-Service -ComputerName 'sqlprod4.unesco.com' -Name 'MSSQL$DS4' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds4.unesco.com] => Enable service "MSSQL$DRDS4"' -ForegroundColor Green
Set-Service -ComputerName 'sqldr1ds4.unesco.com' -Name 'MSSQL$DRDS4' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod5.unesco.com] => Enable service "MSSQL$DS5"' -ForegroundColor Green
Set-Service -ComputerName 'sqlprod5.unesco.com' -Name 'MSSQL$DS5' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds5.unesco.com] => Enable service "MSSQL$DRDS5"' -ForegroundColor Green
Set-Service -ComputerName 'sqldr1ds5.unesco.com' -Name 'MSSQL$DRDS5' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqlprod6.unesco.com] => Enable service "MSSQL$DS6"' -ForegroundColor Green
Set-Service -ComputerName 'sqlprod6.unesco.com' -Name 'MSSQL$DS6' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status


Write-Host '[sqldr1ds6.unesco.com] => Enable service "MSSQL$DRDS6"' -ForegroundColor Green
Set-Service -ComputerName 'sqldr1ds6.unesco.com' -Name 'MSSQL$DRDS6' -StartupType Manual -PassThru | Select-Object -Property MachineName, Name, StartType, Status



########### START SERVICE ##########


#Write-Host '[sqlprod1.unesco.com] => Start service "MSSQL$DS1"' -ForegroundColor Green
#Set-Service -ComputerName 'sqlprod1.unesco.com' -Name 'MSSQL$DS1' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod1.unesco.com] => Start cluster service "SQL Server (DS1)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod1.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS1)'
Invoke-Command -ComputerName 'sqlprod1.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DS1)'


#Write-Host '[sqldr1ds1.unesco.com] => Start service "MSSQL$DRDS1"' -ForegroundColor Green
#Set-Service -ComputerName 'sqldr1ds1.unesco.com' -Name 'MSSQL$DRDS1' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds1.unesco.com] => Start cluster service "SQL Server (DRDS1)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds1.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS1)'
Invoke-Command -ComputerName 'sqldr1ds1.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DRDS1)'


#Write-Host '[sqlprod2.unesco.com] => Start service "MSSQL$DS2"' -ForegroundColor Green
#Set-Service -ComputerName 'sqlprod2.unesco.com' -Name 'MSSQL$DS2' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod2.unesco.com] => Start cluster service "SQL Server (DS2)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod2.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS2)'
Invoke-Command -ComputerName 'sqlprod2.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DS2)'


#Write-Host '[sqldr1ds2.unesco.com] => Start service "MSSQL$DRDS2"' -ForegroundColor Green
#Set-Service -ComputerName 'sqldr1ds2.unesco.com' -Name 'MSSQL$DRDS2' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds2.unesco.com] => Start cluster service "SQL Server (DRDS2)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds2.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS2)'
Invoke-Command -ComputerName 'sqldr1ds2.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DRDS2)'


#Write-Host '[sqlprod3.unesco.com] => Start service "MSSQL$DS3"' -ForegroundColor Green
#Set-Service -ComputerName 'sqlprod3.unesco.com' -Name 'MSSQL$DS3' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod3.unesco.com] => Start cluster service "SQL Server (DS3)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod3.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS3)'
Invoke-Command -ComputerName 'sqlprod3.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DS3)'


#Write-Host '[sqldr1ds3.unesco.com] => Start service "MSSQL$DRDS3"' -ForegroundColor Green
#Set-Service -ComputerName 'sqldr1ds3.unesco.com' -Name 'MSSQL$DRDS3' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds3.unesco.com] => Start cluster service "SQL Server (DRDS3)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds3.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS3)'
Invoke-Command -ComputerName 'sqldr1ds3.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DRDS3)'


#Write-Host '[sqlprod4.unesco.com] => Start service "MSSQL$DS4"' -ForegroundColor Green
#Set-Service -ComputerName 'sqlprod4.unesco.com' -Name 'MSSQL$DS4' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod4.unesco.com] => Start cluster service "SQL Server (DS4)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod4.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS4)'
Invoke-Command -ComputerName 'sqlprod4.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DS4)'


#Write-Host '[sqldr1ds4.unesco.com] => Start service "MSSQL$DRDS4"' -ForegroundColor Green
#Set-Service -ComputerName 'sqldr1ds4.unesco.com' -Name 'MSSQL$DRDS4' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds4.unesco.com] => Start cluster service "SQL Server (DRDS4)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds4.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS4)'
Invoke-Command -ComputerName 'sqldr1ds4.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DRDS4)'


#Write-Host '[sqlprod5.unesco.com] => Start service "MSSQL$DS5"' -ForegroundColor Green
#Set-Service -ComputerName 'sqlprod5.unesco.com' -Name 'MSSQL$DS5' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod5.unesco.com] => Start cluster service "SQL Server (DS5)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod5.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS5)'
Invoke-Command -ComputerName 'sqlprod5.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DS5)'


#Write-Host '[sqldr1ds5.unesco.com] => Start service "MSSQL$DRDS5"' -ForegroundColor Green
#Set-Service -ComputerName 'sqldr1ds5.unesco.com' -Name 'MSSQL$DRDS5' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds5.unesco.com] => Start cluster service "SQL Server (DRDS5)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds5.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS5)'
Invoke-Command -ComputerName 'sqldr1ds5.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DRDS5)'


#Write-Host '[sqlprod6.unesco.com] => Start service "MSSQL$DS6"' -ForegroundColor Green
#Set-Service -ComputerName 'sqlprod6.unesco.com' -Name 'MSSQL$DS6' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqlprod6.unesco.com] => Start cluster service "SQL Server (DS6)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqlprod6.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DS6)'
Invoke-Command -ComputerName 'sqlprod6.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DS6)'


#Write-Host '[sqldr1ds6.unesco.com] => Start service "MSSQL$DRDS6"' -ForegroundColor Green
#Set-Service -ComputerName 'sqldr1ds6.unesco.com' -Name 'MSSQL$DRDS6' -Status Running -PassThru | Select-Object -Property MachineName, Name, StartType, Status

Write-Host '[sqldr1ds6.unesco.com] => Start cluster service "SQL Server (DRDS6)"' -ForegroundColor Cyan
Invoke-Command -ComputerName 'sqldr1ds6.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server (DRDS6)'
Invoke-Command -ComputerName 'sqldr1ds6.unesco.com' -ScriptBlock { param($servicename) Start-ClusterResource -Name $servicename -Wait 180 -ErrorAction Stop } -ArgumentList 'SQL Server Agent (DRDS6)'
