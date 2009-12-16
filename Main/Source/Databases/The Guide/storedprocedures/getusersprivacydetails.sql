CREATE PROCEDURE getusersprivacydetails @userid INT
AS
SELECT HideUserName, HideLocation FROM dbo.Users WITH(NOLOCK) WHERE UserID = @userid