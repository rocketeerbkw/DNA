
/*********************************************************************************

	CREATE PROCEDURE pollcontentratingvote @voteid int, @response int, @userid int

	Author:		James Pullicino
	Created:	27/01/2005
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Add/Update vote for a user for content rating polls
				Update content rating stats in pagevotes table
	
*********************************************************************************/

CREATE PROCEDURE pollcontentratingvote @pollid int, @userid int, @response int
AS
BEGIN TRANSACTION

	DECLARE @ErrorCode INT
	DECLARE @RowCount INT
	
	-- Attempt to update existing vote
	UPDATE dbo.votemembers SET response = @response, Visible = 1, DateVoted = GetDate()
	WHERE UserID = @userid AND VoteID = @pollid
	
	SELECT @ErrorCode = @@ERROR, @RowCount = @@ROWCOUNT
	
	IF @ErrorCode <> 0 BEGIN
		ROLLBACK TRANSACTION
		RETURN @ErrorCode
	END

	-- If nothing was updated, add new vote
	IF @RowCount = 0 
	INSERT INTO votemembers (UserID, VoteID, Response, Visible, DateVoted)
	VALUES (@userid, @pollid, @response, 1, GetDate())
	
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
	
	-- If Vote is on a comment update the comment forum last updated.
	IF ( EXISTS ( SELECT * FROM PageVotes WHERE voteid = @pollid AND itemtype = 4 ) )
	BEGIN
		INSERT INTO  ForumLastUpdated (ForumID, LastUpdated)
			SELECT forumid, getdate() 
			FROM VComments vu
			INNER JOIN PageVotes pv ON pv.itemid = vu.id
			WHERE voteid = @pollid
	END

COMMIT TRANSACTION