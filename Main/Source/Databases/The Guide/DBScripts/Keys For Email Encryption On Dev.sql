/*
-- To reacreate the keys, execute these commands in this order to delete the key hierarchy

USE TheGuide
DROP SYMMETRIC KEY key_EmailAddress
DROP CERTIFICATE cert_keyProtection
DROP MASTER KEY
DROP TABLE Salt

USE SmallGuide
DROP SYMMETRIC KEY key_EmailAddress
DROP CERTIFICATE cert_keyProtection
DROP MASTER KEY
DROP TABLE Salt
USE master

*/
USE TheGuide
GO
IF NOT EXISTS(SELECT * FROM sys.symmetric_keys WHERE name = 'key_EmailAddress')
BEGIN
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Dev Master Key PW';

	CREATE CERTIFICATE cert_keyProtection WITH SUBJECT = 'Key Protection';
	-- You can ignore error "Warning: The certificate you created is not yet valid; its start date is in the future."
	-- as the certificate date is not used in the context of accessing a symmetric key

	CREATE SYMMETRIC KEY key_EmailAddress WITH
		KEY_SOURCE = 'Eh up chuck',
		ALGORITHM = TRIPLE_DES, 
		IDENTITY_VALUE = 'Nice day'
		ENCRYPTION BY CERTIFICATE cert_keyProtection;

	-- Grant ripleyrole permissions to use the objects
	GRANT CONTROL ON CERTIFICATE::cert_keyProtection TO ripleyrole;
	GRANT VIEW DEFINITION ON SYMMETRIC KEY::key_EmailAddress TO ripleyrole;
END
IF dbo.udf_tableexists('Salt')=0
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
GO

USE SmallGuide
GO
IF NOT EXISTS(SELECT * FROM sys.symmetric_keys WHERE name = 'key_EmailAddress')
BEGIN
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Dev Master Key PW';

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
IF dbo.udf_tableexists('Salt')=0
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

-- Recreate SmallGuide snap shot
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
GO
USE master
