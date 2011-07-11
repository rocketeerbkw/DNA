CREATE PROCEDURE openemailaddresskey
AS
IF NOT EXISTS(SELECT * FROM sys.openkeys WHERE key_name = 'key_EmailAddress' and database_name = db_name())
BEGIN
	OPEN SYMMETRIC KEY key_EmailAddress DECRYPTION BY CERTIFICATE cert_keyProtection;
END

IF NOT EXISTS(SELECT * FROM sys.openkeys WHERE key_name = 'key_EmailAddress' and database_name = db_name())
BEGIN
	RAISERROR('Unable to open key_EmailAddress',18,1)
END
