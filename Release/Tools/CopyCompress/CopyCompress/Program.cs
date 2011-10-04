using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.IO.Compression;
using System.Diagnostics;
using System.Xml.Linq;

namespace CopyCompress
{
    class Program
    {
        static bool _replaceExistingOn = false;
        static bool _compressionOn = true;
        static DateTime? _olderThan = null;
        static bool _moveSrc = false;
        static bool _verbose = false;


        public static void ProcessElements(IEnumerable<XNode> nodes)
        {
            if (nodes == null)
                return;

        }

        public static int Main(string[] args)
        {

            Console.WriteLine("Copy Compress v1.0.1.4");

             if (args.Length < 2)
            {
                Console.WriteLine("Use: Copy Compress <src> <dest> [-r] [-n] [-m] [-v] [-olderthan <n><d|m>]");
                Console.WriteLine("If 'src' is a directory, 'dest' is assumed to be a directory.  'dest' is created if necessary");
                Console.WriteLine("-r means replace destFile if it exists");
                Console.WriteLine("-n means 'no compression' i.e. just copy the file");
                Console.WriteLine("-m means move source files instead of copy");
                Console.WriteLine("-v means verbose output");
                Console.WriteLine("-olderthan <n><d|m> means only process files that have not been *updated* in the last <n> days or months");
                Console.WriteLine("  e.g. '-olderthan 15d' will copy files only if they were last modified more than 15 days ago");
                Console.WriteLine("  e.g. '-olderthan 2m' will copy files only if they were last modified more than 2 months ago");
                return 1;
            }

            try
            {
                string srcFile = args[0], destFile = args[1];
                ProcessArgsOptions(args);

                DateTime start = DateTime.Now;
                Console.WriteLine("Started at {0}", start.ToString());

                int count = 0;

                if (File.Exists(srcFile))
                    CopyFile(srcFile, destFile, _compressionOn, _replaceExistingOn, _olderThan, _moveSrc, ref count);
                else
                {
                    // If it's a directory, assume both
                    if (Directory.Exists(srcFile))
                        CopyDirectory(srcFile, destFile, _compressionOn, _replaceExistingOn, _olderThan, _moveSrc, ref count);
                }

                var t = DateTime.Now-start;
                Console.WriteLine("Copied {0} files", count);
                Console.WriteLine("Took {0} hours {1} mins {2} seconds {3} ms", t.Hours,t.Minutes,t.Seconds,t.Milliseconds);
            }
            catch (Exception ex)
            {
                LogException(ex);
                return 1;
            }

            return 0;
        }

        static void LogException(Exception ex)
        {
            Console.WriteLine(ex.Message);
            Console.WriteLine("");
            Console.WriteLine(ex.ToString());
        }


        static void ProcessArgsOptions(string[] args)
        {
            for (int i = 2; i < args.Length; i++)
            {
                if (args[i].Equals("-r"))
                {
                    _replaceExistingOn = true;
                    Console.WriteLine("Replacing existing files");
                }

                if (args[i].Equals("-n"))
                {
                    _compressionOn = false;
                    Console.WriteLine("Compression is on");
                }

                if (args[i].Equals("-m"))
                {
                    _moveSrc = true;
                    Console.WriteLine("Moving source files to the destination");
                }

                if (args[i].Equals("-v"))
                {
                    _verbose = true;
                    Console.WriteLine("Verbose output on");
                }

                if (args[i].ToLower().Equals("-olderthan"))
                {
                    if (i == args.Length-1)
                        throw new Exception("Missing value after -olderthan");

                    var val = args[++i];

                    if (val.Length < 2)
                        throw new Exception("Invalid value '"+val+"' after -olderthan: ");

                    var dayOrMonth = val[val.Length - 1];
                    var n = int.Parse(val.Substring(0,val.Length-1));
                    var now = DateTime.Now;
                    var midnight = new DateTime(now.Year, now.Month, now.Day);

                    switch (dayOrMonth)
                    {
                        case 'd' : _olderThan = midnight.AddDays(-n); break;
                        case 'm' : _olderThan = midnight.AddMonths(-n); break;
                        default : throw new Exception("Unknown 'olderthan' option "+dayOrMonth);
                    }

                    Console.WriteLine("Copying files older than {0}", _olderThan.ToString());
                }
            }
        }

        static void CopyDirectory(string srcDir, string destDir, bool compress, bool replaceExisting, DateTime? olderThan, bool delSrc, ref int count)
        {
            if (!Directory.Exists(destDir))
                Directory.CreateDirectory(destDir);

            Console.WriteLine("Copying directory " + srcDir + " to " + destDir);

            foreach (var srcFile in Directory.EnumerateFiles(srcDir))
            {
                try
                {
                    string destFile = Path.Combine(destDir, Path.GetFileName(srcFile));

                    // As no explicit file name was given, and we're compressing, add the ".gz" suffix
                    if (compress)
                        destFile += ".gz";

                    CopyFile(srcFile, destFile, compress, replaceExisting, olderThan, delSrc, ref count);
                }
                catch (IOException ex)
                {
                    // An exception we will just report and carry on
                    LogException(ex);
                }
            }

            foreach (var subDir in Directory.EnumerateDirectories(srcDir))
            {
                var newDestDir = Path.Combine(destDir, Path.GetFileName(subDir));

                CopyDirectory(subDir, newDestDir, compress, replaceExisting, olderThan, delSrc, ref count);
            }
        }

        static void CopyFile(string srcFile, string destFile, bool compress, bool replaceExisting, DateTime? olderThan, bool moveSrc, ref int count)
        {
            string tempFileName = null;

            try
            {
                if (olderThan.HasValue)
                {
                    var lastWritten = File.GetLastWriteTime(srcFile);
                    if (lastWritten > olderThan)
                    {
                        OutputVerbose("Skipping file {0} - not old enough", destFile);
                        return;
                    }
                }

                if (File.Exists(destFile))
                {
                    if (!replaceExisting)
                    {
                        throw new Exception(string.Format("File {0} exists.  If you want to replace existing files, call with -r", destFile));
                    }
                    else
                    {
                        tempFileName = GenerateTempFileName(destFile);
                        File.Move(destFile, tempFileName);
                        OutputVerbose("Replacing file "+ destFile);
                    }
                }

                if (compress)
                {
                    OutputVerbose("Compressing "+srcFile+" to "+ destFile);
                    Compress(srcFile, destFile);
                }
                else
                {
                    OutputVerbose("Copying " + srcFile + " to " + destFile);
                    Copy(srcFile, destFile);
                }
                count++;

                if (tempFileName != null)
                    File.Delete(tempFileName);

                if (moveSrc)
                {
                    // If we got here, it's now safe to delete the source now that it's been safely copied
                    File.Delete(srcFile);
                    OutputVerbose("Moved file "+srcFile);
                }
            }
            finally
            {
                // Something went wrong, so put the orig file back if we need to
                if (tempFileName != null && File.Exists(tempFileName))
                {
                    if (File.Exists(destFile))
                        File.Delete(destFile);
                    File.Move(tempFileName,destFile);
                }
            }
        }

        static void OutputVerbose(string format, params object[] p)
        {
            if (_verbose)
                Console.WriteLine(format,p);
        }

        static Random rand = new Random();

        static string GenerateTempFileName(string origFileName)
        {
            string newFileName;
            do
            {
                 newFileName = Path.GetFullPath(origFileName) + "." + rand.Next();
            } while (File.Exists(newFileName));

            return newFileName;
        }


        static void Compress(string srcFile, string destFile)
        {
            var fi = new FileInfo(srcFile);

            // Get the stream of the source file.
            using (FileStream inFile = File.Open(srcFile, FileMode.Open))
            {
                // Create the compressed file.
                using (FileStream outFile = File.Create(destFile))
                {
                    using (GZipStream Compress = new GZipStream(outFile, CompressionMode.Compress))
                    {
                        // Copy the source file into the compression stream.
                        inFile.CopyTo(Compress, 1000000);
                        decimal pctComp = 0;
                        if (fi.Length != 0)
                            pctComp = 100 - (((decimal)outFile.Length / fi.Length) * 100);
                        OutputVerbose("Compressed {0} from {1} to {2} bytes. {3}%", fi.Name, fi.Length.ToString(), outFile.Length.ToString(), pctComp.ToString("N2"));
                    }
                }
            }
        }

        static void Copy(string srcFile, string destFile)
        {
            var fi = new FileInfo(srcFile);

            // Get the stream of the source file.
            using (FileStream inFile = File.Open(srcFile, FileMode.Open))
            {
                // Create the compressed file.
                using (FileStream outFile = File.Create(destFile))
                {
                    // Copy the source file into the compression stream.
                    inFile.CopyTo(outFile, 1000000);
                }
            }
        }
    }
}
