select percent_complete,datediff(mi,start_time,getdate()) minsTakenSoFar
,case when percent_complete > 0 then dateadd(ss,datediff(ss,start_time,getdate())/(percent_complete/100),start_time) end estTimeToComplete
,* 
from sys.dm_exec_requests 
where command like '%backup%' or  command like '%restore%'
