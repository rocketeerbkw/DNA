using System;
using System.Diagnostics;
using System.IO;
using System.Threading;

namespace BBC.Dna.LoadTest
{
    public class WcatServer
    {
        private readonly int _warmUpTime;
        private readonly int _duration;
        private readonly int _coolDownTime;
        private const int ClientMachines = 1;
        private const int ClientThreads = 50;
        private readonly string _testName;
        private readonly string _workingDirectory;
        private readonly string _outputFolder;
        private readonly int _runTime;
        private readonly string _server;
        private readonly string _serverName;
        
        public bool IsComplete;


        public WcatServer(string workingDirectory, string testName, int warmUpTime, int duration, int coolDownTime, string outputFolder, string server, string serverName)
        {
            _workingDirectory = workingDirectory;
            _warmUpTime = warmUpTime;
            _duration = duration;
            _coolDownTime = coolDownTime;
            _testName = testName;
            _outputFolder = outputFolder;
            _server = server;
            _serverName = serverName;
            _runTime =  (_duration + _warmUpTime + _coolDownTime+2) * 1000;
        }

        public void Start()
        {
            var output = "";
            var error = "";
            try
            {


                

                var server = new ProcessStartInfo();
                server.WorkingDirectory = _workingDirectory;
                server.FileName = _workingDirectory + "wcctl.exe";
                server.Arguments= string.Format(
                         "-a 10.152.4.15 -d \"{0}\" -s \"{1}\" -l \"{2}\" -x \"{3}\" -m {4} -t {5} -w {6}s -u {7}s -f {8}s -c \"{9}\" -p \"{10}\" -n {11}",
                         _workingDirectory + _testName + "\\distribution.txt",
                         _workingDirectory + _testName + "\\script.txt",
                         _workingDirectory + _outputFolder + "log",
                         _workingDirectory + _outputFolder + "log",
                         ClientMachines, 
                         ClientThreads, 
                         _warmUpTime, 
                         _duration, 
                         _coolDownTime, 
                         _workingDirectory + "config.txt",
                         _workingDirectory + "perfmon.txt",
                         _serverName
                         );
                

                //Console.Write("Arguments:" + server.Arguments);
                server.WindowStyle = ProcessWindowStyle.Hidden;
                server.RedirectStandardOutput = true;
                server.RedirectStandardError = true;
                server.UseShellExecute = false;
                var process = Process.Start(server);
                  
                while(!process.HasExited)
                {
                    
                    //Thread.Sleep(1000);
                }
                output += process.StandardOutput.ReadToEnd();
                error += process.StandardError.ReadToEnd();
                
            }
            catch(Exception e)
            {
                error += "\r\nException thrown:\r\nMessage:" + e.Message + "\r\nSource:" + e.Source + "\r\nTrace:" +
                         e.StackTrace;
            }
            finally
            {
                LoggingHelper.WriteSection("WCAT SERVER CONSOLE OUTPUT", output + Environment.NewLine + error);
                
                IsComplete = true;

                var write = File.CreateText(_workingDirectory + _outputFolder + "serveroutput.txt");
                write.Write(output);
                write.Write(error);
                write.Close();
            }

        }


    }
}
