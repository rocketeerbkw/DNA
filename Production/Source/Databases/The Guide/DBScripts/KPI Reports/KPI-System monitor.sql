use dnamonitoring

--select distinct kpiname
--from KPIsHistory

--select distinct appname
--from KPIsHistory

declare @mindate datetime
declare @maxdate datetime

set @mindate ='20120301'
set @maxdate ='20120401'

select appname, AVG(KPIValue) as 'AverageRequestTime'
from KPIsHistory
where dt > @mindate and dt < @maxdate
and KPIName='AverageRequestTime'
and DATEPART(hh, dt) <> 3
group by appname

select appname, sum(KPIValue) as 'RawRequests'
from KPIsHistory
where dt > @mindate and dt < @maxdate
and KPIName='RawRequests'
--and KPIValue < 10000
group by appname


select appname, sum(KPIValue) as 'ServerTooBusyCount'
from KPIsHistory
where dt > @mindate and dt < @maxdate
and KPIName='ServerTooBusyCount'
--and KPIValue < 10000
group by appname

