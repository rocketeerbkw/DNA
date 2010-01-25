using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace updatesp
{
	class TriggerDbObject : DbObject
	{

		public TriggerDbObject(string file, string fileContent, DataReader dataReader)
			: base(file, fileContent, dataReader)
		{
		}

		public static bool ContainsTrigger(string SQL)
		{
			Match m = Regex.Match(SQL, @"create\s+trigger", RegexOptions.IgnoreCase);
			return m.Success;
		}
		protected override string GetObjectNameFromFileContent()
		{
			Match m = Regex.Match(FileContent, @"create\s+trigger\s+(\S+)", RegexOptions.IgnoreCase);
			return m.Groups[1].Value;
		}

		protected override void CheckObjectParams()
		{
			return; // triggers have no params
		}

		protected override bool AreObjectParamsOk(ref string error)
		{
			return true;
		}

		protected override void GrantPermissions()
		{
			return; // triggers don't need permissions
		}

		protected override string GetPermissionsSql()
		{
			return string.Empty;
		}

		public override void RegisterObject()
		{
			CheckObjectNameMatchesFileName();
			DropObject();
			CreateObject();
		}

		public override bool AppendToBatchScript(StringBuilder sql, ref string error)
		{
			if (!DoesObjectNameMatchFileName(ref error))
			{
				return false;
			}
			sql.AppendLine(GetDropObjectSql());
			sql.AppendLine("GO");
			sql.AppendLine(FileContent);
			sql.AppendLine("GO");
			return true;
		}

		public override string GetDropObjectSql()
		{
			return "if exists(select * from sys.objects where name = '" + ObjName + "' AND type = 'TR')\r\n" +
					"BEGIN\r\n" +
					"drop trigger [dbo].[" + ObjName + "]\r\n" +
					"END\r\n";
		}
	}
}
