CREATE PROCEDURE setcommentforumascontactform @forumid int, @contactemail nvarchar(255)
AS
IF EXISTS (SELECT * FROM dbo.CommentForums WHERE ForumID = @forumid)
BEGIN
	EXEC openemailaddresskey;
	
	UPDATE dbo.CommentForums SET IsContactForm = 1 WHERE ForumID = @forumid

	IF NOT EXISTS (SELECT * FROM dbo.ContactForms WHERE ForumID = @forumid)
	BEGIN
		INSERT INTO dbo.ContactForms SELECT ForumID = @forumid, EncryptedContactEmail = dbo.udf_encryptemailaddress(@contactemail,@forumid), HashedEmail = dbo.udf_hashemailaddress(@contactemail)
	END
	ELSE
	BEGIN
		UPDATE dbo.ContactForms SET EncryptedContactEmail = dbo.udf_encryptemailaddress(@contactemail,@forumid), HashedEmail = dbo.udf_hashemailaddress(@contactemail) WHERE ForumID = @forumid
	END
END