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

ALTER TABLE dbo.NicknameMod
	DROP CONSTRAINT DF_NicknameMod_DateQueued
GO
ALTER TABLE dbo.NicknameMod
	DROP CONSTRAINT DF_NicknameMod_Status
GO
ALTER TABLE dbo.NicknameMod
	DROP CONSTRAINT DF__NickNameM__SiteI__7DE51B40
GO

DROP TABLE Tmp_NicknameMod
GO
CREATE TABLE dbo.Tmp_NicknameMod
	(
	ModID int NOT NULL IDENTITY (1, 1),
	UserID int NULL,
	DateQueued datetime NULL,
	DateLocked datetime NULL,
	LockedBy int NULL,
	Status int NULL,
	DateCompleted datetime NULL,
	SiteID int NOT NULL,
	ComplainantID int NULL,
	ComplaintText text NULL,
	NickName nvarchar(255) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
GRANT SELECT ON dbo.Tmp_NicknameMod TO editrole  AS dbo
GO
GRANT SELECT ON dbo.Tmp_NicknameMod TO ripleyrole  AS dbo
GO
ALTER TABLE dbo.Tmp_NicknameMod ADD CONSTRAINT
	DF_NicknameMod_DateQueued DEFAULT (getdate()) FOR DateQueued
GO
ALTER TABLE dbo.Tmp_NicknameMod ADD CONSTRAINT
	DF_NicknameMod_Status DEFAULT (0) FOR Status
GO
ALTER TABLE dbo.Tmp_NicknameMod ADD CONSTRAINT
	DF_NickNameMod_SiteID DEFAULT (1) FOR SiteID
GO
SET IDENTITY_INSERT dbo.Tmp_NicknameMod ON
GO
IF EXISTS(SELECT * FROM dbo.NicknameMod)
	 EXEC('INSERT INTO dbo.Tmp_NicknameMod (ModID, UserID, DateQueued, DateLocked, LockedBy, Status, DateCompleted, SiteID, ComplainantID, ComplaintText, NickName)
		SELECT ModID, UserID, DateQueued, DateLocked, LockedBy, Status, DateCompleted, SiteID, ComplainantID, ComplaintText, CONVERT(nvarchar(255), NickName) FROM dbo.NicknameMod WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_NicknameMod OFF
GO
ALTER TABLE dbo.NicknameModHistory
	DROP CONSTRAINT FK__NicknameM__ModID__7DDC904D
GO
ALTER TABLE dbo.NicknameModHistory
	DROP CONSTRAINT FK_NicknameModHistory_NicknameMod_ModID
GO
ALTER TABLE dbo.NicknameModHistory
	DROP CONSTRAINT FK__NicknameM__ModID__49A4C67D
GO
ALTER TABLE dbo.NicknameModHistory
	DROP CONSTRAINT FK__NicknameM__Trigg__4B8D0EEF
GO
ALTER TABLE dbo.NicknameModHistory
	DROP CONSTRAINT FK__NicknameM__Trigg__4A5EB4BF
GO

DROP TABLE dbo.NicknameMod
GO
EXECUTE sp_rename N'dbo.Tmp_NicknameMod', N'NicknameMod', 'OBJECT' 
GO
ALTER TABLE dbo.NicknameMod ADD CONSTRAINT
	PK_NicknameMod PRIMARY KEY NONCLUSTERED 
	(
	ModID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_NicknameMod_Status ON dbo.NicknameMod
	(
	Status,
	LockedBy,
	SiteID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_NickNameMod_UserID ON dbo.NicknameMod
	(
	UserID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.NicknameModHistory ADD CONSTRAINT
	FK_NicknameModHistory_NicknameMod_ModID FOREIGN KEY
	(
	ModID
	) REFERENCES dbo.NicknameMod
	(
	ModID
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