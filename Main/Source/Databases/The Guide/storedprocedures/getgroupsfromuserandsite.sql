CREATE PROCEDURE getgroupsfromuserandsite @userid int = null, @siteid int = null
AS

SELECT DISTINCT u.UserName, u.UserID, 'GroupName' = gr.Name, u.Area, p.Title, p.SiteSuffix, u.FirstNames, u.LastName, u.Status
FROM Users u
LEFT JOIN GroupMembers m ON u.UserID = m.UserID AND m.SiteID = @siteid
LEFT JOIN Groups gr ON m.GroupID = gr.GroupID
LEFT JOIN Preferences p ON u.UserID = p.UserID AND p.SiteID = @siteid
WHERE u.userid = @userid
