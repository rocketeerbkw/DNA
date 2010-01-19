
/*********************************************************************************

	CREATE PROCEDURE pollanonymouscontentratingvote @voteid int, @response int, @userid int, @bbcuid uniqueidentifier

	Author:		Steve Francis
    Created:	27/02/2007
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Add/Update vote for a user for anonymous content rating polls
				Update content rating stats in pagevotes table
	
*********************************************************************************/

CREATE PROCEDURE pollanonymouscontentratingvote @pollid int, @userid int, @response int, @bbcuid uniqueidentifier
AS
BEGIN TRANSACTION

	DECLARE @ErrorCode INT
	DECLARE @RowCount INT

	DECLARE @VotedWithBBCUID tinyint
	DECLARE @AlreadyVoted tinyint
	SELECT @AlreadyVoted = 0

	SELECT @VotedWithBBCUID = 
	CASE WHEN EXISTS ( SELECT UserID FROM VoteMembers WHERE UID = @bbcuid AND VoteID = @pollid ) THEN 1 ELSE 0 END

	-- Is the user logged in?
	IF (@userid > 0)
	BEGIN

		-- Does the UserID already exist?
		IF EXISTS ( SELECT UserID FROM VoteMembers WHERE VoteID = @pollid AND UserID = @userid )
		BEGIN			
			SELECT	@AlreadyVoted = 1	
		END		
		ELSE
		BEGIN
			-- Is there a previous userid in the table?
			DECLARE @VotingUser int
			
			SELECT @VotingUser = UserID FROM VoteMembers WHERE VoteID = @pollid AND UID = @bbcuid
			
			-- If the UID already exists, but does not have a UserID, then update the table with the current userid
			IF (@VotedWithBBCUID > 0 AND @VotingUser = 0)
			BEGIN
				DECLARE @Error int
				BEGIN TRANSACTION
					UPDATE VoteMembers SET UserID = @userid WHERE UID = @bbcuid
					SELECT @Error = @@ERROR
					IF (@Error <> 0)
					BEGIN
						ROLLBACK TRANSACTION
						EXEC Error @Error
						RETURN @Error
					END
					COMMIT TRANSACTION
					SELECT	@AlreadyVoted = 1 -- UserID is now in the table, so they have already voted!
				END
			ELSE
			BEGIN
				SELECT	@AlreadyVoted = 0 -- UserID isn't the one in the table, so they haven't voted!
			END
		END
	END


	IF (@AlreadyVoted = 1 AND @userid > 0)
	BEGIN
		-- Attempt to update existing vote
		UPDATE dbo.votemembers SET response = @response, Visible = 1, DateVoted = GetDate()
		WHERE UserID = @userid AND VoteID = @pollid
	END
	ELSE IF(@AlreadyVoted = 0 AND @userid = 0 AND @VotedWithBBCUID = 1)
	BEGIN
		-- Attempt to update existing vote of the non logged in user with there same uid
		UPDATE dbo.votemembers SET response = @response, Visible = 1, DateVoted = GetDate()
		WHERE UID = @bbcuid AND VoteID = @pollid
	END
	
	SELECT @ErrorCode = @@ERROR, @RowCount = @@ROWCOUNT
	
	IF @ErrorCode <> 0 BEGIN
		ROLLBACK TRANSACTION
		RETURN @ErrorCode
	END

	-- If nothing was updated, add new vote
	IF @RowCount = 0
	BEGIN
		INSERT INTO dbo.votemembers (UserID, VoteID, Response, Visible, DateVoted, UID)
		VALUES (@userid, @pollid, @response, 1, GetDate(), @bbcuid)
	END
	ELSE
	BEGIN
		SELECT	@AlreadyVoted = 1		
	END
		
	SELECT @ErrorCode = @@ERROR
	IF @ErrorCode <> 0 BEGIN
		ROLLBACK TRANSACTION
		RETURN @ErrorCode
	END
	
	-- Update stats
	UPDATE dbo.pagevotes
	SET AverageRating=vm.AverageRating, VoteCount=vm.VoteCount
	FROM 
	(select count(*) VoteCount, avg(cast(response as float)) AverageRating from dbo.votemembers where voteid=@pollid) AS vm
	where voteid=@pollid

	SELECT @ErrorCode = @@ERROR
	IF @ErrorCode <> 0 BEGIN
		ROLLBACK TRANSACTION
		RETURN @ErrorCode
	END

COMMIT TRANSACTION