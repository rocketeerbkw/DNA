using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;

namespace updatesp
{
    abstract class DbObject
    {
        private DataReader _dataReader;
        private string _file;
        private string _fileContent;
        private string _dbObjName;
        private DateTime _fileLastAccessed;
        private DateTime _fileLastModified;

        public string FileContent
        {
            get { return _fileContent; }
        }

        public string FilePath
        {
            get { return _file; }
        }

        public DateTime FileLastAccessed
        {
            get { return _fileLastAccessed; }
        }

        public DateTime FileLastModified
        {
            get { return _fileLastModified; }
        }

        public string DbObjName
        {
            get { return _dbObjName; }
        }

        public abstract string DbObjType { get; }

        protected DataReader DataReader
        {
            get { return _dataReader; }
        }
		
        public DbObject(string file, string fileContent, DataReader dataReader)
        {
            _dataReader = dataReader;
            _file = file;
            _fileContent = fileContent;
            _fileLastAccessed = File.GetLastAccessTime(file);
            _fileLastModified = File.GetLastWriteTime(file);
            _dbObjName = GetObjectNameFromFileContent();
        }

        protected abstract string GetObjectNameFromFileContent();
        protected abstract void CheckObjectParams();
		protected abstract bool AreObjectParamsOk(ref string error);
        protected abstract void GrantPermissions();
		protected abstract string GetPermissionsSql();

        public abstract void RegisterObject();

		public abstract bool AppendToBatchScript(StringBuilder sql, ref string error);

		public virtual void DropObject()
		{
			string SQL = GetDropObjectSql();
			DataReader.ExecuteDropQuery(SQL);
		}

		public abstract string GetDropObjectSql();

        protected void CheckObjectNameMatchesFileName()
        {
			string error = string.Empty;
			if (!DoesObjectNameMatchFileName(ref error))
			{
				throw new Exception(error);
			}
        }

		protected bool DoesObjectNameMatchFileName(ref string error)
		{
			string objNameFromFile = Path.GetFileNameWithoutExtension(FilePath);

			if (DbObjName.ToLower().CompareTo(objNameFromFile.ToLower()) != 0)
			{
				error = "Name inside file (" + DbObjName + ") different from name of file (" + objNameFromFile + ")";
				return false;
			}
			return true;
		}

        protected void CheckObjectNameIsLowerCase()
        {
			string error = string.Empty;
			if (!IsObjectNameLowerCase(ref error))
			{
				throw new Exception(error);
			}
        }

		protected bool IsObjectNameLowerCase(ref string error)
		{
			if (DbObjName.ToLower().CompareTo(DbObjName) != 0)
			{
				error = "Name (" + DbObjName + ") has to be all lower case";
				return false;
			}
			return true;
		}

        protected void TestParamsAreLowerCase(string paramBlock)
        {
			string error = string.Empty;
			if (!AreParamsLowerCase(paramBlock,ref error))
			{
				throw new Exception(error);
			}
        }

		protected bool AreParamsLowerCase(string paramBlock)
		{
			string dummy = string.Empty;
			return AreParamsLowerCase(paramBlock, ref dummy);
		}

		protected bool AreParamsLowerCase(string paramBlock, ref string error)
		{
			// Match all the vars, checking they are lower case
			Match m = Regex.Match(paramBlock, @"(@\S+)+", RegexOptions.IgnoreCase);
			while (m.Success)
			{
				string var = m.Groups[1].Value;
				if (var.ToLower().CompareTo(var) != 0)
				{
					error = "Variable name '" + var + "' has to be all lower case";
					return false;
				}
				m = m.NextMatch();
			}
			return true;
		}

        protected void CreateObject()
        {
            Console.WriteLine("CreateObject - " + DbObjName);
            DataReader.ExecuteNonQuery(FileContent,null);
            GrantPermissions();
            DataReader.CheckObjectExists(DbObjName);
        }

        protected void GrantExecutePermissions()
        {
            string cmd = GetExecutePermissionSql();
            if (cmd.Length > 0)
            {
                Console.WriteLine("GrantExecutePermissions - " + DbObjName);
                DataReader.ExecuteNonQuery(cmd, null, true);
            }
            else
            {
                Console.WriteLine("No Principles to Grant Execute Permissions on " + DbObjName);
            }
        }

		protected string GetExecutePermissionSql()
		{
            ArrayList permissionPrinciples = DataReader.PermissionPrincipleList;

            string SQL = string.Empty;
            foreach (string principle in permissionPrinciples)
            {
                SQL += "GRANT EXECUTE ON [dbo].[" + DbObjName + "] TO " + principle + "\n";
            }

            return SQL;
		}

        protected void GrantSelectPermissions()
        {
			string cmd = GetSelectPermissionSql();
            if (cmd.Length > 0)
            {
                Console.WriteLine("GrantSelectPermissions - " + DbObjName);
                DataReader.ExecuteNonQuery(cmd, null, true);
            }
            else
            {
                Console.WriteLine("No Principles to Grant Select Permissions on " + DbObjName);
            }
        }

		protected string GetSelectPermissionSql()
		{
            ArrayList permissionPrinciples = DataReader.PermissionPrincipleList;

            string SQL = string.Empty;
            foreach (string principle in permissionPrinciples)
            {
                SQL += "GRANT SELECT ON [dbo].[" + DbObjName + "] TO " + principle + ";\n";
            }

            return SQL;
		}

        public static DbObject CreateDbObject(string file, DataReader dataReader)
        {
            string fileContent = ReadFileContent(file);

            if (DBUpgradeScriptDbObject.ContainsScript(file))
            {
                return new DBUpgradeScriptDbObject(file, fileContent, dataReader);
            }

            if (ProcedureDbObject.ContainsProcedure(fileContent))
            {
                return new ProcedureDbObject(file, fileContent, dataReader);
            }

            if (FunctionDbObject.ContainsFunction(fileContent))
            {
                return new FunctionDbObject(file, fileContent, dataReader);
            }

            if (ViewDbObject.ContainsView(fileContent))
            {
                return new ViewDbObject(file, fileContent, dataReader);
            }

            if (TriggerDbObject.ContainsTrigger(fileContent))
			{
                return new TriggerDbObject(file, fileContent, dataReader);
			}

            throw new Exception("The content of file " + file + "is not recognised");
        }

        public string SqlCommandMsgs
        {
            get { return _dataReader.SqlCommandMsgs; }
        }

        private static string ReadFileContent(string file)
        {
            TextReader tr = new StreamReader(new FileStream(file, FileMode.Open, FileAccess.Read, FileShare.Read));
            string SQL = tr.ReadToEnd();
            tr.Close();
            return SQL;
        }
    }
}
