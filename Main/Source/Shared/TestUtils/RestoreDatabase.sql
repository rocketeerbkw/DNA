Declare @state varchar(50)
USE [master]
SELECT @state = Cast(DATABASEPROPERTYEX ('SmallGuide', 'Status') as varchar(50))
IF @state = 'RESTORING'	
BEGIN 
	DROP DATABASE [smallGuideSS] 
	DROP DATABASE [SmallGuide] 
RESTORE DATABASE [SmallGuide] FROM 
DISK = '[SQLROOT]Backup\SmallGuide.bak'
WITH  FILE = 1,  
MOVE N'SmallGuide' TO N'[SQLROOT]Data\SmallGuide.mdf',  
MOVE N'SmallGuide_log' TO N'[SQLROOT]Log\SmallGuide_log.LDF',  
NOUNLOAD,  REPLACE,  STATS = 1, NORECOVERY

RESTORE DATABASE [SmallGuide]

CREATE DATABASE [smallGuideSS] ON
( NAME = smallGuide, FILENAME = '[SQLROOT]Data\smallGuideSS.mdf' )
AS SNAPSHOT OF SmallGuide

END
ELSE
BEGIN
	RESTORE DATABASE  [SmallGuide]  FROM DATABASE_SNAPSHOT = 'smallGuideSS' WITH RECOVERY
END