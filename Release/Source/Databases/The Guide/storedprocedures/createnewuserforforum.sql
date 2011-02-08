CREATE PROCEDURE createnewuserforforum	@forumid int,
											@username nvarchar(255) = 'Anonymous User',
											@email varchar(255) = 'anonymoususer@bbc.co.uk',
											@siteid int,
											@firstnames varchar(255) = null,
											@lastname varchar(255) = null,
											@displayname nvarchar(255) = 'Anonymous User'
As

-- create the new account for anonymous commenting on a comment forum
-- This procedure can be called when the account exists, but the assests (masthead, journal etc) don't for this site
-- So the first part can usually only be called once, but populateuseraccount could be called multiple times

declare @userid int

select @userid = isnull(NotSignedInUserId, 0)
from commentforums
where forumid = @forumid

BEGIN TRANSACTION
IF @userid = 0
BEGIN

	INSERT INTO dbo.SignInUserIDMapping SELECT SSOUserID = 0, IdentityUserID = 0
	SELECT @userid = @@IDENTITY

	-- Make sure the exact same time is used throughout
	DECLARE @date datetime
	SET @date=getdate()
	
	DECLARE @Err INT
	
	declare @nickname nvarchar(255)
	-- Use Displayname if provided otherwise loginname
	IF (@displayname IS NULL OR LEN(@displayname) = 0 )
	BEGIN
		SET @nickname = @username
	END
	ELSE
	BEGIN
		SET @nickname = @displayname
	END

	
	--Create user 
	INSERT INTO Users (UserID, UserName, LoginName,  Email, Active, FirstNames, LastName )
	--VALUES(@userid, @nickname, @username,  @email, 1, @firstnames, @lastname) <-- Reinsert to correctly collect firstname/lastname
	VALUES(@userid, @nickname, @username,  @email, 1, NULL, NULL)
	
	--update forum with userid
	update commentforums
	set NotSignedInUserId = @userid
	where forumid = @forumid
	
	SET @Err = @@ERROR; IF @Err <> 0 GOTO HandleError
	
	
END

-- See if we need to check the preferences table to see if the user has an entry for this site?
IF NOT EXISTS ( SELECT SiteID FROM Preferences WHERE UserID = @UserID AND SiteID = @SiteID )
BEGIN
	DECLARE @DateJoined DATETIME, @AutoSinBin BIT
	SELECT  @DateJoined = MIN (DateJoined),
			@AutoSinBin =  0 
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

	--moving anonymous user out of sinbin if set within perferences table
	IF @DateJoined IS NOT NULL
	BEGIN
		UPDATE dbo.Preferences SET datejoined = GETDATE(), AutoSinBin = 0
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
	
EXEC @Err = finduserfromid @userid, NULL, @siteid
SET @Err = dbo.udf_checkerr(@@ERROR,@Err); IF @Err <> 0 GOTO HandleError
	
COMMIT TRANSACTION

RETURN 0

HandleError:
ROLLBACK TRANSACTION
EXEC Error @Err
RETURN @Err

