--Updates the ForumPostCount column of the Forum specified by ForumID.
--If NewCount is NOT NULL then that value will be inserted into the ForumPostCount
--If NewCount and Difference are NULL then the ForumPostCount is calculated
--If Difference is NOT NULL then this value will be added to the existing value
--If both NewCount and Difference are NOT NULL then NewCount has precedence
CREATE PROCEDURE updateforumpostcount
	@forumid int, 
	@newcount int = NULL,
	@difference int = NULL
AS
BEGIN
	IF @newcount IS NULL
		IF @difference IS NULL
			BEGIN
				DELETE FROM ForumPostCountAdjust WHERE ForumID = @forumid
				UPDATE Forums SET ForumPostCount = (SELECT COUNT(*) FROM ThreadEntries WHERE ForumID = @forumid)
				WHERE ForumID = @forumid
			END
		ELSE
			BEGIN
				INSERT INTO ForumPostCountAdjust (ForumID, PostCountDelta)
					VALUES (@forumid, @difference)
			END
	ELSE
		BEGIN
			DELETE FROM ForumPostCountAdjust WHERE ForumID = @forumid
			UPDATE Forums SET ForumPostCount = @newcount WHERE ForumID = @forumid
		END
END
