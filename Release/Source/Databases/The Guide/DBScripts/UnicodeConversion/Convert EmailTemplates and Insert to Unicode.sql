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
SET @type = dbo.udf_getcolumntype('EmailTemplates','Body')
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

CREATE TABLE dbo.Tmp_EmailTemplates
	(
	EmailTemplateID int NOT NULL IDENTITY (1, 1),
	Subject nvarchar(255) NULL,
	Body nvarchar(MAX) NULL,
	Name varchar(255) NULL,
	ModClassID int NULL,
	AutoFormat bit NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_EmailTemplates SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_EmailTemplates ON
GO
IF EXISTS(SELECT * FROM dbo.EmailTemplates)
	 EXEC('INSERT INTO dbo.Tmp_EmailTemplates (EmailTemplateID, Subject, Body, Name, ModClassID, AutoFormat)
		SELECT EmailTemplateID, CONVERT(nvarchar(255), Subject), CONVERT(nvarchar(MAX), Body), Name, ModClassID, AutoFormat FROM dbo.EmailTemplates WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_EmailTemplates OFF
GO
DROP TABLE dbo.EmailTemplates
GO
EXECUTE sp_rename N'dbo.Tmp_EmailTemplates', N'EmailTemplates', 'OBJECT' 
GO
CREATE TABLE dbo.Tmp_EmailInserts
	(
	EmailInsertID int NOT NULL IDENTITY (1, 1),
	ModClassID int NULL,
	SiteID int NULL,
	InsertName varchar(255) NULL,
	InsertGroup varchar(255) NULL,
	InsertText nvarchar(MAX) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_EmailInserts SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_EmailInserts ON
GO
IF EXISTS(SELECT * FROM dbo.EmailInserts)
	 EXEC('INSERT INTO dbo.Tmp_EmailInserts (EmailInsertID, ModClassID, SiteID, InsertName, InsertGroup, InsertText)
		SELECT EmailInsertID, ModClassID, SiteID, InsertName, InsertGroup, CONVERT(nvarchar(MAX), InsertText) FROM dbo.EmailInserts WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_EmailInserts OFF
GO
DROP TABLE dbo.EmailInserts
GO
EXECUTE sp_rename N'dbo.Tmp_EmailInserts', N'EmailInserts', 'OBJECT' 
GO
ALTER TABLE dbo.EmailInserts ADD CONSTRAINT
	PK_EmailInserts PRIMARY KEY CLUSTERED 
	(
	EmailInsertID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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