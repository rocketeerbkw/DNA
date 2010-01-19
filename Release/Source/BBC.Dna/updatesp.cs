using System;
using System.IO;
using System.Xml;
using System.Text.RegularExpressions;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Configuration;

namespace BBC.Dna.DynamicLists
{
    /// <summary>
    /// 
    /// </summary>
	public class Dbo
	{
        private string _connectionString;
        private string _configFile;

        /// <summary>
        /// Constructs new dbo object given connection string.
        /// </summary>
        /// <param name="connectionString">Config file</param>
        public Dbo( string connectionString )
        {
            _connectionString = connectionString;
        }

		/// <summary>
		/// Contrsucts new dbo object and reads config
		/// </summary>
		/// <param name="folder">Config file folder</param>
		/// <param name="configFile">Config filename</param>
		public Dbo(string folder, string configFile)
		{
			Initialise(Path.Combine(folder, configFile));
		}

        /// <summary>
        /// Initialise from a file with config XML.
        /// </summary>
        /// <param name="configfile"></param>
		private void Initialise(string configfile)
		{

            _configFile = configfile;
			XmlDocument doc = new XmlDocument();
			XmlTextReader xtr = new XmlTextReader(configfile);
			doc.Load(xtr);
			xtr.Close();

			string server	 = ReadConfig(doc,"server");
			string username = ReadConfig(doc,"username");
			string pw		 = ReadConfig(doc,"pw");
			string database = ReadConfig(doc,"database");
            _connectionString = "server=" + server + ";database=" + database + ";User Id=" + username + ";Password=" + pw + ";";
		}

		private string ReadConfig(XmlDocument doc,string name)
		{
			string xpath = "/updatesp/"+name;
			try
			{
				XmlNode docElement = doc.DocumentElement;
				XmlNodeList result = docElement.SelectNodes(xpath+"/text()");
				return result.Item(0).Value;
			}
			catch (Exception)
			{
				throw new Exception("Unable to read '"+xpath+"' from '" + _configFile+"'");
			}
		}

		/// <summary>
		/// RegiserObjectString - Executes the given XML
		/// </summary>
		/// <param name="SQL"></param>
		public void RegisterObjectString(string SQL)
		{
			string objName = GetObjectName(SQL);
			CheckObjectParams(SQL);
			DropObject(objName,IsProcedure(SQL));
			ExecuteNonQuery(SQL);
			GrantPermissions(SQL);
			CheckObjectExists(objName);
		}

        /// <summary>
        /// Create a stored procedure given a file.
        /// </summary>
        /// <param name="file"></param>
		public void RegisterObject(string file)
		{
			string SQL = ReadFileContent(file);
			string objName = GetObjectName(SQL);
			CheckObjectName(objName, file);
			RegisterObjectString(SQL);
		}

        /// <summary>
        /// Drops stored procedure
        /// </summary>
        /// <param name="file"></param>
		public void DropObjectViaFile(string file)
		{
			string SQL = ReadFileContent(file);
			string objName = GetObjectName(SQL);
			DropObject(objName,IsProcedure(SQL));
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
		private string ReadFileContent(string file)
		{
			TextReader tr = new StreamReader(new FileStream(file,FileMode.Open,FileAccess.Read,FileShare.Read));
			string SQL = tr.ReadToEnd();
			tr.Close();

			return SQL;
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SQL"></param>
        /// <returns></returns>
		private bool IsProcedure(string SQL)
		{
			Match m = Regex.Match(SQL,@"create\s+procedure",RegexOptions.IgnoreCase);
			if (m.Success)
			{
				return true;
			}
			else
			{
				m = Regex.Match(SQL,@"create\s+function",RegexOptions.IgnoreCase);
				if (m.Success)
				{
					return false;
				}
			}

			throw new Exception("The file must contain SQL to either create a procedure or a function");
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SQL"></param>
        /// <returns></returns>
		private string GetObjectName(string SQL)
		{
			Match m = null;
			if (IsProcedure(SQL))
			{
				m = Regex.Match(SQL,@"create\s+procedure\s+(\S+)",RegexOptions.IgnoreCase);
			}
			else
			{
				m = Regex.Match(SQL,@"create\s+function\s+([^\(\s]+)",RegexOptions.IgnoreCase);
			}

			return m.Groups[1].Value;
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SQL"></param>
		private void CheckObjectParams(string SQL)
		{
			// Get the part of the text that contains the input variables
			Match m = null;
			if (IsProcedure(SQL))
			{
				m = Regex.Match(SQL,@"create\s+procedure.*?\sas",RegexOptions.IgnoreCase | RegexOptions.Singleline);
			}
			else
			{
				m = Regex.Match(SQL,@"create\s+function.*?\sas",RegexOptions.IgnoreCase | RegexOptions.Singleline);
			}
			string s = m.Value;

			// Now match all the vars, checking they are lower case
			m = Regex.Match(s,@"(@\S+)+",RegexOptions.IgnoreCase);
			while (m.Success)
			{
				string var = m.Groups[1].Value;
				if (var.ToLower().CompareTo(var) != 0)
				{
					throw new Exception("Variable name '"+var+"' has to be all lower case");
				}
				m = m.NextMatch();
			}
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objName"></param>
        /// <param name="file"></param>
		private void CheckObjectName(string objName, string file)
		{
			string objNameFromFile = Path.GetFileNameWithoutExtension(file);

			if (objName.ToLower().CompareTo(objNameFromFile.ToLower()) != 0)
			{
				throw new Exception("Name inside file ("+objName+") different from name of file ("+objNameFromFile+")");
			}

			if (objName.ToLower().CompareTo(objName) != 0)
			{
				throw new Exception("Name ("+objName+") has to be all lower case");
			}
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="spName"></param>
        /// <param name="bIsProcedure"></param>
		public void DropObject(string spName,bool bIsProcedure)
		{
			string SQL = "drop procedure [dbo].["+spName+"]";
			if (!bIsProcedure)
			{
				SQL = "drop function [dbo].["+spName+"]";
			}

			try
			{
				ExecuteNonQuery(SQL);
			}
			catch (SqlException e)
			{
				// If it's not a "sp doen't exist" error, complain!
				if (e.Number != 3701)
				{
					throw e;
				}
			}
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SQL"></param>
		private void GrantPermissions(string SQL)
		{
			// If the object is a stored procedure or scalar function, we need to grant EXECUTE
			// permissions for the various roles.
			//
			// If it's a table-valued function, we need to grant SELECT permissions on the returned
			// table

			string objName = GetObjectName(SQL);
			string cmd = "GRANT EXECUTE ON [dbo].["+objName+"] TO ripleyrole, wholesite, editrole";

			if (!IsProcedure(SQL))
			{
				Match m = Regex.Match(SQL,@"returns.+table",RegexOptions.IgnoreCase);
				if (m.Success)
				{
					// It's a table-valued function
					cmd = "GRANT SELECT ON [dbo].["+objName+"] TO ripleyrole, wholesite, editrole";
				}
			}

			ExecuteNonQuery(cmd);
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objName"></param>
		private void CheckObjectExists(string objName)
		{
			object o = ExecuteScalar("SELECT * FROM sysobjects WHERE name = '"+objName+"'");
			if (o == null)
			{
				throw new Exception("After creating '"+objName+"', can't find it in sysobjects");
			}
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SQL"></param>
        /// <returns></returns>
		public int ExecuteNonQuery(string SQL)
		{
			string connstr = ConnectionString;
			SqlConnection MySqlConn = new SqlConnection(connstr);
			MySqlConn.Open();
			try
			{
				SqlCommand MySqlCmd = new SqlCommand(SQL,MySqlConn);
				return MySqlCmd.ExecuteNonQuery();
			}
			finally
			{
				MySqlConn.Close();
			}
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SQL"></param>
        /// <returns></returns>
		public object ExecuteScalar(string SQL)
		{
			string connstr = ConnectionString;
			SqlConnection MySqlConn = new SqlConnection(connstr);
			MySqlConn.Open();
			try
			{
				SqlCommand MySqlCmd = new SqlCommand(SQL,MySqlConn);
				return MySqlCmd.ExecuteScalar();
			}
			finally
			{
				MySqlConn.Close();
			}
		}

        /// <summary>
        /// 
        /// </summary>
		public string ConnectionString
		{
            get { return _connectionString; }
           //return "server="+server+";database="+database+";User Id="+username+";Password="+pw+";";
		}
	}
}
