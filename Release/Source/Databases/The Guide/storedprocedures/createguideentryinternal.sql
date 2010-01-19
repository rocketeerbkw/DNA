CREATE PROCEDURE createguideentryinternal
@subject varchar(255), 
@bodytext varchar(max), 
@extrainfo text,
@editor int,
@style int = 1, 
@status int = NULL, 
@keywords varchar(255) = NULL,
@researcher int = NULL,
@siteid int = 1,
@submittable tinyint = 1,
@guidetypeid int, 
@returnentryid int OUTPUT,
@returndatecreated datetime OUTPUT,
@returnforumid int OUTPUT,
@returnh2g2id int OUTPUT,
@returnhaveduplicate tinyint OUTPUT,
@hash uniqueidentifier = NULL,
@preprocessed int = 1,
@canread tinyint = 1,
@canwrite tinyint = 0, 
@canchangepermissions tinyint = 0,
@forumstyle tinyint = 0,
@groupnumber int = NULL,
@ignoremoderation int = 0

AS

/*
	IMPORTANT!!!
	This Stored procedure should never be called directly as it doesn't do any TRANSACTION calls!
	Make sure the calling procedure calls this within BEGIN / COMMIT TRANSACTION calls
*/
IF (@@TRANCOUNT = 0)
BEGIN
	RAISERROR ('createguideentryinternal cannot be called outside a transaction!!!',16,1)
	RETURN 50000
END

if (NOT (@editor IS NULL))
BEGIN
	-- Check to see if we've been given a hash value to check against!
	IF (@hash IS NOT NULL)
	BEGIN
		-- Try to insert the new Hashvalue and details into the ArticleDuplicates table.
		INSERT INTO ArticleDuplicates ( HashValue, UserID ) VALUES (@hash, @editor)

		-- If no rows were effected, then we've already got this guideentry!!!
		IF (@@ROWCOUNT = 0)
		BEGIN
			-- Get the h2g2id from the duplicates table
			SELECT	@returnh2g2id = h2g2ID
				FROM ArticleDuplicates
				WHERE HashValue = @hash

			-- Make sure all the return details are set correctly
			SELECT	@returnentryid = EntryID,
					@returndatecreated = GetDate(),
					@returnforumid = ForumID,
					@returnhaveduplicate = 1
				FROM GuideEntries
				WHERE h2g2id = @returnh2g2id AND siteid = @siteid

			-- Return ok!
			return (0)
		END
	END

	declare @HideArticle bit
	SET @HideArticle = 0
	
	-- Allow Moderation to be ignored. Editors / Superusers should not be moderated.
	IF ( @ignoremoderation <> 1 )
	BEGIN
		EXEC dbo.checkifarticleshouldbehidden	@siteid = @siteid, 
												@userid = @editor, 
												@h2g2id = null, 
												@hide	= @HideArticle output
	END

	DECLARE @ErrorCode int

	declare @forumid int
	
	INSERT INTO Forums (Title, keywords, SiteID, ForumStyle) VALUES(@subject, @keywords, @siteid, @forumstyle)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode
	
	SELECT @forumid = @@IDENTITY

	-- Add user to the forum for their own entry
	INSERT INTO FaveForums (UserID, ForumID) VALUES (@editor, @forumid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode

	declare @curdate datetime
	SELECT @curdate = getdate()

	INSERT INTO GuideEntries (ExtraInfo,blobid,text, Editor, Subject, Keywords, ForumID, DateCreated, 
								Style, Status, Hidden, SiteID,Submittable, Type, PreProcessed,
								CanRead, CanWrite, CanChangePermissions)
		VALUES (@extrainfo,0,@bodytext, @editor, @subject, @keywords, @forumid, @curdate, @style, 
				@status, CASE WHEN @HideArticle = 1 THEN 3 ELSE NULL END , @siteid,
				@submittable, @guidetypeid, @preprocessed, @canread, @canwrite, @canchangepermissions)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode

	declare @guideentry int
	SELECT @guideentry = @@IDENTITY

	IF @researcher IS NOT NULL
		INSERT INTO Researchers (EntryID, UserID) VALUES (@guideentry, @researcher)

	declare @temp int, @checksum int
	SELECT @temp = @guideentry, @checksum = 0
	WHILE @temp > 0
	BEGIN
		SELECT @checksum = @checksum + (@temp % 10)
		SELECT @temp = @temp  / 10
	END
	SELECT @checksum = @checksum % 10
	SELECT @checksum = 9 - @checksum
	SELECT @checksum = @checksum + (10 * @guideentry)
	
	UPDATE GuideEntries SET h2g2ID = @checksum WHERE EntryID = @guideentry 
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode

	-- Make sure we Update the new entry in the ArticleDuplicates table!
	IF (@hash IS NOT NULL)
	BEGIN
		UPDATE ArticleDuplicates SET h2g2ID = @checksum, UserID = @editor, DateCreated = @curdate WHERE HashValue = @hash
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
			RETURN @ErrorCode
	END

	if (@groupnumber IS NOT NULL)
	BEGIN
		INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, CanRead, CanWrite) 
			SELECT @checksum, (SELECT OwnerTeam FROM Clubs WHERE ClubID = @groupnumber), 1, 1
		INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, CanRead, CanWrite) 
			SELECT @checksum, (SELECT MemberTeam FROM Clubs WHERE ClubID = @groupnumber), 1, 1
	END
	
	-- Lastly, make sure the editor is given edit permissions
	INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, Priority, CanRead, CanWrite, CanChangePermissions) 
		SELECT @checksum, TeamID, 1, 1, 1, 1 FROM UserTeams WHERE UserId = @editor AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode
		
	-- update content signif. We don't want zeitgeist to fail this procedure so sp's error codes are not processed.
	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'CreateGuideEntry',
											  @siteid		= @siteid, 
											  @entryid		= @guideentry, 
											  @userid		= @editor

	SELECT @returnentryid = @guideentry, @returndatecreated = @curdate, @returnforumid = @forumid, @returnh2g2id = @checksum, @returnhaveduplicate = 0
	return 0
END
