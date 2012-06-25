CREATE PROCEDURE createnewuserfromtwitteruserid		@twitteruserid			nvarchar(40) = null,
													@twitterscreenname		nvarchar(255),
													@twittername		    nvarchar(255),
													@siteid					int = 1
AS
-- Try to get the dnauserid from the sign in mapping table
DECLARE @DnaUserID int

SELECT @DnaUserID = DNAUserID FROM dbo.SignInUserIDMapping WHERE TwitterUserID = @twitteruserid
IF (@DnaUserID IS NULL)
BEGIN
		-- We still didn't find the DNAUserID. Create a new entry for the user
	INSERT INTO dbo.SignInUserIDMapping(TwitterUserID) VALUES (@twitteruserid)
	SELECT @DnaUserID = @@IDENTITY
END
ELSE 
BEGIN
	-- update the screenname if the user already exists and the screenname is changed
	UPDATE dbo.users 
	SET UserName = @twittername, LoginName = @twitterscreenname
	WHERE UserID = @DnaUserID AND (UserName <> @twittername OR LoginName <> @twitterscreenname)
END

EXEC createnewuserfromuserid @DnaUserID, @twitterscreenname, null, @siteid, null, null, @twittername, null, null



