using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace DnaCacheFileDel
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Console.Write("DnaCacheFileDel: ");
                Console.WriteLine("Version : " + System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString());

                if (args.GetLength(0) < 3)
                {
                    Console.WriteLine("Syntax: DnaCacheFileDel <rootFolder> <filePattern> <minsOld> [<delayBetweenDelsInMilliseconds>]");
                    Console.WriteLine(@"E.g.: DnaCacheFileDel c:\cache *.txt 60");
                    return;
                }

                string srcFolder = args[0];
                if (!Directory.Exists(srcFolder))
                {
                    Console.WriteLine("Folder {0} does not exist", srcFolder);
                    return;
                }

                string filePattern = args[1];

                int minsOld;
                if (!int.TryParse(args[2], out minsOld))
                {
                    Console.WriteLine("Argument <minsOld> needs to be a number");
                    return;
                }

                int delayBetweenDels = 0;
                if (args.GetLength(0) >= 4)
                {
                    if (!int.TryParse(args[3],out delayBetweenDels))
                    {
                        Console.WriteLine("Argument <delayBetweenDelsInMilliseconds> needs to be a number");
                        return;
                    }
                }

                Console.WriteLine("Deleting files from {0} that are more than {1} minute(s) old", srcFolder, minsOld);

                if (delayBetweenDels > 0)
                    Console.WriteLine("Delay between deletes is {0}ms",delayBetweenDels);

                DateTime startTime = DateTime.Now;

                Dictionary<string, int> dirCount = new Dictionary<string, int>();
                Dictionary<string, int> dirDeleteCount = new Dictionary<string, int>();

                string[] files = Directory.GetFiles(srcFolder, filePattern, SearchOption.AllDirectories);
                int totalFileCount = files.GetLength(0);

                Console.WriteLine("Looking at {0} files matching pattern {1}", totalFileCount, filePattern);

                int delFileCount = 0;
                foreach (string file in files)
                {
                    try
                    {
                        string dir = Path.GetDirectoryName(file);

                        if (!dirCount.ContainsKey(dir))
                        {
                            dirCount.Add(dir, 0);
                        }
                        dirCount[dir] += 1;

                        DateTime lastWrite = File.GetLastWriteTime(file);
                        DateTime timeToCompare = lastWrite.AddMinutes(minsOld);

                        if (DateTime.Compare(timeToCompare, DateTime.Now) < 0)
                        {
                            File.Delete(file);

                            if (delFileCount++ % 1000 == 0)
                                Console.WriteLine("File {0} deleted: {1}", delFileCount, file);

                            if (!dirDeleteCount.ContainsKey(dir))
                            {
                                dirDeleteCount.Add(dir, 0);
                            }
                            dirDeleteCount[dir] += 1;

                            if (delayBetweenDels > 0)
                                System.Threading.Thread.Sleep(delayBetweenDels);
                        }
                    }
                    catch (Exception e)
                    {
                        OutputExeception(file,e);
                    }
                }

                foreach (KeyValuePair<string, int> kvp in dirCount)
                {
                    string dir = kvp.Key;
                    int dirTotal = kvp.Value;
                    int numDeleted = 0;
                    dirDeleteCount.TryGetValue(dir, out numDeleted);

                    int percentage = 0;
                    if (dirTotal > 0)
                        percentage = (numDeleted * 100) / dirTotal;

                    Console.WriteLine("Deleted {0} files from {1}.  Folder total {2} ({3}%)", numDeleted, dir, dirTotal, percentage);
                }
                Console.WriteLine("Total files deleted: {0}", delFileCount.ToString());

                DateTime endTime = DateTime.Now;
                TimeSpan ts = endTime - startTime;

                Console.WriteLine("Started {0}, Ended {1}", startTime.ToString(), endTime.ToString());
                Console.WriteLine("Took {0} hours, {1} minutes, {2} seconds", ts.Hours, ts.Minutes, ts.Seconds);
            }
            catch (Exception e)
            {
                OutputExeception("<no file specified>",e);
            }
        }

        static void OutputExeception(string file,Exception e)
        {
            Console.WriteLine("*****************************************");
            Console.WriteLine("Exception.  File = "+file);
            Console.WriteLine(e.ToString());
            Console.WriteLine("*****************************************");
        }
    }
}
