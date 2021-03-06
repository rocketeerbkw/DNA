create procedure getsiteevents		
									@siteids varchar(6000) = null
									, @typeids varchar(6000) = null
									, @startindex int =0
									, @itemsperpage int = 20
									, @startdate datetime = null
									, @enddate datetime = null
									, @sitetype int =0							

as

-- get types

create table #types (type int)
if @typeids is not null
begin
	INSERT INTO #types	
	SELECT element FROM dbo.udf_splitint(@typeids);
end

-- get sites to return events on
create table #sites (siteid int)
if @siteids is not null
begin

	insert into #sites
	SELECT element FROM dbo.udf_splitint(@siteids);
end

if @sitetype > 0 and @siteids is null
begin

	delete from #sites
	
	insert into #sites
	select siteid from siteoptions where section='General' and name='SiteType' and value=convert(varchar(5), @sitetype)
end

--get events
;WITH CTE_EVENTS AS
(
	SELECT row_number() OVER ( ORDER BY datetime DESC ) AS n, sai.id
	FROM siteactivityitems sai
	where 
		(@siteids is null OR siteid in (select siteid from #sites))
		and (@sitetype =0 or siteid in (select siteid from #sites))
		and (@typeids is null or sai.type in (select type from #types))
		and (@startdate is null or sai.datetime >= @startdate)
		and (@enddate is null or sai.datetime < @enddate)
		
),
CTE_TOTAL AS
(
	SELECT (SELECT CAST(MAX(n) AS INT) FROM CTE_EVENTS) AS 'total', * FROM CTE_EVENTS
)
select sai.datetime, sai.siteid, sai.type, cte.total, cte.n, sai.activitydata
from CTE_TOTAL cte
inner join siteactivityitems sai on cte.id = sai.id
where 
	n > @startindex and n <= @startindex + @itemsperpage
ORDER BY n

drop table #sites
drop table #types