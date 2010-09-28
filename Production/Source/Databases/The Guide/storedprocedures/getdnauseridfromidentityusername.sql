CREATE PROCEDURE getdnauseridfromidentityusername @identityusername varchar(255)
AS
SELECT TOP 1 UserID FROM dbo.Users WITH(NOLOCK) WHERE LoginName = @identityusername ORDER BY UserID DESC