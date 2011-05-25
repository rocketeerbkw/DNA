CREATE PROCEDURE createnewuserfromidentityid	@identityuserid varchar(40),
												@legacyssoid int = null,
												@username varchar(255),
												@email varchar(255),
												@siteid int = 1,
												@firstnames varchar(255) = null,
												@lastname varchar(255) = null,
												@displayname nvarchar(255) = null,
												@ipaddress varchar(25)=null, 
												@bbcuid uniqueidentifier=null
AS
-- Try to get the dnauserid from the sign in mapping table
DECLARE @DnaUserID int
SELECT @DnaUserID = DNAUserID FROM dbo.SignInUserIDMapping WHERE IdentityUserID = @identityuserid
IF (@DnaUserID IS NULL)
BEGIN
	-- Didn't find the userid, see if they have a legacy sso id matching
	SELECT @DnaUserID = DNAUserID FROM dbo.SignInUserIDMapping WHERE SSOUserID = @legacyssoid
	
	-- Check to see if we found the DNAUserID
	IF (@DnaUserID IS NOT NULL)
	BEGIN
		-- Update the row with the identity id passed in
		UPDATE dbo.SignInUserIDMapping SET IdentityUserID = @identityuserid WHERE SSOUserID = @legacyssoid
	END
	ELSE
	BEGIN
		-- We still didn't find the DNAUserID. Create a new entry for the user
		INSERT INTO dbo.SignInUserIDMapping SELECT SSOUserID = @legacyssoid, IdentityUserID = @identityuserid
		SELECT @DnaUserID = @@IDENTITY
	END
END

-- Now call the internal create new user from id
EXEC createnewuserfromuserid @DnaUserID, @username, @email, @siteid, @firstnames, @lastname, @displayname, @ipaddress, @bbcuid