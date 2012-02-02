CREATE PROCEDURE addemailtobannedlist @email VARCHAR(255), @signinbanned bit, @complaintbanned bit, @editorid INT
AS

DECLARE @duplicate int
IF @email IS NOT NULL AND LEN(@email) > 0
BEGIN
	EXEC openemailaddresskey

	SET @duplicate = 1
	IF NOT EXISTS (SELECT * FROM dbo.BannedEmails WHERE HashedEmail = dbo.udf_hashemailaddress(@email))
	BEGIN
		INSERT dbo.BannedEmails (DateAdded, EditorID, SignInBanned, ComplaintBanned,EncryptedEmail,HashedEmail)
			SELECT				 GetDate(),@editorid,@signinbanned,@complaintbanned,dbo.udf_encryptemailaddress(@email,0),dbo.udf_hashemailaddress(@email)
		SET @duplicate = 0
	END
END
-- Return either 1, 0
RETURN ISNULL(@duplicate,0)
