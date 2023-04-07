use master
go

:CONNECT dbrepl1
GO
SELECT @@SERVERNAME as srv_name
GO
EXECUTE dbo.DatabaseBackup
@Databases = 'ALL_DATABASES',
@Directory = '\\sqlmon2\sqlrepl1-sql2019upgrade',
-- '\\dbmonitor.unesco.com\F$\sqlrepl1-sql2019upgrade'
@BackupType = 'FULL',
@CopyOnly = 'Y',
@Compress = 'Y',
@DirectoryStructure = NULL,
@AvailabilityGroupDirectoryStructure = NULL,
@OverrideBackupPreference = 'Y',
@FileName = '{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}',
@AvailabilityGroupFileName = '{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'
,@Execute = 'N'
GO
SELECT 'Check Messages Tab' as [** Backup Progress **]
GO

:CONNECT dbrepl2
GO
SELECT @@SERVERNAME as srv_name
GO
EXECUTE dbo.DatabaseBackup
@Databases = 'ALL_DATABASES',
@Directory = '\\sqlmon2\sqlrepl1-sql2019upgrade',
-- '\\dbmonitor.unesco.com\F$\sqlrepl1-sql2019upgrade'
@BackupType = 'FULL',
@CopyOnly = 'Y',
@Compress = 'Y',
@DirectoryStructure = NULL,
@AvailabilityGroupDirectoryStructure = NULL,
@OverrideBackupPreference = 'Y',
@FileName = '{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}',
@AvailabilityGroupFileName = '{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'
,@Execute = 'N'
GO
SELECT 'Check Messages Tab' as [** Backup Progress **]
GO
