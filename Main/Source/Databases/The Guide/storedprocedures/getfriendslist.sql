CREATE PROCEDURE getfriendslist @userid int, @siteid int
as

declare @friendgroup int
select @friendgroup = GroupID FROM Groups WHERE Name = 'Friend_' + CAST(@userid as varchar) AND System = 1

SELECT u.*, gm.SiteID
FROM GroupMembers gm	
	INNER JOIN Users u ON u.UserID = gm.UserID 
	WHERE gm.GroupID = @friendgroup 
