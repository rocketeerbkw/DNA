using System;
using System.IO;
using System.Xml;
using System.Text.RegularExpressions;
using System.Data;
using System.Data.SqlClient;
using System.Collections;

namespace updatesp
{
    public class DataReader
    {
        private class ConfigConnection
        {
            public string name;
            public string server;
            public string username;
            public string pw;

            public string makeConnectionString(string dbName)
            {
                return "server=" + server + ";database=" + dbName + ";User Id=" + username + ";Password=" + pw + "; Pooling=false; Connection Timeout=0";
            }
        }

        private class ConfigDatabase
        {
            public string name;
            public ConfigConnection conn;
            public string snapshot;
            public string snapshotfilename;

            public string makeConnectionString()
            {
                return conn.makeConnectionString(name);
            }
        }

        Hashtable _configConnections = new Hashtable();
        ArrayList _configDatabases = new ArrayList();
        ArrayList _permissionPrinciples = new ArrayList();

        public DataReader(string configFile)
        {
            Initialise(Path.Combine(Environment.CurrentDirectory, configFile));
        }

        private void Initialise(string configfile)
        {
            XmlDocument doc = new XmlDocument();
            XmlTextReader xtr = new XmlTextReader(configfile);
            doc.Load(xtr);
            xtr.Close();

            ReadConfigConnections(doc);
            ReadConfigDatabases(doc);
            ReadConfigPermissionPrinciples(doc);
        }

        private void ReadConfigConnections(XmlDocument doc)
        {
            XmlNodeList nodes = doc.SelectNodes("/updatesp/connection");
            if (nodes.Count == 0)
            {
                throw new Exception("Unable to read database configuration: can't find any /updatesp/connection nodes");
            }

            foreach (XmlNode node in nodes)
            {
                ConfigConnection conn = new ConfigConnection();

                conn.name = node.SelectSingleNode("name").InnerText;
                conn.server = node.SelectSingleNode("server").InnerText;
                conn.username = node.SelectSingleNode("username").InnerText;
                conn.pw = node.SelectSingleNode("pw").InnerText;

                _configConnections.Add(conn.name, conn);
            }

            if ((ConfigConnection)_configConnections["admin"] == null)
            {
                throw new Exception("You must have at least on connection called 'admin'");
            }
        }

        private void ReadConfigDatabases(XmlDocument doc)
        {
            XmlNodeList nodes = doc.SelectNodes("/updatesp/database");
            if (nodes.Count == 0)
            {
                throw new Exception("Unable to read database configuration: can't find any /updatesp/database nodes");
            }

            foreach (XmlNode node in nodes)
            {
                ConfigDatabase db = new ConfigDatabase();

                db.name = node.SelectSingleNode("name").InnerText;
                string connName = node.SelectSingleNode("connection").InnerText;
                db.conn = (ConfigConnection)_configConnections[connName];

                if (node.SelectSingleNode("snapshot") != null)
                {
                    db.snapshot         = node.SelectSingleNode("snapshot").InnerText;
                    db.snapshotfilename = node.SelectSingleNode("snapshotfilename").InnerText;
                }

                _configDatabases.Add(db);
            }
        }

        private void ReadConfigPermissionPrinciples(XmlDocument doc)
        {
            XmlNodeList permissionPrinciplesNodes = doc.SelectNodes("/updatesp/permissionPrinciples");
            if (permissionPrinciplesNodes.Count == 0)
            {
                Console.WriteLine("Can't find a permissionPrinciples node, so defaulting the theGuide principles");
                _permissionPrinciples.Add("ripleyrole");
                _permissionPrinciples.Add("wholesite");
                _permissionPrinciples.Add("editrole");
                return;
            }

            XmlNodeList principleNodes = doc.SelectNodes("/updatesp/permissionPrinciples/principle");
            foreach (XmlNode node in principleNodes)
            {
                _permissionPrinciples.Add(node.InnerText);
            }
        }

        public string[] GetListOfDatabaseNames()
        {
            string[] sa = new string[_configDatabases.Count];

            int i = 0;
            foreach (ConfigDatabase db in _configDatabases)
            {
                sa[i++] = db.name;
            }

            return sa;
        }

        public string[] GetListOfServers()
        {
            string[] sa = new string[_configConnections.Count];

            int i = 0;
            foreach (DictionaryEntry de in _configConnections)
            {
                sa[i++] = ((ConfigConnection)de.Value).server;
            }

            return sa;
        }

        public ArrayList PermissionPrincipleList
        {
            get { return _permissionPrinciples; }
        }

        public void ExecuteDropQuery(string SQL)
        {
            Console.WriteLine("ExecuteDropQuery");
            foreach (ConfigDatabase db in _configDatabases)
            {
                try
                {
                    ExecuteNonQuery(db.name, db.conn, SQL, false);
                }
                catch (SqlException e)
                {
                    // If it's not a "doesn't exist" error, complain!
                    if (e.Number != 3701)
                    {
                        throw;
                    }
                }
            }
        }

        public void CheckObjectExists(string objName)
        {
            ArrayList alist = ExecuteScalar("SELECT * FROM sysobjects WHERE name = '" + objName + "'");
            if (alist.Count != _configDatabases.Count)
            {
                Console.WriteLine("WARNING! After creating '" + objName + "', can't find it in sysobjects for all databases");
            }
            for (int i=0;i < alist.Count;i++)
            {
                if (alist[i] == null)
                {
                    Console.WriteLine("WARNING! After creating '" + objName + "', can't find it in sysobjects for database " + ((ConfigDatabase)_configDatabases[i]).name);
                }
            }
        }

        public void RestoreSnapShot()
        {
            ConfigConnection conn = (ConfigConnection)_configConnections["admin"];

            foreach (ConfigDatabase db in _configDatabases)
            {
                if (db.snapshot != null)
                {
                    CheckSnapShotDbConnections(db.name);

                    Console.WriteLine("Restoring " + db.name + " from snapshot " + db.snapshot);
                    string sql = 
                    "ALTER DATABASE " + db.name + " SET OFFLINE WITH ROLLBACK IMMEDIATE" + NL +
                    "GO" + NL +
                    "ALTER DATABASE " + db.name + " SET ONLINE" + NL +
                    "GO" + NL +
                    "RESTORE DATABASE " + db.name + " FROM DATABASE_SNAPSHOT = '" + db.snapshot + "'" + NL +
                    "GO";

                    ExecuteNonQuery("master", conn, sql, false);
                }
            }
        }

        public void ReCreateSnapShot()
        {
            ConfigConnection conn = (ConfigConnection)_configConnections["admin"];

            foreach (ConfigDatabase db in _configDatabases)
            {
                if (db.snapshot != null)
                {
                    CheckSnapShotDbConnections(db.name);

                    Console.WriteLine("Recreating SnapShot " + db.snapshot + " on " + db.name);
                    string sql =
                    "IF db_id('"+db.snapshot +"') IS NOT NULL" + NL +
                    "   DROP DATABASE " + db.snapshot + NL +
                    "GO" + NL +
                    "CREATE DATABASE " + db.snapshot + " ON ( NAME = " + db.name + ", FILENAME = '" + db.snapshotfilename + "') AS SNAPSHOT OF " + db.name + NL +
                    "GO";

                    ExecuteNonQuery("master",conn,sql,false);
                }
            }
        }

        private string NL
        {
            get { return System.Environment.NewLine; }
        }

        private void CheckSnapShotDbConnections(string dbName)
        {
            DataReader.DbConnections dbConns = GetDbConnections(dbName);

            if (dbConns.Count > 0)
            {
                string msg = "Can't continue because there are connections open on database " + dbName + " that supports snapshot recreation.  Connections:";
                msg += System.Environment.NewLine + dbConns.OutputConnections();
                throw new Exception(msg);
            }
        }

        public void ExecuteNonQuery(string SQL)
        {
            ExecuteNonQuery(SQL, false);
        }

        public void ExecuteNonQuery(string SQL, bool bIgnoreNotExistForPermissions)
        {
            foreach (ConfigDatabase db in _configDatabases)
            {
                ExecuteNonQuery(db.name, db.conn, SQL, bIgnoreNotExistForPermissions);
            }
        }

        private string _SqlCommandMsgs = string.Empty;

        public string SqlCommandMsgs
        {
            get { return _SqlCommandMsgs; }
        }

        private void ExecuteNonQuery(string dbName, ConfigConnection conn, string SQL, bool bIgnoreNotExistForPermissions)
        {
            string connstr = conn.makeConnectionString(dbName);
            SqlConnection MySqlConn = new SqlConnection(connstr);
            MySqlConn.Open();
            try
            {
                MySqlConn.InfoMessage += new SqlInfoMessageEventHandler(OnInfoMessage);

                // Supports multiple batches by looking for "\nGO" as a separator
                string[] cmds = SQL.Split(new string[] { "\nGO" }, StringSplitOptions.RemoveEmptyEntries);

                foreach (string cmd in cmds)
                {
					if (cmd != "\r\n")
					{
						SqlCommand MySqlCmd = new SqlCommand(cmd, MySqlConn);
						MySqlCmd.CommandTimeout = 0;
						MySqlCmd.ExecuteNonQuery();
					}
                }
            }
            catch (SqlException e)
            {
                if (e.Number == 7601)// || conn.database.ToLower().Equals("theguide"))
                {
                    // Ignore the CONTAINSTABLE error when full text catalogs are missing
                }
                else if (bIgnoreNotExistForPermissions && e.Number == 15151)
                {
                    Console.WriteLine("Permission Warning: " + e.Message);
                    // Ignore if asked to ignore "object doesn't exist when applying permissions" errors
                }
				else if (bIgnoreNotExistForPermissions && e.Number == 3701)
				{
					// Ignore if asked and trying to drop existing stored procedure
				}
				else
				{
					throw;
				}
            }
            finally
            {
                MySqlConn.Close();
            }
        }

        protected void OnInfoMessage(object sender, SqlInfoMessageEventArgs args)
        {
            foreach (SqlError err in args.Errors)
            {
                _SqlCommandMsgs += err.Message + NL;
            }
        }

        public ArrayList ExecuteScalar(string SQL)
        {
            ArrayList alist = new ArrayList();

            foreach (ConfigDatabase db in _configDatabases)
            {
                string connstr = db.conn.makeConnectionString(db.name);
                SqlConnection MySqlConn = new SqlConnection(connstr);
                MySqlConn.Open();
                try
                {
                    SqlCommand MySqlCmd = new SqlCommand(SQL, MySqlConn);
                    alist.Add(MySqlCmd.ExecuteScalar());
                }
                finally
                {
                    MySqlConn.Close();
                }
            }

            return alist;
        }

        public class DbConnections
        {
            public string dbName;
            public ArrayList dbConnList = new ArrayList();

            public int Count
            {
                get { return dbConnList.Count; }
            }

            public string OutputConnections()
            {
                string o = String.Empty;
                for (int i = 0; i < dbConnList.Count; i++)
                {
                    DbConnection conn = (DbConnection)dbConnList[i];
                    o += "Host:" + conn.hostName + " | Program:" + conn.program_name + " | SPID:" + conn.spid.ToString();
                    o += System.Environment.NewLine;
                }

                return o;
            }
        }

        public class DbConnection
        {
            public int spid;
            public string hostName;
            public string program_name;
        }

        public DbConnections GetDbConnections(string dbName)
        {
            DbConnections dbConns = new DbConnections();
            dbConns.dbName = dbName;
            ConfigConnection conn = (ConfigConnection)_configConnections["admin"];

            string SQL = "SELECT * FROM master..sysprocesses where dbid=db_id('"+dbName+"') AND SPID >= 50";

            using (SqlDataReader dataReader = Execute("master", conn, SQL, false))
            {
                while (dataReader.Read())
                {
                    DbConnection dbConn = new DbConnection();
                    dbConn.spid = dataReader.GetInt16(dataReader.GetOrdinal("spid"));
                    dbConn.hostName = dataReader.GetString(dataReader.GetOrdinal("hostname")).Trim();
                    dbConn.program_name = dataReader.GetString(dataReader.GetOrdinal("program_name")).Trim();
                    dbConns.dbConnList.Add(dbConn);
                }
            }

            return dbConns;
        }

        private SqlDataReader Execute(string dbName, ConfigConnection conn, string SQL, bool bIgnoreNotExistForPermissions)
        {
            string connstr = conn.makeConnectionString(dbName);
            SqlConnection MySqlConn = new SqlConnection(connstr);
            MySqlConn.Open();

            SqlCommand MySqlCmd = new SqlCommand(SQL, MySqlConn);
            SqlDataReader dataReader = MySqlCmd.ExecuteReader();

            return dataReader;
        }
    }
}
