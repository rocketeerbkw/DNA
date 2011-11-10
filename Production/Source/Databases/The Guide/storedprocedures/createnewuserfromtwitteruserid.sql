CREATE PROCEDURE createnewuserfromtwitteruserid		@twitteruserid			nvarchar(40) = null,
													@username				varchar(255),
													@siteid					int = 1,
													@displayname			nvarchar(255) = null
													
AS
-- Try to get the dnauserid from the sign in mapping table
DECLARE @DnaUserID int

SELECT @DnaUserID = DNAUserID FROM dbo.SignInUserIDMapping WHERE TwitterUserID = @twitteruserid
IF (@DnaUserID IS NULL)
BEGIN
		-- We still didn't find the DNAUserID. Create a new entry for the user
	INSERT INTO dbo.SignInUserIDMapping ( TwitterUserID)
		SELECT @twitteruserid
		SELECT @DnaUserID = @@IDENTITY
END

-- Now call the internal create new user from id
EXEC createnewuserfromuserid @DnaUserID, @username, null, @siteid, null, null, @displayname, null, null



