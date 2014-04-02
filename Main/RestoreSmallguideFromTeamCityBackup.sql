USE MASTER

-- Drop snapshot if it exists
IF EXISTS(SELECT * FROM sys.master_files WHERE database_id = DB_ID('smallguidess'))
	DROP DATABASE SmallGuideSS

-- Kill all existing connections
ALTER DATABASE SmallGuide SET OFFLINE WITH ROLLBACK IMMEDIATE
ALTER DATABASE SmallGuide SET ONLINE

-- Restore SmallGuide from the Team City backup
RESTORE DATABASE [smallguide] 
FROM  DISK = N'E:\MSSQL\data\DNADB-smallguide-teamcity.bak' 
WITH  FILE = 1,  
MOVE N'Smallguide' TO N'E:\MSSQL\data\smallguide.mdf',  
MOVE N'Smallguide_log' TO N'E:\MSSQL\data\smallguide.LDF',  
MOVE N'sysft_GuideEntriesCat' TO N'D:\MSSQL\FTData\SmallGuide\GuideEntriesCat0000',  
MOVE N'sysft_HierarchyCat' TO N'D:\MSSQL\FTData\SmallGuide\HierarchyCat0000',  
MOVE N'sysft_ThreadEntriesCat' TO N'D:\MSSQL\FTData\SmallGuide\ThreadEntriesCat0000',  
MOVE N'sysft_VGuideEntryText_collectiveCat' TO N'D:\MSSQL\FTData\SmallGuide\VGuideEntryText_collectiveCat0000',  
MOVE N'sysft_VGuideEntryText_memoryshareCat' TO N'D:\MSSQL\FTData\SmallGuide\VGuideEntryText_memoryshareCat0000',  
NOUNLOAD,  REPLACE,  STATS = 10

-- Recreate the Dev email address key for Smallguide
USE SmallGuide
DROP SYMMETRIC KEY key_EmailAddress
DROP CERTIFICATE cert_keyProtection
DROP MASTER KEY
DROP TABLE Salt

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

-- Recreate snapshot 
PRINT 'Recreating SmallGuide SnapShot'
CREATE DATABASE SmallGuideSS ON 
( NAME = [Smallguide], FILENAME = 'E:\MSSQL\data\smallGuideSS.ss') AS SNAPSHOT OF SmallGuide
