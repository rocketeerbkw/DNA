using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.DNA.Monitoring
{
    public class ZenossKPIThreshold
    {
        string _name;
        int _threshold;

        public string Name   { get { return _name; }      set { _name = value;  } }
        public int Threshold { get { return _threshold; } set { _threshold = value;  } }
    }
}
