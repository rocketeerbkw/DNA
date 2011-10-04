USE master
GO

RESTORE DATABASE TheGuide FROM 
	DISK = 'D:\TheGuideBackup\theguide_Full_001.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_002.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_003.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_004.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_005.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_006.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_007.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_008.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_009.bak',
	DISK = 'D:\TheGuideBackup\theguide_Full_010.bak'

WITH MOVE 'TheGuide_Data'	TO 'D:\MSSQL\Data\TheGuide.mdf',
MOVE 'TheGuide_Data2'		TO 'D:\MSSQL\Data\TheGuide2.ndf',
MOVE 'TheGuide_Data3'		TO 'D:\MSSQL\Data\TheGuide3.ndf',
MOVE 'TheGuide_Data4'		TO 'D:\MSSQL\Data\TheGuide4.ndf',
MOVE 'TheGuide_Log'			TO 'E:\MSSQL\Logs\TheGuide_log.LDF',

MOVE 'sysft_GuideEntriesCat'				TO 'F:\MSSQL\FTData\TheGuide_GuideEntriesCat',
MOVE 'sysft_ThreadEntriesCat'				TO 'F:\MSSQL\FTData\TheGuide_ThreadEntriesCat',
MOVE 'sysft_HierarchyCat'					TO 'F:\MSSQL\FTData\TheGuide_HierarchyCat',
MOVE 'sysft_VGuideEntryText_collectiveCat'	TO 'F:\MSSQL\FTData\TheGuide_VGuideEntryText_collectiveCat',
MOVE 'sysft_VGuideEntryText_memoryshareCat' TO 'F:\MSSQL\FTData\TheGuide_VGuideEntryText_memoryshareCat'
,REPLACE
,STATS=5
GO

USE TheGuide
GO
exec sp_revokedbaccess N'ripley'
exec sp_grantdbaccess N'ripley', N'ripley'
exec sp_addrolemember N'ripleyrole', N'ripley'
GO

-- Ensure we use CHECKSUM page verification
ALTER DATABASE TheGuide SET PAGE_VERIFY CHECKSUM
GO