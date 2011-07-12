CREATE PROCEDURE updatebannedemailsettings @email VARCHAR(255), @editorid int, @togglesigninbanned bit, @togglecomplaintbanned bit
AS
BEGIN TRANSACTION
DECLARE @Error int

EXEC openemailaddresskey

UPDATE dbo.BannedEmails
	SET EditorID = @editorid,
		SignInBanned = toggle.SignInBanned ^ @togglesigninbanned,
		ComplaintBanned = toggle.ComplaintBanned ^ @togglecomplaintbanned
		FROM
		(
			SELECT SignInBanned, ComplaintBanned FROM dbo.Bannedemails where HashedEMail = dbo.udf_hashemailaddress(@email)
		) toggle
	WHERE HashedEMail = dbo.udf_hashemailaddress(@email)
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	EXEC Error @Error
	RETURN @Error
END
COMMIT TRANSACTION