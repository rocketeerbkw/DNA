exec AddAppOid 'DNA-RipleyServer','1.3.6.1.4.1.2333.3.2.144'
exec AddAppOid 'DNA-BBC.DNA','1.3.6.1.4.1.2333.3.2.148'
exec AddAppOid 'DNA-API-Comments','1.3.6.1.4.1.2333.3.2.149'
exec AddAppOid 'DNA-EventsService','1.3.6.1.4.1.2333.3.2.150'

exec AddKPIConfig 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur2', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-RipleyServer', 'narthur3', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-BBC.DNA', 'narthur1', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur2', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-BBC.DNA', 'narthur3', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'

exec AddKPIConfig 'DNA-API-Comments', 'narthur8', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur9', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'
exec AddKPIConfig 'DNA-API-Comments', 'narthur10', 'AverageResponseTime','GAUGE', 'http://www.bbc.co.uk','ms'

exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','debug',null,null
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','info',null,null
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','warning',null,null
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','error',null,null
exec ChangeKPIThresholds 'DNA-RipleyServer', 'narthur1', 'AverageResponseTime','critical',null,null
