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
SET @type = dbo.udf_getcolumntype('PreModPostings','Subject')
IF @type IS NULL RAISERROR ('Failed to find type for column',20,1) WITH LOG

IF @type = 'nvarchar'
BEGIN 
	-- Level 20 is used as it will kill the connection, preventing any further script after the GO from executing
	RAISERROR ('This table has already been converted to Unicode.  No need to run this script',20,1) WITH LOG
END
GO

SELECT ModID, UserID, ForumID, ThreadID, InReplyTo, CONVERT(nvarchar(255), Subject) AS Subject, CONVERT(nvarchar(MAX), Body) AS Body, 
	PostStyle, Hash, Keywords, CONVERT(nvarchar(255), Nickname) AS Nickname, Type, EventDate, ClubID, NodeID, IPAddress, 
	DatePosted, ThreadRead, ThreadWrite, SiteID, AllowEventEntries, BBCUID, IsComment 
	INTO dbo.Tmp_PreModPostings
	FROM dbo.PreModPostings
	-- Took on my machine
GO
DROP TABLE dbo.PreModPostings
GO
-- Make the Unicode version the real version
EXECUTE sp_rename N'dbo.Tmp_PreModPostings', N'PreModPostings', 'OBJECT' 
GO
GRANT SELECT ON dbo.PreModPostings TO ripleyrole  AS dbo
GO
ALTER TABLE dbo.PreModPostings ADD CONSTRAINT DF_PreModPostings_DatePosted DEFAULT (getdate()) FOR DatePosted
GO
ALTER TABLE dbo.PreModPostings ADD CONSTRAINT DF_PreModPostings_IgnoreThreadPostings DEFAULT ((0)) FOR IsComment
GO
ALTER TABLE dbo.PreModPostings ADD CONSTRAINT
	PK_PreModPostings PRIMARY KEY CLUSTERED 
	(
	ModID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
