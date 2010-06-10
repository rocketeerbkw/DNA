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
    public class AnalysisIISLog : AnalyseLog
    {
        private string logType = "IIS";
        private string _directory = "";
        private string _fileprefix = "";
        private string _machineName = "";


        public AnalysisIISLog(string fileprefix, string directory)
        {
            _fileprefix = fileprefix;
            _directory = directory;
        }

        public override void GetStats(string fileName)
        {
            string query = String.Format("select distinct s-computername as ComputerName FROM {0}", fileName);
            LogRecordSet recordSet = null;
            try
            {
                
                LogQuery logQuery = new LogQuery();
                IISLogInputFormat iisInputFormat = new IISLogInputFormat();
                recordSet = logQuery.Execute(query, iisInputFormat);
                _machineName = recordSet.getRecord().getValue("ComputerName").ToString();

                outputlog = String.Format("{0}\\{1}_{2}_{3}_{4}", _directory, _machineName, logType, _fileprefix, ConfigurationManager.AppSettings["OutputFilename"]);
                ResetOutputFile();

                if (!File.Exists(fileName))
                {
                    throw new Exception("File not found");
                }
            }
            finally
            {
                if (recordSet != null)
                {
                    recordSet.close();
                    recordSet = null;
                }
            }

            //get ripley stats
            query = string.Format("SELECT STRCAT(  TO_STRING(date, 'yyyy-MM-dd '), TO_STRING( QUANTIZE( time, 3600 ), 'hh:mm:ss')  ) AS DateTime, " +
                        " s-computername as ComputerName, "  +
                        " cs-method as Method, " +
                        " sc-status as Status, " +
                        " TO_UPPERCASE(STRCAT( cs-uri-stem,  STRCAT('?', SUBSTR(cs-uri-query, 0, INDEX_OF(cs-uri-query,'?') ) ) ))  as URL," +
                        " count(*) as Count, " +
                        " MAX(time-taken) as Max, MIN(time-taken) as Min, AVG(time-taken) as Avg, " +
                        " TO_UPPERCASE(EXTRACT_VALUE(cs-uri-query, '_si')) as Site" +
                        " FROM {0} " +
                        " where TO_UPPERCASE(EXTRACT_EXTENSION( cs-uri-stem ))='DLL'" +
                        " group by DateTime, URL, Method, ComputerName, Site, Status", fileName);
            ProcessRecordset(query, fileName);


            query = string.Format("SELECT STRCAT(  TO_STRING(date, 'yyyy-MM-dd '), TO_STRING(QUANTIZE( time, 3600 ), 'hh:mm:ss')  ) AS DateTime, " +
                        " s-computername as ComputerName, " +
                        " cs-method as Method, " +
                        " sc-status as Status, " +
                        " TO_UPPERCASE( SUBSTR(cs-uri-stem, LAST_INDEX_OF(cs-uri-stem, '/')))  as URL, " +
                        " count(*) as Count, " +
                        " MAX(time-taken) as Max, MIN(time-taken) as Min, AVG(time-taken) as Avg, " +
                        " TO_UPPERCASE(EXTRACT_VALUE(cs-uri-query, '_si')) as Site" +
                        " FROM {0} " +
                        " where TO_UPPERCASE(EXTRACT_EXTENSION( cs-uri-stem ))='ASPX'" +
                        " group by DateTime, URL, Method, ComputerName, Site, Status", fileName);
            ProcessRecordset(query, fileName);
        }

        protected override void ProcessRecordset(string query, string fileName)
        {
            using (StreamWriter stream = new StreamWriter(outputlog, true))
            {
                LogQuery logQuery = new LogQuery();
                IISLogInputFormat iisInputFormat = new IISLogInputFormat();
                LogRecordSet recordSet = logQuery.Execute(query, iisInputFormat);

                if (newOutput)
                {
                    for (int i = 0; i < recordSet.getColumnCount(); i++)
                    {
                        stream.Write(recordSet.getColumnName(i) + delimiter);
                    }
                    newOutput = false;
                    stream.Write(stream.NewLine);
                }
                //read log file
                while (!recordSet.atEnd())
                {
                    DateTime logDate = DateTime.Parse(recordSet.getRecord().getValue("DateTime").ToString());
                    stream.WriteLine(recordSet.getRecord().toNativeString(delimiter));
                    stream.Flush();
                    ImportToDatabase(recordSet.getRecord(), logDate);
                    recordSet.moveNext();
                }
                recordSet.close();
                recordSet = null;
            }

        }

        public override void ImportToDatabase(ILogRecord record, DateTime date)
        {
            if (ConfigurationManager.AppSettings["AddToDatabase"] == "1")
            {
                using(IDnaDataReader dataReader = StoredProcedureReader.Create("impressionswrite"))
                {

                    dataReader.AddParameter("@date", DateTime.Parse(record.getValue("DateTime").ToString()));
                    dataReader.AddParameter("@machine_name", record.getValue("ComputerName"));
                    dataReader.AddParameter("@http_method", record.getValue("Method"));
                    dataReader.AddParameter("@http_status", record.getValue("Status"));
                    dataReader.AddParameter("@url", record.getValue("URL"));
                    dataReader.AddParameter("@site", String.IsNullOrEmpty(record.getValue("Site").ToString()) ? "UNKNOWN" : record.getValue("Site").ToString());
                    dataReader.AddParameter("@count", Int32.Parse(record.getValue("count").ToString()));
                    dataReader.AddParameter("@min", Int32.Parse(record.getValue("min").ToString()));
                    dataReader.AddParameter("@max", Int32.Parse(record.getValue("max").ToString()));
                    dataReader.AddParameter("@avg", Int32.Parse(record.getValue("avg").ToString()));
                    dataReader.Execute();
                }   
            }
        }
    }
}

