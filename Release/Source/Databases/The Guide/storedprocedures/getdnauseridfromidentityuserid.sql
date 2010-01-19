CREATE PROCEDURE getdnauseridfromidentityuserid @identityuserid INT
AS
SELECT DNAUserID FROM dbo.SignInUserIDMapping WITH(NOLOCK) WHERE IdentityUserID = @identityuserid