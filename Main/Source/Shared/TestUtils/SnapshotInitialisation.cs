using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Configuration;
using System.Text;


namespace Tests
{
    /// <summary>
    /// 
    /// </summary>
    public sealed class SnapshotInitialisation : IDisposable
    {
        //static SnapshotInitialisation sngleton = new SnapshotInitialisation();

        /// <summary>
        /// 
        /// </summary>

        public SnapshotInitialisation()
        {
            //System.Diagnostics.Debugger.Break();
            //System.Diagnostics.EventLog evlog = new System.Diagnostics.EventLog();
            //evlog.WriteEntry("Initialised");
        }

        private static bool _hasRestored = false;

        /// <summary>
        /// 
        /// </summary>
        public void Dispose()
        { }

        public static void RestoreFromSnapshot()
        {
            RestoreFromSnapshot(true);
        }
        /// <summary>
        /// Restores Small Guide From SnapShot.
        /// </summary>
        public static void RestoreFromSnapshot(bool clearConnections)
        {
            if (_hasRestored)
            {
                return;
            }
            //Execute Restore from snapshot.
            ForceRestore(clearConnections);

            //System.Diagnostics.EventLog evlog = new System.Diagnostics.EventLog();
            //evlog.WriteEntry("Dispose");
            //System.Diagnostics.Debugger.Break();
        }

        public static void ForceRestore()
        {
            ForceRestore(true);
        }

        /// <summary>
        /// This static method will force a snapshot restore. Do not call this method as a matter of course - 
        /// only call it if your test absolutely requires that the database be restored from the snapshot.
        /// Consider rewriting your test to not require this restore (because a restore takes time, which causes 
        /// tests to run longer).
        /// In most cases, you don't need to call this method because the test input context and the URL test object
        /// will call it for you. Those will call the one-off RestoreFromSnapshot method instead.
        /// </summary>
        public static void ForceRestore(bool clearConnections)
        {
            try
            {
                Console.WriteLine("FORCE RESTORE");

                //get smallguide names
                string smallGuideName = "smallguide";
                string smallGuideSSName = "smallguideSS";

                if (!String.IsNullOrEmpty(ConfigurationManager.AppSettings["smallguideName"]))
                {
                    smallGuideName = ConfigurationManager.AppSettings["smallguideName"];
                }

                if (!String.IsNullOrEmpty(ConfigurationManager.AppSettings["smallguideSSName"]))
                {
                    smallGuideSSName = ConfigurationManager.AppSettings["smallguideSSName"];
                }

                //Use admin account for restoring small guide - get admin account for Web.Config ( alsoo used for creating dynamic lists)
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();

                TestConfig config = TestConfig.GetConfig();
                doc.Load(config.GetRipleyServerPath() + @"\Web.Config");

                System.Xml.XmlNamespaceManager nsMgr = new System.Xml.XmlNamespaceManager(doc.NameTable);
                nsMgr.AddNamespace("microsoft", @"http://schemas.microsoft.com/.NetConfiguration/v2.0");

                System.Xml.XmlNode node = doc.SelectSingleNode(@"/configuration/connectionStrings/add[@name='updateSP']", nsMgr);
                if (node == null)
                {
                    Assert.Fail("Unable to read updateSP connnection string from Web.Config");
                }

                string updateSpConnString = node.Attributes["connectionString"].Value;



                // Check to make sure there are no connection on the small guide database
                bool noConnections = false;
                int tries = 0;
                DateTime start = DateTime.Now;
                Console.Write("Checking for connections on small guide -");

                // Keep checking while there's connections and we tried less than 24 times. We sleep for 5 seconds
                // in between each check. A total of 2 minutes before giving up.
                while (!noConnections && tries++ <= 24)
                {
                    using (IDnaDataReader reader = StoredProcedureReader.Create("", updateSpConnString))
                    {
                        string sql = "USE Master; SELECT 'count' = COUNT(*) FROM sys.sysprocesses sp INNER JOIN sys.databases db ON db.database_id = sp.dbid WHERE db.name = '" + smallGuideName + "' AND sp.SPID >= 50";
                        reader.ExecuteDEBUGONLY(sql);

                        if (reader.Read())
                        {
                            noConnections = (reader.GetInt32NullAsZero("count") == 0);
                        }

                        if (!noConnections)
                        {
                            if (clearConnections)
                            {
                                string clearConSql = @"ALTER DATABASE " + smallGuideName + @" SET OFFLINE WITH ROLLBACK IMMEDIATE;" +
                                                     @"ALTER DATABASE " + smallGuideName + @" SET ONLINE;";
                                reader.ExecuteDEBUGONLY(clearConSql);
                            }
                            else
                            {
                                // Goto sleep for 5 secs
                                System.Threading.Thread.Sleep(5000);
                                Console.Write("-");
                            }
                        }
                    }
                }

                // Change the tries into seconds and write to the console
                TimeSpan time = DateTime.Now.Subtract(start);
                Console.WriteLine("> waited for " + time.Seconds.ToString() + " seconds.");

                StringBuilder builder = new StringBuilder();
                builder.AppendLine("USE MASTER; ");
                builder.AppendLine("RESTORE DATABASE " + smallGuideName + " FROM DATABASE_SNAPSHOT = '" + smallGuideSSName + "' WITH RECOVERY");

                using (IDnaDataReader reader = StoredProcedureReader.Create("", updateSpConnString))
                {
                    Console.WriteLine(builder);
                    reader.ExecuteDEBUGONLY(builder.ToString());
                }


                Console.WriteLine("Restored SmallGuide from Snapshot successfully.");

                _hasRestored = true;
            }
            catch (Exception e)
            {
                Console.WriteLine("FAILED!!! SmallGuide Snapshot restore." + e.Message);
                Assert.Fail(e.Message);
            }
        }
    }
}
