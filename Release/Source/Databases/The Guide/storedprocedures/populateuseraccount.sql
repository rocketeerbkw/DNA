CREATE PROCEDURE populateuseraccount	@userid int, @siteid int
as
BEGIN TRANSACTION
	-- Create the user's private team
	declare @ErrorCode int
	declare @userteam int
	declare @journal int
	declare @privateforum int
	declare @masthead int
	declare @messagecentre int
	declare @guidetypeid int
	declare @extrainfo varchar(255)
	declare @FoundDuplicate tinyint

	set @extrainfo='<EXTRAINFO><TYPE ID="3001" NAME="userpage"/></EXTRAINFO>'

	-- get the guide entry id for 'userpage'
	SELECT @guidetypeid = Id FROM GuideEntryTypes WHERE Name = 'userpage'
	IF (@guidetypeid <= 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	select @masthead = EntryID FROM Mastheads where UserID = @userid and SiteID = @siteid
	select @journal = ForumID FROM Journals where UserID = @userid and SiteID = @siteid
	select @userteam = TeamID FROM UserTeams where UserID = @userid AND SiteID = @siteid
	
	IF @userteam IS NULL
	BEGIN
		declare @title varchar(60)
		SELECT @title = 'Private Messages - U' + convert(varchar(30),@userid )
		EXEC @ErrorCode = createnewteam @siteid, @userid, @title, 'user', @userteam OUTPUT, @privateforum OUTPUT, 1 /*AlertInstantly*/
		--EXEC @ErrorCode = createprivateforum @userid, NULL, @title, @siteid, 0,1,0,0, @privateforum OUTPUT
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

--		UPDATE Users SET PrivateForum = @privateforum WHERE UserID = @userid
--		SELECT @ErrorCode = @@ERROR
--		IF (@ErrorCode <> 0)
--		BEGIN
--			ROLLBACK TRANSACTION
--			EXEC Error @ErrorCode
--			RETURN @ErrorCode
--		END
		
		--UPDATE Users SET TeamID = @userteam WHERE UserID = @userid
		INSERT INTO UserTeams (UserID, SiteID, TeamID)
		VALUES (@userid, @siteid, @userteam)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

	END
		
	-- Now create the user's journal
	IF @journal IS NULL
	BEGIN
		EXEC @ErrorCode = createprivateforum @userid, @userid, 'User-journal', @siteid, 1,0,1,1, @journal OUTPUT
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		/*
		UPDATE Users SET Journal = @journal WHERE UserID = @userid
		*/
		INSERT INTO Journals (UserID, SiteID, ForumID) VALUES(@userid, @siteid, @journal)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
		

--		by default, users should *not* be subscribed to their own journal because that puts them on their friends list, which looks odd.

--		INSERT INTO FaveForums (ForumID, UserID)
--			VALUES(@journal, @userid)
--		SELECT @ErrorCode = @@ERROR
--		IF (@ErrorCode <> 0)
--		BEGIN
--			ROLLBACK TRANSACTION
--			EXEC Error @ErrorCode
--			RETURN @ErrorCode
--		END
	END

	-- Now create an empty personal space
	IF @masthead IS NULL
	BEGIN
		declare @entryid int, @datecreated datetime, @entryforumid int, @h2g2id int
		EXEC @ErrorCode = createguideentryinternal	'','',@extrainfo, @userid, 2, 3, NULL, NULL, @siteid, 0, 
				@guidetypeid, @entryid OUTPUT, @datecreated OUTPUT, @entryforumid OUTPUT, @h2g2id OUTPUT, @FoundDuplicate OUTPUT
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		IF EXISTS(SELECT * FROM dbo.Sites WHERE SiteID = @siteid AND PreModeration = 1)
		BEGIN
			-- CreateGuideEntryInternal has hidden the new user's Masthead if the site is premoderated but no record has yet been placed in ArticleMod. 
			-- The masthead is blank so we can safely unhide it and avoid the moderation of a blank GuideEntry. 
			UPDATE GuideEntries
			   SET Hidden = NULL
			 WHERE EntryID = @entryid
		END
										
		INSERT INTO Mastheads (UserID, SiteID, EntryID)
		VALUES(@userid, @siteid, @entryid)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		INSERT INTO FaveForums (ForumID, UserID)
			VALUES(@entryforumid, @userid)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
		
	END
COMMIT TRANSACTION	
return 0