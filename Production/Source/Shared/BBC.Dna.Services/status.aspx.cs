using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Collections;
using BBC.Dna.Common;

namespace BBC.Dna.Services
{
    public class status : System.Web.UI.Page
    {
        protected Label lblHostName;
        protected Label lblmemcachedStats;
        protected Table tblStats;


        protected void Page_Load(object sender, EventArgs e)
        {
            int interval = 60;
            if (!Int32.TryParse(Request.QueryString["interval"], out interval))
            {
                interval = 60;
            }




            if (Request.QueryString["reset"] == "1")
            {
                Statistics.ResetCounters();
            }
            if (Request.QueryString["skin"] == "purexml")
            {
                OutputXML(interval);
            }
            else
            {
                OutputHTML(interval);
            }
        }

        private void OutputXML(int interval)
        {
            XmlDocument xDoc = new XmlDocument();
            XmlNode xmlEl = xDoc.AppendChild(xDoc.CreateElement("H2G2"));
            xmlEl.Attributes.Append(xDoc.CreateAttribute("TYPE"));
            xmlEl.Attributes["TYPE"].InnerText = "STATUSPAGE";
            xmlEl = xmlEl.AppendChild(xDoc.CreateElement("STATUS-REPORT"));
            xmlEl.AppendChild(xDoc.ImportNode(Statistics.CreateStatisticsDocument(interval).FirstChild, true));

            XmlDocument xmlSignal = new XmlDocument();
            xmlSignal.LoadXml(StringUtils.SerializeToXmlUsingXmlSerialiser(SignalHelper.GetStatus(Global.dnaDiagnostics)));
            xmlEl.AppendChild(xDoc.ImportNode(xmlSignal.DocumentElement, true));

            try
            {
                var memcachedCacheManager = (MemcachedCacheManager)CacheFactory.GetCacheManager("Memcached");
                xmlEl.AppendChild(xDoc.ImportNode(memcachedCacheManager.GetStatsXml(), true));
            }
            catch (Exception e)
            {
                var childNode = xmlEl.AppendChild(xDoc.CreateElement("MEMCACHED_STATUS"));
                childNode.InnerText = "Error getting memcached stats:" + e.Message;
            }

            Response.ContentType = "text/xml";
            Response.Clear();
            Response.Write(xDoc.InnerXml);
            Response.End();
        }

        private void OutputHTML(int interval)
        {
            lblHostName.Text = Request.ServerVariables["SERVER_NAME"];

            XmlDocument xStats = Statistics.CreateStatisticsDocument(interval);
            XmlNodeList nodeList = xStats.SelectNodes("/STATISTICS/STATISTICSDATA");
            for (int i = 0; i < nodeList.Count; i++)
            {
                TableRow row = null;
                TableCell cell = null;
                if (i == 0)
                {//add header row
                    row = new TableRow();
                    cell = new TableCell();
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    cell.Style.Add("font-weight", "bold");
                    cell.Text = "TIME";
                    row.Cells.Add(cell);

                    foreach (XmlElement el in nodeList[i].ChildNodes)
                    {
                        cell = new TableCell();
                        cell.Text = el.Name;
                        cell.HorizontalAlign = HorizontalAlign.Center;
                        cell.Style.Add("font-weight", "bold");
                        cell.Text = cell.Text.Replace("CACHE", "CACHE ").Replace("SERVER", "SERVER ").Replace("REQUESTS", " REQUESTS").Replace("REQUEST", " REQUEST");
                        row.Cells.Add(cell);
                    }
                    tblStats.Rows.Add(row);
                }

                row = new TableRow();
                cell = new TableCell();
                cell.Style.Add("font-weight", "bold");
                cell.Text = nodeList[i].Attributes["INTERVALSTARTTIME"].InnerText;
                row.Cells.Add(cell);

                foreach (XmlElement el in nodeList[i].ChildNodes)
                {
                    cell = new TableCell();
                    cell.Text = el.InnerText;
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    row.Cells.Add(cell);
                }
                tblStats.Rows.Add(row);
            }

        }
    }
}
