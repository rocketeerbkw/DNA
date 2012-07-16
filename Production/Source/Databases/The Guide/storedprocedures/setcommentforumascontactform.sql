CREATE PROCEDURE setcommentforumascontactform @forumid int, @contactemail nvarchar(255)
AS
IF EXISTS (SELECT * FROM dbo.CommentForums WHERE ForumID = @forumid)
BEGIN
	UPDATE dbo.CommentForums SET IsContactForm = 1 WHERE ForumID = @forumid
	
	IF NOT EXISTS (SELECT * FROM dbo.ContactForms WHERE ForumID = @forumid)
	BEGIN
		INSERT INTO dbo.ContactForms SELECT ForumID = @forumid, EncryptedContactEmail = @contactemail
	END
	ELSE
	BEGIN
		UPDATE dbo.ContactForms SET EncryptedContactEmail = @contactemail WHERE ForumID = @forumid
	END
END