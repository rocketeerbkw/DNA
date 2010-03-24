USE TheGuide
GO
-- Increase the size of the four data files to 45Gb each, and the log to 80Gb
-- We're going to need this extra space to store the old and new
-- versions of ThreadEntries
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Data',  SIZE = 46080000KB )
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Data2', SIZE = 46080000KB )
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Data3', SIZE = 46080000KB )
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Data4', SIZE = 46080000KB )
ALTER DATABASE [TheGuide] MODIFY FILE ( NAME = N'TheGuide_Log',   SIZE = 81920000KB )
-- This took 20mins on 28-4-09!
GO
-- DROP all the indexes on ThreadEntries to create some space in the data files
DROP INDEX IX_ThreadEntries_ForumID			ON dbo.ThreadEntries
DROP INDEX IX_ThreadEntries_Parent			ON dbo.ThreadEntries
DROP INDEX IX_ThreadEntries_ThreadPostIndex ON dbo.ThreadEntries
DROP INDEX IX_ThreadEntries_DatePosted		ON dbo.ThreadEntries
DROP INDEX IX_ThreadUsers					ON dbo.ThreadEntries
GO
-- Put the db into BULK_LOGGED recovery mode so that the operations are minimally logged
ALTER DATABASE [TheGuide] SET RECOVERY BULK_LOGGED 
GO
USE TheGuide
GO
--DROP TABLE dbo.Tmp_ThreadEntries
GO
SELECT	te.ThreadID, te.blobid, te.ForumID, te.UserID, CONVERT(nvarchar(255), te.Subject) AS [Subject], te.NextSibling, te.Parent, te.PrevSibling, 
		te.FirstChild, te.EntryID, te.DatePosted, CONVERT(nvarchar(255), te.UserName) AS UserName, te.Hidden, te.PostIndex, te.PostStyle, 
		CONVERT(nvarchar(MAX), te.text) AS [text], te.LastUpdated 
	INTO dbo.Tmp_ThreadEntries
	FROM dbo.ThreadEntries te
-- 19m on 28/4/09
GO
-- Put the db back into FULL recovery mode
ALTER DATABASE [TheGuide] SET RECOVERY FULL
GO
DECLARE @disk nvarchar(1000)
SET @disk = N'H:\TempBackup\BeforeDateFileShrink_' + REPLACE(convert(nvarchar(20), getdate(), 120),N':', N'_') + N'.bak'
BACKUP LOG [theguide] TO  DISK = @disk WITH  INIT ,  NOUNLOAD ,  NAME = N'theguide backup Log',  SKIP ,  STATS = 10,  FORMAT ,  MEDIANAME = N'theguideLog',  MEDIADESCRIPTION = N'local Log'
-- took 25mins 31s, and generated a log file backup of 122Gb!
-- 11m & 59Gb, but only the SELECT INTO has been backed up - 28-4-09
GO
DROP VIEW VUserPostCount
DROP VIEW VUserComments
PRINT 'IMPORTANT: Make sure you recreate views VUserPostCount & VUserComments once you are done'
GO
DROP TABLE dbo.ThreadEntries
GO
-- Make the Unicode version the real version
EXECUTE sp_rename N'dbo.Tmp_ThreadEntries', N'ThreadEntries', 'OBJECT' 
GO


GRANT INSERT ON dbo.ThreadEntries TO wholesite  AS dbo
GO
GRANT SELECT ON dbo.ThreadEntries TO ripleyrole  AS dbo
GO
GRANT SELECT ON dbo.ThreadEntries TO wholesite  AS dbo
GO
GRANT SELECT ON dbo.ThreadEntries TO editrole  AS dbo
GO
GRANT UPDATE ON dbo.ThreadEntries TO wholesite  AS dbo
GO

ALTER TABLE dbo.ThreadEntries ADD CONSTRAINT
	DF_ThreadEntries_DatePosted DEFAULT (getdate()) FOR DatePosted
GO
ALTER TABLE dbo.ThreadEntries ADD CONSTRAINT
	DF_ThreadEntries_PostIndex DEFAULT (0) FOR PostIndex
GO
--EXECUTE sp_tableoption N'dbo.Tmp_ThreadEntries', 'text in row', '5000'
GO

-- Indexes

ALTER TABLE dbo.ThreadEntries ADD CONSTRAINT
	PK_ThreadEntries PRIMARY KEY CLUSTERED 
	(
	EntryID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 45mins in BULK_LOGGED mode 28-4-09
-- 36mins in FULL mode 28-4-09
GO

-- Recreate Indexes
CREATE NONCLUSTERED INDEX IX_ThreadEntries_ForumID ON dbo.ThreadEntries
	(
	ForumID
	) INCLUDE (ThreadID, UserID, Parent, Hidden, PostIndex) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 13m in BULK_LOGGED mode 28-4-09
-- 13m in FULL mode 28-4-09
GO
CREATE NONCLUSTERED INDEX IX_ThreadEntries_Parent ON dbo.ThreadEntries
	(
	Parent
	) INCLUDE (NextSibling, EntryID) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 10m in BULK_LOGGED mode 28-4-09
-- 10m  in FULL mode 28-4-09
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_ThreadEntries_ThreadPostIndex ON dbo.ThreadEntries
	(
	ThreadID,
	PostIndex
	) INCLUDE (UserID, DatePosted, Hidden) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 12m in BULK_LOGGED mode 28-4-09
-- 11m in FULL mode 29-4-09
GO
CREATE NONCLUSTERED INDEX IX_ThreadEntries_DatePosted ON dbo.ThreadEntries
	(
	DatePosted
	) INCLUDE (ForumID, Hidden) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 10m in BULK_LOGGED mode 28-4-09
-- 10m in FULL mode 29-4-09
GO
CREATE NONCLUSTERED INDEX IX_ThreadUsers ON dbo.ThreadEntries
	(
	UserID
	) INCLUDE (DatePosted, ForumID) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 13m in BULK_LOGGED mode 28-4-09
-- 13m in FULL mode 29-4-09
GO
ALTER TABLE dbo.ThreadEntries ADD CONSTRAINT
	FK_ThreadEntries_Users FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ThreadEntries ADD CONSTRAINT
	FK_ThreadEntries_Threads FOREIGN KEY
	(
	ThreadID
	) REFERENCES dbo.Threads
	(
	ThreadID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
DENY DELETE ON dbo.ThreadEntries TO readonly  AS dbo 
GO
DENY INSERT ON dbo.ThreadEntries TO readonly  AS dbo 
GO
DENY UPDATE ON dbo.ThreadEntries TO readonly  AS dbo 
GO
CREATE FULLTEXT INDEX ON dbo.ThreadEntries
( 
	text LANGUAGE 0
 )
KEY INDEX PK_ThreadEntries
ON ThreadEntriesCat
 WITH  CHANGE_TRACKING  OFF , NO POPULATION 
GO
ALTER FULLTEXT INDEX ON dbo.ThreadEntries
ENABLE 
GO


DBCC SHRINKFILE(TheGuide_Data,40000)-- 1m27s, 11m34s, 16m36s
DBCC SHRINKFILE(TheGuide_Data2,40000)-- 3m04s, 8m38s, 15m24s
DBCC SHRINKFILE(TheGuide_Data3,40000)-- 12m37s, 7m42s, 13m41s
DBCC SHRINKFILE(TheGuide_Data4,40000)-- 10m03s, 7m09s, 8m01s
GO
DECLARE @disk nvarchar(1000)
SET @disk = N'H:\TempBackup\BeforeDateFileShrink_' + REPLACE(convert(nvarchar(20), getdate(), 120),N':', N'_') + N'.bak'
BACKUP LOG [theguide] TO  DISK = @disk WITH  INIT ,  NOUNLOAD ,  NAME = N'theguide backup Log',  SKIP ,  STATS = 10,  FORMAT ,  MEDIANAME = N'theguideLog',  MEDIADESCRIPTION = N'local Log'
-- took 3mins 16s, and generated a log file backup of 21Gb!
-- took 3mins 50s, and generated a log file backup of 26Gb!
-- took 14m, bak file 89Gb! 29-4-09
GO
-- Back-up log again using above script
GO
DBCC SHRINKFILE(TheGuide_Log,500) -- 3m16s
GO

