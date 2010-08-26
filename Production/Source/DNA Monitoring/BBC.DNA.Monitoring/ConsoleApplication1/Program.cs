using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.DNA.Monitoring;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            DNAMonitoring dm = new DNAMonitoring();

            KPIList l = dm.GetBbcDnaStatsKPIs("narthur11");

            var zkl = new ZenossKPIList();
            foreach (var k in l.ListOfKPIs)
            {
                var z = new ZenossKPI();
                z.AppName = "";

            }
        }
    }
}
