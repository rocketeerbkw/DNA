using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Configuration;
using System.IO;


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

                RestoreDatabase(smallGuideName, smallGuideSSName, updateSpConnString);
            }
            catch (Exception e)
            {
                Console.WriteLine("FAILED!!! SmallGuide Snapshot restore." + e.Message);
                Assert.Fail(e.Message);
            }
        }

        private static void RestoreDatabase(string smallGuideName, string smallGuideSSName, string updateSpConnString)
        {
            var restoreSqlFile = Path.Combine(Environment.CurrentDirectory, "RestoreDatabase.sql");

            var restoreSql = File.ReadAllText(restoreSqlFile);

            var sqlRoot = ConfigurationManager.AppSettings["testserver:sqlDirectoryRoot"];

            if (string.IsNullOrEmpty(sqlRoot)) throw new ConfigurationErrorsException("testserver:sqlDirectoryRoot does not exist");

            sqlRoot = sqlRoot.EndsWith("\\") ? sqlRoot : sqlRoot + "\\";

            var exectueSql = restoreSql.Replace("[SQLROOT]", sqlRoot);

            var masterConnectionString = updateSpConnString.Replace(smallGuideName, "master");

            using (IDnaDataReader reader = StoredProcedureReader.Create("", masterConnectionString))
            {
                reader.ExecuteDEBUGONLY(exectueSql);
            }

            _hasRestored = true;
        }
    }
}
