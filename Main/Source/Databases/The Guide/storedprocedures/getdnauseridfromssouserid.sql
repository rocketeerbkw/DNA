CREATE PROCEDURE getdnauseridfromssouserid @ssouserid INT
AS
SELECT DNAUserID FROM dbo.SignInUserIDMapping WITH(NOLOCK) WHERE SSOUserID = @ssouserid