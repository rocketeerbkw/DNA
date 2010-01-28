using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace updatesp
{
    class ViewDbObject : DbObject
    {
        public override string DbObjType { get { return "V"; } }

        public static bool ContainsView(string SQL)
        {
            Match m = Regex.Match(SQL, @"create\s+view", RegexOptions.IgnoreCase);
            return m.Success;
        }

        public ViewDbObject(string file, string fileContent, DataReader dataReader)
            : base(file, fileContent, dataReader)
        {
        }

        protected override string GetObjectNameFromFileContent()
        {
            Match m = Regex.Match(FileContent, @"create\s+view\s+(\S+)", RegexOptions.IgnoreCase);
            return m.Groups[1].Value;
        }

        protected override void CheckObjectParams()
        {
            // Do nothing about parameters for views
        }

		protected override bool AreObjectParamsOk(ref string error)
		{
			return true;
		}

        protected override void GrantPermissions()
        {
            GrantSelectPermissions();
        }

		protected override string GetPermissionsSql()
		{
			return GetSelectPermissionSql();
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
			return "if exists(select * from sys.objects where name = '" + DbObjName + "' AND type = 'V')\r\n" +
					"BEGIN\r\n" +
					"drop view [dbo].[" + DbObjName + "]\r\n" +
					"END\r\n";
		}

        /*
                protected bool HasObjectDefinitionChanged(string objName, string objDef)
                {
                    ArrayList alist = DataReader.ExecuteScalar("select object_definition(object_id('" + objName + "'))");

                    // If we haven't found definitions of this object in each db, assume def has changed
                    if (alist.Count != DataReader.DatabaseCount)
                        return true;

                    bool bObjDefHasChanged = false;

                    for (int i = 0; i < alist.Count && !bObjDefHasChanged; i++)
                    {
                        if (DBNull.Value.Equals(alist[i]))
                            bObjDefHasChanged = true;   // If def is NULL, then assume def has changed
                        else
                        {
                            string objDefInDb = (string)alist[i];

                            string objDefInDbFile = string.Format(@"d:\t\{0}.{1}.objInDb", ObjName, i);
                            string objDefFile = string.Format(@"d:\t\{0}.{1}.obj", ObjName, i);

                            using (StreamWriter writer = new StreamWriter(objDefInDbFile))
                            {
                                writer.Write(objDefInDb);
                            }

                            using (StreamWriter writer = new StreamWriter(objDefFile))
                            {
                                writer.Write(objDef);
                            }

                            if (!objDef.Equals(objDefInDb))
                                bObjDefHasChanged = true;
                        }
                    }

                    return bObjDefHasChanged;
                }
          */
        /*
        public override bool HasObjectDefinitionChanged()
        {
            ArrayList al = DataReader.ExecuteScalar("select create_date from sys.objects where name = 'VMyView'");

            DateTime dt = (DateTime) al[0];


            string[] cmds = FileContent.Split(new string[] { "\nGO" }, StringSplitOptions.RemoveEmptyEntries);

            bool bObjDefHasChanged = false;

            foreach (string cmd in cmds)
            {
                string viewName = GetViewName(cmd);

                if (viewName.Length > 0)
                {
                    if (HasObjectDefinitionChanged(viewName, cmd))
                        bObjDefHasChanged = true;
                }
                else
                {
                    string indexName = GetIndexName(cmd);
                    if (indexName.Length > 0)
                    {
                        if (HasObjectDefinitionChanged(indexName, cmd))
                            bObjDefHasChanged = true;
                    }
                }

                if (bObjDefHasChanged)
                    break;
            }

            return bObjDefHasChanged;
        }
        */
        /*
      protected string GetViewName(string obj)
      {
          Match m = Regex.Match(obj, @"create\s+view\s+(\S+)", RegexOptions.IgnoreCase);
          return m.Groups[1].Value;
      }

      protected string GetIndexName(string obj)
      {
          Match m = Regex.Match(obj, @"create\s+unique\s+clustered\s+index\s+(\S+)", RegexOptions.IgnoreCase);
          return m.Groups[1].Value;
      }
*/
    }
}
