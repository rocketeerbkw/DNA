IF DB_NAME() NOT LIKE '%guide%'
BEGIN
	RAISERROR ('Are you sure you want to apply this script to a non-guide db?',20,1) WITH LOG;
	RETURN
END
GO

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- Check the column type to see if it's already been converted to nvarchar.
DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype('Threads','FirstSubject')
IF @type IS NULL RAISERROR ('Failed to find type for column',20,1) WITH LOG

IF @type = 'nvarchar'
BEGIN 
	-- Level 20 is used as it will kill the connection, preventing any further script after the GO from executing
	RAISERROR ('This table has already been converted to Unicode.  No need to run this script',20,1) WITH LOG
END
GO

-- DROP all the indexes on Thread to create some space in the data files
DROP INDEX IX_Threads_MostRecentThreads						ON dbo.Threads
DROP INDEX IX_Threads_SiteIDLastPosted						ON dbo.Threads
DROP INDEX nci_Threads_ForumID_VisibleTo_Included_Dates_4	ON dbo.Threads
DROP INDEX threads0											ON dbo.Threads
GO
ALTER TABLE dbo.ThreadEntries DROP CONSTRAINT FK_ThreadEntries_Threads
GO
SELECT ThreadID, Keywords, ForumID, DateCreated, CONVERT(nvarchar(255), FirstSubject) AS FirstSubject, LastPosted, MovedFrom, LastUpdated, VisibleTo, 
	CanRead, CanWrite, Type, EventDate, ThreadPostCount, ModerationStatus, SiteID 
	INTO dbo.Tmp_Threads
	FROM dbo.Threads
	-- Took 1m40s on my machine
GO
DROP TABLE dbo.Threads
GO
-- Make the Unicode version the real version
EXECUTE sp_rename N'dbo.Tmp_Threads', N'Threads', 'OBJECT' 
GO
GRANT SELECT ON dbo.Threads TO ripleyrole  AS dbo
GO
GRANT INSERT ON dbo.Threads TO wholesite  AS dbo
GO
GRANT SELECT ON dbo.Threads TO wholesite  AS dbo
GO
GRANT SELECT ON dbo.Threads TO editrole  AS dbo
GO
GRANT UPDATE ON dbo.Threads TO wholesite  AS dbo
GO

ALTER TABLE dbo.Threads ADD CONSTRAINT DF_Threads_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
ALTER TABLE dbo.Threads ADD CONSTRAINT DF_Threads_LastPosted DEFAULT (getdate()) FOR LastPosted
GO
ALTER TABLE dbo.Threads ADD CONSTRAINT DF_Threads_LastUpdated DEFAULT (getdate()) FOR LastUpdated
GO
ALTER TABLE dbo.Threads ADD CONSTRAINT DF_Threads_CanRead DEFAULT (1) FOR CanRead
GO
ALTER TABLE dbo.Threads ADD CONSTRAINT DF_Threads_CanWrite DEFAULT (1) FOR CanWrite
GO
ALTER TABLE dbo.Threads ADD CONSTRAINT DF_Threads_PostCount DEFAULT (0) FOR ThreadPostCount
GO

ALTER TABLE dbo.Threads ADD CONSTRAINT
	PK_Threads PRIMARY KEY CLUSTERED 
	(
	ThreadID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 4m25s on my machine
GO
CREATE NONCLUSTERED INDEX threads0 ON dbo.Threads
	(
	ForumID,
	LastPosted,
	VisibleTo,
	ThreadID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 21s on my machine
GO
CREATE NONCLUSTERED INDEX nci_Threads_ForumID_VisibleTo_Included_Dates_4 ON dbo.Threads
	(
	ForumID,
	DateCreated,
	VisibleTo
	) INCLUDE (ThreadID) 
    WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 18s on my machine
GO
CREATE NONCLUSTERED INDEX IX_Threads_MostRecentThreads ON dbo.Threads
	(
	DateCreated DESC
	) INCLUDE (ThreadID, ForumID, VisibleTo, CanRead) 
    WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 14s on my machine
GO
CREATE NONCLUSTERED INDEX IX_Threads_SiteIDLastPosted ON dbo.Threads
	(
	SiteID,
	LastPosted DESC
	) INCLUDE (CanRead, VisibleTo) 
    WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 20s on my machine
GO
ALTER TABLE dbo.Threads ADD CONSTRAINT
	FK_Threads_Forums FOREIGN KEY
	(
	ForumID
	) REFERENCES dbo.Forums
	(
	ForumID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	-- Took 18s on my machine
GO
CREATE TRIGGER trg_Threads_iu ON dbo.Threads
AFTER INSERT, UPDATE 
AS
	-- If the forumid changes for this thread, make sure the SiteID
	-- is the same as the siteid for the new forum
	IF UPDATE(ForumID)
	BEGIN
		UPDATE dbo.Threads SET dbo.Threads.SiteID = f.SiteID 
			FROM inserted i
			INNER JOIN Forums f ON f.ForumId = i.ForumID
			WHERE dbo.Threads.ThreadID=i.ThreadID
	END
GO
DENY DELETE ON dbo.Threads TO readonly  AS dbo 
GO
DENY INSERT ON dbo.Threads TO readonly  AS dbo 
GO
DENY UPDATE ON dbo.Threads TO readonly  AS dbo 
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
	-- Took 1m57s on my machine
GO
