create procedure getmoderatorinfo @userid int
as
select	u.UserID, 
		u.UserName, 
		u.FirstNames, 
		u.LastName, 
		u.Email,
		u.taxonomynode,
		u.area,
		u.Active,
		u.Status,
		'ModID' = m.UserID, 
		'IsModerator' = CASE WHEN m.UserID IS NULL THEN 0 ELSE 1 END,
		cm.ModClassID, 
		'SiteClassID' = s.ModClassID,
		gm.SiteID,
		s.description
from users u
inner join GroupMembers gm on u.UserID = gm.UserID
inner join Sites s ON s.SiteID = gm.SiteID
inner join Groups g on g.GroupID = gm.GroupID AND ( g.Name = 'Moderator' OR g.name = 'Editor' OR g.name = 'Host' )
left join Moderators m on u.userid = m.userid
left join ModerationClassMembers cm on u.UserID = cm.UserID 
	AND cm.ModClassID = s.ModClassID
where u.userid = @userid
union
select	u.UserID, 
		u.UserName, 
		u.FirstNames, 
		u.LastName, 
		u.Email,
		u.taxonomynode,
		u.area,
		u.Active,
		u.Status,
		'ModID' = m.UserID, 
		'IsModerator' = CASE WHEN m.UserID IS NULL THEN 0 ELSE 1 END,
		cm.ModClassID,
		'SiteClassID' = s.ModClassID,
		NULL,
		null
from users u
inner join Moderators m on u.userid = m.userid
left join ModerationClassMembers cm on u.UserID = cm.UserID
left join Sites s on s.ModClassID = cm.ModClassID
where s.SiteID IS NULL and u.userid = @userid
order by u.UserID, s.description, cm.ModClassID, s.ModClassID, gm.SiteID


