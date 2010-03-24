create procedure getforumpermissions @userid int, @forumid int, @canread int output, @canwrite int output 
as

-- Using the permissions in the Forums table as well
-- 


select TOP 1 @canread = CASE WHEN gm.UserID IS NULL THEN f.CanRead ELSE fp.CanRead END,
		@canwrite = CASE WHEN gm.UserID IS NULL THEN 
			f.CanWrite 
		ELSE fp.CanWrite END
FROM Forums f WITH(NOLOCK)
LEFT JOIN ForumPermissions fp WITH(NOLOCK) ON fp.ForumID = f.ForumID
LEFT JOIN (SELECT u.UserID, g.TeamID FROM Users u WITH(NOLOCK) INNER JOIN TeamMembers g WITH(NOLOCK) ON u.UserID = g.UserID) as gm ON gm.TeamID = fp.TeamID AND gm.UserID = @userid
WHERE f.ForumID = @forumid
order by gm.UserID DESC, fp.Priority DESC
