CREATE PROCEDURE addresponsetovote @ivoteid int, @iuserid int, @uid uniqueidentifier, @iresponse int, @bvisible TinyInt, @isiteid int, @ithreadid int = 0
AS
	BEGIN TRANSACTION
	
	DECLARE @ErrorCode 	INT
	DECLARE @ClubID 	INT
	
	INSERT INTO VoteMembers(VoteID,UserID,UID,Response,DateVoted,Visible) VALUES (@ivoteid,@iuserid,@uid,@iresponse,GetDate(),@bvisible)
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	IF (@ithreadid != 0)
	BEGIN
		insert into ForumLastUpdated (ForumID, LastUpdated)
			select t.ForumID, getdate() from Threads t where t.ThreadID = @ithreadid
/*
		UPDATE Forums SET LastUpdated = getdate() WHERE ForumID IN 
		(
			SELECT t.ForumID FROM Threads t
				INNER JOIN ThreadVotes v ON v.ThreadID = t.ThreadID
				WHERE v.VoteID = @ivoteid AND t.ThreadID = @ithreadid
		)
*/
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
	END

	COMMIT TRANSACTION

	IF(dbo.udf_getsiteoptionsetting(@isiteid, 'Zeitgeist', 'UseZeitgeist') = 1)
	BEGIN
		DECLARE @ContentAuthor	INT;
		DECLARE @VoteType		INT; 
		DECLARE @ThreadID		INT; 
		DECLARE @EntryID		INT; 

		SELECT @VoteType = Type
		  FROM dbo.Votes 
		 WHERE VoteID = @ivoteid;

		IF (@VoteType = 1)
		BEGIN
			-- Club vote
			SELECT @ContentAuthor = ge.Editor, 
				   @ClubID		  = cv.ClubID
			  FROM dbo.ClubVotes cv WITH (NOLOCK) 
					INNER JOIN dbo.Clubs c WITH (NOLOCK) ON cv.ClubID = c.ClubID
					INNER JOIN dbo.GuideEntries ge WITH (NOLOCK) ON c.h2g2ID = ge.h2g2ID
			 WHERE cv.VoteID = @ivoteid;
		END
		ELSE IF (@VoteType = 2)
		BEGIN
			SELECT @ContentAuthor = UserID, 
				   @ThreadID	  = tv.ThreadID
			  FROM dbo.ThreadVotes tv WITH (NOLOCK)
					INNER JOIN dbo.ThreadEntries te WITH (NOLOCK) ON tv.ThreadID = te.ThreadID AND PostIndex = 0 
			 WHERE tv.VoteID = @ivoteid;
		END
		ELSE IF (@VoteType = 3)
		BEGIN
			SELECT @ContentAuthor = ge.Editor, 
				   @EntryID = @entryID
			  FROM dbo.PageVotes pv
					INNER JOIN dbo.GuideEntries ge on pv.ItemID = ge.h2g2ID -- assumes that there is only one type of Vote (type = 1). Must change if votes on objects other than GuideEntries are implemented.
			 WHERE pv.VoteID = @ivoteid;
		END

		DECLARE @UserToIncrement INT; -- User to increment the zeitgeist score of. 

		IF (dbo.udf_getsiteoptionsetting(@isiteid, 'Zeitgeist', 'AddResponseToVote-IncrementAuthor') = 1)
		BEGIN
			SELECT @UserToIncrement = @ContentAuthor; 
		END
		ELSE
		BEGIN
			SELECT @UserToIncrement = @iuserid; 
		END

		IF (@iresponse > 0)
		BEGIN
			EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddPositiveResponseToVote',
													  @siteid		= @isiteid,  
													  @userid		= @UserToIncrement,
													  @clubid		= @ClubID, 
													  @entryid		= @EntryID, 
													  @threadid		= @ThreadID
		END
		ELSE
		BEGIN
			EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddNegativeResponseToVote',
													  @siteid		= @isiteid,  
													  @userid		= @UserToIncrement, 
													  @clubid		= @ClubID, 
													  @entryid		= @EntryID, 
													  @threadid		= @ThreadID
		END
	END	
	
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_VOTEADDED', @ClubID, 'IT_CLUB', @iVoteID, 'IT_VOTE', @iuserid
	
RETURN 0