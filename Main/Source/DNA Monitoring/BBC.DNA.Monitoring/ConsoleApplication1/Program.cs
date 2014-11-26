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
            DNAMonitoringOnAzure dm = new DNAMonitoringOnAzure();
            KPIList l = dm.GetBbcDnaStatsKPIs("ServerOnAzure",
                                                "http://www.bbc.co.uk/dna/moderation/status-n?s_disp=stats&interval=5&skin=purexml",
                                                "DNA-BBCDNA",
                                                "C:\\DebugLogs");
            var zkl = new ZenossKPIList();
            foreach (var k in l.ListOfKPIs)
            {
                var z = new ZenossKPI();
                z.AppName = "";
            }
        }
    }
}
