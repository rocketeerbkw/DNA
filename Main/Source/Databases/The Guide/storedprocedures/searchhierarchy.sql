create procedure searchhierarchy
						@subjectcondition varchar(8000),
						@siteid int
as

/* various constants for weighting the final score */
declare @SubjectBias char(10)
declare @DefaultMultiplier char(10)
/* change these values for different weightings */
set @SubjectBias = '0.7'
set @DefaultMultiplier = '0.0004'

select * into #results from containstable(Hierarchy, *, @subjectcondition)

select
	h.NodeID, h.UserAdd, h.DisplayName, h.SiteID, h.TreeLevel, s.[KEY],	
	'Rank' = s.rank,
	'Score' = sqrt((0.7 * s.rank) * 0.0004),
	h.Type,
	h.NodeMembers,
	h.RedirectNodeID,
	'RedirectNodeName' = h2.DisplayName
from #results s
	JOIN Hierarchy h WITH(NOLOCK) ON h.NodeID = s.[KEY]
	LEFT JOIN Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = h.RedirectNodeID
	where	h.SiteID = @siteid
UNION ALL
select
	h.NodeID, h.UserAdd, h.DisplayName, h.SiteID, h.TreeLevel, s.[KEY],	
	'Rank' = s.rank,
	'Score' = sqrt((0.7 * s.rank) * 0.0004),
	h.Type,
	h.NodeMembers,
	h.RedirectNodeID,
	'RedirectNodeName' = h2.DisplayName
	FROM #results s JOIN Ancestors a WITH(NOLOCK) on a.NodeID = s.[KEY]
	JOIN Hierarchy h WITH(NOLOCK) ON h.NodeID = a.AncestorID
	LEFT JOIN Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = h.RedirectNodeID
	where	h.SiteID = @siteid
	order by  Score desc, s.[KEY], h.TreeLevel
DROP table #results

