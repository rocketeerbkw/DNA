CREATE PROCEDURE fetchgroupsforuser @userid int
as
select distinct gm.siteid, gm.groupid, g.name, gm.userid
from groupmembers gm WITH(NOLOCK)
inner join groups g WITH(NOLOCK) on g.groupid = gm.groupid
WHERE gm.userid = @userid
ORDER BY SiteID, GroupID