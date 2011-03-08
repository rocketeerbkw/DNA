CREATE PROCEDURE commentforumcreate @uid varchar(255), @url varchar(255), @title nvarchar(255), @sitename varchar(255), @moderationstatus int = NULL, @frompostindex int = 0, @topostindex int = 19, @show int = 20, @duration int = NULL
AS

DECLARE @newforumid int

BEGIN TRANSACTION
	DECLARE @forumid int
	DECLARE @ErrorCode int
	DECLARE @siteid int
	
	select @siteid = siteid from sites where urlname = @sitename
	IF (@siteid is null)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error -1
		RETURN -1
	END
	
	
	SELECT @forumid = ForumID FROM CommentForums WHERE UID = @uid and siteid=@siteid
	IF (@forumid IS NULL)
	BEGIN
		EXEC @ErrorCode = CreateCommentForum @uid, @url, @title, @siteid, @moderationstatus, @duration, @newforumid OUTPUT
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
	ELSE
	BEGIN
		SET @newforumid = @forumid		
	END
	
	--get comment data out
	EXEC @ErrorCode = CommentForumReadByUID @uid, @sitename
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
COMMIT TRANSACTION
