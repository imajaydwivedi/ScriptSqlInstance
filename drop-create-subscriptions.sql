
:CONNECT [sqlprod1\DS1]
use [dailyclose]
exec sp_dropsubscription @publication = N'dailyclose_sqlprod4', @subscriber = N'PROD1DS4AGL1', @destination_db = N'dailyclose', @article = N'all';
go
exec sp_addsubscription @publication = N'dailyclose_sqlprod4', @subscriber = N'PROD1DS4AGL1', @destination_db = N'dailyclose', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod1\DS1]
use [geneva_warehouse]
exec sp_dropsubscription @publication = N'geneva_warehouse-sqlprod4', @subscriber = N'PROD1DS4AGL1', @destination_db = N'geneva_warehouse', @article = N'all';
go
exec sp_addsubscription @publication = N'geneva_warehouse-sqlprod4', @subscriber = N'PROD1DS4AGL1', @destination_db = N'geneva_warehouse', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod1\DS1]
use [geneva_warehouse]
exec sp_dropsubscription @publication = N'geneva_warehouse-sqlprod5', @subscriber = N'PROD1DS5AGL1', @destination_db = N'geneva_warehouse', @article = N'all';
go
exec sp_addsubscription @publication = N'geneva_warehouse-sqlprod5', @subscriber = N'PROD1DS5AGL1', @destination_db = N'geneva_warehouse', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [geneva]
exec sp_dropsubscription @publication = N'geneva_DBGEAR_1', @subscriber = N'PROD1DS1AGL1', @destination_db = N'geneva', @article = N'all';
go
exec sp_addsubscription @publication = N'geneva_DBGEAR_1', @subscriber = N'PROD1DS1AGL1', @destination_db = N'geneva', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [geneva]
exec sp_dropsubscription @publication = N'geneva_DBGEAR_2', @subscriber = N'PROD1DS1AGL1', @destination_db = N'geneva', @article = N'all';
go
exec sp_addsubscription @publication = N'geneva_DBGEAR_2', @subscriber = N'PROD1DS1AGL1', @destination_db = N'geneva', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [loans]
exec sp_dropsubscription @publication = N'loans_DBGEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'loans', @article = N'all';
go
exec sp_addsubscription @publication = N'loans_DBGEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'loans', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [loans]
exec sp_dropsubscription @publication = N'loans_DBGEAR1', @subscriber = N'PROD1DS1AGL1', @destination_db = N'loans', @article = N'all';
go
exec sp_addsubscription @publication = N'loans_DBGEAR1', @subscriber = N'PROD1DS1AGL1', @destination_db = N'loans', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_DBGELBASE_vws', @subscriber = N'DBCLQA1DS3\DS3', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_DBGELBASE_vws', @subscriber = N'DBCLQA1DS3\DS3', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_common', @subscriber = N'PROD1DS1AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_common', @subscriber = N'PROD1DS1AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_common1', @subscriber = N'PROD1DS1AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_common1', @subscriber = N'PROD1DS1AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_DBGEAR_vws', @subscriber = N'PROD1DS1AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_DBGEAR_vws', @subscriber = N'PROD1DS1AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_GEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_GEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_common', @subscriber = N'PROD1DS3AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_common', @subscriber = N'PROD1DS3AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_common1', @subscriber = N'PROD1DS3AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_common1', @subscriber = N'PROD1DS3AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_DBGELBASE', @subscriber = N'PROD1DS3AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_DBGELBASE', @subscriber = N'PROD1DS3AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_DBGELBASE_vws', @subscriber = N'PROD1DS3AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_DBGELBASE_vws', @subscriber = N'PROD1DS3AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_common', @subscriber = N'PROD1DS4AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_common', @subscriber = N'PROD1DS4AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_common1', @subscriber = N'PROD1DS4AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_common1', @subscriber = N'PROD1DS4AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_DBTierII_vws', @subscriber = N'PROD1DS4AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_DBTierII_vws', @subscriber = N'PROD1DS4AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_TierII', @subscriber = N'PROD1DS4AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_TierII', @subscriber = N'PROD1DS4AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_common', @subscriber = N'PROD1DS5AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_common', @subscriber = N'PROD1DS5AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_common1', @subscriber = N'PROD1DS5AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_common1', @subscriber = N'PROD1DS5AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_DBTierII_vws', @subscriber = N'PROD1DS5AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_DBTierII_vws', @subscriber = N'PROD1DS5AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [reference]
exec sp_dropsubscription @publication = N'reference_TierII', @subscriber = N'PROD1DS5AGL1', @destination_db = N'reference', @article = N'all';
go
exec sp_addsubscription @publication = N'reference_TierII', @subscriber = N'PROD1DS5AGL1', @destination_db = N'reference', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_DBGEAR_2', @subscriber = N'sqlprod1\DS1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_DBGEAR_2', @subscriber = N'sqlprod1\DS1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_DBGEAR_2', @subscriber = N'sqlprod4\DS4', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_DBGEAR_2', @subscriber = N'sqlprod4\DS4', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'DBGEAR_security_master_DBGEAR_non_core_attr_views', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'DBGEAR_security_master_DBGEAR_non_core_attr_views', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common1', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common1', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common2', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common2', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_DBGEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_DBGEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_DBGEAR_flattened_views', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_DBGEAR_flattened_views', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_DBGEAR_flattened_views_deprecated', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_DBGEAR_flattened_views_deprecated', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_DBGEAR_views', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_DBGEAR_views', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_DBGEAR_views', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_DBGEAR_views', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_GEAR_GELBASE_2014', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_GEAR_GELBASE_2014', @subscriber = N'PROD1DS1AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common1', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common1', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common2', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common2', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_DBGEAR2', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_DBGEAR2', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_GEAR_GELBASE_2014', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_GEAR_GELBASE_2014', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_GELBASE', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_GELBASE', @subscriber = N'PROD1DS3AGL1', @destination_db = N'_security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master.reference', @subscriber = N'PROD1DS3AGL1', @destination_db = N'atlas', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master.reference', @subscriber = N'PROD1DS3AGL1', @destination_db = N'atlas', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common', @subscriber = N'PROD1DS4AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common', @subscriber = N'PROD1DS4AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common1', @subscriber = N'PROD1DS4AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common1', @subscriber = N'PROD1DS4AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_common2', @subscriber = N'PROD1DS4AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_common2', @subscriber = N'PROD1DS4AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_TierII', @subscriber = N'PROD1DS4AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_TierII', @subscriber = N'PROD1DS4AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [security_master]
exec sp_dropsubscription @publication = N'security_master_spn_multiverse_DS5', @subscriber = N'PROD1DS5AGL1', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'security_master_spn_multiverse_DS5', @subscriber = N'PROD1DS5AGL1', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod2\DS2]
use [seed]
exec sp_dropsubscription @publication = N'seed-gear-ca-postion', @subscriber = N'PROD1DS1AGL1', @destination_db = N'seed', @article = N'all';
go
exec sp_addsubscription @publication = N'seed-gear-ca-postion', @subscriber = N'PROD1DS1AGL1', @destination_db = N'seed', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [atlas]
exec sp_dropsubscription @publication = N'atlas_market_tables', @subscriber = N'DBAGSECMASTER', @destination_db = N'security_master', @article = N'all';
go
exec sp_addsubscription @publication = N'atlas_market_tables', @subscriber = N'DBAGSECMASTER', @destination_db = N'security_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [atlas]
exec sp_dropsubscription @publication = N'atlas_DBGEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'atlas', @article = N'all';
go
exec sp_addsubscription @publication = N'atlas_DBGEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'atlas', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [atlas]
exec sp_dropsubscription @publication = N'atlas_Tier_II', @subscriber = N'PROD1DS4AGL1', @destination_db = N'atlas', @article = N'all';
go
exec sp_addsubscription @publication = N'atlas_Tier_II', @subscriber = N'PROD1DS4AGL1', @destination_db = N'atlas', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [atlas]
exec sp_dropsubscription @publication = N'atlas-universe', @subscriber = N'PROD1DS4AGL1', @destination_db = N'atlas', @article = N'all';
go
exec sp_addsubscription @publication = N'atlas-universe', @subscriber = N'PROD1DS4AGL1', @destination_db = N'atlas', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [atlas]
exec sp_dropsubscription @publication = N'atlas_Tier_II', @subscriber = N'PROD1DS5AGL1', @destination_db = N'atlas', @article = N'all';
go
exec sp_addsubscription @publication = N'atlas_Tier_II', @subscriber = N'PROD1DS5AGL1', @destination_db = N'atlas', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [atlas]
exec sp_dropsubscription @publication = N'atlas-universe', @subscriber = N'PROD1DS5AGL1', @destination_db = N'atlas', @article = N'all';
go
exec sp_addsubscription @publication = N'atlas-universe', @subscriber = N'PROD1DS5AGL1', @destination_db = N'atlas', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [equities]
exec sp_dropsubscription @publication = N'equities_DBMO', @subscriber = N'PROD1DS4AGL1', @destination_db = N'equities', @article = N'all';
go
exec sp_addsubscription @publication = N'equities_DBMO', @subscriber = N'PROD1DS4AGL1', @destination_db = N'equities', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [fixed]
exec sp_dropsubscription @publication = N'fixed_DBSEED_curve_tbls', @subscriber = N'PROD1DS2AGL1', @destination_db = N'fixed', @article = N'all';
go
exec sp_addsubscription @publication = N'fixed_DBSEED_curve_tbls', @subscriber = N'PROD1DS2AGL1', @destination_db = N'fixed', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [fixed]
exec sp_dropsubscription @publication = N'fixed_DBSEEDNYC', @subscriber = N'PROD1DS2AGL1', @destination_db = N'fixed', @article = N'all';
go
exec sp_addsubscription @publication = N'fixed_DBSEEDNYC', @subscriber = N'PROD1DS2AGL1', @destination_db = N'fixed', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [qual_trading]
exec sp_dropsubscription @publication = N'qual_trading_DBGEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'qual_trading', @article = N'all';
go
exec sp_addsubscription @publication = N'qual_trading_DBGEAR', @subscriber = N'PROD1DS1AGL1', @destination_db = N'qual_trading', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod3\DS3]
use [qual_trading]
exec sp_dropsubscription @publication = N'qual_trading_GEAR_SEED', @subscriber = N'PROD1DS1AGL1', @destination_db = N'qual_trading', @article = N'all';
go
exec sp_addsubscription @publication = N'qual_trading_GEAR_SEED', @subscriber = N'PROD1DS1AGL1', @destination_db = N'qual_trading', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod4\DS4]
use [authorizationdb]
exec sp_dropsubscription @publication = N'authorizationdb_DBNYC1DS3', @subscriber = N'PROD1DS5AGL1', @destination_db = N'authorizationdb', @article = N'all';
go
exec sp_addsubscription @publication = N'authorizationdb_DBNYC1DS3', @subscriber = N'PROD1DS5AGL1', @destination_db = N'authorizationdb', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [coda]
exec sp_dropsubscription @publication = N'coda-dbgearnyc', @subscriber = N'PROD1DS1AGL1', @destination_db = N'coda', @article = N'all';
go
exec sp_addsubscription @publication = N'coda-dbgearnyc', @subscriber = N'PROD1DS1AGL1', @destination_db = N'coda', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [coda]
exec sp_dropsubscription @publication = N'coda-DBRECONNYC', @subscriber = N'PROD1DS4AGL1', @destination_db = N'coda', @article = N'all';
go
exec sp_addsubscription @publication = N'coda-DBRECONNYC', @subscriber = N'PROD1DS4AGL1', @destination_db = N'coda', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [HRBase]
exec sp_dropsubscription @publication = N'sqlprod5..HRBase to sqlprod5..ams_uat', @subscriber = N'PROD1DS5AGL1', @destination_db = N'ams_uat', @article = N'all';
go
exec sp_addsubscription @publication = N'sqlprod5..HRBase to sqlprod5..ams_uat', @subscriber = N'PROD1DS5AGL1', @destination_db = N'ams_uat', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [price_master]
exec sp_dropsubscription @publication = N'price_master_to_be_del_ds2', @subscriber = N'PROD1DS2AGL1', @destination_db = N'price_master', @article = N'all';
go
exec sp_addsubscription @publication = N'price_master_to_be_del_ds2', @subscriber = N'PROD1DS2AGL1', @destination_db = N'price_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [price_master]
exec sp_dropsubscription @publication = N'price_master_to_be_del_ds4_ds2', @subscriber = N'PROD1DS4AGL1', @destination_db = N'price_master', @article = N'all';
go
exec sp_addsubscription @publication = N'price_master_to_be_del_ds4_ds2', @subscriber = N'PROD1DS4AGL1', @destination_db = N'price_master', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [rms]
exec sp_dropsubscription @publication = N'sqlprod5..rms to DBDMZTOA2..ams_icims', @subscriber = N'DBAMS.AD.unesco.NET', @destination_db = N'ams_icims', @article = N'all';
go
exec sp_addsubscription @publication = N'sqlprod5..rms to DBDMZTOA2..ams_icims', @subscriber = N'DBAMS.AD.unesco.NET', @destination_db = N'ams_icims', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [rms]
exec sp_dropsubscription @publication = N'sqlprod5..rms to sqlprod5..ams', @subscriber = N'PROD1DS5AGL1', @destination_db = N'ams', @article = N'all';
go
exec sp_addsubscription @publication = N'sqlprod5..rms to sqlprod5..ams', @subscriber = N'PROD1DS5AGL1', @destination_db = N'ams', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [rms_nyc]
exec sp_dropsubscription @publication = N'sqlprod5..rms_nyc_ to DMZ2.._rms_nyc', @subscriber = N'DBAMS.AD.unesco.NET', @destination_db = N'rms_nyc', @article = N'all';
go
exec sp_addsubscription @publication = N'sqlprod5..rms_nyc_ to DMZ2.._rms_nyc', @subscriber = N'DBAMS.AD.unesco.NET', @destination_db = N'rms_nyc', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [rms_nyc]
exec sp_dropsubscription @publication = N'rms_nyc_to_rms_nyc_reports', @subscriber = N'PROD1DS5AGL1', @destination_db = N'rms_nyc_reports', @article = N'all';
go
exec sp_addsubscription @publication = N'rms_nyc_to_rms_nyc_reports', @subscriber = N'PROD1DS5AGL1', @destination_db = N'rms_nyc_reports', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go

:CONNECT [sqlprod5\DS5]
use [rms_uat]
exec sp_dropsubscription @publication = N'sqlprod5..rms_uat to sqlprod5..ams_uat', @subscriber = N'PROD1DS5AGL1', @destination_db = N'ams_uat', @article = N'all';
go
exec sp_addsubscription @publication = N'sqlprod5..rms_uat to sqlprod5..ams_uat', @subscriber = N'PROD1DS5AGL1', @destination_db = N'ams_uat', 
						@subscription_type = N'Push', @article = N'all',
						@sync_type = N'replication support only'
go
