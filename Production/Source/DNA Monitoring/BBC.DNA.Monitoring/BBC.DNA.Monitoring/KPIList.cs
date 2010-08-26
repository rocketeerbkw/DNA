using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.DNA.Monitoring
{
    public class KPIList
    {
        public KPIList(string appName, string serverName) { _appName = appName;  _serverName = serverName; }

        private string _serverName;
        private string _appName;
        private List<KPI> _listOfKPIs = new List<KPI>();

        public List<KPI> ListOfKPIs { get { return _listOfKPIs; } }
        public string ServerName { get { return _serverName; } }
        public string AppName { get { return _appName; } }

        public KPI FindKpiByName(string name)
        {
            foreach (KPI kpi in _listOfKPIs)
            {
                if (kpi.KPIName.Equals(name))
                    return kpi;
            }

            return null;
        }
    }
}
