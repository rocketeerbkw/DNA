CREATE PROCEDURE synchroniseuserwithprofile	@userid int,
												@firstnames varchar(255) = NULL,
												@lastname varchar(255) = NULL,
												@email varchar(255),
												@loginname varchar(255),
												@displayname varchar(255) = NULL,
												@identitysite int = NULL,
												@siteid int = 1
As

IF EXISTS (SELECT * FROM Users WHERE UserID = @userid)
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	-- Get the First, last, and user names from the DNA db
	DECLARE @firstnamesInDNA varchar(255), @lastnameInDNA varchar(255), @UserNameInDNA varchar(255), @CurrentEmail varchar(255)
	SELECT @firstnamesInDNA = FirstNames, @lastnameInDNA = LastName, @UserNameInDNA = UserName, @CurrentEmail = Email
			FROM Users WHERE UserID = @UserID
		
	IF (@displayname IS NOT NULL AND @displayname != @UserNameInDNA AND LEN(@displayname) > 0)
	BEGIN
		DECLARE @premoderatenicknames bit
		SELECT @premoderatenicknames = CASE WHEN dbo.udf_getsiteoptionsetting (@siteid, 'Moderation', 'NicknameModerationStatus') = 2 THEN 1 ELSE 0 END
	
		DECLARE @postmoderatenicknames bit
		SELECT @postmoderatenicknames = CASE WHEN dbo.udf_getsiteoptionsetting (@siteid, 'Moderation', 'NicknameModerationStatus') = 1 THEN 1 ELSE 0 END
		
		DECLARE @UserIsPreMod bit
		SELECT @UserIsPreMod = CASE WHEN p.PrefStatus = 1 THEN 1 ELSE 0 END
			FROM dbo.Preferences p
			WHERE p.Siteid = @siteid AND p.UserID = @userid
		
		IF ( @premoderatenicknames =  0 AND @UserIsPreMod = 0)
		BEGIN
			-- Nickname change takes immediate effect
			SET @UserNameInDNA = @displayname
		END

		-- Only put the nickname in the moderation queue if premod or postmod and setting nicknames is allowed
		IF (@premoderatenicknames = 1 OR @postmoderatenicknames = 1 OR @UserIsPreMod = 1)
		BEGIN 
			EXEC @ErrorCode = dbo.queuenicknameformoderation @userid, @siteid, @displayname
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END
		END	
	END
					
	-- If the FirstNames and LastName are not defined, then the SSO service doesn't
	-- support these attributes for the given site.  Force them to be the same as in the database
	-- so the logic that checks for changes isn't triggered below, and the UPDATE that follows
	-- retains the original settings
	IF (@firstnames IS NULL ) BEGIN SET @firstnames=@firstnamesInDNA END
	IF (@lastname   IS NULL ) BEGIN SET @lastname=  @lastnameInDNA   END

	-- If we're NOT an Identity site AND the user has an Identity account, then don't sync with SSO EMail.
	IF ( @identitysite = 0 AND EXISTS ( SELECT * FROM SignInUserIDMapping WHERE DNAUSerID = @userID AND IdentityUserID IS NOT NULL ) )
	BEGIN
		SET @email = @CurrentEmail
	END

	UPDATE Users
	--SET EMail = @email, FirstNames = @firstnames, LastName = @lastname, LoginName = @loginname, username = @UserNameInDNA, LastUpdatedDate = GetDate() where UserID = @userid <-- Reinsert to correctly collect firstname/lastname
	SET EMail = @email, FirstNames = NULL, LastName = NULL, LoginName = @loginname, username = @UserNameInDNA, LastUpdatedDate = GetDate() where UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	COMMIT TRANSACTION

	-- See if we need to check the preferences table to see if the user has an entry for this site?
	-- userjoinedsite.sql will set default preference etc so should not be necessary here.
	IF NOT EXISTS ( SELECT SiteID FROM Preferences WHERE UserID = @UserID AND SiteID = @SiteID )
	BEGIN
		EXEC @ErrorCode = SetDefaultPreferencesForUser @UserID, @SiteID
		IF (@ErrorCode <> 0)
		BEGIN
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END

	SELECT Username, UserID From Users WHERE UserID = @userid
END