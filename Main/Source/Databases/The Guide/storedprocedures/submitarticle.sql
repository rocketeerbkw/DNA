CREATE PROCEDURE submitarticle @subject varchar(255), @body varchar(max), @userid int, @keywords varchar(255)
AS

/*
declare @userid int
SELECT @userid = UserID FROM Users WHERE @email = email
IF (@userid IS NULL)
BEGIN
EXEC storenewemaildirect @email
SELECT @userid = @@IDENTITY
END
*/
if (NOT (@userid IS NULL))
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	declare @forumid int
	INSERT INTO Forums (Title, keywords) VALUES(@subject, @keywords)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	SELECT @forumid = @@IDENTITY

	INSERT INTO GuideEntries (blobid, text, Editor, Subject, Keywords, ForumID)
		VALUES (0, @body, @userid, @subject, @keywords, @forumid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	declare @guideentry int
	SELECT @guideentry = @@IDENTITY

	declare @temp int, @checksum int
	SELECT @temp = @guideentry, @checksum = 0
	WHILE @temp > 0
	BEGIN
		SELECT @checksum = @checksum + (@temp % 10)
		SELECT @temp = @temp  / 10
	END
	SELECT @checksum = @checksum % 10
	SELECT @checksum = 9 - @checksum
	SELECT @checksum = @checksum + (10 * @guideentry)

	UPDATE GuideEntries SET h2g2ID = @checksum WHERE EntryID = @guideentry 
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION
	
	SELECT 'EntryID' = @guideentry, 'ForumID' = @forumid, 'Checksum' = @checksum
END

