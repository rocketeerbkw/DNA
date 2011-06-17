CREATE TRIGGER trg_Users_iu ON Users
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON -- IMPORTANT.  Prevents result sets being generated via variable assignment, SELECTS, etc

	IF UPDATE(EncryptedEmail)
	BEGIN
		EXEC openemailaddresskey
		
		UPDATE Users
			SET HashedEmail = dbo.udf_hashemailaddress(dbo.udf_decryptemailaddress(Users.EncryptedEmail,Users.UserId))
			FROM Users
			INNER JOIN inserted i ON i.UserId=Users.UserId
	END

	IF UPDATE(Email)
	BEGIN
		EXEC openemailaddresskey
		
		UPDATE Users
			SET HashedEmail = dbo.udf_hashemailaddress(Users.Email),
				EncryptedEmail = dbo.udf_encryptemailaddress(Users.Email,Users.UserId)
			FROM Users
			INNER JOIN inserted i ON i.UserId=Users.UserId
	END
