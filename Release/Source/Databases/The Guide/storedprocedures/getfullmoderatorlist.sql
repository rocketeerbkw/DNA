CREATE PROCEDURE getfullmoderatorlist @groupname VARCHAR(64) = 'moderator'
as
/*
	NOTE: Fix this so that siteid/classid pairs are correct - I don't think
	that it's getting it right when the siteid field and the modclassid 
	field are both not null
*/

DECLARE @groupid INT
SELECT @groupid = groupid FROM Groups WHERE name = @groupname

select u.*, 
	cm.ModClassID, 
	gm.SiteID 
from users u
inner join GroupMembers gm on u.UserID = gm.UserID AND gm.groupid = @groupid
inner join Groups g on g.GroupID = gm.GroupID
inner join Sites s ON s.SiteID = gm.SiteID
left join ModerationClassMembers cm on u.UserID = cm.UserID AND cm.ModClassID = s.ModClassID AND cm.groupid = @groupid
union
select u.*, 
	cm.ModClassID, 
	NULL 
from users u
inner join Moderators m on u.userid = m.userid
left join ModerationClassMembers cm on u.UserID = cm.UserID AND cm.groupid = @groupid
left join Sites s on s.ModClassID = cm.ModClassID
where s.SiteID IS NULL
order by u.UserID, cm.ModClassID, gm.SiteID
