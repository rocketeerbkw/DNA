using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Build.Utilities;
using Microsoft.Build.Framework;
using System.IO;
using System.Configuration;
using System.Xml;
using System.Linq;
using System.Xml.Linq;

namespace updatesp
{
	public class UpdateSpTask : Task
	{
		string[] _buildFiles;

		[Required]
		public string[] BuildFiles
		{
			get { return _buildFiles; }
			set { _buildFiles = value; }
		}

        string _buildConfig;

        [Required]
        public string BuildConfig
        {
            get { return _buildConfig; }
            set { _buildConfig = value; }
        }

        string _buildTargetFile;

        [Required]
        public string BuildTargetFile
        {
            get { return _buildTargetFile; }
            set { _buildTargetFile = value; }
        }

        string _tfsBuildDefinition;
        public string TfsBuildDefinition
        {
            get { return _tfsBuildDefinition; }
            set { _tfsBuildDefinition = value; }
        }

        // This attribute can optionally be set during a build.  It is defined as a property
        // in the <UpdateSpTask> tag in the csproj file.
        // It will override any setting defined in machine.config or app.config
        string _updateSpBuildConfigFile;
        public string UpdateSpBuildConfigFile
        {
            get { return _updateSpBuildConfigFile; }
            set { _updateSpBuildConfigFile = value; }
        }

        // OutputScriptFile specifies the file to output the scripts that are run to update the objects
        string _outputScriptFile;
        [Required]
        public string OutputScriptFile
        {
            get { return _outputScriptFile; }
            set { _outputScriptFile = value; }
        }

		public string ResolveConfigFilePath(string tfsBuildDefinition, string buildConfig)
		{
            // Locate the UpdateSp build config fil
            string updatespBuildConfigurationsFile = UpdateSpBuildConfigFile;
            if (updatespBuildConfigurationsFile == null || updatespBuildConfigurationsFile.Length == 0)
            {
                // The build config file has not been passed in during the build, so read the app's config setting
                Log.LogMessage(MessageImportance.High, "Looking for 'updatespBuildConfigurationsFile' in app settings", updatespBuildConfigurationsFile);
                updatespBuildConfigurationsFile = ConfigurationManager.AppSettings["updatespBuildConfigurationsFile"];
            }
            else
            {
                Log.LogMessage(MessageImportance.High, "UpdateSpBuildConfigFile attribute set by build: '{0}'", updatespBuildConfigurationsFile);
            }

            updatespBuildConfigurationsFile = Path.Combine(Environment.CurrentDirectory, updatespBuildConfigurationsFile);
            Log.LogMessage(MessageImportance.High, "Full path to UpdateSp Build Configurations File: '{0}'", updatespBuildConfigurationsFile);

            BuildConfigurationList bcList = new BuildConfigurationList();
            bcList.InitialiseFromFile(updatespBuildConfigurationsFile);
            BuildConfiguration bc = bcList.GetMatchingBuildConfiguration(tfsBuildDefinition, buildConfig);

            if (bc == null)
            {
                string msg = string.Format("Failed to find matching config in file '{0}'.  Looking for TFS Build Definition '{1}' and build configuration '{2}'", updatespBuildConfigurationsFile, tfsBuildDefinition, buildConfig);
                Log.LogMessage(MessageImportance.High, msg);
                throw new Exception(msg);
            }

            string configFile = bc.UpdateConfigFile;
            Log.LogMessage(MessageImportance.High, "UpdateSp Config File for [{0},{1}] is '{2}'", tfsBuildDefinition, buildConfig, configFile);
            configFile = Path.Combine(Environment.CurrentDirectory, configFile);
            Log.LogMessage(MessageImportance.High, "Full path to UpdateSp Config File: '{0}'", configFile);

            return configFile;
		}

        private void LogDatabaseNames(DataReader dataReader)
        {
            string msg = "Databases: ";

            string[] dbNames = dataReader.GetListOfDatabaseNames();
            foreach (string dbName in dbNames)
            {
                msg += dbName + ", ";
            }

            Log.LogMessage(MessageImportance.High, msg.Substring(0, msg.Length - 2));
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
            string configFile = ResolveConfigFilePath(TfsBuildDefinition,BuildConfig);
			DataReader dataReader = new DataReader(configFile);

            ScriptFile scriptFile = PrepareOutputScriptFile(OutputScriptFile);


            LogDatabaseNames(dataReader);
            LogServerNames(dataReader);

			dataReader.RestoreSnapShot();

			foreach (string file in BuildFiles)
			{
				//Log.LogMessage(MessageImportance.High, "Processing: {0}", file);
				DateTime thisFileTime = File.GetLastWriteTime(file);
				if (buildAllFiles || thisFileTime > targetTime)
				{
                    Log.LogMessage(MessageImportance.High, "Processing: {0}", file);
                    if (true)//dataReader.IsObjectInDbOutOfDate(file))
                    {
                        DbObject dbobj = DbObject.CreateDbObject(file, dataReader);

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

                            string sql = sqlScript.ToString();

                            dataReader.ExecuteNonQuery(sql, bIgnoreNotExistForPermissions);
                            if (dataReader.SqlCommandMsgs.Length > 0)
                            {
                                Log.LogMessage(MessageImportance.High, dataReader.SqlCommandMsgs);
                            }
                            scriptFile.AppendSql(sql);
                        }
                        catch (Exception e)
                        {
                            Log.LogError("Error processing " + file + ": " + e.Message);
                            return false;
                        }
                    }
                    else
                    {
                        Log.LogMessage(MessageImportance.High, "Skipping: {0}. Definition in db is up to date (Last Accessed: {1}, Last Modified: {2})", file, File.GetLastAccessTime(file).ToLocalTime().ToString(), File.GetLastAccessTime(file).ToLocalTime().ToString());
                    }
				}
			}


			dataReader.ReCreateSnapShot();

            // Make sure the folder for the build target file exists
            string dir = Path.GetDirectoryName(BuildTargetFile);
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);

			using (StreamWriter writer = new StreamWriter(BuildTargetFile))
			{
			    writer.WriteLine(DateTime.Now.ToString());
			}

			return true;

		}

        ScriptFile PrepareOutputScriptFile(string outputScriptFile)
        {
            outputScriptFile = Path.Combine(Environment.CurrentDirectory, outputScriptFile);
            Log.LogMessage(MessageImportance.High, "OutputScriptFile = " + outputScriptFile);

            string folder = Path.GetDirectoryName(outputScriptFile);
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            ScriptFile scriptFile = new ScriptFile();
            scriptFile.Initialise(outputScriptFile);

            Log.LogMessage(MessageImportance.High, "Deleting '{0}' if it exists....", outputScriptFile);
            scriptFile.DeleteExisting();

            scriptFile.AppendHeader();

            return scriptFile;
        }
	}
}
