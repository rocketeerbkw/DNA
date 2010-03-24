using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace SkinsChecker
{
    public class CommandLineTester : IOutputReporting
    {
        private string _skinFile = "";
        private string _xmlFile = "";
        private bool _logtoFile = false;
        private bool _errorsOnly = false;
        private bool _recursiveScan = false;
        private bool _xslt2 = false;
        private string _logFileDirectory = System.Environment.CurrentDirectory;
        
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="args">The args passed in on start up</param>
        public CommandLineTester(string[] args)
        {
            SetupFromCommandLineArgs(args); 
        }

        /// <summary>
        /// Checks the passed in args for expected values
        /// </summary>
        /// <param name="args">The args passed in at startup</param>
        private void SetupFromCommandLineArgs(string[] args)
        {
            // Check to make sure that we have all the command line args needed to run tests.
            // We need the minimum of just a skin file and Xml file to run the tests.
            foreach (string arg in args)
            {
                if (arg.ToLower().Contains("/xsltfile:"))
                {
                    _skinFile = arg.Substring(10);
                }
                else if (arg.ToLower().Contains("/xmlfile:"))
                {
                    _xmlFile = arg.Substring(9);
                }
                else if (arg.ToLower().Contains("/logtofile:"))
                {
                    _logtoFile = true;
                    _logFileDirectory = arg.Substring(11);
                }
                else if (arg.ToLower().Contains("/errorsonly"))
                {
                    _errorsOnly = true;
                }
                else if (arg.ToLower().Contains("/recursivescan"))
                {
                    _recursiveScan = true;
                }
                else if (arg.ToLower().Contains("/xslt2"))
                {
                    _xslt2 = true;
                }
                else if (arg.ToLower().CompareTo("/help") == 0 || arg.ToLower().CompareTo("/?") == 0)
                {
                    WriteOutputText("");
                    WriteOutputText("*** DNA Skin Checker ***");
                    WriteOutputText("");
                    WriteOutputText("This tool is used to test xslt against XML for compilation errors.");
                    WriteOutputText("The default success return value is 1. If an error is found, then the return value is 0.");
                    WriteOutputText("Any errors will be reported in the log file if specified to.");
                    WriteOutputText("All stages of the testing are echoed to the console.");
                    WriteOutputText("");
                    WriteOutputText("Skin Checker takes the following command line args...");
                    WriteOutputText("");
                    WriteOutputText("   /xsltfile:###   - The full pathname to the xslt file or testfile. (*.xsl, *.txs)");
                    WriteOutputText("   /xmlfile:###    - The full pathname to the xml file or testfile. (*.xml, *.txm)");
                    WriteOutputText("   /logtofile:###  - Optional flag to tell skin checker to log the results. ### is the folder that");
                    WriteOutputText("                     you want the log file to be written to.");
                    WriteOutputText("                     If empty, it will create a subfolder in the folder it is run from named Logs.");
                    WriteOutputText("   /errorsonly     - Optional flag to state that you only want to see errors and failed tests only.");
                    WriteOutputText("   /commandline    - Optional flag to state that test should be run in command line mode. (No GUI)");
                    WriteOutputText("   /autorun        - Optional flag for GUI mode that states that tests should be automatically run on startup.");
                    WriteOutputText("                     This requires the /xsltfile and /xmlfile args to be set as well.");
                    WriteOutputText("   /recursivescan  - Optional flag that means the SkinChecker will recursively scan for files of the given");
                    WriteOutputText(@"                     name and type down the given folder. e.g c:\inetpub\wwwroot\h2g2\skins\output.xsl will");
                    WriteOutputText("                     scan for all files called output.xsl in skins folder and all subfolders.");
                    WriteOutputText("   /xslt2          - Optional flag to state that you want to use the Xslt 2.0 transformer instead of 1.0");
                    WriteOutputText("");
                    WriteOutputText("*.txs files contain line seperated lists of full pathnames to xslt files to test against.");
                    WriteOutputText("*.txm files contain line seperated lists of full pathnames to xml files to test against.");
                    WriteOutputText("If a *.txs or *.txm file contains invalid files, tests will still be run on the valid files if any.");
                }
            }
        }

        /// <summary>
        /// This method setup up TestSetup object which runs the tests against the given files
        /// </summary>
        /// <returns>A flag that states whether or not the test produced an error or not</returns>
        public bool RunTests()
        {
            bool errors = false;
            TestSetup test = new TestSetup(this, _logtoFile, _errorsOnly, _xslt2);
            
            // Check to see if we are wanting to recursive scan down given folders
            if (_recursiveScan)
            {
                test.RecursiveScan = true;
            }

            if (test.ReadSetupFiles(_skinFile, _xmlFile))
            {
                test.RunTests();
            }
            errors = test.ErrorCount > 0;

            // Let them know if we've had errors
            return errors;
        }

        /// <summary>
        /// This method writes output text to the console.
        /// </summary>
        /// <param name="text">The text you want to output</param>
        public void WriteOutputText(string text)
        {
            Console.WriteLine(text);
        }

        /// <summary>
        /// does nothing
        /// </summary>
        /// <param name="text"></param>
        public void SetRunningText(string text)
        {
        }

        /// <summary>
        /// Get property for the log file directory
        /// </summary>
        public string LogFileDirectory
        {
            get { return _logFileDirectory; }
        }
    }
}
