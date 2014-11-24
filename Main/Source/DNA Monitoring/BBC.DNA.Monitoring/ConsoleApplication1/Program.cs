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
            //Code called when resources existed on ATOS Content N\W
            //DNAMonitoring dm = new DNAMonitoring();
            //KPIList l = dm.GetBbcDnaStatsKPIs("narthur11");
            //var zkl = new ZenossKPIList();
            //foreach (var k in l.ListOfKPIs)
            //{
            //    var z = new ZenossKPI();
            //    z.AppName = "";
            //}

            //Code called when resources exist on Azure
            DNAMonitoringOnAzure dm = new DNAMonitoringOnAzure();
            KPIList l = dm.GetBbcDnaStatsKPIs("ServerOnAzure");
            var zkl = new ZenossKPIList();
            foreach (var k in l.ListOfKPIs)
            {
                var z = new ZenossKPI();
                z.AppName = "";
            }
        }
    }
}
