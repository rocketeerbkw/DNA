CREATE PROCEDURE fetchgroupsforuser @userid int
as
select distinct gm.siteid, gm.groupid, g.name, gm.userid
from groupmembers gm WITH(NOLOCK)
inner join groups g WITH(NOLOCK) on g.groupid = gm.groupid
WHERE gm.userid = @userid
ORDER BY SiteID, GroupID
OPTION(OPTIMIZE FOR (@userid=0)) -- optimize for the common case - most users do not belong to any groups
