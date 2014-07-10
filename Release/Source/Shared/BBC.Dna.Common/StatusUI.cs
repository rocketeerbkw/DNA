using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Text;
using System.Reflection;
using System.IO;
using System.Drawing;

namespace BBC.Dna.Common
{
    public class StatusUI
    {
        public XmlDocument OutputXML(int interval, Page page, IDnaDiagnostics diagnostics)
        {
            XmlDocument xDoc = new XmlDocument();
            XmlNode xmlEl = xDoc.AppendChild(xDoc.CreateElement("H2G2"));
            xmlEl.Attributes.Append(xDoc.CreateAttribute("TYPE"));
            xmlEl.Attributes["TYPE"].InnerText = "STATUSPAGE";
            xmlEl = xmlEl.AppendChild(xDoc.CreateElement("STATUS-REPORT"));
            xmlEl.AppendChild(xDoc.ImportNode(Statistics.CreateStatisticsDocument(interval).FirstChild, true));

            XmlDocument xmlSignal = new XmlDocument();
            xmlSignal.LoadXml(StringUtils.SerializeToXmlUsingXmlSerialiser(SignalHelper.GetStatus(diagnostics)));
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

            return xDoc;
        }

        public void OutputHTML(int interval, ref Label lblHostName, string hostName, ref Table tblStats)
        {
            lblHostName.Text = hostName;

            XmlDocument xStats = Statistics.CreateStatisticsDocument(interval);
            XmlNodeList nodeList = xStats.SelectNodes("/STATISTICS/STATISTICSDATA");
            bool headerAdded = false;
            DateTime currentTime = DateTime.Now;

            //for (int i = 0; i < nodeList.Count; i++)
            foreach (XmlNode node in nodeList)
            {
                TableRow row = null;
                TableCell cell = null;
                if (!headerAdded)
                {
                    CreateHeaderRow(node, ref tblStats, ref row, ref cell);
                    headerAdded = true;
                }

                row = new TableRow();
                cell = new TableCell();
                cell.Style.Add("font-weight", "bold");
                cell.Text = node.Attributes["INTERVALSTARTTIME"].InnerText;
                row.Cells.Add(cell);
                string[] hourMinutes = cell.Text.Split(':');
                DateTime statTime = DateTime.Today + TimeSpan.FromHours(double.Parse(hourMinutes[0])) + TimeSpan.FromMinutes(double.Parse(hourMinutes[1]));
                if (currentTime >= statTime && currentTime < statTime.AddMinutes(interval))
                {
                    row.Font.Bold = true;
                    row.Font.Italic = true;
                    row.BackColor = Color.FromArgb(220, 255, 220);
                }

                foreach (XmlElement el in node.ChildNodes)
                {
                    if (!el.Name.StartsWith("RSS") && !el.Name.StartsWith("HTML") && !el.Name.StartsWith("SSI"))
                    {
                        cell = new TableCell();
                        cell.Text = el.InnerText;
                        cell.HorizontalAlign = HorizontalAlign.Center;
                        row.Cells.Add(cell);
                    }
                }
                tblStats.Rows.Add(row);
            }

        }

        public void AddFileinfo(ref Label lbFileInfo)
        {
            StringBuilder info = new StringBuilder();
            foreach (Attribute attr in Assembly.GetExecutingAssembly().GetCustomAttributes(false))
            {
                if (attr.GetType() == typeof(AssemblyFileVersionAttribute))
                {
                    info.AppendLine("File Version : " + ((AssemblyFileVersionAttribute)attr).Version + "<br/>");
                }
            }

            string loc = Assembly.GetExecutingAssembly().Location;
            DateTime creationTime = File.GetCreationTime(loc);
            DateTime lastAccessTime = File.GetLastAccessTime(loc);
            DateTime lastWriteTime = File.GetLastWriteTime(loc);

            info.AppendLine("Created : " + creationTime.ToString() + "<br/>");
            info.AppendLine("Last Accessed : " + lastAccessTime.ToString() + "<br/>");
            info.AppendLine("Last Written : " + lastWriteTime.ToString() + "<br/>");
            lbFileInfo.Text = info.ToString();
        }

        private void CreateHeaderRow(XmlNode node, ref Table tblStats, ref TableRow row, ref TableCell cell)
        {
            //add header row
            row = new TableRow();
            cell = new TableCell();
            cell.HorizontalAlign = HorizontalAlign.Center;
            cell.Style.Add("font-weight", "bold");
            cell.Text = "TIME";
            row.Cells.Add(cell);

            foreach (XmlElement el in node.ChildNodes)
            {
                if (!el.Name.StartsWith("RSS") && !el.Name.StartsWith("HTML") && !el.Name.StartsWith("SSI"))
                {
                    cell = new TableCell();
                    cell.Text = el.Name;
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    cell.Style.Add("font-weight", "bold");
                    cell.Text = cell.Text.Replace("CACHE", "CACHE ").Replace("SERVER", "SERVER ").Replace("REQUESTS", " REQUESTS").Replace("REQUEST", " REQUEST");
                    row.Cells.Add(cell);
                }
            }
            tblStats.Rows.Add(row);
        }

        public void AddDatabaseVersion(IDnaDataReaderCreator readerCreator, ref Label lbDatabaseVersion)
        {
            var databaseVersion = DatabaseVersion.GetDatabaseVersion(readerCreator);
            lbDatabaseVersion.Text = "Database version : "+databaseVersion;
        }
    }
}
