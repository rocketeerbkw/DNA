exec AddKPIConfig 'DNA-RipleyServeraa', 'narthur1', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
--delete from KPIConfig where appname = 'DNA-RipleyServeraa'

exec AddKPIConfig 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur2', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur3', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-BBC.DNA', 'narthur1', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur2', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur3', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-API-Comments', 'narthur8', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur9', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur10', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'

select * from KPIConfig

exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','debug',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','info',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','warning',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','error',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','critical',null,null
select * from KPIConfig

exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','debug',3,4
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','info',5,6
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','warning',7,8
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','error',9,10
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','critical',11,12
select * from KPIConfig

exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','debug',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','info',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','warning',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','error',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','critical',null,null
select * from KPIConfig

exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','debug',30,40
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','info',null,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','warning',null,80
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','error',1,null
select * from KPIConfig
exec ChangeKPIThresholds 'DNA-RipleyServer', null, 'AverageResponseTime','critical',110,120
select * from KPIConfig


select * from kpis order by dt desc
select * from kpisHistory order by dt desc
select * from kpiConfig
exec GetLatestKPIs


declare @n int=1
while @n < 1000
begin
	insert kpis select DATEADD(hh,-1,dt) dt,AppName, ServerName, KPIName, KPIValue
	from kpis
	where dt = (select MIN(dt) from kpis)
	set @n+=1
end



