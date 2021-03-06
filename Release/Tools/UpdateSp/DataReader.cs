using System;
using System.IO;
using System.Xml;
using System.Text.RegularExpressions;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;

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
                return makeConnectionString(dbName, 0);
            }

            private string makeConnectionString(string dbName, int ConnectionTimeout)
            {
                return "server=" + server + ";database=" + dbName + ";User Id=" + username + ";Password=" + pw + "; Pooling=false; Connection Timeout=" + ConnectionTimeout + "; Application Name=UpdateSp";
            }

            public void TestConnection()
            {
                using (SqlConnection MySqlConn = new SqlConnection(makeConnectionString("master", 5)))
                {
                    MySqlConn.Open();
                    MySqlConn.Close();
                }
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

        public class DatabaseAndServerPairs
        {
            public string dbName;
            public string serverName;
        }

        Hashtable _configConnections = new Hashtable();
        ArrayList _configDatabases = new ArrayList();
        ArrayList _permissionPrinciples = new ArrayList();

        public DataReader()
        {
        }

        public void Initialise(string configfile)
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

                conn.TestConnection();

                _configConnections.Add(conn.name, conn);
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

        public List<DatabaseAndServerPairs> GetListOfDatabaseAndServerPairs()
        {
            List<DatabaseAndServerPairs> dbAndServerPairsList = new List<DatabaseAndServerPairs>();

            foreach (ConfigDatabase db in _configDatabases)
            {
                DatabaseAndServerPairs dbsp = new DatabaseAndServerPairs();
                dbsp.dbName = db.name;
                dbsp.serverName = db.conn.server;

                dbAndServerPairsList.Add(dbsp);
            }

            return dbAndServerPairsList;
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
                    ExecuteNonQuery(db.name, db.conn, SQL, null, false);
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
            ArrayList alist = ExecuteScalar("SELECT * FROM sysobjects WHERE name = '" + objName + "'", null);
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
            foreach (ConfigDatabase db in _configDatabases)
            {
                if (db.snapshot != null)
                {
                    CheckSnapShotDbConnections(db);

                    Console.WriteLine("Restoring " + db.name + " from snapshot " + db.snapshot);
                    string sql = 
                    "ALTER DATABASE " + db.name + " SET OFFLINE WITH ROLLBACK IMMEDIATE" + NL +
                    "GO" + NL +
                    "ALTER DATABASE " + db.name + " SET ONLINE" + NL +
                    "GO" + NL +
                    "RESTORE DATABASE " + db.name + " FROM DATABASE_SNAPSHOT = '" + db.snapshot + "'" + NL +
                    "GO";

                    ExecuteNonQuery("master", db.conn, sql, null, false);
                }
            }
        }

        public void ReCreateSnapShot()
        {
            foreach (ConfigDatabase db in _configDatabases)
            {
                if (db.snapshot != null)
                {
                    CheckSnapShotDbConnections(db);

                    Console.WriteLine("Recreating SnapShot " + db.snapshot + " on " + db.name);
                    string sql =
                    "IF db_id('"+db.snapshot +"') IS NOT NULL" + NL +
                    "   DROP DATABASE " + db.snapshot + NL +
                    "GO" + NL +
                    "CREATE DATABASE " + db.snapshot + " ON ( NAME = " + db.name + ", FILENAME = '" + db.snapshotfilename + "') AS SNAPSHOT OF " + db.name + NL +
                    "GO";

                    ExecuteNonQuery("master",db.conn,sql,null,false);
                }
            }
        }

        private string NL
        {
            get { return System.Environment.NewLine; }
        }

        private void CheckSnapShotDbConnections(ConfigDatabase db)
        {
            DataReader.DbConnections dbConns = GetDbConnections(db);

            if (dbConns.Count > 0)
            {
                string msg = "Can't continue because there are connections open on database " + db.name + " that supports snapshot recreation.  Connections:";
                msg += System.Environment.NewLine + dbConns.OutputConnections();
                throw new Exception(msg);
            }
        }

        public List<string> UpdateDbObject(string dbObjName, string dbObjType, string SQL, List<SqlParameter> sqlParamList)
        {
            return UpdateDbObject(dbObjName, dbObjType, SQL, sqlParamList, false);
        }

        public List<string> UpdateDbObject(string dbObjName, string dbObjType, string SQL, List<SqlParameter> sqlParamList, bool bIgnoreNotExistForPermissions)
        {
            List<string> msgList = new List<string>();

            foreach (ConfigDatabase db in _configDatabases)
            {
                if (HasDbObjectDefinitionChanged(db, dbObjName, dbObjType, SQL))
                {
                    ExecuteNonQuery(db.name, db.conn, SQL, sqlParamList, bIgnoreNotExistForPermissions);
                    UpdateDbObjectDefinition(db, dbObjName, dbObjType, SQL);

                    msgList.Add(string.Format("Updated {0} in database {1}", dbObjName, db.name));
                }
                else
                {
                    msgList.Add(string.Format("Skipping {0} in database {1}. Definition is up to date", dbObjName, db.name));
                }
            }

            return msgList;
        }



        public void ExecuteNonQuery(string SQL, List<SqlParameter> sqlParamList)
        {
            ExecuteNonQuery(SQL, sqlParamList, false);
        }

        public void ExecuteNonQuery(string SQL, List<SqlParameter> sqlParamList, bool bIgnoreNotExistForPermissions)
        {
            foreach (ConfigDatabase db in _configDatabases)
            {
                ExecuteNonQuery(db.name, db.conn, SQL, sqlParamList, bIgnoreNotExistForPermissions);
            }
        }

        private string _SqlCommandMsgs = string.Empty;

        public string SqlCommandMsgs
        {
            get { return _SqlCommandMsgs; }
        }

        private void ExecuteNonQuery(string dbName, ConfigConnection conn, string SQL, List<SqlParameter> sqlParamList, bool bIgnoreNotExistForPermissions)
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
                        AddParamsToCmd(MySqlCmd, sqlParamList);
						MySqlCmd.CommandTimeout = 0;
						MySqlCmd.ExecuteNonQuery();
                        MySqlCmd.Parameters.Clear();
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

        public ArrayList ExecuteScalar(string SQL, List<SqlParameter> sqlParamList)
        {
            ArrayList alist = new ArrayList();

            foreach (ConfigDatabase db in _configDatabases)
            {
                alist.Add(ExecuteScalar(db, SQL, sqlParamList));
            }

            return alist;
        }

        private object ExecuteScalar(ConfigDatabase db, string SQL, List<SqlParameter> sqlParamList)
        {
            object result;

            string connstr = db.conn.makeConnectionString(db.name);
            SqlConnection MySqlConn = new SqlConnection(connstr);
            MySqlConn.Open();
            try
            {
                using (SqlCommand MySqlCmd = new SqlCommand(SQL, MySqlConn))
                {
                    AddParamsToCmd(MySqlCmd, sqlParamList);
                    result = MySqlCmd.ExecuteScalar();
                    MySqlCmd.Parameters.Clear();
                }
            }
            finally
            {
                MySqlConn.Close();
            }

            return result;
        }

        private void AddParamsToCmd(SqlCommand MySqlCmd, List<SqlParameter> sqlParamList)
        {
            if (sqlParamList != null)
            {
                foreach (SqlParameter p in sqlParamList)
                {
                    MySqlCmd.Parameters.Add(p);
                }
            }
        }

        /*
        /// <summary>
        /// IsObjectInDbOutOfDate() - Not used in the end
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public bool IsObjectInDbOutOfDate(string file)
        {
            DateTime fileLastAccessed = File.GetLastAccessTime(file);
            DateTime fileLastModified = File.GetLastWriteTime(file);

            string objName = file.Substring(0,file.IndexOf('.'));

            ArrayList al = ExecuteScalar("select create_date from sys.objects where name = '" + objName + "'");

            if (al.Count < 1)
                throw new Exception("IsObjectInDbOutOfDate() didn't get any results back from db.  There should be one result per configured db");

            for (int i = 0; i < al.Count; i++)
            {
                if (al[i] == null)  // If it doesn't exist yet, act like it's out of date
                    return true;

                DateTime dbObjDate = (DateTime)al[i];

                if (dbObjDate.CompareTo(fileLastAccessed) < 0 || dbObjDate.CompareTo(fileLastModified) < 0)
                    return true;
            }

            return false;
        }
        */

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

        private DbConnections GetDbConnections(ConfigDatabase db)
        {
            DbConnections dbConns = new DbConnections();
            dbConns.dbName = db.name;

            string SQL = "SELECT * FROM master..sysprocesses where dbid=db_id('"+db.name+"') AND SPID >= 50";

            using (SqlDataReader dataReader = Execute("master", db.conn, SQL, false))
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

        private string DbObjDefTableName { get { return "_updateSpDbObjectDefs"; } }

        public void PrepareDbObjectDefintionStorage()
        {
            string query = @"
                IF OBJECTPROPERTY ( object_id('{0}'),'ISTABLE') IS NULL
                BEGIN
	                CREATE TABLE dbo.{0}
	                (
		                dbObjectName nvarchar(256) NOT NULL,
		                dbObjectType char(2) NOT NULL,
		                dbObjectDefinition nvarchar(max) NOT NULL,
		                lastUpdated datetime NOT NULL,
		                lastChecked datetime NOT NULL
	                )
	                ALTER TABLE dbo.{0} ADD CONSTRAINT	PK_{0} PRIMARY KEY CLUSTERED 
	                (
		                dbObjectName,
		                dbObjectType
	                )
                END
                ";

            query = string.Format(query, DbObjDefTableName);

            ExecuteNonQuery(query, null);
        }

        private bool HasDbObjectDefinitionChanged(ConfigDatabase db, string dbObjName, string dbObjType, string dbObjDef)
        {
            List<SqlParameter> sqlParamList = new List<SqlParameter>();
            sqlParamList.Add(new SqlParameter("dbObjName", dbObjName));
            sqlParamList.Add(new SqlParameter("dbObjType", dbObjType));

            string query = @"SELECT dbObjectDefinition FROM {0} WHERE dbObjectName=@dbObjName AND dbObjectType=@dbObjType";
            query = string.Format(query, DbObjDefTableName);

            object result = ExecuteScalar(db, query, sqlParamList);

            bool hasChanged = true;
            if (result != null)
            {
                string dbObjDefFromDb = (string)result;
                hasChanged = !dbObjDefFromDb.Equals(dbObjDef);
            }

            UpdateLastCheckedForDbObjectDefinition(db, dbObjName, dbObjType);
            return hasChanged;
        }

        private void UpdateDbObjectDefinition(ConfigDatabase db, string dbObjName, string dbObjType, string dbObjDef)
        {
            List<SqlParameter> sqlParamList = new List<SqlParameter>();
            sqlParamList.Add(new SqlParameter("dbObjName", dbObjName));
            sqlParamList.Add(new SqlParameter("dbObjType", dbObjType));
            sqlParamList.Add(new SqlParameter("dbObjDef", dbObjDef));

            string query = @"
                IF EXISTS(SELECT * FROM {0} WHERE dbObjectName=@dbObjName AND dbObjectType=@dbObjType)
                BEGIN
                    UPDATE {0} SET dbObjectDefinition=@dbObjDef, lastUpdated=getdate()
	                    WHERE dbObjectName=@dbObjName AND dbObjectType=@dbObjType
                END
                ELSE
                BEGIN
                    INSERT {0}(dbObjectName,dbObjectType,dbObjectDefinition,lastUpdated,lastChecked) values(@dbObjName,@dbObjType,@dbObjDef,getdate(),getdate())
                END
                ";
            query = string.Format(query, DbObjDefTableName);

            ExecuteNonQuery(db.name, db.conn, query, sqlParamList, false);
        }

        private void UpdateLastCheckedForDbObjectDefinition(ConfigDatabase db, string dbObjName, string dbObjType)
        {
            List<SqlParameter> sqlParamList = new List<SqlParameter>();
            sqlParamList.Add(new SqlParameter("dbObjName", dbObjName));
            sqlParamList.Add(new SqlParameter("dbObjType", dbObjType));

            string query = @"UPDATE {0} SET lastChecked=getdate() WHERE dbObjectName=@dbObjName AND dbObjectType=@dbObjType";
            query = string.Format(query, DbObjDefTableName);

            ExecuteNonQuery(db.name, db.conn, query, sqlParamList, false);
        }
    }
}
