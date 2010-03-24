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
SET @type = dbo.udf_getcolumntype('Forums','Title')
IF @type IS NULL RAISERROR ('Failed to find type for column',20,1) WITH LOG

IF @type = 'nvarchar'
BEGIN 
	-- Level 20 is used as it will kill the connection, preventing any further script after the GO from executing
	RAISERROR ('This table has already been converted to Unicode.  No need to run this script',20,1) WITH LOG
END
GO

DROP INDEX IX_ForumJournalOwner    ON dbo.Forums
DROP INDEX IX_Forums_ForumIDSiteID ON dbo.Forums
DROP INDEX IX_ForumsSiteId         ON dbo.Forums
GO

ALTER TABLE dbo.GuideEntries DROP CONSTRAINT FK_GuideEntries_Forums
GO
ALTER TABLE dbo.Threads DROP CONSTRAINT FK_Threads_Forums
GO

DROP VIEW VGuideEntryForumLastPosted
DROP VIEW VGuideEntryForumPostCount  
DROP VIEW VUserPostCount  
PRINT 'IMPORTANT: Make sure you recreate views VGuideEntryForumLastPosted, VGuideEntryForumPostCount & VUserPostCount once you are done'
GO

SELECT ForumID, CONVERT(nvarchar(255), Title) AS Title, keywords, LastPosted, JournalOwner, LastUpdated, DateCreated, SiteID, CanRead, CanWrite, 
	ThreadCanRead, ThreadCanWrite, TempID, ModerationStatus, AlertInstantly, ForumStyle, ForumPostCount 
	INTO dbo.Tmp_Forums
	FROM dbo.Forums
	-- Took 3m52s on my machine
GO
DROP TABLE dbo.Forums
GO
-- Make the Unicode version the real version
EXECUTE sp_rename N'dbo.Tmp_Forums', N'Forums', 'OBJECT' 
GO
GRANT SELECT ON dbo.Forums TO ripleyrole  AS dbo
GO
-- Only need to do these roles in production
GRANT INSERT ON dbo.Forums TO wholesite  AS dbo
GO
GRANT SELECT ON dbo.Forums TO wholesite  AS dbo
GO
GRANT SELECT ON dbo.Forums TO editrole  AS dbo
GO
GRANT UPDATE ON dbo.Forums TO wholesite  AS dbo
GO

ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_LastPosted DEFAULT (getdate()) FOR LastPosted
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_LastUpdated DEFAULT (getdate()) FOR LastUpdated
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_SiteID DEFAULT (1) FOR SiteID
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_CanRead DEFAULT (1) FOR CanRead
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_CanWrite DEFAULT (1) FOR CanWrite
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_ThreadCanRead DEFAULT (1) FOR ThreadCanRead
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_ThreadCanWrite DEFAULT (1) FOR ThreadCanWrite
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_AlertInstantly DEFAULT (0) FOR AlertInstantly
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_ForumStyle DEFAULT (0) FOR ForumStyle
GO
ALTER TABLE dbo.Forums ADD CONSTRAINT DF_Forums_ForumPostCount DEFAULT (0) FOR ForumPostCount
GO


ALTER TABLE dbo.Forums ADD CONSTRAINT
	PK_Forums PRIMARY KEY CLUSTERED 
	(
	ForumID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 6m01s on my machine
GO
CREATE NONCLUSTERED INDEX IX_ForumJournalOwner ON dbo.Forums
	(
	JournalOwner
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 1m02s on my machine
GO
CREATE NONCLUSTERED INDEX IX_Forums_ForumIDSiteID ON dbo.Forums
	(
	ForumID,
	SiteID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 1m04s on my machine
GO
CREATE NONCLUSTERED INDEX IX_ForumsSiteId ON dbo.Forums
	(
	SiteID,
	ForumID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	-- Took 18s on my machine
GO
ALTER TABLE dbo.Forums WITH NOCHECK ADD CONSTRAINT
	FK_Forums_Sites FOREIGN KEY
	(
	SiteID
	) REFERENCES dbo.Sites
	(
	SiteID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
CREATE TRIGGER trg_Forums_u ON dbo.Forums
AFTER UPDATE 
AS
	-- If the siteid changes for this forum,
	-- update the siteid on all associated Threads
	IF UPDATE(SiteID)
	BEGIN
		UPDATE dbo.Threads SET dbo.Threads.SiteID = i.SiteID 
			FROM inserted i
			INNER JOIN Forums f ON f.ForumId = i.ForumID
			WHERE dbo.Threads.ForumID=i.ForumID
	END
GO
-- Only need to do these roles in production
DENY DELETE ON dbo.Forums TO readonly  AS dbo 
GO
DENY INSERT ON dbo.Forums TO readonly  AS dbo 
GO
DENY UPDATE ON dbo.Forums TO readonly  AS dbo 
GO

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
	-- Took 15s on my machine
GO
ALTER TABLE dbo.GuideEntries ADD CONSTRAINT
	FK_GuideEntries_Forums FOREIGN KEY
	(
	ForumID
	) REFERENCES dbo.Forums
	(
	ForumID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	-- Took 8s on my machine
	
GO
