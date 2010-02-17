IF DB_NAME() NOT LIKE '%guide%'
BEGIN
	RAISERROR ('Are you sure you want to apply this script to a non-guide db?',20,1) WITH LOG;
	RETURN
END
GO

IF ( DB_NAME() = 'SmallGuide' AND DB_ID('SmallGuideSS') > 0  )
BEGIN
	-- Restore SmallGuide DB from SnapShot, cannot restore whilst it has active connections.
	USE MASTER
	ALTER DATABASE SmallGuide SET OFFLINE WITH ROLLBACK IMMEDIATE
	ALTER DATABASE SmallGuide SET ONLINE
	RESTORE DATABASE SmallGuide FROM DATABASE_SNAPSHOT = 'SmallGuideSS'
	PRINT 'Restoring Small Guide From Snapshot.'
	USE SmallGuide
END
GO
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- Check the column type to see if it's already been converted to nvarchar.
DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype('ThreadEntries','Subject')
IF @type IS NULL RAISERROR ('Failed to find type for column',20,1) WITH LOG

IF @type = 'nvarchar'
BEGIN 
	-- Level 20 is used as it will kill the connection, preventing any further script after the GO from executing
	RAISERROR ('This table has already been converted to Unicode.  No need to run this script',20,1) WITH LOG
END
GO
-- Put the db into SIMPLE recovery mode so that the operations are minimally logged
ALTER DATABASE [TheGuide] SET RECOVERY SIMPLE 
GO

-- DROP all the indexes on ThreadEntries to create some space in the data files
DROP INDEX IX_ThreadEntries_ForumID			ON dbo.ThreadEntries
DROP INDEX IX_ThreadEntries_Parent			ON dbo.ThreadEntries
DROP INDEX IX_ThreadEntries_ThreadPostIndex ON dbo.ThreadEntries
DROP INDEX IX_ThreadEntries_DatePosted		ON dbo.ThreadEntries
DROP INDEX IX_ThreadUsers					ON dbo.ThreadEntries
GO
SELECT	te.ThreadID, te.blobid, te.ForumID, te.UserID, CONVERT(nvarchar(255), te.Subject) AS [Subject], te.NextSibling, te.Parent, te.PrevSibling, 
		te.FirstChild, te.EntryID, te.DatePosted, CONVERT(nvarchar(255), te.UserName) AS UserName, te.Hidden, te.PostIndex, te.PostStyle, 
		CONVERT(nvarchar(MAX), te.text) AS [text], te.LastUpdated 
	INTO dbo.Tmp_ThreadEntries
	FROM dbo.ThreadEntries te
-- 19mins on GUIDE6-2
-- 1h 55mins on my machine (13-5-09)
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
-- Only have to worry about ripleyrole on dev machines
GRANT SELECT ON dbo.ThreadEntries TO ripleyrole  AS dbo
GO
-- Add default constraints
ALTER TABLE dbo.ThreadEntries ADD CONSTRAINT DF_ThreadEntries_DatePosted DEFAULT (getdate()) FOR DatePosted
GO
ALTER TABLE dbo.ThreadEntries ADD CONSTRAINT DF_ThreadEntries_PostIndex DEFAULT (0) FOR PostIndex
GO

-- Create the indexes

ALTER TABLE dbo.ThreadEntries ADD CONSTRAINT
	PK_ThreadEntries PRIMARY KEY CLUSTERED 
	(
	EntryID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 45mins in BULK_LOGGED mode 28-4-09
-- 36mins in FULL mode 28-4-09
-- 4h 23mins on my machine (14-05-09)
GO

-- Recreate Indexes
CREATE NONCLUSTERED INDEX IX_ThreadEntries_ForumID ON dbo.ThreadEntries
	(
	ForumID
	) INCLUDE (ThreadID, UserID, Parent, Hidden, PostIndex) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 13m in BULK_LOGGED mode 28-4-09
-- 13m in FULL mode 28-4-09
-- 43mins on my machine (14-05-09)
GO
CREATE NONCLUSTERED INDEX IX_ThreadEntries_Parent ON dbo.ThreadEntries
	(
	Parent
	) INCLUDE (NextSibling, EntryID) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 10m in BULK_LOGGED mode 28-4-09
-- 10m  in FULL mode 28-4-09
-- 36mins on my machine (14-05-09)
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_ThreadEntries_ThreadPostIndex ON dbo.ThreadEntries
	(
	ThreadID,
	PostIndex
	) INCLUDE (UserID, DatePosted, Hidden) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 12m in BULK_LOGGED mode 28-4-09
-- 11m in FULL mode 29-4-09
-- 42mins on my machine (14-05-09)
GO
CREATE NONCLUSTERED INDEX IX_ThreadEntries_DatePosted ON dbo.ThreadEntries
	(
	DatePosted
	) INCLUDE (ForumID, Hidden) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 10m in BULK_LOGGED mode 28-4-09
-- 10m in FULL mode 29-4-09
-- 39mins on my machine (14-05-09)

GO
CREATE NONCLUSTERED INDEX IX_ThreadUsers ON dbo.ThreadEntries
	(
	UserID
	) INCLUDE (DatePosted, ForumID) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- 13m in BULK_LOGGED mode 28-4-09
-- 13m in FULL mode 29-4-09
-- 38mins on my machine (14-05-09)
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

-- Both constraints: 5mins on my machine (14-05-09)

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

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--Recreate SmallGuide Snapshot. Create Database not permitted within transaction.
IF DB_NAME() = 'SmallGuide'
BEGIN
	--Create New SnapShot.
	DECLARE @filename VARCHAR(128), @SQL nvarchar(1000)
	SELECT @filename = physical_name
	FROM sys.master_files
	WHERE database_id = DB_ID('smallguidess')

	IF ( @filename IS NOT NULL )
	BEGIN
		DROP DATABASE SmallGuideSS
		SET @SQL = 'CREATE DATABASE SmallGuideSS ON 
		( NAME = SmallGuide, FILENAME = ''' + @filename + ''') AS SNAPSHOT OF SmallGuide'
		EXEC sp_executeSQL @SQL
		PRINT 'Recreating SmallGuide SnapShot'
	END
END

