CREATE PROCEDURE getemaillistsforuser @userid int, @siteid int
AS
SELECT	e.*,
		u.username,
		u.firstnames,
		u.lastname,
		u.taxonomynode,
		u.area,
		u.Active,
		u.Status,
		j.ForumID as 'Journal',
		p.title,
		p.SiteSuffix
FROM dbo.EMailAlertList e
INNER JOIN dbo.Users u ON e.UserID = u.UserID
LEFT JOIN dbo.Preferences p ON p.UserID = u.UserID AND p.SiteID = @siteid
LEFT JOIN dbo.Journals j WITH(NOLOCK) on j.UserID = u.UserID and j.SiteID = @siteid
WHERE e.SiteID = @siteid AND e.UserID = @userid
