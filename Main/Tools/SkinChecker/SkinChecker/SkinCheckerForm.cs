using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Threading;

namespace SkinsChecker
{
    public partial class SkinCheckerForm : Form, IOutputReporting
    {
        private string _skinFile = "";
        private string _xmlFile = "";
        private bool _autorun = false;
        Thread _splinterThread = null;
        TestSetup _test = null;

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="args">A list of the arguments passed in from startup</param>
        public SkinCheckerForm(string[] args)
        {
            InitializeComponent();
            SetupFromCommandLineArgs(args);
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            if (_splinterThread != null && _splinterThread.IsAlive)
            {
                _splinterThread.Abort();
            }
            base.OnClosing(e);
        }

        /// <summary>
        /// Checks the passed in args for expected values
        /// </summary>
        /// <param name="args">The list of args passed in at startup</param>
        private void SetupFromCommandLineArgs(string[] args)
        {
            // Check to make sure that we have all the command line args needed to run tests.
            // We need the minimum of just a skin file and Xml file to run the tests.
            foreach (string arg in args)
            {
                if (arg.ToLower().Contains("/xsltfile:"))
                {
                    _skinFile = arg.Substring(10);
                    tbSkinFilePath.Text = _skinFile;
                }
                else if (arg.ToLower().Contains("/xmlfile:"))
                {
                    _xmlFile = arg.Substring(9);
                    tbXMLFilePath.Text = _xmlFile;
                }
                else if (arg.ToLower().Contains("/logtofile"))
                {
                    logToFile.Checked = true;
                }
                else if (arg.ToLower().Contains("/autorun"))
                {
                    _autorun = true;
                }
                else if (arg.ToLower().Contains("/recursivescan"))
                {
                    cbRecursiveScan.Checked = true;
                }
                else if (arg.ToLower().Contains("/errorsonly"))
                {
                    cbErrorOnly.Checked = true;
                }
                else if (arg.ToLower().Contains("/xslt2"))
                {
                    cbXslt2.Checked = true;
                }
            }
        }

        /// <summary>
        /// Override of the On activated event. Used to kick off an autorun if specified
        /// </summary>
        /// <param name="e"></param>
        protected override void OnActivated(EventArgs e)
        {
            base.OnActivated(e);
            if (_autorun)
            {
                RunTestSuite();
            }
        }

        /// <summary>
        /// Called when the user clicks the browse for test file
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void browseSkinFile_Click(object sender, EventArgs e)
        {
            // Browse to skin test file
            openSkinFile.ShowDialog();
            openSkinFile.CheckFileExists = false;
            _skinFile = openSkinFile.FileName;
            tbSkinFilePath.Text = _skinFile;
        }

        /// <summary>
        /// Called when the use clicks the browse for XML file
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void browseXMLFile_Click(object sender, EventArgs e)
        {
            // Browse to xml test file
            openXMLFile.ShowDialog();
            _xmlFile = openXMLFile.FileName;
            tbXMLFilePath.Text = _xmlFile;
        }

        /// <summary>
        /// Called when the user clicks the run tests button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void RunTests_Click(object sender, EventArgs e)
        {
            // Run tests
            _skinFile = tbSkinFilePath.Text;
            _xmlFile = tbXMLFilePath.Text;

            if (_splinterThread != null && _splinterThread.IsAlive)
            {
                _test.AbortTests();
                _splinterThread.Abort();
                if (_splinterThread.Join(10000))
                {
                    WriteOutputText("Ready to go...");
                }
                else
                {
                    WriteOutputText("Failed to abort splitter thread!");
                }
            }
            else
            {
                RunTestSuite();
            }
        }

        /// <summary>
        /// Sets up a TestSetup object and runs the tests passing in the given files and settings.
        /// This kicks off on a seperate thread so that the rest of the message queue can be updated
        /// while the tests are running.
        /// </summary>
        private void RunTestSuite()
        {
            _test = new TestSetup(this, logToFile.Checked, cbErrorOnly.Checked, cbXslt2.Checked);
            if (useSuppliedXML.Checked)
            {
                _test.UseXmlTestText = true;
                _test.XmlTestText = tbXMLInput.Text;
            }

            // Check to see if we are wanting to recursive scan down given folders
            if (cbRecursiveScan.Checked)
            {
                _test.RecursiveScan = true;
            }

            // Read the supplied files and run.
            if (_test.ReadSetupFiles(_skinFile, _xmlFile))
            {
                _splinterThread = new Thread(_test.RunTests);
                _splinterThread.Start();
            }
        }

        /// <summary>
        /// Delegate and Interface method for writing output text.
        /// The delegate is used for the multithreading.
        /// </summary>
        /// <param name="text">The text you want to output</param>
        delegate void WriteOutputTextHandler(string text);
        public void WriteOutputText(string text)
        {
            // Check to see if we're running on the same thread as the UI or need to invoke
            if (!InvokeRequired)
            {
                tbResults.AppendText(text);
            }
            else
            {
                WriteOutputTextHandler handler = new WriteOutputTextHandler(WriteOutputText);
                Invoke(handler, new object[] { text });
            }
        }

        /// <summary>
        /// Updates the text in the Run tests button to show tests are running
        /// </summary>
        /// <param name="text">The text you want to display</param>
        delegate void SetRunningTextHandler(string text);
        public void SetRunningText(string text)
        {
            // Check to see if we're running on the same thread as the UI or need to invoke
            if (!InvokeRequired)
            {
                RunTests.Text = text;
            }
            else
            {
                SetRunningTextHandler handler = new SetRunningTextHandler(SetRunningText);
                Invoke(handler, new object[] { text });
            }
        }

        /// <summary>
        /// Get property for the log file directory
        /// </summary>
        public string LogFileDirectory
        {
            get { return Application.StartupPath; }
        }

        /// <summary>
        /// Creates a new bat file from the current settings
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_Click(object sender, EventArgs e)
        {
            // Check to make sure that we have the minimum number of params set
            if (_xmlFile.Length == 0 || _skinFile.Length == 0)
            {
                // We need at least the xml and xslt files
                return;
            }

            // Popup the save dialog for the user to type in the file to create
            saveBatFileDlg.ShowDialog();
            string filePathName = saveBatFileDlg.FileName;

            // Create the cmd line for the current settings
            StringBuilder cmd = new StringBuilder(Application.ExecutablePath);
            cmd.Append(" /xmlfile:\"" + _xmlFile + "\"");
            cmd.Append(" /xsltfile:\"" + _skinFile + "\"");
            cmd.Append(" /commandline");
            if (logToFile.Checked)
            {
                cmd.Append(" /logtofile:" + Application.StartupPath);
            }
            if (cbRecursiveScan.Checked)
            {
                cmd.Append(" /recursivescan");
            }
            if (cbErrorOnly.Checked)
            {
                cmd.Append(" /errorsonly");
            }
            if (cbXslt2.Checked)
            {
                cmd.Append(" /xslt2");
            }

            // Now create the file
            try
            {
                StreamWriter cmdfile = File.CreateText(filePathName);
                cmdfile.WriteLine(cmd.ToString());
                cmdfile.WriteLine("Pause");
                cmdfile.Close();
            }
            catch (Exception ex)
            {
                WriteOutputText("ERROR : Failed to create " + filePathName + ". " + ex.Message);
                return;
            }

            WriteOutputText("Autorun file created - " + filePathName);
        }
    }
}
