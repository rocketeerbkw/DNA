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
        private string _objName;
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

        public string ObjName
        {
            get { return _objName; }
        }

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
            _objName = GetObjectNameFromFileContent();
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

        public bool IsObjectInDbOutOfDate()
        {
            ArrayList al = DataReader.ExecuteScalar("select create_date from sys.objects where name = '"+ObjName+"'");

            if (al.Count < 1)
                throw new Exception("IsObjectInDbOutOfDate() didn't get any results back from db.  There should be one result per configured db");

            for (int i = 0; i < al.Count; i++)
            {
                if (al[i] == null)  // If it doesn't exist yet, act like it's out of date
                    return true;

                DateTime dbObjDate = (DateTime)al[i];

                if (dbObjDate.CompareTo(FileLastAccessed) < 0 || dbObjDate.CompareTo(FileLastModified) < 0)
                    return true;
            }

            return false;
        }

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

			if (ObjName.ToLower().CompareTo(objNameFromFile.ToLower()) != 0)
			{
				error = "Name inside file (" + ObjName + ") different from name of file (" + objNameFromFile + ")";
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
			if (ObjName.ToLower().CompareTo(ObjName) != 0)
			{
				error = "Name (" + ObjName + ") has to be all lower case";
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
            Console.WriteLine("CreateObject - " + ObjName);
            DataReader.ExecuteNonQuery(FileContent);
            GrantPermissions();
            DataReader.CheckObjectExists(ObjName);
        }

        protected void GrantExecutePermissions()
        {
            string cmd = GetExecutePermissionSql();
            if (cmd.Length > 0)
            {
                Console.WriteLine("GrantExecutePermissions - " + ObjName);
                DataReader.ExecuteNonQuery(cmd, true);
            }
            else
            {
                Console.WriteLine("No Principles to Grant Execute Permissions on " + ObjName);
            }
        }

		protected string GetExecutePermissionSql()
		{
            ArrayList permissionPrinciples = DataReader.PermissionPrincipleList;

            string SQL = string.Empty;
            foreach (string principle in permissionPrinciples)
            {
                SQL += "GRANT EXECUTE ON [dbo].[" + ObjName + "] TO " + principle + "\nGO\n";
            }

            return SQL;
		}

        protected void GrantSelectPermissions()
        {
			string cmd = GetSelectPermissionSql();
            if (cmd.Length > 0)
            {
                Console.WriteLine("GrantSelectPermissions - " + ObjName);
                DataReader.ExecuteNonQuery(cmd, true);
            }
            else
            {
                Console.WriteLine("No Principles to Grant Select Permissions on " + ObjName);
            }
        }

		protected string GetSelectPermissionSql()
		{
            ArrayList permissionPrinciples = DataReader.PermissionPrincipleList;

            string SQL = string.Empty;
            foreach (string principle in permissionPrinciples)
            {
                SQL += "GRANT SELECT ON [dbo].[" + ObjName + "] TO " + principle + ";\n";
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
