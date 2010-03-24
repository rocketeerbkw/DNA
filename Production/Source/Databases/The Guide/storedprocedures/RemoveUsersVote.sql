CREATE PROCEDURE removeusersvote @voteid int, @userid int
AS
BEGIN
	DECLARE @Error int
	IF NOT EXISTS (SELECT * FROM VoteMembers WHERE VoteID = @voteid and UserID = @userid)
	BEGIN
		SELECT 'Removed' = 0
		RETURN 0
	END
	
	BEGIN TRANSACTION
	DELETE FROM VoteMembers WHERE VoteID = @voteid AND UserID = @userid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	COMMIT TRANSACTION
	
	-- update the eventqueue
	DECLARE @ClubID 	INT
	SELECT @ClubID = ClubID  FROM dbo.ClubVotes WHERE VoteID = @voteid
	
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_VOTEREMOVED', @ClubID, 'IT_CLUB', DEFAULT, DEFAULT, @userid
	
	SELECT 'Removed' = 1
END