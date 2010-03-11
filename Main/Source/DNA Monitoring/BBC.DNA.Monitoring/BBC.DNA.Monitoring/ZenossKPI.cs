using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.DNA.Monitoring
{
    public class ZenossKPI
    {
        string _appOid;
        string _oid;
        string _appName;
        string _serverName;
        string _KPIName;
        int    _KPIValue;
        string _KPIType;
        string _url;
        string _yTitle;
        int _ttl;

        List<ZenossKPIThreshold> _zenossKPIThresholdList = new List<ZenossKPIThreshold>();

        public string AppOid     { get { return _appOid; } set { _appOid = value; } }
        public string Oid        { get { return _oid; } set { _oid = value; } }
        public string AppName    { get { return _appName; } set { _appName = value; } }
        public string ServerName { get { return _serverName; } set { _serverName = value; } }
        public string KPIName    { get { return _KPIName; }    set { _KPIName = value; } }
        public int    KPIValue   { get { return _KPIValue; }   set { _KPIValue = value; } }
        public string KPIType    { get { return _KPIType; }    set { _KPIType = value; } }
        public string Url        { get { return _url; }        set { _url = value; } }
        public string YTitle     { get { return _yTitle; } set { _yTitle = value; } }
        public int    Ttl        { get { return _ttl; } set { _ttl = value; } }

        public List<ZenossKPIThreshold> ZenossKPIThresholdList { get { return _zenossKPIThresholdList; } }

        public string ZKPIName { get { return _serverName + "-" + _KPIName; } }

        public string GenerateZenossLogLine()
        {
            string logLine = "";

            logLine += Oid;
            logLine +=" STRING ";
            logLine +="value=" + KPIValue.ToString();
            logLine +="|valueType=" + KPIType;
            logLine +="|kpiName=" + ZKPIName;
            logLine +="|appName=" + AppName;
            logLine +="|url=" + Url;
            logLine +="|yTitle=" + YTitle;
            logLine +="|ttl=" + Ttl;

            foreach (ZenossKPIThreshold zt in ZenossKPIThresholdList)
            {
                logLine +="|" + zt.Name + "=" + zt.Threshold.ToString();
            }

            return logLine;
        }
    }
}
