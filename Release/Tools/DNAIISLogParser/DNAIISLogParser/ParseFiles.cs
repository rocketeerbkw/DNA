using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;
using java.util.zip;
using java.util;
using java.io;

namespace DNAIISLogParser
{
    public delegate void InputLogDelegate(object sender, InputLogDebugArgs args);

    public class ParseFiles
    {
        private AnalyseLog anaLog;
        private Regex matchIISLog = new Regex(@"ex[0-9]{6}\.log");
        private Regex matchPerfLog = new Regex(@"DNA System Counters_([0-9])+\.tsv");
        
        public event InputLogDelegate OnDebug;

        public ParseFiles()
        {
        }


        /// <summary>
        /// Scans the directory for the two types of logfiles in directory or zips
        /// </summary>
        /// <returns>Next logfile date to be scanned (this date should be passed back for the next one)</returns>
        /// <param name="directory"></param>
        public void ScanDirectory(string directory)
        {
            DirectoryInfo directoryInfo = new DirectoryInfo(directory);
            if (directoryInfo == null || !directoryInfo.Exists)
            {
                DebugMessage("Unable to open directory or directory does not exist");
                return;
            }

            //set up regex's
            
            foreach(DirectoryInfo subDir in directoryInfo.GetDirectories())
            {
                ScanDirectory(subDir.FullName);
            }
            //go through files and look for relevant log files/zip files
            foreach (FileInfo logFile in directoryInfo.GetFiles())
            {
                
                
                switch (logFile.Extension.ToUpper())
                {
                    //look for log files
                    case ".LOG":
                        try
                        {
                            if (matchIISLog.Match(logFile.Name).Success)
                            {
                                ConsumeIISLog(logFile);
                            }
                            else
                            {
                                DebugMessage(String.Format("Ignoring {0}", logFile.FullName));
                            }
                        }
                        catch (Exception e)
                        {
                            throw e;
                        }

                        GC.Collect();
                        GC.WaitForPendingFinalizers();

                        break;

                    //look for log files
                    case ".TSV":
                        try
                        {
                            if (matchPerfLog.Match(logFile.Name).Success)
                            {
                                ConsumePerfLog(logFile);
                            }
                            else
                            {
                                DebugMessage(String.Format("Ignoring {0}", logFile.FullName));
                            }
                        }
                        catch (Exception e)
                        {
                            throw e;
                        }

                        GC.Collect();
                        GC.WaitForPendingFinalizers();

                        break;

                    //look for zips, then read the zip and look for specific files
                    case ".ZIP":
                        ProcessZipFile(directory, logFile);
                        break;
                }
            }
        }

        public void ProcessFile(FileInfo logFile)
        {
            if (logFile.Extension == ".zip")
            {
                ProcessZipFile(logFile.Directory.FullName, logFile);
            }
            if (matchPerfLog.Match(logFile.Name).Success)
            {
                ConsumePerfLog(logFile);
            }
            if (matchIISLog.Match(logFile.Name).Success)
            {
                ConsumeIISLog(logFile);
            }
            
        }


        public void ProcessZipFile(string directory, FileInfo logFile)
        {
            ZipFile zipfile = new ZipFile(Path.Combine(directory + "\\", logFile.Name));
            try
            {
                List<ZipEntry> zipFiles = GetZipFiles(zipfile);

                foreach (ZipEntry zipEntry in zipFiles)
                {
                    if (!zipEntry.isDirectory())
                    {
                        string zipFileName = zipEntry.getName().Substring(zipEntry.getName().LastIndexOf("/") + 1, zipEntry.getName().Length - zipEntry.getName().LastIndexOf("/") - 1);
                        string zipFileNamePath = zipEntry.getName().Substring(zipEntry.getName().IndexOf("/") + 1, zipEntry.getName().Length - zipEntry.getName().IndexOf("/") - 1);
                        string tempZipFileName = Path.Combine(directory + "\\", zipFileName + ".tmp");
                        try
                        {
                            if (matchPerfLog.Match(zipFileName).Success)
                            {
                                DebugMessage(String.Format("Extracting {0}", zipEntry.getName()));
                                ExtractFile(zipfile, zipEntry, tempZipFileName);
                                FileInfo file = new FileInfo(tempZipFileName);
                                ConsumePerfLog(file);
                            }
                            if (matchIISLog.Match(zipFileName).Success)
                            {
                                DebugMessage(String.Format("Extracting {0}", zipEntry.getName()));
                                ExtractFile(zipfile, zipEntry, tempZipFileName);
                                FileInfo file = new FileInfo(tempZipFileName);
                                ConsumeIISLog(file);
                            }
                        }
                        catch (Exception e)
                        {
                            DebugMessage(e);
                            return;
                        }
                        finally
                        {//clean up after finished processing
                            if (System.IO.File.Exists(tempZipFileName))
                                System.IO.File.Delete(tempZipFileName);
                        }
                    }
                }
            }
            finally
            {

                zipfile.close();
                GC.Collect();
                GC.WaitForPendingFinalizers();
            }
        }

        private void ExtractFile(ZipFile zipFile, ZipEntry zipEntry, string tempFileName)
        {
            InputStream s = zipFile.getInputStream(zipEntry);
            try
            {
                FileOutputStream dest = new FileOutputStream(tempFileName);
                try
                {
                    int len = 0;
                    sbyte[] buffer = new sbyte[7168];
                    while ((len = s.read(buffer)) >= 0)
                    {
                        dest.write(buffer, 0, len);
                    }
                }
                finally
                {
                    dest.close();
                }
            }
            finally
            {
                s.close();
            }

        }

        private List<ZipEntry> GetZipFiles(ZipFile zipfil)
        {
            List<ZipEntry> lstZip = new List<ZipEntry>();
            Enumeration zipEnum = zipfil.entries();
            while (zipEnum.hasMoreElements())
            {
                ZipEntry zip = (ZipEntry)zipEnum.nextElement();
                lstZip.Add(zip);
            }
            return lstZip;
        }

        public void ConsumeIISLog(FileInfo logFile)
        {
            anaLog = new AnalysisIISLog(logFile.Name.Substring(0, logFile.Name.IndexOf(".")), logFile.Directory.ToString());
            DebugMessage(String.Format("Processing {0}", logFile.FullName));
            anaLog.GetStats(logFile.FullName);

        }

        public void ConsumePerfLog(FileInfo logFile)
        {
            anaLog = new AnalysisPerfMonLog(logFile.Name.Substring(0, logFile.Name.IndexOf(".")), logFile.Directory.ToString());
            DebugMessage(String.Format("Processing {0}", logFile.FullName));
            anaLog.GetStats(logFile.FullName);

        }

        protected void DebugMessage(string msg)
        {
            if (OnDebug != null)
            {
                InputLogDebugArgs args = new InputLogDebugArgs();
                args.msg = msg;
                OnDebug(this, args);
            }
            //errorLog += msg + "\r\n";
        }

        protected void DebugMessage(Exception e)
        {
            DebugMessage(string.Format("Exception Thrown\r\n" +
            "Message:{0}\r\n" +
            "Source:{1}\r\n" +
            "Stack:{2}\r\n"
            , e.Message, e.Source, e.StackTrace));
        }
    }

    public class InputLogDebugArgs : EventArgs
    {
        public string msg;
    }
}
