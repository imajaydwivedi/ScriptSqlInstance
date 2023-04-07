-- Step1 - Configure the Distribution DB nodes (AG Replicas) to act as a distributor

:Connect sqltest2A\RMDISTDS2
sp_adddistributor @distributor = @@ServerName, @password = 'P0ssw@rd1'
Go 
:Connect sqltest2b\RMDISTDS1
sp_adddistributor @distributor = @@ServerName, @password = 'P0ssw@rd1'
Go

-- Step2 - Configure the Distribution Database

:Connect sqltest2A\RMDISTDS2
USE master
EXEC sp_adddistributiondb @database = 'DistributionDB', @security_mode = 1;
GO
Alter Database [DistributionDB] Set Recovery Full
Go
Backup Database [DistributionDB] to Disk = 'Nul'
Go

-- Step 3 - Create AG for the Distribution DB.

:Connect sqltest2A\RMDISTDS2
USE [master]
GO
CREATE ENDPOINT [Hadr_endpoint] 
	STATE=STARTED
	AS TCP (LISTENER_PORT = 5024, LISTENER_IP = ALL)   
	FOR DATA_MIRRORING (ROLE = ALL, AUTHENTICATION = WINDOWS NEGOTIATE
, ENCRYPTION = REQUIRED ALGORITHM AES)
GO

:Connect sqltest2B\RMDISTDS1
USE [master]
GO
CREATE ENDPOINT [Hadr_endpoint] 
	STATE=STARTED
	AS TCP (LISTENER_PORT = 5024, LISTENER_IP = ALL)   
	FOR DATA_MIRRORING (ROLE = ALL, AUTHENTICATION = WINDOWS NEGOTIATE
, ENCRYPTION = REQUIRED ALGORITHM AES)
GO

:Connect sqltest2A\RMDISTDS2
-- Create the Availability Group
CREATE AVAILABILITY GROUP [Dist_AG]
FOR DATABASE [DistributionDB]
REPLICA ON 'sqltest2A\RMDISTDS2'
--WITH (ENDPOINT_URL = N'TCP://sqltest2A\RMDISTDS2.unesco.com:5024', 
--WITH (ENDPOINT_URL = N'TCP://Hadr_endpoint.unesco.com:5024', 
WITH (ENDPOINT_URL = N'TCP://sqltest2A.unesco.com:5024', 
		 FAILOVER_MODE = AUTOMATIC, 
		 AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, 
		 BACKUP_PRIORITY = 50, 
		 SECONDARY_ROLE(ALLOW_CONNECTIONS = ALL), 
		 SEEDING_MODE = AUTOMATIC),
N'sqltest2B\RMDISTDS1' 
--WITH (ENDPOINT_URL = N'TCP://sqltest2B\RMDISTDS1.unesco.com:5024', 
--WITH (ENDPOINT_URL = N'TCP://Hadr_endpoint.unesco.com:5024', 
WITH (ENDPOINT_URL = N'TCP://sqltest2B.unesco.com:5024', 
	 FAILOVER_MODE = AUTOMATIC, 
	 AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, 
	 BACKUP_PRIORITY = 50, 
	 SECONDARY_ROLE(ALLOW_CONNECTIONS = ALL), 
	 SEEDING_MODE = AUTOMATIC);
 GO

 :Connect sqltest2B\RMDISTDS1
ALTER AVAILABILITY GROUP [Dist_AG] JOIN
GO  
ALTER AVAILABILITY GROUP [Dist_AG] GRANT CREATE ANY DATABASE
Go

--STEP4 - Create the Listener for the Availability Group. This is very important.

:Connect sqltest2A\RMDISTDS2

USE [master]
GO
ALTER AVAILABILITY GROUP [Dist_AG]
ADD LISTENER N'replagagl1' (
WITH IP
((N'10.228.64.19', N'255.255.255.0')
)
, PORT=1433);
GO

-- STEP 5 - Enable SQLNode2 also as a Distributor

:CONNECT sqltest2B\RMDISTDS1
EXEC sp_adddistributiondb @database = 'DistributionDB', @security_mode = 1;
GO

--STEP 6 - On all Distributor Nodes Configure the Publisher Details 
:CONNECT sqltest2A\RMDISTDS2
EXEC sp_addDistPublisher @publisher = 'sqltest2DS1\DS1', @distribution_db = 'DistributionDB', 
	@working_directory = '\\sqltest2A\AG_Backup\'
GO
:CONNECT sqltest2B\RMDISTDS1
EXEC sp_addDistPublisher @publisher = 'sqltest2DS1\DS1', @distribution_db = 'DistributionDB', 
	@working_directory = '\\sqltest2A\AG_Backup\'
GO