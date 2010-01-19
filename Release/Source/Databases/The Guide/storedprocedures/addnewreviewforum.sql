Create Procedure addnewreviewforum 
	@reviewforumname varchar(50), 
	@urlname varchar(50), 
	@incubate int,
	@recommend tinyint, 
	@siteid int, 
	@userid int,
	@extra text,
	@type int,
	@hash uniqueidentifier
As

declare @h2g2id int
declare @entryid int, @datecreated datetime, @entryforumid int, @ErrorCode int
declare @FoundDuplicate tinyint

BEGIN TRANSACTION

-- Create a new article for the new reciew forum
EXEC @ErrorCode = createguideentryinternal '', '', @Extra, @userid, 1, 3, 
				NULL, NULL, @siteid, 0, @type, @entryid OUTPUT,
				@datecreated OUTPUT, @entryforumid OUTPUT, @h2g2id OUTPUT,
				@FoundDuplicate OUTPUT, @hash

IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Check to see if we found a duplicate club guide entry.
IF (@FoundDuplicate = 1)
BEGIN
	ROLLBACK TRANSACTION
	SELECT 'ReviewForumID' = ReviewForumID FROM ReviewForums WHERE h2g2ID = @h2g2id
	RETURN 0
END

-- Now create a new review forum passing in the new guide entry
INSERT INTO REVIEWFORUMS (h2g2id,forumname,urlfriendlyname,siteid,recommend,incubatetime)
	VALUES(@h2g2id,@reviewforumname,@urlname,@siteid,@recommend,@incubate)

-- Select the new ID Fro the review forum
DECLARE @reviewforumid int
SELECT @reviewforumid = @@IDENTITY
SELECT 'ReviewForumID' = @reviewforumid

SET @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)