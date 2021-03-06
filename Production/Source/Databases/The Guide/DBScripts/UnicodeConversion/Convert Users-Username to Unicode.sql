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
-----------------------------------------------------------------------------------

-- Check the column type to see if it's already been converted to nvarchar.
DECLARE @type varchar(128)
SET @type = dbo.udf_getcolumntype('Users','Username')
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

BEGIN TRANSACTION
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_Cookie
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_Active
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_DateJoined
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_Status
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_Anonymous
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_UnreadPublicMessage
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_UnreadPrivateMessage
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_HideLocation
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_HideUserName
GO
ALTER TABLE dbo.Users
	DROP CONSTRAINT DF_Users_AcceptSubscriptions
GO
CREATE TABLE dbo.Tmp_Users
	(
	UserID int NOT NULL,
	Cookie uniqueidentifier NULL,
	email varchar(255) NULL,
	UserName nvarchar(255) NULL,
	Password varchar(255) NULL,
	FirstNames varchar(255) NULL,
	LastName varchar(255) NULL,
	Active bit NOT NULL,
	Masthead int NULL,
	DateJoined datetime NULL,
	Status int NULL,
	Anonymous bit NOT NULL,
	Journal int NULL,
	Latitude float(53) NULL,
	Longitude float(53) NULL,
	SinBin int NULL,
	DateReleased datetime NULL,
	Prefs1 varchar(1024) NULL,
	Recommended int NULL,
	Friends int NULL,
	LoginName varchar(255) NULL,
	BBCUID uniqueidentifier NULL,
	TeamID int NULL,
	Postcode varchar(20) NULL,
	Area varchar(100) NULL,
	TaxonomyNode int NULL,
	UnreadPublicMessageCount smallint NOT NULL,
	UnreadPrivateMessageCount smallint NOT NULL,
	Region varchar(255) NULL,
	HideLocation int NOT NULL,
	HideUserName int NOT NULL,
	AcceptSubscriptions bit NOT NULL,
	LastUpdatedDate datetime NULL
	)  ON [PRIMARY]
GO
GRANT SELECT ON dbo.Tmp_Users TO ripleyrole  AS dbo
GO
GRANT UPDATE ON dbo.Tmp_Users TO ripleyrole  AS dbo
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_Cookie DEFAULT (newid()) FOR Cookie
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_Active DEFAULT ((0)) FOR Active
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_DateJoined DEFAULT (getdate()) FOR DateJoined
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_Status DEFAULT ((1)) FOR Status
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_Anonymous DEFAULT ((0)) FOR Anonymous
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_UnreadPublicMessage DEFAULT ((0)) FOR UnreadPublicMessageCount
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_UnreadPrivateMessage DEFAULT ((0)) FOR UnreadPrivateMessageCount
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_HideLocation DEFAULT ((0)) FOR HideLocation
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_HideUserName DEFAULT ((0)) FOR HideUserName
GO
ALTER TABLE dbo.Tmp_Users ADD CONSTRAINT
	DF_Users_AcceptSubscriptions DEFAULT ((1)) FOR AcceptSubscriptions
GO
IF EXISTS(SELECT * FROM dbo.Users)
	 EXEC('INSERT INTO dbo.Tmp_Users (UserID, Cookie, email, UserName, Password, FirstNames, LastName, Active, Masthead, DateJoined, Status, Anonymous, Journal, Latitude, Longitude, SinBin, DateReleased, Prefs1, Recommended, Friends, LoginName, BBCUID, TeamID, Postcode, Area, TaxonomyNode, UnreadPublicMessageCount, UnreadPrivateMessageCount, Region, HideLocation, HideUserName, AcceptSubscriptions, LastUpdatedDate)
		SELECT UserID, Cookie, email, CONVERT(nvarchar(255), UserName), Password, FirstNames, LastName, Active, Masthead, DateJoined, Status, Anonymous, Journal, Latitude, Longitude, SinBin, DateReleased, Prefs1, Recommended, Friends, LoginName, BBCUID, TeamID, Postcode, Area, TaxonomyNode, UnreadPublicMessageCount, UnreadPrivateMessageCount, Region, HideLocation, HideUserName, AcceptSubscriptions, LastUpdatedDate FROM dbo.Users WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Location
	DROP CONSTRAINT FK_Location_Users
GO
ALTER TABLE dbo.Route
	DROP CONSTRAINT FK_Route_Users
GO
ALTER TABLE dbo.Researchers
	DROP CONSTRAINT FK_Researchers_Users
GO
ALTER TABLE dbo.Favourites
	DROP CONSTRAINT FK_Favourites_Users
GO
ALTER TABLE dbo.GuideEntries
	DROP CONSTRAINT FK_GuideEntries_Users
GO
ALTER TABLE dbo.ThreadModHistory
	DROP CONSTRAINT FK_ThreadModHistory_LockedBy
GO
ALTER TABLE dbo.ThreadModHistory
	DROP CONSTRAINT FK_ThreadModHistory_TriggeredBy
GO
ALTER TABLE dbo.ArticleModHistory
	DROP CONSTRAINT FK_ArticleModHistory_LockedBy
GO
ALTER TABLE dbo.ArticleModHistory
	DROP CONSTRAINT FK_ArticleModHistory_TriggeredBy
GO
ALTER TABLE dbo.ImageLibrary
	DROP CONSTRAINT FK_ImageLibrary_Users
GO
ALTER TABLE dbo.DNASystemMessages
	DROP CONSTRAINT FK_DNASystemMessages_Users
GO
ALTER TABLE dbo.NicknameModHistory
	DROP CONSTRAINT FK_NicknameModHistory_LockedBy
GO
ALTER TABLE dbo.NicknameModHistory
	DROP CONSTRAINT FK_NicknameModHistory_TriggeredBy
GO
ALTER TABLE dbo.UserSubscriptions
	DROP CONSTRAINT FK_UserSubscriptions_Users
GO
ALTER TABLE dbo.UserSubscriptions
	DROP CONSTRAINT FK_UserSubscriptionsAuthorId_Users
GO
ALTER TABLE dbo.ArticleSubscriptions
	DROP CONSTRAINT FK_ArticleSubscriptions_Users
GO
ALTER TABLE dbo.ArticleSubscriptions
	DROP CONSTRAINT FK_ArticleSubscriptionsAuthorId_Users
GO
ALTER TABLE dbo.BlockedUserSubscriptions
	DROP CONSTRAINT FK_BlockedUserSubscriptions_Users
GO
ALTER TABLE dbo.BlockedUserSubscriptions
	DROP CONSTRAINT FK_BlockedUserSubscriptionsAuthorId_Users
GO
ALTER TABLE dbo.ThreadEntries
	DROP CONSTRAINT FK_ThreadEntries_Users
GO
DROP TABLE dbo.Users
GO
EXECUTE sp_rename N'dbo.Tmp_Users', N'Users', 'OBJECT' 
GO
ALTER TABLE dbo.Users ADD CONSTRAINT
	PK_Users PRIMARY KEY CLUSTERED 
	(
	UserID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Journal ON dbo.Users
	(
	Journal
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Users_Cookie ON dbo.Users
	(
	Cookie
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Users_email ON dbo.Users
	(
	email
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Users_TeamID ON dbo.Users
	(
	TeamID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX users0 ON dbo.Users
	(
	Masthead,
	UserID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
COMMIT
BEGIN TRANSACTION
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
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.BlockedUserSubscriptions ADD CONSTRAINT
	FK_BlockedUserSubscriptions_Users FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.BlockedUserSubscriptions ADD CONSTRAINT
	FK_BlockedUserSubscriptionsAuthorId_Users FOREIGN KEY
	(
	AuthorId
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ArticleSubscriptions ADD CONSTRAINT
	FK_ArticleSubscriptions_Users FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ArticleSubscriptions ADD CONSTRAINT
	FK_ArticleSubscriptionsAuthorId_Users FOREIGN KEY
	(
	AuthorId
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.UserSubscriptions ADD CONSTRAINT
	FK_UserSubscriptions_Users FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.UserSubscriptions ADD CONSTRAINT
	FK_UserSubscriptionsAuthorId_Users FOREIGN KEY
	(
	AuthorId
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.NicknameModHistory ADD CONSTRAINT
	FK_NicknameModHistory_LockedBy FOREIGN KEY
	(
	LockedBy
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.NicknameModHistory ADD CONSTRAINT
	FK_NicknameModHistory_TriggeredBy FOREIGN KEY
	(
	TriggeredBy
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DNASystemMessages ADD CONSTRAINT
	FK_DNASystemMessages_Users FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ImageLibrary ADD CONSTRAINT
	FK_ImageLibrary_Users FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ArticleModHistory ADD CONSTRAINT
	FK_ArticleModHistory_LockedBy FOREIGN KEY
	(
	LockedBy
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ArticleModHistory ADD CONSTRAINT
	FK_ArticleModHistory_TriggeredBy FOREIGN KEY
	(
	TriggeredBy
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ThreadModHistory ADD CONSTRAINT
	FK_ThreadModHistory_LockedBy FOREIGN KEY
	(
	LockedBy
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ThreadModHistory ADD CONSTRAINT
	FK_ThreadModHistory_TriggeredBy FOREIGN KEY
	(
	TriggeredBy
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.GuideEntries ADD CONSTRAINT
	FK_GuideEntries_Users FOREIGN KEY
	(
	Editor
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Favourites ADD CONSTRAINT
	FK_Favourites_Users FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Researchers ADD CONSTRAINT
	FK_Researchers_Users FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Route ADD CONSTRAINT
	FK_Route_Users FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Location ADD CONSTRAINT
	FK_Location_Users FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.Users
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT

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