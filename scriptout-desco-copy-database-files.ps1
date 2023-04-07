
<# ***********************************************************************
    RDP to server [dbrepl1], and execute below powershell commands
##  ******************************************************************** #>

New-Item '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1' -ItemType Directory -Force | Out-Null

Write-Host "[dbrepl1] => Copying file 'master.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\master.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'mastlog.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\mastlog.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'model.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\model.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'modellog.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\modellog.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'MSDBData.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MSDBData.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'MSDBLog.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MSDBLog.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'distribution.MDF'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data\distribution.MDF' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'distribution.LDF'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data\distribution.LDF' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'audit_archive.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\audit_archive.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'audit_archive_log.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\audit_archive_log.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox_log.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox_log.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox1.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox1.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox2.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox2.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox3.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox3.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox4.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox4.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox5.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox5.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox7.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox7.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';
Write-Host "[dbrepl1] => Copying file 'sandbox8.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox8.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl1';

<# ***********************************************************************
    RDP to server [dbrepl2], and execute below powershell commands
##  ******************************************************************** #>

New-Item '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2' -ItemType Directory -Force | Out-Null

Write-Host "[dbrepl2] => Copying file 'master.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\master.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'mastlog.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\mastlog.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'model.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\model.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'modellog.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\modellog.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'MSDBData.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MSDBData.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'MSDBLog.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MSDBLog.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'rousselj_test.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\rousselj_test.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'rousselj_test_log.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\rousselj_test_log.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'distribution.MDF'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data\distribution.MDF' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'distribution.LDF'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data\distribution.LDF' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'audit_archive.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\audit_archive.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'audit_archive_log.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\audit_archive_log.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox.mdf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox.mdf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox_log.ldf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox_log.ldf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox1.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox1.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox2.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox2.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox3.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox3.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox4.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox4.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox5.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox5.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox7.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox7.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
Write-Host "[dbrepl2] => Copying file 'sandbox8.ndf'"
Copy-Item 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sandbox8.ndf' -Destination '\\sqlprod1\ZDrive\SqlUpgrade2019\DbFilesCopied\dbrepl2';
