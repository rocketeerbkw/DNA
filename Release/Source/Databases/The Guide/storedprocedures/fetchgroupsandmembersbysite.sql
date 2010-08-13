-- Fetch all groups and members
-- James Pullicino
-- 08/04/05
create procedure fetchgroupsandmembersbysite
as
select gm.siteid, gm.groupid, g.name, gm.userid
from groupmembers gm WITH(NOLOCK)
inner join groups g WITH(NOLOCK) on g.groupid = gm.groupid
WHERE gm.UserID IS NOT NULL AND gm.groupID IS NOT NULL AND gm.SiteID IS NOT NULL
order by gm.siteid, gm.userid, gm.groupid
