Declare @state varchar(50)
USE [master]
ALTER DATABASE [SmallGuide] SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE [SmallGuide] SET ONLINE
SELECT @state = Cast(DATABASEPROPERTYEX ('SmallGuide', 'Status') as varchar(50))
IF @state = 'RESTORING'	or db_id('smallguidess') is null
BEGIN 
	If db_id('smallguidess') is not null
	BEGIN
		DROP DATABASE [smallGuideSS] 
		EXECUTE xp_cmdshell 'del "[SQLROOT]Data\smallGuideSS.mdf"'
	END
	DROP DATABASE [SmallGuide] 

	RESTORE DATABASE [SmallGuide] FROM 
	DISK = '[SQLROOT]Backup\SmallGuide.bak'
	WITH  FILE = 1,  
	MOVE N'SmallGuide' TO N'[SQLROOT]Data\SmallGuide.mdf',  
	MOVE N'SmallGuide_log' TO N'[SQLROOT]Log\SmallGuide_log.LDF',  
	NOUNLOAD,  REPLACE,  STATS = 1

	EXEC sp_change_users_login 'Auto_Fix', 'ripley' 

	IF NOT EXISTS(SELECT * FROM sys.symmetric_keys WHERE name = 'key_EmailAddress')
	BEGIN
		CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Dev Master Key PW c0mPl3x!';

		CREATE CERTIFICATE cert_keyProtection WITH SUBJECT = 'Key Protection';

		CREATE SYMMETRIC KEY key_EmailAddress WITH
			KEY_SOURCE = 'Eh up chuck',
			ALGORITHM = TRIPLE_DES, 
			IDENTITY_VALUE = 'Nice day'
			ENCRYPTION BY CERTIFICATE cert_keyProtection;

		-- Grant ripleyrole permissions to use the objects
		GRANT CONTROL ON CERTIFICATE::cert_keyProtection TO ripleyrole;
		GRANT VIEW DEFINITION ON SYMMETRIC KEY::key_EmailAddress TO ripleyrole;
	END
	IF OBJECT_ID('dbo.Salt', 'U') IS NULL
	BEGIN
		CREATE TABLE Salt
		(
			SaltId varchar(50) CONSTRAINT PK_Salt PRIMARY KEY CLUSTERED,
			EncryptedSalt varbinary(8000)
		)

		-- Add an encrypted salt value for email hashes
		OPEN SYMMETRIC KEY key_EmailAddress DECRYPTION BY CERTIFICATE cert_keyProtection;
		DECLARE @enc varbinary(8000)
		SET @enc=EncryptByKey(KEY_GUID('key_EmailAddress'),'Dev Salt')
		INSERT Salt VALUES('Email',@enc)
	END

	CREATE DATABASE [smallGuideSS] ON
	( NAME = smallGuide, FILENAME = '[SQLROOT]Data\smallGuideSS.mdf' )
	AS SNAPSHOT OF SmallGuide
END
ELSE
BEGIN
	RESTORE DATABASE  [SmallGuide]  FROM DATABASE_SNAPSHOT = 'smallGuideSS' WITH RECOVERY
END