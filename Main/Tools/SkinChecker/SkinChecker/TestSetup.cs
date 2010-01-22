using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.IO;
using System.Timers;

namespace SkinsChecker
{
    public class TestSetup
    {
        private List<string> _xsltTestList = null;
        private List<string> _xmlTestList = null;
        private string _xmlTestText = "";
        private bool _useXmlTestText = false;
        private bool _errorsOnly = false;
        private bool _writeTolog = false;
        StreamWriter _logFile = null;
        private int _numberOfErrors = 0;
        private int _numberOfTestsRun = 0;
        private int _totalNumberOfFiles = 0;
        private int _numberOfFileErrors = 0;
        private bool _recursiveScan = false;
        private bool _xslt2 = false;
        IOutputReporting _parent = null;

        enum WriteLogType
        {
            Normal = 0,
            Test,
            Error,
            File,
            ConsoleNewLine,
            Result,
            testpassed,
            testsfailed,
            totaltests
        }

        private bool _timerOn = false;
        private Timer _timer = new System.Timers.Timer(300);
        private string _RunningText = "Running...";

        private void StartTimer()
        {
            _timer.Start();
            _timerOn = true;
            _timer.Elapsed += new ElapsedEventHandler(_timer_Elapsed);
        }

        private void _timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            _RunningText = _RunningText.Substring(1) + _RunningText.Substring(0,1);
            _parent.SetRunningText(_RunningText);

            if (_timerOn)
            {
                _timer.Start();
            }
        }

        private void StopTimer()
        {
            _timer.Stop();
            _timerOn = false;
            _parent.SetRunningText("Run Tests");
        }

        public void AbortTests()
        {
            StopTimer();
            WriteErrorOutputText("Tests Aborted");
            CloseLogFile();
        }

        /// <summary>
        /// Get Set Property for the use xml text for testing.
        /// </summary>
        public bool UseXmlTestText
        {
            get { return _useXmlTestText; }
            set { _useXmlTestText = value; }
        }

        /// <summary>
        /// Get Set Property for the xml text to test with
        /// </summary>
        public string XmlTestText
        {
            get { return _xmlTestText; }
            set { _xmlTestText = value; }
        }

        /// <summary>
        /// Get set property to state whether or not to recursivly scan down given folders for files
        /// </summary>
        public bool RecursiveScan
        {
            get { return _recursiveScan; }
            set { _recursiveScan = value; }
        }

        /// <summary>
        /// Get property for the number of errors that testing found
        /// </summary>
        public int ErrorCount
        {
            get { return _numberOfErrors; }
        }

        /// <summary>
        /// Creates a new log file to log the results of the tests to
        /// </summary>
        private void CreateLogFile()
        {
            StringBuilder logFileName = new StringBuilder("SkinCheckerLogFile.log");
            try
            {
                string logDirectory = _parent.LogFileDirectory + @"\Logs\";
                if (!Directory.Exists(logDirectory))
                {
                    Directory.CreateDirectory(logDirectory);
                }

                _logFile = File.CreateText(logDirectory + logFileName.ToString());
                _logFile.AutoFlush = true;
                _logFile.WriteLine("<skinchecker>");
                WriteOutputText("Writing results to log file - " + logDirectory + logFileName.ToString(), WriteLogType.Normal);
            }
            catch (Exception ex)
            {
                _writeTolog = false;
                WriteErrorOutputText("Failed to create the log file - " + ex.Message);
                _logFile = null;
            }
        }

        /// <summary>
        /// Closes the current log file if one is open.
        /// </summary>
        private void CloseLogFile()
        {
            if (_logFile != null)
            {
                _logFile.WriteLine("</skinchecker>");
                _logFile.Close();
                _logFile.Dispose();
                _logFile = null;
            }
        }

        /// <summary>
        /// Creates the TestSetup classs
        /// </summary>
        /// <param name="parent">The parent object that supports the IOutputReporting interface.</param>
        /// <param name="writeToLog">A flag to state that we are wanting to write the results to a log file.</param>
        /// <param name="reportErrorsOnly">A flag to state that you want to see errors only being reported.</param>
        public TestSetup(IOutputReporting parent, bool writeToLog, bool reportErrorsOnly, bool xslt2)
        {
            _parent = parent;
            _writeTolog = writeToLog;
            _errorsOnly = reportErrorsOnly;
            _xslt2 = xslt2;

            // Check to see if we need to setup logging?
            if (_writeTolog)
            {
                CreateLogFile();
            }
        }

        /// <summary>
        /// Reads the specified files for the test setup
        /// </summary>
        /// <param name="xsltTestFile">The xslt file to test, or a file containing a list of xslt files to test.</param>
        /// <param name="xmlTestFile">The XML file to test against, or a file containing a list of XML files to test against.</param>
        /// <returns>True if setup went ok, false if not</returns>
        public bool ReadSetupFiles(string xsltTestFile, string xmlTestFile)
        {
            // Reset counters
            _numberOfErrors = 0;
            _numberOfTestsRun = 0;

            WriteOutputText("Starting tests - " + DateTime.Now.ToShortTimeString() + " " + DateTime.Now.ToShortDateString(), WriteLogType.Normal);
            WriteOutputNewLine();
            if (_xslt2)
            {
                WriteOutputText("Using Xslt 2.0 transforms", WriteLogType.Normal);
            }
            else
            {
                WriteOutputText("Using Xslt 1.0 transforms", WriteLogType.Normal);
            }
            WriteOutputNewLine();

            // Check to see if we're being given a single xslt file or a txs file.
            // txs files contain a list of skin files to test in one go.
            _xsltTestList = new List<string>();
            if (xsltTestFile.EndsWith(".txs"))
            {
                // Read the list of supplied files.
                LoadTestFile(xsltTestFile, _xsltTestList);
            }
            else
            {
                // Check to see if we're doing a recursive search. The given file might not exist in the given folder,
                // but may do in subfolders. Don't check to make sure it exists
                if (RecursiveScan)
                {
                    RecursiveAddFiles(xsltTestFile, _xsltTestList);
                }
                // Just add the specified skin file
                else if (!File.Exists(xsltTestFile))
                {
                    WriteErrorOutputText("The specified XSLT file does not exist - " + xsltTestFile);
                    _numberOfFileErrors++;
                }
                else
                {
                    _xsltTestList.Add(xsltTestFile);
                }
                _totalNumberOfFiles++;
            }

            // Check to see if we're being given a single xml file or a txm file.
            // txm files contain a list of xml files to test in one go.
            _xmlTestList = new List<string>();
            if (xmlTestFile.EndsWith(".txm"))
            {
                LoadTestFile(xmlTestFile, _xmlTestList);
            }
            else
            {
                // Just add the specified skin file
                if (!xmlTestFile.Contains("http://") && !File.Exists(xmlTestFile))
                {
                    WriteErrorOutputText("The specified XML file does not exist - " + xmlTestFile);
                    _numberOfFileErrors++;
                }
                else
                {
                    _xmlTestList.Add(xmlTestFile);
                }
                _totalNumberOfFiles++;
            }
            WriteOutputNewLine();

            return _numberOfErrors == 0;
        }
        
        /// <summary>
        /// The main method that takes the given files and runs the tests
        /// </summary>
        public void RunTests()
        {
            StartTimer();

            // Check to make sure that we're ready to rock and roll
            if (_numberOfErrors > 0)
            {
                WriteErrorOutputText("There have been errors while setting up the tests. Please call TestSetup() before running the tests.");
                StopTimer();
                return;
            }

            TestSkinFile test = new TestSkinFile(_xslt2);
            if (_useXmlTestText)
            {
                // Go through each test file in turn.
                foreach (string xsltFile in _xsltTestList)
                {
                    int currentErrorCount = _numberOfErrors;
                    StringBuilder testReport = new StringBuilder();
                    testReport.AppendLine("Testing Xslt file - " + xsltFile);
                    testReport.AppendLine("Using typed in XML.");
                    testReport.AppendLine(test.RunTestsWithSuppliedXML(xsltFile, _xmlTestText, ref _numberOfErrors));
                    if (currentErrorCount < _numberOfErrors)
                    {
                        WriteErrorOutputText(testReport.ToString());
                    }
                    else
                    {
                        WriteOutputText(testReport.ToString(), WriteLogType.Test);
                    }
                    _numberOfTestsRun++;
                }
            }
            else
            {
                // Go through each test file in turn.
                foreach (string xsltFile in _xsltTestList)
                {
                    foreach (string xmlFile in _xmlTestList)
                    {
                        int currentErrorCount = _numberOfErrors;
                        StringBuilder testReport = new StringBuilder();
                        testReport.AppendLine("Testing Xslt file - " + xsltFile);
                        testReport.AppendLine("Using XML file - " + xmlFile);
                        testReport.AppendLine(test.RunTestsWithXMLFile(xsltFile, xmlFile, ref _numberOfErrors));
                        if (currentErrorCount < _numberOfErrors)
                        {
                            WriteErrorOutputText(testReport.ToString());
                        }
                        else
                        {
                            WriteOutputText(testReport.ToString(), WriteLogType.Test);
                        }
                        _numberOfTestsRun++;
                    }
                }
            }

            WriteOutputText(_numberOfTestsRun.ToString(), WriteLogType.totaltests);
            WriteOutputText(Convert.ToInt32(_numberOfTestsRun - _numberOfErrors).ToString(), WriteLogType.testpassed);
            WriteOutputText(_numberOfErrors.ToString(), WriteLogType.testsfailed);

            WriteOutputText("Total files - " + _totalNumberOfFiles.ToString() + ". File errors - " + _numberOfFileErrors.ToString(), WriteLogType.Result);
            WriteOutputText("Finished - " + DateTime.Now.ToShortTimeString() + " " + DateTime.Now.ToShortDateString(), WriteLogType.Normal);
            WriteOutputNewLine();
            WriteOutputNewLine();
            WriteOutputText("", WriteLogType.Normal);
            CloseLogFile();

            StopTimer();
        }

        /// <summary>
        /// Loads the list file and adds all the files to the given list
        /// </summary>
        /// <param name="testListFileName">The name of the list files that contains the test files</param>
        /// <param name="testFiles">The list that will take the names of the files to test</param>
        private void LoadTestFile(string testListFileName, List<string> testFiles)
        {
            WriteOutputText("Reading setup files from " + testListFileName, WriteLogType.Normal);
            try
            {
                foreach (string file in File.ReadAllLines(testListFileName))
                {
                    bool isURL = file.Contains("http://");
                    if (!file.StartsWith("#") && (file.Contains(".xsl") || file.Contains(".xml") || isURL))
                    {
                        if (!isURL && !File.Exists(file))
                        {
                            WriteErrorOutputText("File does not exist - " + file);
                            _numberOfFileErrors++;
                        }
                        else
                        {
                            WriteOutputText(file, WriteLogType.File);
                            testFiles.Add(file);
                        }
                        _totalNumberOfFiles++;
                    }
                }
            }
            catch (Exception ex)
            {
                WriteErrorOutputText("Error!!! - " + ex.Message);
            }
            WriteOutputNewLine();
        }

        /// <summary>
        /// Starting at the given Folder, this method recursively scans the folder and subfolders for all
        /// files that match the given file name.
        /// </summary>
        /// <param name="testFolderFileName">The folder to start looking down and the filename to search for</param>
        /// <param name="testFiles">The list that all valid files will be added to</param>
        private void RecursiveAddFiles(string testFolderFileName, List<string> testFiles)
        {
            // First check to make sure that base folde exists
            try
            {
                string baseFolder = testFolderFileName.Substring(0, testFolderFileName.LastIndexOf(@"\"));
                string fileName = testFolderFileName.Substring(testFolderFileName.LastIndexOf(@"\") + 1);
                if (Directory.Exists(baseFolder))
                {
                    ScanAndAddRecursive(baseFolder, fileName, testFiles);
                }
                else
                {
                    WriteErrorOutputText("Error!!! - Given staring folder '" + baseFolder + "' does not exist!");
                }
            }
            catch (Exception ex)
            {
                WriteErrorOutputText("Error!!! - " + ex.Message);
            }
        }

        /// <summary>
        /// Scans a folder subtree for files of the name and adds them to a list
        /// </summary>
        /// <param name="folder">The folder to start looking in</param>
        /// <param name="fileName">The file name to look for</param>
        /// <param name="testFiles">The list to add the found files to</param>
        private void ScanAndAddRecursive(string folder, string fileName, List<string> testFiles)
        {
            // Does the file exist in this folder?
            string filePathAndName = folder + @"\" + fileName;
            if (File.Exists(filePathAndName))
            {
                WriteOutputText(filePathAndName, WriteLogType.File);
                testFiles.Add(filePathAndName);
                _totalNumberOfFiles++;
            }

            // Check subfolders
            foreach (string subFolder in Directory.GetDirectories(folder))
            {
                ScanAndAddRecursive(subFolder, fileName, testFiles);
            }
        }

        private void WriteErrorOutputText(string errorText)
        {
            WriteOutputText("ERROR : " + errorText, WriteLogType.Error);
        }

        private void WriteOutputNewLine()
        {
            WriteOutputText("", WriteLogType.ConsoleNewLine);
        }

        /// <summary>
        /// Writes the given text to the output.
        /// </summary>
        /// <param name="text">The text you want to output.</param>
        private void WriteOutputText(string text, WriteLogType type)
        {
            // Call the parents output method. Turn it into a new line
            if (type == WriteLogType.Result || 
                type == WriteLogType.Error ||
                type == WriteLogType.File ||
                type == WriteLogType.Normal ||
                type == WriteLogType.totaltests ||
                type == WriteLogType.testsfailed ||
                type == WriteLogType.testpassed ||
                (!_errorsOnly && type == WriteLogType.Test))
            {
                if (type == WriteLogType.totaltests)
                {
                    _parent.WriteOutputText("Total tests run - " + text + "\r\n");
                }
                else if (type == WriteLogType.testsfailed)
                {
                    _parent.WriteOutputText("Total tests failed - " + text + "\r\n");
                }
                else if (type == WriteLogType.testpassed)
                {
                    _parent.WriteOutputText("Total tests passed - " + text + "\r\n");
                }
                else
                {
                    _parent.WriteOutputText(text + "\r\n");
                }

                if (_writeTolog && _logFile != null && type != WriteLogType.ConsoleNewLine)
                {
                    string reportTest = "";
                    if (type == WriteLogType.File)
                    {
                        reportTest = "<file>{0}</file>";
                    }
                    else if (type == WriteLogType.Test)
                    {
                        reportTest = "<test>{0}</test>";
                    }
                    else if (type == WriteLogType.Error)
                    {
                        reportTest = "<Error>{0}</Error>";
                    }
                    else if (type == WriteLogType.Normal)
                    {
                        reportTest = "<info>{0}</info>";
                    }
                    else if (type == WriteLogType.Result)
                    {
                        reportTest = "<result>{0}</result>";
                    }
                    else if (type == WriteLogType.totaltests)
                    {
                        reportTest = "<totaltests>{0}</totaltests>";
                    }
                    else if (type == WriteLogType.testsfailed)
                    {
                        reportTest = "<testsfailed>{0}</testsfailed>";
                    }
                    else if (type == WriteLogType.testpassed)
                    {
                        reportTest = "<testspassed>{0}</testspassed>";
                    }

                    _logFile.WriteLine(new StringBuilder().AppendFormat(reportTest, HttpUtility.HtmlEncode(text)).ToString());
                }
            }
        }
    }
}
