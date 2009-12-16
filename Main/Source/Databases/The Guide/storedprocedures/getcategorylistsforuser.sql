CREATE PROCEDURE getcategorylistsforuser @userid int, @siteid int
AS
SELECT	c.*,
		u.username,
		u.firstnames,
		u.lastname,
		u.taxonomynode,
		u.area,
		u.Active,
		u.Status,
		'Journal' = J.ForumID,
		p.title,
		p.SiteSuffix
FROM dbo.CategoryList c
INNER JOIN dbo.Users u ON c.UserID = u.UserID
LEFT JOIN dbo.Preferences p ON p.UserID = u.UserID AND p.SiteID = @siteid
INNER JOIN dbo.Journals J on J.UserID = U.UserID and J.SiteID = @siteid
WHERE c.SiteID = @siteid AND c.UserID = @userid
