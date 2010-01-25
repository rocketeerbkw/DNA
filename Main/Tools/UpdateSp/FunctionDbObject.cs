using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace updatesp
{
    class FunctionDbObject : DbObject
    {
        public static bool ContainsFunction(string SQL)
        {
            Match m = Regex.Match(SQL, @"create\s+function", RegexOptions.IgnoreCase);
            return m.Success;
        }

        public FunctionDbObject(string file, string fileContent, DataReader dataReader)
            : base(file, fileContent, dataReader)
        {
        }

        protected override string GetObjectNameFromFileContent()
        {
            Match m = Regex.Match(FileContent, @"create\s+function\s+([^\(\s]+)", RegexOptions.IgnoreCase);
            return m.Groups[1].Value;
        }

        protected override void CheckObjectParams()
        {
            Match m = Regex.Match(FileContent, @"create\s+function.*?\sas", RegexOptions.IgnoreCase | RegexOptions.Singleline); 
            TestParamsAreLowerCase(m.Value);
        }

		protected override bool AreObjectParamsOk(ref string error)
		{
			Match m = Regex.Match(FileContent, @"create\s+function.*?\sas", RegexOptions.IgnoreCase | RegexOptions.Singleline);
			return AreParamsLowerCase(m.Value, ref error);
		}

        protected override void GrantPermissions()
        {
            Match m = Regex.Match(FileContent, @"returns.+table", RegexOptions.IgnoreCase);
            if (m.Success)
            {
                // It's a table-valued function, so we need SELECT permissions on the returned table
                GrantSelectPermissions();
            }
            else
            {
                GrantExecutePermissions();
            }
        }

		protected override string GetPermissionsSql()
		{
			Match m = Regex.Match(FileContent, @"returns.+table", RegexOptions.IgnoreCase);
			if (m.Success)
			{
				// It's a table-valued function, so we need SELECT permissions on the returned table
				return GetSelectPermissionSql();
			}
			else
			{
				return GetExecutePermissionSql();
			}
			
		}

        public override void RegisterObject()
        {
            CheckObjectNameMatchesFileName();
            CheckObjectNameIsLowerCase();
            CheckObjectParams();
            DropObject();
            CreateObject();
        }

		public override bool AppendToBatchScript(StringBuilder sql, ref string error)
		{
			if (!DoesObjectNameMatchFileName(ref error))
			{
				return false;
			}
			if (!IsObjectNameLowerCase(ref error))
			{
				return false;
			}
			if (!AreObjectParamsOk(ref error))
			{
				return false;
			}
			sql.AppendLine(GetDropObjectSql());
			sql.AppendLine("GO");
			sql.AppendLine(FileContent);
			sql.AppendLine("GO");
			sql.AppendLine(GetPermissionsSql());
			sql.AppendLine("GO");
			return true;
		}

        public override void DropObject()
        {
            string SQL = GetDropObjectSql();
            DataReader.ExecuteDropQuery(SQL);
        }

		public override string GetDropObjectSql()
		{
			return	"if exists(select * from sys.objects where name = '" + ObjName + "' AND type IN ('IF','FN','TF'))\r\n" +
					"BEGIN\r\n" +
					"drop function [dbo].[" + ObjName + "]\r\n" +
					"END\r\n";
		}
    }
}
