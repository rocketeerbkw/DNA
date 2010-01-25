using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Build.Utilities;
using Microsoft.Build.Framework;
using System.IO;

namespace updatesp
{
	public class UpdateSpTask : Task
	{
		string[] buildFiles;

		[Required]
		public string[] BuildFiles
		{
			get { return buildFiles; }
			set { buildFiles = value; }
		}

        string buildConfig;

        [Required]
        public string BuildConfig
        {
            get { return buildConfig; }
            set { buildConfig = value; }
        }

        string buildTargetFile;

        [Required]
        public string BuildTargetFile
        {
            get { return buildTargetFile; }
            set { buildTargetFile = value; }
        }

		string config;
		
		[Required]
		public string Config
		{
			get 
            {
                // If it's a "smallguide" build configuration, look for the "smallguide" version of the config
                if (BuildConfig.Contains("SmallGuide"))
                {
                    return config.Replace(".config", "SmallGuide.config");
                }
                else
                    return config; 
            }

			set { config = value; }
		}

        private void LogDatabaseNames(DataReader dataReader)
        {
            string msg = "Databases: ";

            string[] dbNames = dataReader.GetListOfDatabaseNames();
            foreach (string dbName in dbNames)
            {
                msg += dbName + ", ";
            }

            Log.LogMessage(MessageImportance.High, msg.Substring(0,msg.Length-2));
        }

        private void LogServerNames(DataReader dataReader)
        {
            string msg = "Servers: ";
            string[] serverNames = dataReader.GetListOfServers();
            foreach (string serverName in serverNames)
            {
                msg += serverName + ", ";
            }

            Log.LogMessage(MessageImportance.High, msg.Substring(0, msg.Length - 2));
        }

		public override bool Execute()
        {
            Log.LogMessage(MessageImportance.High, "updateSP : version {0}",System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString());

			//DataReader reader = new DataReader("updatesp.config");
			//Log.LogMessage(MessageImportance.High, "Starting spupdate task");
			//Log.LogMessage(MessageImportance.High, "Got target: {0}", buildTargetFile);
			//Log.LogMessage(MessageImportance.High, "Got Config: {0}", config);
			bool buildAllFiles = !File.Exists(BuildTargetFile);

			DateTime targetTime = DateTime.Now;
			if (!buildAllFiles)
			{
				targetTime = File.GetLastWriteTime(BuildTargetFile);
			}
			//Log.LogMessage(MessageImportance.High, "BuildAllFiles = {0}", buildAllFiles);
			if (!buildAllFiles)
			{
				//Log.LogMessage(MessageImportance.High, "target time = {0}", targetTime);
			}

            Log.LogMessage(MessageImportance.High, "Build Configuration: {0}", BuildConfig);
            Log.LogMessage(MessageImportance.High, "UpdateSP's Config File: {0}", Config);

			DataReader dataReader = new DataReader(Config);

            LogDatabaseNames(dataReader);
            LogServerNames(dataReader);

			dataReader.RestoreSnapShot();

			foreach (string file in BuildFiles)
			{
				//Log.LogMessage(MessageImportance.High, "Processing: {0}", file);
				DateTime thisFileTime = File.GetLastWriteTime(file);
				if (buildAllFiles || thisFileTime > targetTime)
				{
					DbObject dbobj = DbObject.CreateDbObject(file, dataReader);
                    if (dbobj.IsObjectInDbOutOfDate())
                    {
                        Log.LogMessage(MessageImportance.High, "Processing: {0}", file);

                        string error = string.Empty;
                        StringBuilder sqlScript = new StringBuilder();
                        if (!dbobj.AppendToBatchScript(sqlScript, ref error))
                        {
                            Log.LogError(error);
                            return false;
                        }
                        try
                        {
                            bool bIgnoreNotExistForPermissions = true;

                            // Do not ignore errors 
                            if (file.Equals("dbupgradescript.sql", StringComparison.OrdinalIgnoreCase))
                                bIgnoreNotExistForPermissions = false;

                            dataReader.ExecuteNonQuery(sqlScript.ToString(), bIgnoreNotExistForPermissions);
                            if (dataReader.SqlCommandMsgs.Length > 0)
                            {
                                Log.LogMessage(MessageImportance.High, dataReader.SqlCommandMsgs);
                            }
                        }
                        catch (Exception e)
                        {
                            Log.LogError("Error processing " + file + ": " + e.Message);
                            return false;
                        }
                    }
                    else
                    {
                        Log.LogMessage(MessageImportance.High, "Skipping: {0}. Definition in db is up to date (Last Accessed: {1}, Last Modified: {2})", dbobj.ObjName, dbobj.FileLastAccessed.ToLocalTime().ToString(), dbobj.FileLastModified.ToLocalTime().ToString());
                    }
				}
			}


			dataReader.ReCreateSnapShot();

			using (StreamWriter writer = new StreamWriter(BuildTargetFile))
			{
			    writer.WriteLine(DateTime.Now.ToString());
			}

			return true;

		}
	}
}
