CREATE PROCEDURE hasuseralreadyvoted2 @ivoteid int, @iuserid int, @uid uniqueidentifier
As
-- Check to see if the UID has been used to vote before?
DECLARE @iVotedWithBBCUID tinyint

SELECT @iVotedWithBBCUID = 
CASE WHEN EXISTS ( SELECT UserID FROM VoteMembers WHERE UID = @uid AND VoteID = @ivoteid ) THEN 1 ELSE 0 END

-- Is the user logged in?
IF (@iuserid > 0)
BEGIN

	-- Does the UserID already exist?
	IF EXISTS ( SELECT UserID FROM VoteMembers WHERE VoteID = @ivoteid AND UserID = @iuserid )
	BEGIN
		SELECT 'AlreadyVoted' = 1 -- User has already voted!
		RETURN 0
	END
	
	-- Is there a previous userid in the table?
	DECLARE @iVotingUser int
	
	SELECT @iVotingUser = UserID FROM VoteMembers WHERE VoteID = @ivoteid AND UID = @uid
	
	-- If the UID already exists, but does not have a UserID, then update the table with the current userid
	IF (@iVotedWithBBCUID > 0 AND @iVotingUser = 0)
	BEGIN
		DECLARE @Error int
		BEGIN TRANSACTION
			UPDATE VoteMembers SET UserID = @iuserid WHERE UID = @uid
			SELECT @Error = @@ERROR
			IF (@Error <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @Error
				RETURN @Error
			END
			COMMIT TRANSACTION
			SELECT 'AlreadyVoted' = 1 -- UserID is now in the table, so they have already voted!
			RETURN 0
		END
	ELSE
	BEGIN
		SELECT 'AlreadyVoted' = 0 -- UserID isn't the one in the table, so they havn't voted!
		RETURN 0
	END
END
SELECT 'AlreadyVoted' = @iVotedWithBBCUID