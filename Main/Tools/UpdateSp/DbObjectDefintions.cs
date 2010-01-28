using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Collections;

namespace updatesp
{
    class DbObjectDefintions
    {
        DataReader _dataReader;
        DataReader DbReader { get { return _dataReader; } }

        public void Initialise(DataReader dataReader)
        {
            _dataReader = dataReader;
        }

        string TableName { get { return "_updateSpDbObjectDefs"; } }

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

            query = string.Format(query, TableName);

            DbReader.ExecuteNonQuery(query,null);
        }

        public bool HasDbObjectDefinitionChanged(string dbObjName, string dbObjType, string dbObjDef)
        {
            List<SqlParameter> sqlParamList = new List<SqlParameter>();
            sqlParamList.Add(new SqlParameter("dbObjName", dbObjName));
            sqlParamList.Add(new SqlParameter("dbObjType", dbObjType));

            string query = @"SELECT dbObjectDefinition FROM {0} WHERE dbObjectName=@dbObjName AND dbObjectType=@dbObjType";
            query = string.Format(query, TableName);

            ArrayList al = DbReader.ExecuteScalar(query, sqlParamList);

            bool hasChanged = true;
            if (al.Count > 0 && al[0] != null)
            {
                string dbObjDefFromDb = (string)al[0];
                hasChanged = !dbObjDefFromDb.Equals(dbObjDef);
            }

            UpdateLastCheckedForDbObjectDefinition(dbObjName, dbObjType);
            return hasChanged;
        }

        public void UpdateDbObjectDefinition(string dbObjName, string dbObjType, string dbObjDef)
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
            query = string.Format(query, TableName);

            DbReader.ExecuteNonQuery(query, sqlParamList);
        }

        private void UpdateLastCheckedForDbObjectDefinition(string dbObjName, string dbObjType)
        {
            List<SqlParameter> sqlParamList = new List<SqlParameter>();
            sqlParamList.Add(new SqlParameter("dbObjName", dbObjName));
            sqlParamList.Add(new SqlParameter("dbObjType", dbObjType));

            string query = @"
                IF EXISTS(SELECT * FROM {0} WHERE dbObjectName=@dbObjName AND dbObjectType=@dbObjType)
                BEGIN
                    UPDATE {0} SET lastChecked=getdate() WHERE dbObjectName=@dbObjName AND dbObjectType=@dbObjType
                END
                ";
            query = string.Format(query, TableName);

            DbReader.ExecuteNonQuery(query, sqlParamList);
        }
    }
}
