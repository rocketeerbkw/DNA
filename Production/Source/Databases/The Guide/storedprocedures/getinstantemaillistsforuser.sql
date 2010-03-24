CREATE PROCEDURE getinstantemaillistsforuser @userid int, @siteid int
AS
SELECT	e.*,
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
FROM dbo.InstantEMailAlertList e
INNER JOIN dbo.Users u ON e.UserID = u.UserID
LEFT JOIN dbo.Preferences p ON p.UserID = u.UserID AND p.SiteID = @siteid
INNER JOIN dbo.Journals J on J.UserID = U.UserID and J.SiteID = @siteid
WHERE e.SiteID = @siteid AND e.UserID = @userid
