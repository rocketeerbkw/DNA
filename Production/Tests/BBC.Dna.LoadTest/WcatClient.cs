using System;
using System.Diagnostics;
using System.IO;
using System.Threading;

namespace BBC.Dna.LoadTest
{
    public class WcatClient
    {
        public bool IsComplete = false;
        private readonly string _workingDirectory;
        public WcatClient(string workDirectory)
        {
            _workingDirectory = workDirectory + @"..\WCAT Client\";
        }

        public void Start()
        {
            var output = "";
            var error = "";
            try
            {


                var client = new ProcessStartInfo();
                client.WorkingDirectory = _workingDirectory;
                client.FileName = _workingDirectory + "wcclient.exe";
                client.Arguments = "local.bbc.co.uk";
                client.RedirectStandardOutput = true;
                client.RedirectStandardError = true;
                client.WindowStyle = ProcessWindowStyle.Hidden;
                client.UseShellExecute = false;
                var process = Process.Start(client);
                while (!process.HasExited)
                {
                    //Thread.Sleep(1000);
                }
                output = process.StandardOutput.ReadToEnd();
                error = process.StandardError.ReadToEnd();
                

                
                
            }
            catch (Exception e)
            {
                error += "\r\nException thrown:\r\nMessage:" + e.Message + "\r\nSource:" + e.Source + "\r\nTrace:" +
                         e.StackTrace;
            }
            finally
            {
                LoggingHelper.WriteSection("WCAT CLIENT CONSOLE OUTPUT", output + Environment.NewLine + error);

                IsComplete = true;
            }
        }
        
    }
}