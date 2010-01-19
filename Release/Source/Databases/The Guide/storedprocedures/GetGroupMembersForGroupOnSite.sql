CREATE PROCEDURE getgroupmembersforgrouponsite @groupname varchar(255), @siteid int
AS
SELECT g.Name, gm.userid, gm.GroupID, gm.SiteID, u.username, u.firstnames, u.lastname, u.Area, u.taxonomynode, p.Title, p.SiteSuffix FROM GroupMembers gm WITH(NOLOCK)
INNER JOIN Groups g WITH(NOLOCK) ON g.GroupID = gm.GroupID
INNER JOIN Users u WITH(NOLOCK) ON u.UserID = gm.UserID
LEFT JOIN Preferences p WITH(NOLOCK) ON p.userid = u.userid AND p.SiteID = @siteid
WHERE g.Name = @groupname AND gm.SiteID = @siteid