using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace updatesp
{
    class ProcedureDbObject : DbObject
    {
        public override string DbObjType { get { return "P"; } }

        public static bool ContainsProcedure(string SQL)
        {
            Match m = Regex.Match(SQL, @"create\s+procedure", RegexOptions.IgnoreCase);
            return m.Success;
        }

        public ProcedureDbObject(string file, string fileContent, DataReader dataReader)
            : base(file, fileContent, dataReader)
        {
        }

        protected override string GetObjectNameFromFileContent()
        {
            Match m = Regex.Match(FileContent, @"create\s+procedure\s+(\S+)", RegexOptions.IgnoreCase);
            return m.Groups[1].Value;
        }

        protected override void CheckObjectParams()
        {
            Match m = Regex.Match(FileContent, @"create\s+procedure.*?\sas", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            TestParamsAreLowerCase(m.Value);
        }

		protected override bool AreObjectParamsOk(ref string error)
		{
			Match m = Regex.Match(FileContent, @"create\s+procedure.*?\sas", RegexOptions.IgnoreCase | RegexOptions.Singleline);
			return AreParamsLowerCase(m.Value, ref error);
		}

        protected override void GrantPermissions()
        {
            GrantExecutePermissions();
        }

		protected override string GetPermissionsSql()
		{
			return GetExecutePermissionSql();
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
			return "if exists(select * from sys.objects where name = '" + DbObjName + "' AND type = 'P')\r\n" +
					"BEGIN\r\n" +
					"drop procedure [dbo].[" + DbObjName + "]\r\n" +
					"END\r\n";
		}
    }
}
