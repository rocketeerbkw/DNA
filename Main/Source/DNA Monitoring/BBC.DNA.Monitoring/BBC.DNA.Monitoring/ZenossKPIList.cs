using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace BBC.DNA.Monitoring
{
    public class ZenossKPIList
    {
        List<ZenossKPI> _zenossKPIList = new List<ZenossKPI>();

        public void Add(ZenossKPI zkpi) { _zenossKPIList.Add(zkpi); }

        public void ExportAllToFile(string filename)
        {
            using (StreamWriter sw = new StreamWriter(filename))
            {
                foreach (ZenossKPI zkpi in _zenossKPIList)
                {
                    sw.WriteLine(zkpi.GenerateZenossLogLine());
                }
            }
        }

        public void ExportToAppOidFiles(string pathRoot)
        {
            Dictionary<string,StreamWriter> streamWriters = new Dictionary<string,StreamWriter>();

            try
            {
                foreach (ZenossKPI zkpi in _zenossKPIList)
                {
                    if (!streamWriters.ContainsKey(zkpi.AppOid))
                    {
                        StreamWriter newSw = new StreamWriter(Path.Combine(pathRoot, zkpi.AppOid));
                        streamWriters.Add(zkpi.AppOid, newSw);
                    }

                    StreamWriter sw = streamWriters[zkpi.AppOid];

                    sw.WriteLine(zkpi.GenerateZenossLogLine());
                }
            }
            finally
            {
                foreach (StreamWriter sw in streamWriters.Values)
                {
                    sw.Close();
                }
            }
        }
    }
}
