CREATE PROCEDURE createnewuserfromssoid	@ssouserid int,
										@username varchar(255),
										@email varchar(255),
										@siteid int = 1,
										@firstnames varchar(255) = null,
										@lastname varchar(255) = null,
										@displayname varchar(255) = null
AS
-- Try to get the dnauserid from the sign in mapping table
DECLARE @DnaUserID int
SELECT @DnaUserID = DNAUserID FROM dbo.SignInUserIDMapping WHERE SSOUserID = @ssouserid
IF (@DnaUserID IS NULL)
BEGIN
	-- We still didn't find the DNAUserID. Create a new entry for the user
	INSERT INTO dbo.SignInUserIDMapping SELECT SSOUserID = @ssouserid, IdentityUserID = NULL
	SELECT @DnaUserID = @@IDENTITY
END

-- Now call the internal create new user from id
EXEC createnewuserfromuserid @DnaUserID, @username, @email, @siteid, @firstnames, @lastname, @displayname