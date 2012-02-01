CREATE PROCEDURE createnewuserfromuserid	@userid int,
											@loginname varchar(255),
											@email varchar(255),
											@siteid int = 1,
											@firstnames varchar(255) = null,
											@lastname varchar(255) = null,
											@displayname nvarchar(255) = null,
											@ipaddress varchar(25)=null, 
											@bbcuid uniqueidentifier=null
As

-- create the new account
-- This procedure can be called when the account exists, but the assests (masthead, journal etc) don't for this site
-- So the first part can usually only be called once, but populateuseraccount could be called multiple times

BEGIN TRANSACTION
IF NOT EXISTS (SELECT * FROM Users WHERE UserID = @userid)
BEGIN
	-- Make sure the exact same time is used throughout
	DECLARE @date datetime
	SET @date=getdate()
	
	DECLARE @Err INT
	
	--  Nickname to be used when creating user.
	DECLARE @nickname NVARCHAR(255)

	DECLARE @premoderatenicknames bit
	SELECT @premoderatenicknames = CASE WHEN dbo.udf_getsiteoptionsetting (@siteid, 'Moderation', 'NicknameModerationStatus') = 2 THEN 1 ELSE 0 END
	
	DECLARE @postmoderatenicknames bit
	SELECT @postmoderatenicknames = CASE WHEN dbo.udf_getsiteoptionsetting (@siteid, 'Moderation', 'NicknameModerationStatus') = 1 THEN 1 ELSE 0 END
	
	DECLARE @setnicknamestousername bit
	SELECT @setnicknamestousername = CASE WHEN dbo.udf_getsiteoptionsetting (@siteid, 'Moderation', 'SetNewUsersNickNames') = 1 THEN 1 ELSE 0 END

	
	-- Use Displayname if provided otherwise loginname
	IF (@displayname IS NULL OR LEN(@displayname) = 0 )
	BEGIN
		SET @nickname = @loginname
	END
	ELSE
	BEGIN
		SET @nickname = @displayname
	END

	-- Only put the nickname in the moderation queue if setting nicknames and nicknames are moderated.
	IF (@setnicknamestousername = 1 AND ( @premoderatenicknames = 1 OR @postmoderatenicknames = 1 ) )
	BEGIN 
		--All new users have their nickname moderated.
		INSERT INTO NicknameMod (UserID, Status, DateQueued, SiteID, NickName )
		VALUES (@userid, 0, @date, @SiteID, @nickname )
		SET @Err = @@ERROR; IF @Err <> 0 GOTO HandleError

		-- Get the identity of the new nickname mod entry
		DECLARE @ModID int
		SET @ModID = SCOPE_IDENTITY()
		
		EXEC @Err = addnicknamemodhistory @ModID,0,0,NULL,3,NULL,@date
		SET @Err = dbo.udf_checkerr(@@ERROR,@Err); IF @Err <> 0 GOTO HandleError
	END	
	
	-- Reset username if premoderated or if not setting usernames.
	IF ( @premoderatenicknames = 1 OR @setnicknamestousername = 0 )
	BEGIN
		SET @nickname = 'U' + CAST(@userid AS varchar(20))
	END
	
	BEGIN TRY
		EXEC openemailaddresskey
		--Create user 
		INSERT INTO Users (UserID, UserName, LoginName,  EncryptedEmail, Active, FirstNames, LastName )
		--VALUES(@userid, @nickname, @loginname,  @email, 1, @firstnames, @lastname) <-- Reinsert to correctly collect firstname/lastname
		VALUES(@userid, @nickname, @loginname,  dbo.udf_encryptemailaddress(@email,@userid), 1, NULL, NULL)
	END TRY
	BEGIN CATCH
		SET @Err = ERROR_NUMBER();
		GOTO HandleError
	END CATCH

END

-- See if we need to check the preferences table to see if the user has an entry for this site?
IF NOT EXISTS ( SELECT SiteID FROM Preferences WHERE UserID = @UserID AND SiteID = @SiteID )
BEGIN
	DECLARE @DateJoined DATETIME, @AutoSinBin BIT
	SELECT  @DateJoined = MIN (DateJoined),
			@AutoSinBin = CASE WHEN MIN(CAST(ISNULL(AutoSinBin,0) AS INT)) > 0 THEN 1 ELSE 0 END
		FROM dbo.Preferences p
	INNER JOIN dbo.Sites s ON s.SiteID = p.siteid
	WHERE s.ModClassID IN
	(
		SELECT ModClassID FROM Sites WHERE SiteID = @SiteID
	)
	AND p.UserID = @UserID

	EXEC @Err = SetDefaultPreferencesForUser @UserID, @SiteID
	SET @Err = dbo.udf_checkerr(@@ERROR,@Err); IF @Err <> 0 GOTO HandleError

-- add event 
EXEC addtoeventqueueinternal 'ET_NEWUSERTOSITE', @UserID, 'IT_USER', @SiteID, 'IT_SITE', @UserID


	IF @DateJoined IS NOT NULL
	BEGIN
		UPDATE dbo.Preferences SET datejoined = GETDATE(), AutoSinBin = @AutoSinBin
		WHERE userid = @userid AND siteid = @siteid
		SET @Err = @@ERROR; IF @Err <> 0 GOTO HandleError
	END
	ELSE
	BEGIN
		UPDATE dbo.Preferences SET datejoined = GETDATE()
		WHERE userid = @userid AND siteid = @siteid
		SET @Err = @@ERROR; IF @Err <> 0 GOTO HandleError

		DECLARE @premodduration int
		EXEC checkpremodduration @siteid, @premodduration OUTPUT

		DECLARE @postcountthreshold int
		EXEC checkpostcountthreshold @siteid, @postcountthreshold OUTPUT

		IF (@premodduration IS NULL)
		BEGIN
			SET @premodduration = 0
		END

		IF (@postcountthreshold IS NULL)
		BEGIN
			SET @postcountthreshold = 0
		END
		
		IF (@premodduration <> 0 OR @postcountthreshold <> 0)
		BEGIN
			UPDATE dbo.Preferences SET AutoSinBin = 1
			WHERE userid = @userid AND siteid = @siteid
			SET @Err = @@ERROR; IF @Err <> 0 GOTO HandleError
		END
		ELSE
		BEGIN
			UPDATE dbo.Preferences SET AutoSinBin = 0
			WHERE userid = @userid AND siteid = @siteid
			SET @Err = @@ERROR; IF @Err <> 0 GOTO HandleError
		END
	END
	
	EXEC @Err = populateuseraccount @userid, @siteid
	SET @Err = dbo.udf_checkerr(@@ERROR,@Err); IF @Err <> 0 GOTO HandleError

	EXEC @Err = verifyuseragainstbannedipaddress @userid, @siteid, @ipaddress, @bbcuid
	SET @Err = dbo.udf_checkerr(@@ERROR,@Err); IF @Err <> 0 GOTO HandleError
	
END




EXEC @Err = finduserfromid @userid, NULL, @siteid
SET @Err = dbo.udf_checkerr(@@ERROR,@Err); IF @Err <> 0 GOTO HandleError


	
COMMIT TRANSACTION

RETURN 0

HandleError:
ROLLBACK TRANSACTION
EXEC Error @Err
RETURN @Err

