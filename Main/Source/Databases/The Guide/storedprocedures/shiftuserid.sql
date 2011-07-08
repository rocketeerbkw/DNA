Create Procedure shiftuserid @userid int
As
RAISERROR('shiftuserid DEPRECATED',16,1)

/*
	Deprecated - just not called anymore
*/
/*
BEGIN TRANSACTION
DECLARE @ErrorCode INT
	INSERT INTO Users (	Cookie, 
						email,
						UserName, 
						Password, 
						FirstNames, 
						LastName,
						Active,
						Masthead,
						DateJoined,
						Status,
						Anonymous,
						Journal,
						Latitude,
						Longitude,
						LoginName,
						BBCUID
						)
			SELECT Cookie, 
						email,
						UserName, 
						Password, 
						FirstNames, 
						LastName,
						Active,
						Masthead,
						DateJoined,
						Status,
						Anonymous,
						Journal,
						Latitude,
						Longitude,
						LoginName,
						BBCUID
				FROM Users
				WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
--@createdid is the ID of teh new account into which the user @newuserid's details
--have been copied

	DECLARE @createdid int
	SELECT @createdid = @@IDENTITY

-- reset the old account where the old user was
	UPDATE Users
		SET	Cookie = newid(), 
			email = NULL, 
			UserName	= NULL, 
			Password	= NULL, 
			FirstNames	= NULL, 
			LastName	= NULL,
			Active		= 0,
			Masthead	= NULL,
			Status		= 1,
			Anonymous	= 0,
			Journal		= NULL,
			Latitude	= NULL,
			Longitude	= NULL,
			LoginName	= NULL,
			BBCUID		= NULL
		WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

-- Now update all activity records accordingly


print 'thread entries'
	UPDATE ThreadEntries
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
		
print 'Guide entries'
	UPDATE GuideEntries
		SET Editor = @createdid WHERE Editor = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'Researchers'
	UPDATE Researchers
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'edit marks'
	UPDATE EditMarks
		SET Editor = @createdid WHERE Editor = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
		
print 'edit history'
	UPDATE EditHistory
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'articleviews'
	UPDATE ArticleViews
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'articleindex'
	UPDATE ArticleIndex
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

--	UPDATE ActivityLog
--		SET UserID = @createdid WHERE UserID = @userid

print 'favourites'
	UPDATE Favourites
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'SubsArticles'
	UPDATE SubsArticles
		SET UserID = @createdid WHERE UserID = @userid

print 'ArticleMod'
	UPDATE ArticleMod
		SET LockedBy = @createdid WHERE LockedBy = @userid
	UPDATE ArticleMod
		SET ReferredBy = @createdid WHERE ReferredBy = @userid
	UPDATE ArticleMod
		SET ComplainantID = @createdid WHERE ComplainantID = @userid

print 'ThreadMod'
	UPDATE ThreadMod
		SET LockedBy = @createdid WHERE LockedBy = @userid
	UPDATE ThreadMod
		SET ReferredBy = @createdid WHERE ReferredBy = @userid
	UPDATE ThreadMod
		SET ComplainantID = @createdid WHERE ComplainantID = @userid

print 'EditQueue'
	UPDATE EditQueue
		SET EditorID = @createdid WHERE EditorID = @userid
	UPDATE EditQueue
		SET ArtistID = @createdid WHERE ArtistID = @userid


print 'GeneralMod'
	UPDATE GeneralMod
		SET ComplainantID = @createdid WHERE ComplainantID = @userid
	UPDATE GeneralMod
		SET LockedBy = @createdid WHERE LockedBy = @userid
	UPDATE GeneralMod
		SET ReferredBy = @createdid WHERE ReferredBy = @userid

print 'GroupMembers'
	UPDATE GroupMembers
		SET UserID = @createdid WHERE UserID = @userid

print 'Groups'
	UPDATE Groups
		SET Owner = @createdid WHERE Owner = @userid


print 'FaveForums'
	UPDATE FaveForums
		SET UserID = @createdid WHERE UserID = @userid

print 'PeopleWatch'
	UPDATE PeopleWatch
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE PeopleWatch
		SET WatchUserID = @createdid WHERE WatchUserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'ThreadPostings'
	UPDATE ThreadPostings
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ViewedMovies
		SET UserID = @createdid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'journal'
	UPDATE Forums
		SET JournalOwner = @createdid WHERE JournalOwner = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'preferences'
	UPDATE Preferences
		SET UserID = @createdid WHERE UserID = @userid

print 'Unread public messages'
	EXEC @ErrorCode = dbo.updateusersunreadpublicmessagecount @userid = @createdid

	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

print 'Unread private messages'
	EXEC @ErrorCode = dbo.updateusersunreadprivatemessagecount @userid = @createdid

	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

COMMIT TRANSACTION
	SELECT 'NewID' = @createdid
	
	return (0)
*/