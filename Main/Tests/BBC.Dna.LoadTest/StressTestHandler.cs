using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Xml;
using Tests;

namespace BBC.Dna.LoadTest
{
    public class StressTestHandler
    {
        private const string WorkingDirectory = @"C:\Program Files\IIS Resources\WCAT Controller\";
        private const int WarmUpTime = 5;
        private const int Duration = 10;
        private const int CoolDownTime = 5;
        private readonly string _testName;
        private const int RunTime = (Duration + WarmUpTime + CoolDownTime + 5) * 1000;
        private readonly string _outputFolder;
        private readonly string _server;
        private readonly string _serverName;
        private XmlDocument _xmlResults;
        private XmlDocument _prevXmlResults;
        private readonly double _tolerance;

        public StressTestHandler(string testName, string server, string serverName, double tolerance)
        {
            var now = DateTime.Now;
            _testName = testName;
            _outputFolder = now.ToString("yyyyMMdd_HHmm");
            _outputFolder = testName + "\\" + _outputFolder + "\\";
            _server = server;
            _serverName = serverName;
            _tolerance = tolerance;
        }

        public void MakeReplacements(Dictionary<string, string> replacements)
        {
            if (replacements == null)
            {
                return;
            }
            var stream = File.OpenText(WorkingDirectory + _testName + "\\script.txt");
            var script = stream.ReadToEnd();
            stream.Close();
            script = replacements.Aggregate(script, (current, replacement) => current.Replace("<!--" + replacement.Key + "-->", replacement.Value));
            script = script.Replace("<!--SERVER-->", _server);
            File.WriteAllText(WorkingDirectory + _testName + "\\script.txt", script);
        }

        public void InitialiseServer()
        {
            SnapshotInitialisation.ForceRestore();
            using (var iis = IIsInitialise.GetIIsInitialise())
            {
                iis.RestartTestSite();
            }

            var request = new DnaTestURLRequest("h2g2");
            //request.RequestPage("status");
            request.RequestPage("status-n");
            request.RequestPageWithFullURL(string.Format("http://{0}/dna/api/comments/status.aspx", DnaTestURLRequest.CurrentServer));

        }

        public void RunTest()
        {
            GetPreviousResults();
            var directoryInfo = new DirectoryInfo(WorkingDirectory + _outputFolder);
            directoryInfo.Create();

            var wcatServer = new WcatServer(WorkingDirectory, _testName, WarmUpTime, Duration, CoolDownTime, _outputFolder, _server, _serverName);
            var wcatServerThread = new Thread(wcatServer.Start);
            wcatServerThread.TrySetApartmentState(ApartmentState.MTA);
            var wcatClient = new WcatClient(WorkingDirectory);
            var wcatClientThread = new Thread(wcatClient.Start);
            wcatClientThread.TrySetApartmentState(ApartmentState.MTA);

            //wcatServerThread.IsBackground = true;
            //wcatClientThread.IsBackground = true;
            wcatServerThread.Start();
            Thread.Sleep(2000);//wait for server to start
            wcatClientThread.Start();
            Thread.Sleep(2000);//wait for client to start
            while (wcatServerThread.ThreadState != ThreadState.Stopped)
            {
                //Thread.Sleep(1000);
            }

            Assert.IsTrue(File.Exists(WorkingDirectory + _outputFolder + "\\log.log"));
            LoggingHelper.WriteFileSection("RUN LOG FILE", WorkingDirectory + _outputFolder + "\\log.log");

            Assert.IsTrue(File.Exists(WorkingDirectory + _outputFolder + "\\log.xml"));
            LoggingHelper.WriteFileSection("RUN XML LOG FILE", WorkingDirectory + _outputFolder + "\\log.xml");
            _xmlResults = new XmlDocument();
            _xmlResults.Load(WorkingDirectory + _outputFolder + "\\log.xml");

            Assert.IsTrue(File.Exists(WorkingDirectory + _outputFolder + "\\log.prf"));
            LoggingHelper.WriteFileSection("RUN PERFMON LOG FILE", WorkingDirectory + _outputFolder + "\\log.prf");

            if (_prevXmlResults == null)
            {
                Assert.Inconclusive("Unable to find previous run");
            }
        }

        private void GetPreviousResults()
        {
            _prevXmlResults = null;
            var dir = (from d in Directory.GetDirectories(WorkingDirectory + _testName, "20*")
                       orderby d descending
                       select d).FirstOrDefault();

            if (dir == null)
            {
                return;
            }

            var xmlDoc = new FileInfo(dir + "\\log.xml");
            if (!xmlDoc.Exists)
            {
                return;
            }
            _prevXmlResults = new XmlDocument();
            _prevXmlResults.Load(dir + "\\log.xml");

            Console.WriteLine("Previous log used for comparison:" + dir);
        }

        public bool DoesRunContainHttpErrors()
        {
            return CheckForErrors(_xmlResults);
        }


        private bool CheckForErrors(XmlDocument xmlResults)
        {
            return xmlResults.SelectSingleNode("//Webcat/Log/Statistics/BadStatusErrors") != null;

        }

        private LoggingHelper _logHelper;
        public void CompareResults()
        {
            var result = CompareStatisticsResults();
            result = result && CompareCounterResults();

            Assert.IsTrue(result);
        }

        private bool CompareStatisticsResults()
        {

            _logHelper = new LoggingHelper("STATISTICS COMPARISON RESULTS");
            _logHelper.Content += string.Format("Counter\tPrevious Run\tCurrent Run*\tResult\r\n");

            var result = false;
            try
            {
                result = CompareStatisticsResult("Http200");
            }
            catch (Exception e)
            {
                _logHelper.WriteToLog();
                throw e;
            }


            _logHelper.Content += string.Format("*plus tolerance amount\r\n");
            _logHelper.WriteToLog();
            return result;
        }

        private bool CompareStatisticsResult(string counter)
        {
            _logHelper.Content += counter + "\t";
            var xPath = string.Format("//Webcat/Log/Statistics/{0}", counter);

            double previousResult = 0;
            if (!double.TryParse(_prevXmlResults.SelectSingleNode(xPath).InnerText, out previousResult))
            {
                previousResult = 0.0;
            }
            _logHelper.Content += previousResult + "\t";

            double currentResult;
            if (!double.TryParse(_xmlResults.SelectSingleNode(xPath).InnerText, out currentResult))
            {
                Assert.Fail("Unable to find value for counter:" + counter);
            }
            currentResult = currentResult * _tolerance;//add tolerance amount
            _logHelper.Content += currentResult + "\t";
            _logHelper.Content += (currentResult >= previousResult) ? "PASSED\t" : "FAILED\t";

            _logHelper.Content += Environment.NewLine;

            return currentResult >= previousResult;

        }

        private bool CompareCounterResults()
        {
            _logHelper = new LoggingHelper("PERFORMANCE COMPARISON RESULTS");
            _logHelper.Content += string.Format("Counter\tPrevious Run\tCurrent Run*\tResult\r\n");

            var result = false;
            try
            {
                result = CompareCounterResult("Processor", "_Total", "% Processor Time", true);
            }
            catch (Exception e)
            {
                _logHelper.WriteToLog();
                throw e;
            }
            _logHelper.Content += string.Format("*plus tolerance amount\r\n");
            _logHelper.WriteToLog();

            return result;
        }

        private bool CompareCounterResult(string obj, string instance, string name, bool reverseComparison)
        {

            _logHelper.Content += string.Format("{0}({1})/{2}", obj, instance, name) + "\t";
            var xPath = string.Format("//Webcat/Log/Counters/Counter[Object = '{0}' and Instance = '{1}' and Name = '{2}']/Average", obj, instance, name);
            double previousResult = 0;
            if (!double.TryParse(_prevXmlResults.SelectSingleNode(xPath).InnerText, out previousResult))
            {
                previousResult = 0.0;
            }
            _logHelper.Content += previousResult + "\t";

            double currentResult;
            if (!double.TryParse(_xmlResults.SelectSingleNode(xPath).InnerText, out currentResult))
            {
                Assert.Fail("Unable to find value for object:" + obj);
            }
            _logHelper.Content += currentResult + "\t";

            var result = false;
            if (reverseComparison)
            {
                result = (currentResult <= previousResult);
            }
            else
            {
                result = (currentResult >= previousResult);
            }

            _logHelper.Content += result ? "PASSED\t" : "FAILED\t";
            _logHelper.Content += Environment.NewLine;

            return result;
        }

    }
}
