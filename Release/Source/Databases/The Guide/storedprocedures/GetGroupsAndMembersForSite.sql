CREATE PROCEDURE getgroupsandmembersforsite @siteid int
AS
SELECT g.*, m.UserID, m.SiteID FROM Groups g
INNER JOIN GroupMembers m ON m.GroupID = g.GroupID
WHERE m.SiteID = @siteid ORDER BY g.GroupID, m.UserID