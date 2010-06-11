using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MSUtil;
using LogQuery = MSUtil.LogQueryClassClass;
using IISLogInputFormat = MSUtil.COMIISW3CInputContextClassClass;
using LogRecordSet = MSUtil.ILogRecordset;
using System.IO;
using System.Configuration;
using BBC.Dna.Data;

namespace DNAIISLogParser
{
    public class AnalyseLog
    {
        protected string outputlog = "";
        protected bool newOutput = false;
        protected string delimiter = "\t";

        public AnalyseLog()
        {
            
            
        }

        protected void ResetOutputFile()
        {
            if (File.Exists(outputlog))
            {
                File.Delete(outputlog);
            }
            File.Create(outputlog).Close();

            newOutput = true;
        }

        public virtual void GetStats(string fileName){}

        protected virtual void ProcessRecordset(string query, string fileName){}

        public virtual void ImportToDatabase(ILogRecord record, DateTime date) { }
    }
}

