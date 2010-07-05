CREATE PROCEDURE getdnauseridfromidentityuserid @identityuserid varchar(40)
AS
SELECT DNAUserID FROM dbo.SignInUserIDMapping WITH(NOLOCK) WHERE IdentityUserID = @identityuserid