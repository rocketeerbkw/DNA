create procedure getuserevents		
									@modclassid int
									,@userid int
									, @startindex int =0
									, @itemsperpage int = 20
									, @startdate datetime = null
									, @enddate datetime = null

as


--get events
;WITH CTE_EVENTS AS
(
	SELECT row_number() OVER ( ORDER BY eventdate DESC ) AS n, *
	from
	(
		select typeid, eventdate, null as 'activitydata', score, accumulativescore, userid, numberofposts, modclassid
		from UserPostEvents with(nolock)
		where modclassid = @modclassid and userid=@userid

		union all

		select typeid, eventdate, convert(nvarchar(max), se.activitydata) as 'activitydata', score, accumulativescore, userid, 0, modclassid
		from UserSiteEvents uses with(nolock)
		inner join siteactivityitems se on se.id = uses.siteeventid
		where modclassid = @modclassid and userid=@userid
	) events
	where 
		(@startdate is null or eventdate >= @startdate)
		and (@enddate is null or eventdate < @enddate)
		
),
CTE_TOTAL AS
(
	SELECT (SELECT CAST(MAX(n) AS INT) FROM CTE_EVENTS) AS 'total', * FROM CTE_EVENTS
)
select n, total, typeid, eventdate, activitydata, score, accumulativescore, userid, numberofposts, modclassid
from CTE_TOTAL cte
where 
	n > @startindex and n <= @startindex + @itemsperpage
ORDER BY n
