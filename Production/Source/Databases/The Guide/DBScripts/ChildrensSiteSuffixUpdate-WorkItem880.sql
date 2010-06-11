SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT UserID, SiteID INTO SiteSuffixUpdate FROM preferences WHERE SiteID IN
(
	SELECT SiteID from Sites WHERE URLName in ('mbcbbc','mbnewsround')
)
CREATE CLUSTERED INDEX CIX_SiteSuffixUpdate ON SiteSuffixUpdate(UserID,SiteID)

WHILE EXISTS(SELECT * FROM SiteSuffixUpdate)
BEGIN
	;WITH Chunk AS
	(
		SELECT TOP(1000) UserID, SiteID FROM SiteSuffixUpdate ORDER BY UserID, SiteID 
	),
	PrefRows AS
	(
		SELECT p.SiteSuffix, u.UserName
		FROM Preferences p
		JOIN Chunk c on c.UserId = p.UserId AND c.siteId = p.SiteId
		JOIN Users u on u.UserId = p.UserId 
	)
	UPDATE PrefRows SET SiteSuffix = UserName

	;WITH Chunk AS
	(
		SELECT TOP(1000) UserID, SiteID FROM SiteSuffixUpdate ORDER BY UserID, SiteID 
	)
	DELETE Chunk
END
