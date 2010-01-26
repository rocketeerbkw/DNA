using System;
using System.IO;
using System.Xml;
using System.Text.RegularExpressions;
using System.Data;
using System.Data.SqlClient;

namespace updatesp
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class Class1
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static int Main(string[] args)
		{
            bool restoreSnapShot = false;
            bool reCreateSnapShot = false;
            if (args.GetLength(0) > 0)
            {
                restoreSnapShot = args[0].CompareTo("-restoresnapshot") == 0;
                reCreateSnapShot = args[0].CompareTo("-recreatesnapshot") == 0;
            }

            if (args.GetLength(0) > 0 && args[0] == "-V")
            {
                Console.WriteLine("UpdateSP : version " + System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString());
                return 1;
            }

            if ( !restoreSnapShot && !reCreateSnapShot && args.GetLength(0) < 2 )
            {
                Console.WriteLine("UpdateSP : version "+System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString());
                Console.WriteLine("Takes a file containing a db object (stored proc, function, etc), and either updates the object or drops it.");
                Console.WriteLine("\nSyntax 1: updatesp <file> <outputfile>|-drop");
                Console.WriteLine("Syntax 2: updatesp <folder> <outputfolder> [<fileFilter>]");
                Console.WriteLine("Syntax 3: updatesp -restoresnapshot|-recreatesnapshot");
                Console.WriteLine("\nConfiguration file: updatesp.config (lives in same folder as this exe)");
                Console.WriteLine("\nExamples:");
                Console.WriteLine("\nTo update stored procedure mysp.sql:");
                Console.WriteLine(@"  updatesp storedprocedures\mysp.sql storedprocedures\debug\mysp.sql");
                Console.WriteLine("\nTo update all *.sql files in a folder:");
                Console.WriteLine(@"  updatesp storedprocedures storedprocedures\debug");
                Console.WriteLine("\nTo update all dbu_*.sql files in a folder:");
                Console.WriteLine(@"  updatesp storedprocedures storedprocedures\debug dbu_*.sql");
                Console.WriteLine("  (NB: all file names in the folder must match *.sql)");
                Console.WriteLine("\nTo drop stored procedure mysp.sql:");
                Console.WriteLine(@"  updatesp storedprocedures\mysp.sql -drop");
                Console.WriteLine("\nTo restore and recreate snapshots, the config file have corresponding <snapshot> and <snapshotfilename> tags");
                Console.WriteLine("\nTo restore all snapshots specified in the config:");
                Console.WriteLine("   updatesp -restoresnapshot");
                Console.WriteLine("\nTo recreate all snapshots specified in the config:specify -recreatesnapshot:");
                Console.WriteLine("   updatesp -recreatesnapshot");
                return 1;
            }

			int returnCode = 1; // 1 means an error.  Only gets set to 0 if everthing worked
            try
            {
                DataReader dataReader = new DataReader(@"D:\vp-dev-dna-1\User Services\Main\Source\Databases\The Guide\updatesp.config");

                if (restoreSnapShot)
                {
                    dataReader.RestoreSnapShot();
                }
                else if (reCreateSnapShot)
                {
                    dataReader.ReCreateSnapShot();
                }
                else
                {
                    string spfile = args[0];

                    string outputfile = string.Empty;
                    if (args.GetLength(0) > 1)
                        outputfile = args[1];

                    DirectoryInfo dirInfo = new DirectoryInfo(spfile);

                    dataReader.RestoreSnapShot();
                    try
                    {
                        if (dirInfo.Exists)
                        {
                            string fileFilter = "*.sql";
                            if (args.GetLength(0) > 2)
                                fileFilter = args[2];

                            DirectoryInfo outputfolder = new DirectoryInfo(outputfile);
                            if (!outputfolder.Exists)
                            {
                                throw new Exception("The output folder provided does not exist ("+outputfile+")");
                            }
                            UpdateFolder(dataReader, dirInfo, outputfolder, fileFilter);
                        }
                        else
                        {
                            UpdateFile(dataReader, spfile, outputfile);
                        }
                    }
                    catch (Exception)
                    {
                        dataReader.RestoreSnapShot();
                        throw;
                    }
                    dataReader.ReCreateSnapShot();
                }

                returnCode = 0; // 1 means OK.  If we get this far, then hurah!
            }
            catch (SqlException e)
            {
                Console.WriteLine("");
                Console.WriteLine(e.Message);
                Console.WriteLine("Error number: "+e.Number);
                Console.WriteLine("");
                Console.WriteLine(e.ToString());
            }
            catch (Exception e)
            {
                Console.WriteLine("");
                Console.WriteLine(e.Message);
                Console.WriteLine("");
                Console.WriteLine(e.ToString());
            }

            return returnCode;
		}

        static void UpdateFolder(DataReader dataReader, DirectoryInfo dirInfo, DirectoryInfo outputfolder, string fileFilter)
        {
            if (dirInfo.FullName.Equals(outputfolder.FullName,StringComparison.OrdinalIgnoreCase))
            {
                throw new Exception("The source folder and output folder must be different");
            }

            FileInfo[] files = dirInfo.GetFiles(fileFilter);

            foreach (FileInfo finfo in files)
            {
                string spfile = finfo.Name;
                string outputfile = Path.Combine(outputfolder.FullName,spfile);
                UpdateFile(dataReader, finfo.FullName, outputfile);
            }
        }

        static void UpdateFile(DataReader dataReader, string spfile, string outputfile)
        {
            if (outputfile.ToLower().CompareTo("-drop") != 0)
            {
                Console.WriteLine("Updating " + spfile + " ...");
                if (true)//dataReader.IsObjectInDbOutOfDate(spfile))
                {
                    DbObject dbObject = DbObject.CreateDbObject(spfile, dataReader);
                    dbObject.RegisterObject();

                    TextWriter tw = new StreamWriter(new FileStream(outputfile, FileMode.OpenOrCreate));
                    tw.WriteLine(DateTime.Now.ToLongDateString());
                    tw.WriteLine(DateTime.Now.ToLongTimeString());
                    tw.Close();

                    Console.WriteLine(dbObject.SqlCommandMsgs);
                    Console.WriteLine("Updated " + spfile + " OK");
                }
                else
                {
                    Console.WriteLine("Object definition for {0} is up to date.  Skipping update",spfile);
                }
            }
            else
            {
                DbObject dbObject = DbObject.CreateDbObject(spfile, dataReader);
                Console.WriteLine("Dropping " + spfile + " ...");
                dbObject.DropObject();
                Console.WriteLine(dbObject.SqlCommandMsgs);
                Console.WriteLine("Dropped " + spfile + " OK");
            }
            Console.WriteLine("");
        }
	}
}