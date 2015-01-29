using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Xml;
using System.Diagnostics;

namespace BBC.DNA.Monitoring
{
    public class DNAMonitoringOnAzure
    {
        public KPIList GetApiCommentsStatsKPIs(string serverName, string apiCommentsStatsUrl, string apiCommentsAppName, string logFolder)
        {
            string[] results = GetStatsResultsFromUrl(apiCommentsStatsUrl);
            return GenerateKPIListFromStatsResults(results, apiCommentsAppName, serverName, logFolder);
        }

        public KPIList GetBbcDnaStatsKPIs(string serverName, string bbcDnaStatsUrl, string bbcDnaAppName, string logFolder)
        {
            string[] results = GetStatsResultsFromUrl(bbcDnaStatsUrl);
            return GenerateKPIListFromStatsResults(results, bbcDnaAppName, serverName, logFolder);
        }

        public KPIList GetRipleyServerStatsKPIs(string serverName, string ripleyServerStatsUrl, string ripleyServerAppName, string logFolder)
        {
            string[] results = GetStatsResultsFromUrl(ripleyServerStatsUrl);
            return GenerateKPIListFromStatsResults(results, ripleyServerAppName, serverName, logFolder);
        }

        KPIList GenerateKPIListFromStatsResults(string[] statsResults, string appName, string serverName, string logFolder)
        {
            KPIList kpiList = new KPIList(appName, serverName);

            kpiList.ListOfKPIs.Add(ExtractStatsValue(statsResults[0]));
            kpiList.ListOfKPIs.Add(ExtractStatsValue(statsResults[1]));

            //WriteKPIsToLogFile(kpiList, logFolder); //Uncomment when Debugging

            return kpiList;
        }

        KPI ExtractStatsValue(string strStats)
        {
            KPI kpi = new KPI();
            string[] statsArr = strStats.Split(':');

            kpi.KPIName = statsArr[0];
            kpi.KPIValue = int.Parse(statsArr[1]);
            kpi.Dt = DateTime.UtcNow;

            return kpi;
        }

        String[] GetStatsResultsFromUrl(string url)
        {
            string[] results = new string[2];
            TimeSpan timeTaken;

            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();

            try
            {
                HttpWebRequest req = GetWebRequest(url);
                WebResponse resp = req.GetResponse();
                Stream respStream = resp.GetResponseStream();
                StreamReader sreader = new StreamReader(respStream);
                string xmlfile = sreader.ReadToEnd();
                sreader.Close();
                resp.Close();

                stopWatch.Stop();
                //Non200Responses
                results[0] = "Non200Responses:0";
            }
            catch (System.Net.WebException webExc)
            {
                stopWatch.Stop();
                //Non200Responses
                results[0] = "Non200Responses:" + ((int)((HttpWebResponse)webExc.Response).StatusCode).ToString();
            }

            timeTaken = stopWatch.Elapsed;
            //ResponseTime in Milliseconds            
            results[1] = "ResponseTime:" + Math.Round(timeTaken.TotalMilliseconds).ToString();

            return results;
        }

        HttpWebRequest GetWebRequest(string sURL)
        {
            Uri URL = new Uri(sURL);
            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(URL);

            string Proxy = "gatef-rth.mh.bbc.co.uk";
            string Port = "80";
            WebProxy myProxy = new WebProxy("http://" + Proxy + ":" + Port);
            wr.Proxy = myProxy;

            wr.Timeout = 8000; //force a result to be returned if URL makes us wait more than 8 seconds
            wr.PreAuthenticate = true;
            return wr;
        }

        void WriteKPIsToLogFile(KPIList kpis, string logFolder)
        {
            DateTime n = DateTime.Now;

            string date = string.Format("{0}-{1}-{2}-{3}-{4}", n.Year, n.Month, n.Hour, n.Minute, n.Second);
            string fileName = string.Format(@"{0}\{1}-{2}.txt", logFolder, kpis.ServerName, date);

            StreamWriter sw = new StreamWriter(fileName);

            foreach (KPI k in kpis.ListOfKPIs)
            {
                sw.WriteLine(k.KPIName + " : " + k.KPIValue);
            }
            sw.Close();
        }
    }
}
