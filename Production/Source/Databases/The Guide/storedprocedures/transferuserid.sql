CREATE Procedure transferuserid @userid int, @newuserid int
As
RAISERROR('transferuserid DEPRECATED',16,1)

/*
	Deprecated - never called

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
						Longitude
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
						Longitude
				FROM Users WITH(UPDLOCK)
				WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END


-- @createdid is the ID of teh new account into which the user @newuserid's details
-- have been copied

	DECLARE @createdid int
	SELECT @createdid = @@IDENTITY

	DECLARE		@cookie uniqueidentifier,
				@email varchar(255),
				@username varchar(255),
				@password varchar(255),
				@firstnames varchar(255),
				@lastname varchar(255),
				@active int,
				@masthead int,
				@datejoined datetime,
				@status int,
				@anonymous int,
				@journal int,
				@latitude float,
				@longitude float

	SELECT	@cookie = Cookie,
			@email = email,
			@username = UserName,
			@password = Password,
			@firstnames = FirstNames,
			@lastname = LastName,
			@active = Active,
			@masthead = Masthead,
			@datejoined = DateJoined,
			@status = Status,
			@anonymous = Anonymous,
			@journal = Journal,
			@latitude = Latitude,
			@longitude = Longitude
		FROM Users WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Users
		SET Cookie		= @cookie, 
			email		= @email,
			UserName	= @username, 
			Password	= @password, 
			FirstNames	= @firstnames, 
			LastName	= @lastname,
			Active		= @active,
			Masthead	= @masthead,
			DateJoined	= @datejoined,
			Status		= @status,
			Anonymous	= @anonymous,
			Journal		= @journal,
			Latitude	= @latitude,
			Longitude	= @longitude
		WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END


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
			Longitude	= NULL
		WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

-- Now update all activity records accordingly

	UPDATE ThreadEntries
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ThreadEntries
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
		
	UPDATE GuideEntries
		SET Editor = @createdid WHERE Editor = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE GuideEntries
		SET Editor = @newuserid WHERE Editor = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Researchers
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Researchers
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE EditMarks
		SET Editor = @createdid WHERE Editor = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE EditMarks
		SET Editor = @newuserid WHERE Editor = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
		
	UPDATE EditHistory
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE EditHistory
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ArticleViews
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ArticleViews
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ActivityLog
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ActivityLog
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Favourites
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Favourites
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE PeopleWatch
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE PeopleWatch
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE PeopleWatch
		SET WatchUserID = @createdid WHERE WatchUserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE PeopleWatch
		SET WatchUserID = @newuserid WHERE WatchUserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Sessions
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Sessions
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ViewedMovies
		SET UserID = @createdid WHERE UserID = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ViewedMovies
		SET UserID = @newuserid WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Forums
		SET JournalOwner = @createdid WHERE JournalOwner = @newuserid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE Forums
		SET JournalOwner = @newuserid WHERE JournalOwner = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

COMMIT TRANSACTION
	return (0)
*/