using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.IO;
using System.Reflection;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Common;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna
{
    /// <summary>
    /// ********************************
    /// </summary>
    public class Status : DnaInputComponent
    {
        /// <summary>
        /// *********************************************
        /// </summary>
        /// <param name="context"></param>
        public Status(IInputContext context) : base(context)
        {
        }

        /// <summary>
        /// Handle request to put the Status object in the page
        /// </summary>
        public override void ProcessRequest()
        {
            RootElement.RemoveAll();
            int interval = InputContext.GetParamIntOrZero("interval", "Time interval to show statistics data, in minutes. Default is 60.");
            if (interval <= 0 || interval >= 60)
            {
                interval = 60;
            }
            XmlDocument doc = Statistics.CreateStatisticsDocument(interval);
            XmlNode reportnode = AddWholeDocument(RootElement, "STATUS-REPORT", doc);

            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("isdatabaserunning"))
            {
                reader.Execute();
                if (reader.HasRows)
                {
                    AddTextTag(reportnode, "STATUS", "OK");

                    foreach (Attribute attr in Assembly.GetExecutingAssembly().GetCustomAttributes(false))
                    {
                        if (attr.GetType() == typeof(AssemblyFileVersionAttribute))
                        {
                            AddTextTag(reportnode, "FILEVERSION", ((AssemblyFileVersionAttribute)attr).Version);
                        }
                    }

                    string loc = Assembly.GetExecutingAssembly().Location;
                    DateTime creationTime = File.GetCreationTime(loc);
                    DateTime lastAccessTime = File.GetLastAccessTime(loc);
                    DateTime lastWriteTime = File.GetLastWriteTime(loc);

                    AddTextTag(reportnode, "FILECREATED", creationTime.ToString());
                    AddTextTag(reportnode, "FILELASTACCESSED", lastAccessTime.ToString());
                    AddTextTag(reportnode, "FILELASTWRITTEN", lastWriteTime.ToString());

                    string message = string.Format("DNA is up and running on {0}", InputContext.CurrentServerName);
                    AddTextTag(reportnode, "MESSAGE", message);

                    SerialiseAndAppend(SignalHelper.GetStatus(InputContext.Diagnostics), "/DNAROOT/STATUS-REPORT");

                    try
                    {
                        var memcachedCacheManager = (MemcachedCacheManager)CacheFactory.GetCacheManager("Memcached");
                        ImportAndAppend(memcachedCacheManager.GetStatsXml(), "/DNAROOT/STATUS-REPORT");
                    }
                    catch(Exception e) 
                    {
                        AddTextTag(reportnode, "MEMCACHED_STATUS", "Error getting memcached stats:" + e.Message);
                    }
                }
            }
        }
    }
}
