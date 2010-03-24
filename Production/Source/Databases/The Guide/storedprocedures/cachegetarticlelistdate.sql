CREATE PROCEDURE cachegetarticlelistdate @userid int, @siteid int = 0
As
select 'seconds' = DATEDIFF(second, MAX(LastUpdated), getdate()) FROM GuideEntries g WITH(NOLOCK, INDEX=PK_GuideEntries) INNER JOIN Researchers r WITH(NOLOCK) ON r.EntryID = g.EntryID
WHERE (r.UserID = @userid)
AND (@siteid = g.SiteID OR @siteid = 0)
UNION
select 'seconds' = DATEDIFF(second, MAX(LastUpdated), getdate()) FROM GuideEntries g WITH(NOLOCK)
WHERE (g.Editor = @userid)
AND (@siteid = g.SiteID OR @siteid = 0)
order by seconds