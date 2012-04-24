use newguide

--select distinct kpiname
--from KPIsHistory

--select distinct appname
--from KPIsHistory

declare @mindate datetime
declare @maxdate datetime

set @mindate ='20111101'
set @maxdate ='20111201'

select count(*) as 'total posts'
from threadentries
where dateposted >= @mindate and dateposted < @maxdate

select count(*) as 'total failed'
from threadmod
where datecompleted >= @mindate and datecompleted < @maxdate
and status <> 3

select count(*) as 'new users'
from users
where datejoined >= @mindate and datejoined < @maxdate

select count(*) as 'moderation decisions'
from threadmod
where datecompleted >= @mindate and datecompleted < @maxdate


select count(distinct(userid)) as 'distinct users'
from threadentries
where dateposted >= @mindate and dateposted < @maxdate


