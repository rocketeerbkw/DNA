using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.DNA.Monitoring
{
    public class KPI
    {
        private string      _KPIName;
        private int         _KPIValue;
        private DateTime    _dt;

        public string KPIName { get { return _KPIName; }   set { _KPIName = value;  } }
        public int KPIValue { get { return _KPIValue; } set { _KPIValue = value; } }
        public DateTime Dt { get { return _dt; } set { _dt = value; } }
    }
}
