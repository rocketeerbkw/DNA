USE [master]

Declare @state varchar(50)
SELECT @state = Cast(DATABASEPROPERTYEX ('SmallGuide', 'Status') as varchar(50))

IF (@state IS NULL) OR (ISNULL(@state, '') = 'RESTORING')
BEGIN
	PRINT 'Do Nothing'
END
ELSE
BEGIN
	ALTER DATABASE [SmallGuide] SET OFFLINE WITH ROLLBACK IMMEDIATE
	ALTER DATABASE [SmallGuide] SET ONLINE
END

IF @state = 'RESTORING'	OR db_id('smallGuideSS') IS NULL
BEGIN 

	EXECUTE xp_cmdshell 'del "[SQLROOT]Data\smallGuideSS.mdf"'

	IF db_id('smallGuideSS') IS NOT NULL
	BEGIN
		DROP DATABASE [smallGuideSS]
	END
	
	IF db_id('SmallGuide') IS NOT NULL
	BEGIN
		DROP DATABASE [SmallGuide] 
	END

	RESTORE DATABASE [SmallGuide] FROM 
	DISK = '[SQLROOT]Backup\SmallGuide.bak'
	WITH  FILE = 1,  
	MOVE N'SmallGuide' TO N'[SQLROOT]Data\SmallGuide.mdf',  
	MOVE N'SmallGuide_log' TO N'[SQLROOT]Log\SmallGuide_log.LDF',  
	NOUNLOAD,  REPLACE,  STATS = 1

	CREATE DATABASE [smallGuideSS] ON
	( NAME = smallGuide, FILENAME = '[SQLROOT]Data\smallGuideSS.mdf' )
	AS SNAPSHOT OF SmallGuide
END
ELSE
BEGIN
	RESTORE DATABASE  [SmallGuide]  FROM DATABASE_SNAPSHOT = 'smallGuideSS' WITH RECOVERY
END