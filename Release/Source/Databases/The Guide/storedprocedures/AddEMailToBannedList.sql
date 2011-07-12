CREATE PROCEDURE addemailtobannedlist @email VARCHAR(255), @signinbanned bit, @complaintbanned bit, @editorid INT
AS

EXEC openemailaddresskey

DECLARE @duplicate int
SET @duplicate = 1
IF NOT EXISTS (SELECT * FROM dbo.BannedEmails WHERE HashedEmail = dbo.udf_hashemailaddress(@email))
BEGIN
	INSERT dbo.BannedEmails (DateAdded, EditorID, SignInBanned, ComplaintBanned,EncryptedEmail,HashedEmail)
		SELECT				 GetDate(),@editorid,@signinbanned,@complaintbanned,dbo.udf_encryptemailaddress(@email,0),dbo.udf_hashemailaddress(@email)
	SET @duplicate = 0
END
SELECT 'Duplicate' = @duplicate
