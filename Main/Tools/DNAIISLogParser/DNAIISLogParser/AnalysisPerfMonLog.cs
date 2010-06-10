
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
using System.Text.RegularExpressions;

namespace DNAIISLogParser
{
    public class AnalysisPerfMonLog : AnalyseLog
    {
        private string logType = "PERFMON";

        public AnalysisPerfMonLog(string fileprefix, string directory)
        {
            outputlog = String.Format("{0}\\{1}_{2}_{3}", directory, logType, fileprefix, ConfigurationManager.AppSettings["OutputFilename"]);
            ResetOutputFile();
        }

        public override void GetStats(string fileName)
        {
            if (!File.Exists(fileName))
            {
                throw new Exception("File not found");
            }

            //get ripley stats
            string query = string.Format("SELECT * " +
                        " FROM '{0}'", fileName);
            ProcessRecordset(query, fileName);
        }

        protected override void ProcessRecordset(string query, string fileName)
        {
            using (StreamWriter stream = new StreamWriter(outputlog, true))
            {
                LogQuery logQuery = new LogQuery();
                
                COMTSVInputContextClassClass tsvInputFormat = new COMTSVInputContextClassClass();
                LogRecordSet recordSet = logQuery.Execute(query, tsvInputFormat);

                if (newOutput)
                {
                    stream.Write(String.Format("Date{0}Machine{1}Type{2}Instance{3}Counter{4}Value",delimiter,delimiter,delimiter,delimiter,delimiter));
                    stream.Write(stream.NewLine);
                    newOutput = false;
                }

                string[] counterTitles = new string[recordSet.getColumnCount()-3];
                int j = 0;
                for (int i = 3; i < recordSet.getColumnCount()-4; i++)
                {
                    string machine = "", type = "", instance = "", counter = "";
                    if(ParseCounter(recordSet.getColumnName(i), ref machine, ref type, ref instance, ref counter))
                    {
                        counterTitles[j] = String.Format("{0}{1}{2}{3}{4}{5}{6}{7}{8}{9}{10}",
                            "{0}", delimiter, machine, delimiter, type, delimiter, instance, delimiter, counter, delimiter, "{1}");
                    }
                    j++;
                }

                //read log file
                while (!recordSet.atEnd())
                {
                    j = 0;
                    for (int i = 3; i < recordSet.getColumnCount()-4; i++)
                    {
                        if (!String.IsNullOrEmpty(recordSet.getRecord().getValue(i).ToString().Replace("\"", "").Trim()))
                        {
                            DateTime date = DateTime.Parse(recordSet.getRecord().getValue(2).ToString().Replace("\"", ""));
                            string dateStr = date.ToString("yyyy-MM-dd hh:mm:ss");
                            string value = recordSet.getRecord().getValue(i).ToString().Replace("\"", "");
                            stream.WriteLine(String.Format(counterTitles[j], dateStr, value));
                            
                        }
                        j++;
                    }
                    
                    recordSet.moveNext();
                }
                stream.Flush();
                
            }
            ImportToDatabase();
        }

        public void ImportToDatabase()
        {
            if (ConfigurationManager.AppSettings["AddToDatabase"] == "1")
            {
                using (StreamReader stream = new StreamReader(outputlog))
                {
                    //read the first line
                    stream.ReadLine();

                    string line = stream.ReadLine();
                    while (!String.IsNullOrEmpty(line))
                    {
                        string[] items = line.Split('\t');
                        if (items.Length == 6)
                        {
                            using (IDnaDataReader dataReader = StoredProcedureReader.Create("perfMonWrite"))
                            {

                                dataReader.AddParameter("@date", DateTime.Parse(items[0]));
                                dataReader.AddParameter("@machine_name", items[1]);
                                dataReader.AddParameter("@perf_type", items[2]);
                                dataReader.AddParameter("@perf_instance", items[3]);
                                dataReader.AddParameter("@perf_counter", items[4]);
                                dataReader.AddParameter("@value", Double.Parse(items[5]));
                                dataReader.Execute();
                            }
                        }
                        line = stream.ReadLine();
                    }
                }
            }
        }

        //"\\GUIDE6-1\PhysicalDisk(1 G:)\Avg. Disk Queue Length"
        private Regex _regex = new Regex(@"\\\\(.+)\\(.+)\((.+)\)\\(.+)$");
        private bool ParseCounter(string counterStr, ref string machine, ref string type, ref string instance, ref string counter)
        {
            counterStr = counterStr.Replace("\"", "");
            Match match = _regex.Match(counterStr);
            if (match.Success)
            {
                machine =  match.Groups[1].Value;
                type = match.Groups[2].Value;
                instance = match.Groups[3].Value;
                counter = match.Groups[4].Value;
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}

