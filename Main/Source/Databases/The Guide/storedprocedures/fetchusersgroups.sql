CREATE  PROCEDURE fetchusersgroups @userid int, @siteid int
AS
SELECT g.Name FROM groups g WITH(NOLOCK)
INNER JOIN GroupMembers m WITH(NOLOCK) ON m.GroupID = g.GroupID
WHERE m.UserID = @userid AND g.UserInfo = 1 AND m.SiteID = @siteid

