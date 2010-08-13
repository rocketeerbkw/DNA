using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Xml;

namespace BBC.DNA.Monitoring
{
    public class DNAMonitoring
    {
        string _ripleyServerStatsUrlFormat = "http://www.bbc.co.uk/h2g2/servers/{0}/h2g2/plain/status?s_disp=stats&interval=60&skin=purexml";
        string _bbcDnaStatsUrlFormat       = "http://www.bbc.co.uk/h2g2/servers/{0}/h2g2/plain/status-n?s_disp=stats&interval=5&skin=purexml";
        string _apiCommentsStatsUrlFormat  = "http://www.bbc.co.uk/h2g2/servers/{0}/api/comments/status.aspx?interval=60&skin=purexml";

        string _ripleyServerAppName = "DNA-RipleyServer";
        string _bbcDnaAppName = "DNA-BBCDNA";
        string _apiCommentsAppName = "DNA-API-Comments";

        public KPIList GetApiCommentsStatsKPIs(string serverName)
        {
            XmlDocument xml = GetStatsXmlFromUrl(_apiCommentsStatsUrlFormat, serverName);
            return GenerateKPIListFromStatsXml(xml, _apiCommentsAppName, serverName);
        }

        public KPIList GetBbcDnaStatsKPIs(string serverName)
        {
            XmlDocument xml = GetStatsXmlFromUrl(_bbcDnaStatsUrlFormat, serverName);
            return GenerateKPIListFromStatsXml(xml, _bbcDnaAppName, serverName);
        }

        public KPIList GetRipleyServerStatsKPIs(string serverName)
        {
            XmlDocument xml = GetStatsXmlFromUrl(_ripleyServerStatsUrlFormat,serverName);
            return GenerateKPIListFromStatsXml(xml, _ripleyServerAppName, serverName);
        }

        KPIList GenerateKPIListFromStatsXml(XmlDocument statsXml, string appName, string serverName)
        {
            KPIList kpiList = new KPIList(appName, serverName);

            if (statsXml != null)
            {
                string currentHour = statsXml.SelectSingleNode("//STATUS-REPORT/STATISTICS/CURRENTDATE/DATE/@HOURS").InnerText;
                XmlNode statisticsDataNode = statsXml.SelectSingleNode("//STATUS-REPORT/STATISTICS/STATISTICSDATA[@INTERVALSTARTTIME='" + currentHour + ":00']");


                kpiList.ListOfKPIs.Add(ExtractStatsValue(statisticsDataNode, "AVERAGEREQUESTTIME", "AverageRequestTime"));
                kpiList.ListOfKPIs.Add(ExtractStatsValue(statisticsDataNode, "SERVERBUSYCOUNT", "ServerTooBusyCount"));
                kpiList.ListOfKPIs.Add(ExtractStatsValue(statisticsDataNode, "RAWREQUESTS", "RawRequests"));

                kpiList.ListOfKPIs.Add(CreateServerTooBusyPctKpi(kpiList));
            }

            return kpiList;
        }

        private KPI CreateServerTooBusyPctKpi(KPIList kpiList)
        {
            KPI stbPct = new KPI();
            stbPct.KPIName = "ServerTooBusyPct";
            stbPct.Dt = DateTime.UtcNow;

            KPI stb = kpiList.FindKpiByName("ServerTooBusyCount");
            KPI rr = kpiList.FindKpiByName("RawRequests");

            if (rr.KPIValue > 0)
            {
                stbPct.KPIValue = (stb.KPIValue * 100) / rr.KPIValue;
            }
            else
            {
                stbPct.KPIValue = 0;
            }

            return stbPct;
        }

        KPI ExtractStatsValue(XmlNode n, string nodeName, string KPIName)
        {
            KPI kpi = new KPI();
            kpi.KPIName = KPIName;
            kpi.KPIValue = int.Parse(n.SelectSingleNode(nodeName).InnerText);
            kpi.Dt = DateTime.UtcNow;

            return kpi;
        }

        XmlDocument GetStatsXmlFromUrl(string format,string serverName)
        {
            try
            {
                string url = string.Format(format, serverName);

                HttpWebRequest req = GetWebRequest(url);

                WebResponse resp = req.GetResponse();
                Stream respStream = resp.GetResponseStream();
                StreamReader sreader = new StreamReader(respStream);
                string xmlfile = sreader.ReadToEnd();
                sreader.Close();
                resp.Close();

                XmlDocument statsXml = new XmlDocument();
                statsXml.LoadXml(xmlfile);

                return statsXml;
            }
            catch (System.Net.WebException we)
            {
                return null;
            }
        }

        HttpWebRequest GetWebRequest(string sURL)
        {
            Uri URL = new Uri(sURL);
            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(URL);

            string Proxy = "gatef-rth.mh.bbc.co.uk";
            string Port = "80";
            WebProxy myProxy = new WebProxy("http://" + Proxy + ":" + Port);
            wr.Proxy = myProxy;

            //wr.CookieContainer = cContainer;
            wr.PreAuthenticate = true;
            return wr;
        }

        /*
        void WriteKPIsToLogFile(KPIList kpis, string logFolder)
        {
            DateTime n = DateTime.Now;

            string date = string.Format("{0}-{1}-{2}-{3}-{4}", n.Year, n.Month, n.Hour, n.Minute, n.Second);
            string fileName = string.Format(@"{0}\{1}-{2}-{3}.txt",logFolder,_logFilePrefix,kpis.serverName,date);

            StreamWriter sw = new StreamWriter(fileName);

            foreach (KPI k in kpis.listOfKPIs)
            {
                sw.WriteLine(k.KPIName+" : "+k.KPIValue);
            }
            sw.Close();
        }
        */
    }
}
