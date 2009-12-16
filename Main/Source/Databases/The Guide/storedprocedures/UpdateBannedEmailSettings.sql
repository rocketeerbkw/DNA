CREATE PROCEDURE updatebannedemailsettings @email VARCHAR(255), @editorid int, @togglesigninbanned bit, @togglecomplaintbanned bit
AS
BEGIN TRANSACTION
DECLARE @Error int
UPDATE dbo.BannedEmails
	SET EditorID = @editorid,
		SignInBanned = toggle.SignInBanned ^ @togglesigninbanned,
		ComplaintBanned = toggle.ComplaintBanned ^ @togglecomplaintbanned
		FROM
		(
			SELECT SignInBanned, ComplaintBanned FROM dbo.Bannedemails where Email = @email
		) toggle
	WHERE EMail = @email
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	EXEC Error @Error
	RETURN @Error
END
COMMIT TRANSACTION