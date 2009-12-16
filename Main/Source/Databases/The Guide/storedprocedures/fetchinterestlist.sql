CREATE PROCEDURE fetchinterestlist @userid int
as
SELECT * FROM Groups g
	INNER JOIN GroupMembers m ON g.GroupID = m.GroupID
WHERE m.UserID = @userid AND System = 2
ORDER BY g.Name