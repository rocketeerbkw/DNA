/*
exec AddAppOid 'DNA-RipleyServer','1.3.6.1.4.1.2333.3.2.144'
exec AddAppOid 'DNA-BBC.DNA','1.3.6.1.4.1.2333.3.2.148'
exec AddAppOid 'DNA-API-Comments','1.3.6.1.4.1.2333.3.2.149'
exec AddAppOid 'DNA-EventsService','1.3.6.1.4.1.2333.3.2.150'
*/
-------------------------------------- AverageRequestTime
exec AddKPIConfig 'DNA-RipleyServer', 'narthur1', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur2', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur3', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur4', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur8', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur9', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur10', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur11', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur12', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur13', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur14', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur15', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-BBC.DNA', 'narthur1', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur2', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur3', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur4', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur8', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur9', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur10', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur11', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur12', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur13', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur14', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur15', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-API-Comments', 'narthur1', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur2', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur3', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur4', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur8', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur9', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur10', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur11', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur12', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur13', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur14', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur15', 'AverageRequestTime','GAUGE', 'http://www.bbc.co.uk','ms'

-------------------------------------- ServerTooBusyCount
exec AddKPIConfig 'DNA-RipleyServer', 'narthur1', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur2', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur3', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur4', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur8', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur9', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur10', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur11', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur12', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur13', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur14', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur15', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-BBC.DNA', 'narthur1', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur2', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur3', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur4', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur8', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur9', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur10', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur11', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur12', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur13', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur14', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur15', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-API-Comments', 'narthur1', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur2', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur3', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur4', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur8', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur9', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur10', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur11', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur12', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur13', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur14', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur15', 'ServerTooBusyCount','GAUGE', 'http://www.bbc.co.uk','ms'

-------------------------------------- RawRequests
exec AddKPIConfig 'DNA-RipleyServer', 'narthur1', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur2', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur3', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur4', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur8', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur9', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur10', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur11', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur12', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur13', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur14', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur15', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-BBC.DNA', 'narthur1', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur2', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur3', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur4', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur8', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur9', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur10', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur11', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur12', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur13', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur14', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur15', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-API-Comments', 'narthur1', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur2', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur3', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur4', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur8', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur9', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur10', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur11', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur12', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur13', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur14', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur15', 'RawRequests','GAUGE', 'http://www.bbc.co.uk','ms'

/*
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageRequestTime','debug',null,null
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageRequestTime','info',null,null
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageRequestTime','warning',null,null
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageRequestTime','error',null,null
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageRequestTime','critical',null,null
*/