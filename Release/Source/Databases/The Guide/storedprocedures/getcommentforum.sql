CREATE PROCEDURE getcommentforum @uid varchar(255), @url varchar(255), @title nvarchar(255), @siteid int, @moderationstatus int = NULL, @frompostindex int = 0, @topostindex int = 19, @show int = 20, @createifnotexists tinyint = 0, @duration int = NULL
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @forumid int
		DECLARE @newforumid int
		DECLARE @ErrorCode int
		
		SELECT @forumid = ForumID FROM CommentForums WHERE UID = @uid
		IF (@forumid IS NULL AND @createifnotexists > 0)
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
	COMMIT TRANSACTION

	IF @frompostindex <= 0 AND @topostindex <= 0
	BEGIN
		EXEC getlatestcomments @newforumid, @show
	END
	ELSE
	BEGIN
		EXEC getcomments @newforumid, @frompostindex, @topostindex
	END
END