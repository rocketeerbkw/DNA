CREATE PROCEDURE addemailtobannedlist @email VARCHAR(255), @signinbanned bit, @complaintbanned bit, @editorid INT
AS
DECLARE @duplicate int
SET @duplicate = 1
IF NOT EXISTS (SELECT * FROM dbo.BannedEmails WHERE Email = @email)
BEGIN
	INSERT INTO dbo.BannedEmails 
	SELECT 'Email' = @email, 'DateAdded' = GetDate(), 'EditorID' = @editorid, 'SignInBanned' = @signinbanned, 'ComplaintBanned' = @complaintbanned, null, null
	SET @duplicate = 0
END
SELECT 'Duplicate' = @duplicate