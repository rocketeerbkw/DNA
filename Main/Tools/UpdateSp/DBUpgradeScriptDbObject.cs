using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace updatesp
{
    class DBUpgradeScriptDbObject : DbObject
    {
        public override string DbObjType { get { return "DU"; } }

        public static bool ContainsScript(string fileName)
        {
            return fileName.EndsWith("DBupgradeScript.sql",StringComparison.OrdinalIgnoreCase);
        }

        public DBUpgradeScriptDbObject(string file, string fileContent, DataReader dataReader)
            : base(file, fileContent, dataReader)
        {
        }

        protected override string GetObjectNameFromFileContent()
        {
            return FilePath;
        }

        protected override void CheckObjectParams()
        {
            // Do nothing about parameters for scripts
        }

		protected override bool AreObjectParamsOk(ref string error)
		{
			return true;
		}

        protected override void GrantPermissions()
        {
            // Do nothing about permissions for scripts
        }

		protected override string GetPermissionsSql()
		{
            // Do nothing about permissions for scripts
            return "";
		}

        public override void RegisterObject()
        {
            DataReader.ExecuteNonQuery(FileContent,null);
        }

		public override bool AppendToBatchScript(StringBuilder sql, ref string error)
		{
			sql.AppendLine(FileContent);
			sql.AppendLine("GO");
			return true;
		}


        public override void DropObject()
        {
            // Do nothing about dropping for scripts
        }

        public override string GetDropObjectSql()
        {
            // Do nothing about dropping for scripts
            return "";
        }
    }
}
