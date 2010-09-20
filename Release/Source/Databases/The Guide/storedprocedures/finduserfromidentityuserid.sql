CREATE PROCEDURE finduserfromidentityuserid @identityuserid varchar(40) = NULL, @siteid int = 1
AS

-- Try to get the dnauserid from the sign in mapping table
DECLARE @DnaUserID int
SELECT @DnaUserID = DNAUserID FROM dbo.SignInUserIDMapping WHERE IdentityUserID = @identityuserid
IF @DnaUserID IS NOT NULL
BEGIN
	EXEC finduserfromid @DnaUserID, NULL, @siteid
END


