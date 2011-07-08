/*
-- To reacreate the keys, execute these commands in this order to delete the key hierarchy

DROP SYMMETRIC KEY key_EmailAddress
DROP CERTIFICATE cert_keyProtection
DROP MASTER KEY

*/
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'GH676Yt%$fH$"£==ABBATASTIC';
GO
CREATE CERTIFICATE cert_keyProtection WITH SUBJECT = 'Key Protection';
GO
CREATE SYMMETRIC KEY key_EmailAddress WITH
    KEY_SOURCE = 'Cockadoodledo said a man in a shoe',
    ALGORITHM = TRIPLE_DES, 
    IDENTITY_VALUE = 'Fourflusher ferkler'
    ENCRYPTION BY CERTIFICATE cert_keyProtection;
GO
-- Grant ripleyrole permissions to use the objects
GRANT CONTROL ON CERTIFICATE::cert_keyProtection TO ripleyrole;
GRANT VIEW DEFINITION ON SYMMETRIC KEY::key_EmailAddress TO ripleyrole;
GO

CREATE TABLE Salt
(
	SaltId varchar(50) CONSTRAINT PK_Salt PRIMARY KEY CLUSTERED,
	EncryptedSalt varbinary(8000)
)
OPEN SYMMETRIC KEY key_EmailAddress DECRYPTION BY CERTIFICATE cert_keyProtection;
DECLARE @enc varbinary(8000)
SET @enc=EncryptByKey(KEY_GUID('key_EmailAddress'),'gRgg^8kmnpuTc£43"!!480(7NkknBfdDccdffk9K8m00<08%ewMGwsxMovcA<pMp')
INSERT Salt VALUES('Email',@enc)