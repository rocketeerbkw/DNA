create procedure getthreadpermissions @userid int, @threadid int
as

-- Using the permissions in the Threads table as well
-- 


select CASE WHEN gm.UserID IS NULL THEN t.CanRead ELSE tp.CanRead END as CanRead,
		CASE WHEN gm.UserID IS NULL THEN 
			t.CanWrite 
		ELSE tp.CanWrite END as CanWrite from Threads t WITH(NOLOCK)
LEFT JOIN ThreadPermissions tp WITH(NOLOCK) ON tp.ThreadID = t.ThreadID
LEFT JOIN (SELECT u.UserID, g.TeamID FROM Users u WITH(NOLOCK) INNER JOIN TeamMembers g WITH(NOLOCK) ON u.UserID = g.UserID) as gm ON gm.TeamID = tp.TeamID AND gm.UserID = @userid
WHERE t.ThreadID = @threadid
order by gm.UserID DESC, tp.Priority DESC
