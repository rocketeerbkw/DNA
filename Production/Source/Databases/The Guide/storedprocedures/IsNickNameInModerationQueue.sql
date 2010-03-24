CREATE PROCEDURE isnicknameinmoderationqueue @userid int
AS
SELECT TOP 1 Status FROM dbo.NickNameMod WHERE UserID = @userid
ORDER BY DateQueued DESC
