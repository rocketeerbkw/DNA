CREATE PROCEDURE getnamespacesforsite @siteid INT
AS
SELECT NameSpaceID, SiteID, [Name] FROM dbo.NameSpaces WITH(NOLOCK) WHERE SiteID = @siteid