using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;
using System.Configuration;

namespace Tests
{
    public class SeleniumTestHarness
    {
        private string _serverStartupString = "\"java\"";
        private string _serverStartupArgs = "-jar selenium-server.jar";
        private Process _runningServer = null;


        public void StartServer()
        {
            _runningServer = new Process();
            _runningServer.StartInfo = new ProcessStartInfo(_serverStartupString, _serverStartupArgs);
            _runningServer.StartInfo.WorkingDirectory = ConfigurationManager.AppSettings["SeleniumRCServerLocation"];
            _runningServer.StartInfo.UseShellExecute = false;
            _runningServer.StartInfo.RedirectStandardOutput = true;
            _runningServer.Start();
        }


        public void StopServer()
        {
            if (_runningServer != null)
            {
                _runningServer.Kill();
                while (!_runningServer.StandardOutput.EndOfStream)
                {
                    Console.WriteLine(_runningServer.StandardOutput.ReadLine());
                }
            }
        }
    }
}
