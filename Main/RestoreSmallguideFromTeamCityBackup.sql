USE MASTER

--Look up existing snapshot
DECLARE @filename VARCHAR(128), @SQL nvarchar(1000)
SELECT @filename = physical_name
FROM sys.master_files
WHERE database_id = DB_ID('smallguidess')

-- Drop snapshot if it exists
IF ( @filename IS NOT NULL )
	DROP DATABASE SmallGuideSS

-- Kill all existing connections
ALTER DATABASE SmallGuide SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE SmallGuide SET ONLINE

-- Restore SmallGuide from the Team City backup
RESTORE DATABASE [smallguide] 
FROM  DISK = N'E:\MSSQL\data\DNADB-smallguide-teamcity.bak' 
WITH  FILE = 1,  
MOVE N'SmallGuide' TO N'E:\MSSQL\data\smallguide.mdf',  
MOVE N'SmallGuide_log' TO N'E:\MSSQL\data\smallguide.LDF',  
MOVE N'sysft_GuideEntriesCat' TO N'D:\MSSQL\FTData\SmallGuide\GuideEntriesCat0000',  
MOVE N'sysft_HierarchyCat' TO N'D:\MSSQL\FTData\SmallGuide\HierarchyCat0000',  
MOVE N'sysft_ThreadEntriesCat' TO N'D:\MSSQL\FTData\SmallGuide\ThreadEntriesCat0000',  
MOVE N'sysft_VGuideEntryText_collectiveCat' TO N'D:\MSSQL\FTData\SmallGuide\VGuideEntryText_collectiveCat0000',  
MOVE N'sysft_VGuideEntryText_memoryshareCat' TO N'D:\MSSQL\FTData\SmallGuide\VGuideEntryText_memoryshareCat0000',  
NOUNLOAD,  REPLACE,  STATS = 10

-- Recreate snapshot if it existed before the restore, using the same file name
IF ( @filename IS NOT NULL )
BEGIN
	PRINT 'Recreating SmallGuide SnapShot'
	SET @SQL = 'CREATE DATABASE SmallGuideSS ON 
	( NAME = SmallGuide, FILENAME = ''' + @filename + ''') AS SNAPSHOT OF SmallGuide'
	EXEC sp_executeSQL @SQL
END