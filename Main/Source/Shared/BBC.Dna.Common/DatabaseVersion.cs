using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace BBC.Dna.Common
{
    public class DatabaseVersion
    {
        public static string GetDatabaseVersion(IDnaDataReaderCreator readerCreator)
        {
            using (var dataReader = readerCreator.CreateDnaDataReader("dna.DatabaseVersion"))
            {
                dataReader.Execute();
                dataReader.Read();
                var databaseVersion = dataReader.GetString("DatabaseVersion");
                return databaseVersion;
            }
        }
    }
}
