using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace SkinsChecker
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static int Main(string[] args)
        {
            // Check to see if we're being asked to run in command line mode
            bool runInCommandLineMode = false;
            bool showHelp = false;
            foreach (string arg in args)
            {
                if (arg.ToLower().CompareTo("/commandline") == 0)
                {
                    runInCommandLineMode = true;
                }
                else if (arg.ToLower().CompareTo("/help") == 0 || arg.CompareTo("/?") == 0)
                {
                    showHelp = true;
                }
            }

            // Check to see if we're running in command line mode or displaying help
            if (runInCommandLineMode || showHelp)
            {
                CommandLineTester cmdLineTester = new CommandLineTester(args);
                if (!showHelp && cmdLineTester.RunTests())
                {
                    return 0;
                }
                return 1;
            }
            else
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);
                using (SkinCheckerForm sc = new SkinCheckerForm(args))
                {
                    Application.Run(sc);
                }
                return 1;
            }
        }
    }
}