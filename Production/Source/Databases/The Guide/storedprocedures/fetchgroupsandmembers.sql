-- Fetch all groups and members
-- James Pullicino
-- 08/04/05
create procedure fetchgroupsandmembers
as
select gm.siteid, gm.groupid, g.name, gm.userid
from groupmembers gm WITH(NOLOCK)
inner join groups g WITH(NOLOCK) on g.groupid = gm.groupid
order by gm.userid, gm.siteid
