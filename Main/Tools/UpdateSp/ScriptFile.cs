using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace updatesp
{
    class ScriptFile
    {
        private string _scriptFileName;
        public string ScriptFileName
        {
            get { return _scriptFileName; }
        }

        public void Initialise(string scriptFileName)
        {
            _scriptFileName = scriptFileName;
        }

        public void DeleteExisting()
        {
            if (File.Exists(ScriptFileName))
            {
                File.Delete(ScriptFileName);
            }
        }

        public void AppendHeader()
        {
            Append(Separator);
            Append("-- " + DateTime.Now.ToLongDateString() + NL + "-- " + DateTime.Now.ToLongTimeString() + NL);

            Append(NL);
            Append("IF DB_NAME() NOT LIKE '%guide%'" + NL);
            Append("BEGIN" + NL);
            Append("    RAISERROR ('Are you sure you want to apply this script to a non-guide db?',20,1) WITH LOG;" + NL);
            Append("    RETURN" + NL);
            Append("END" + NL);
        }

        public void AppendSql(string sql)
        {
            Append(Separator);
            Append(sql);
        }

        private void Append(string text)
        {
            File.AppendAllText(ScriptFileName, text);
        }

        private string Separator
        {
            get { return NL + "---------------------------------------------------" + NL; }
        }

        private string NL
        {
            get { return System.Environment.NewLine; }
        }
    }
}
