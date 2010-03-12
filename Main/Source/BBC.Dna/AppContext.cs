using System;
using System.IO;
using System.Configuration;
using System.Web.Configuration;
using System.Collections.Generic;
using System.Text;
using System.Net;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using BBC.Dna.Objects;
using BBC.Dna.Groups;

namespace BBC.Dna
{
	/// <summary>
	/// An application-wide context.  Contains configuration, site lists, etc
	/// </summary>
	public class AppContext : IAppContext
	{
		private static AppContext _appContext;
        private static List<string> _bannedCoookies = new List<string>();
        /// <summary>
        /// The creator of all database readers...
        /// </summary>
        public static IDnaDataReaderCreator ReaderCreator{get;set;}

        /// <summary>
        /// 
        /// </summary>
        public static List<string> BannedCookies
        {
            get { return AppContext._bannedCoookies; }
        }

		/// <summary>
		/// Designed to be called once at application Start-up
		/// </summary>
		/// <param name="rootPath">The folder that's the root of the application</param>
		public static void OnDnaStartup(string rootPath)
		{
			_appContext = new AppContext(rootPath);

			DnaDiagnostics.Initialise(TheAppContext.Config.InputLogFilePath, "DNALOG");
#if DEBUG
			DnaDiagnostics.WriteHeader("OnDnaStartup - DEBUG");
#else
                DnaDiagnostics.WriteHeader("OnDnaStartup - RELEASE");
#endif

			Statistics.InitialiseIfEmpty(/*TheAppContext*/);

            //load the smiley list
            
            SmileyTranslator.LoadSmileys(ReaderCreator);
            ProfanityFilter.InitialiseProfanities(AppContext.ReaderCreator, TheAppContext._dnaAppDiagnostics);
            Groups.UserGroups userGroups = new Groups.UserGroups(_appContext._dnaConfig.ConnectionString, null);
		    userGroups.InitialiseAllUsersAndGroups();
		}

		/// <summary>
		/// The instance of the AppContext that's created on application start-up
		/// </summary>
		public static AppContext TheAppContext
		{
			get { return _appContext; }
		}

		private DnaDiagnostics _dnaAppDiagnostics;
		private DnaConfig _dnaConfig;
		private int _maximumRequestCount = 50;
        private ISiteList _siteList = null;
        private AllowedURLs _allowedURLs = null;

		/// <summary>
		/// Creates an AppContext, given the root path of the app, where it can find config info
		/// </summary>
		/// <param name="rootPath">Path where app lives</param>
		public AppContext(string rootPath)
		{
			_dnaConfig = new DnaConfig(rootPath);
			//_dnaConfig.Initialise();
			_dnaAppDiagnostics = new DnaDiagnostics(0, DateTime.Now);

			if (WebConfigurationManager.AppSettings["maxrequests"] != null)
			{
				_maximumRequestCount = Convert.ToInt32(WebConfigurationManager.AppSettings["maxrequests"]);
			}
            ReaderCreator = new DnaDataReaderCreator(_dnaConfig.ConnectionString, _dnaAppDiagnostics);
		}

		/// <summary>
		/// The SiteList for the application
		/// </summary>
		public ISiteList TheSiteList
		{
			get { return _siteList; }
		}

		private static object _createSiteListLock = new object();

		private void InitialiseSiteList(object context)
		{
            _siteList = SiteList.GetSiteList(ReaderCreator, _dnaAppDiagnostics, true);
            if (context == null)
            {
                context = _appContext;
            }
			((IAppContext)context).Diagnostics.WriteToLog("Initialisation", "Initialised SiteList");
		}

		private bool IsSitelistEmpty()
		{
			return (_siteList == null);
		}

        /// <summary>
        /// The SiteList for the application
        /// </summary>
        public IAllowedURLs AllowedURLs
        {
            get { return _allowedURLs; }
        }

        private static object _createAllowedURLsLock = new object();

        private void InitialiseAllowedURLs(object context)
        {
            AllowedURLs allowedURLs = new AllowedURLs();
            allowedURLs.LoadAllowedURLLists((IAppContext)context);
            _allowedURLs = allowedURLs;
            ((IAppContext)context).Diagnostics.WriteToLog("Initialisation", "Initialised AllowedURLs");
        }

        private bool IsAllowedURLsInitialised()
        {
            return (_allowedURLs == null);
        }

		/// <summary>
		/// Maximum number of concurrent requests
		/// </summary>
		public int MaximumRequestCount
		{
			get { return _maximumRequestCount; }
		}

		/// <summary>
		/// The configuration of the application
		/// </summary>
		public DnaConfig Config
		{
			get { return _dnaConfig; }
		}

		/// <summary>
		/// Create a DnaDataReader for this input context.
		/// </summary>
		/// <param name="name">Name passed to DnaDataReader constructor</param>
		/// <returns>Instance of a DnaDataReader.</returns>
		public IDnaDataReader CreateDnaDataReader(string name)
		{
			return CreateDnaDataReader(name, Diagnostics);
		}

		/// <summary>
		/// Create a DnaDataReader for this input context.
		/// </summary>
		/// <param name="name">Name passed to DnaDataReader constructor</param>
		/// <param name="dnaDiagnostics">The diagnostics object that's used for log writing</param>
		/// <returns>Instance of a DnaDataReader.</returns>
		public IDnaDataReader CreateDnaDataReader(string name, IDnaDiagnostics dnaDiagnostics)
		{
			return StoredProcedureReader.Create(name, _dnaConfig.ConnectionString, dnaDiagnostics);
		}

		/// <summary>
		/// Get Profile Connection Details property. Just returns the web.config Connection Strings
		/// </summary>
		public ConnectionStringSettingsCollection GetConnectionDetails
		{
			get
			{
				return WebConfigurationManager.ConnectionStrings;
			}
		}

		/// <summary>
		/// All diagnostics should be written through this instance of IDnaDiagnostics
		/// </summary>
		/// <see cref="IDnaDiagnostics"/>
		/// <remarks>It's this object that implements log writing</remarks>
		public IDnaDiagnostics Diagnostics
		{
			get
			{
				return _dnaAppDiagnostics;
			}
		}

		/// <summary>
		/// Escapes a string safely for use in URLs
		/// </summary>
		/// <param name="text">text to escape</param>
		/// <returns>Escaped version of the text</returns>
		public string UrlEscape(string text)
		{
			return Uri.EscapeDataString(text);
		}

		/// <summary>
		/// Ensures that the site list data is created and loaded. Can be called to reload the data from the database
		/// with the recacheData flag set to true.
		/// </summary>
		/// <param name="context">The context</param>
		/// <param name="recacheData">Set to true will create a new list and replace the old. False will just ensure that there is a valid list to use</param>
		public void EnsureSiteListExists(bool recacheData, IAppContext context)
		{
			Locking.InitialiseOrRefresh(_createSiteListLock, InitialiseSiteList, IsSitelistEmpty, recacheData, context);

		}

        /// <summary>
        /// Ensures that the allowed url list data is created and loaded. Can be called to reload the data from the database
        /// with the recacheData flag set to true.
        /// </summary>
        /// <param name="context">The context</param>
        /// <param name="recacheData">Set to true will create a new list and replace the old. False will just ensure that there is a valid list to use</param>
        public void EnsureAllowedURLsExists(bool recacheData, IAppContext context)
        {
            Locking.InitialiseOrRefresh(_createAllowedURLsLock, InitialiseAllowedURLs, IsAllowedURLsInitialised, recacheData, context);
        }

		/// <summary>
		/// Sends a control signal to all the other front end servers. Used for recaching site data and the likes.
		/// </summary>
		/// <param name="signal">The action that you want to perform. This should not contain the page as this will be different
		/// between the ripley and .net applications. The function itself takes care of this.\n
		/// Current actions supported are...\n
		/// 'action=recache-site' - This recaches all the site information.\n
		/// 'action=recache-groups' - This recaches the groups information.</param>
		public void SendSignal(string signal)
		{
			// Make sue the requested signal does not contain any page specific information, as we need to call both the .net and ripley
			// versions of the signal builder. Get everything after the first ? if it exists
			signal = signal.Substring(signal.IndexOf('?') + 1);

			// Go through each ripley server sending the signal.
			foreach (string address in _dnaConfig.RipleyServerAddresses)
			{
				// Send the signal to the selected server
				SendSignalToServer(address, "signal?" + signal + "&skin=purexml", false);
			}

			// Go through each .net server sending the signal.
			foreach (string address in _dnaConfig.DotNetServerAddresses)
			{
				// Send the signal to the selected server
                SendSignalToServer(address, "dnasignal?action=" + signal + "&skin=purexml", false);
                SendSignalToServer(address, signal, true);
            }
		}

		/// <summary>
		/// Send a given signal to a given server
		/// </summary>
		/// <param name="serverName">the ip or name of the server to send the signal to</param>
		/// <param name="signal">The action you want to perform</param>
        /// <param name="APIsignal">When false, the signal is sent to the h2g2 site, if true, then it sends it to the Status page of the commnets API</param>
		private void SendSignalToServer(string serverName, string signal, bool APIsignal)
		{
			// Setup the request to send the signal action
            string request = "";
            if (APIsignal)
            {
                request = "http://" + serverName + "/dna/api/comments/status.aspx?action=" + signal;
            }
            else
            {
                request = "http://" + serverName + "/dna/h2g2/" + signal;
            }
			Uri URL = new Uri(request);
			HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
			try
			{
				// Try to send the request and get the response
				webRequest.GetResponse();
			}
			catch (Exception ex)
			{
				// Problems!
				Diagnostics.WriteWarningToLog("Signal", "Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
			}
		}

		/// <summary>
		/// Property to get the CurrentServerName
		/// </summary>
		public string CurrentServerName
		{
			get
			{
				return Environment.MachineName;
			}
		}

        /// <summary>
        /// Is the server this instance is running on a dev server?  This property reveals all
        /// </summary>
        public bool IsRunningOnDevServer
        {
            get
            {
                return CurrentServerName.ToLower().StartsWith("ops-dna");
            }
        }

		/// <summary>
		/// Gets the given int site option for the given site
		/// </summary>
		/// <param name="siteId">The site id</param>
		/// <param name="section">Site option section</param>
		/// <param name="name">Site option name</param>
		/// <returns></returns>
		/// <exception cref="SiteOptionNotFoundException"></exception>
		/// <exception cref="SiteOptionInvalidTypeException"></exception>
		public int GetSiteOptionValueInt(int siteId, string section, string name)
		{
			return _siteList.GetSiteOptionValueInt(siteId, section, name);
		}

		/// <summary>
		/// Gets the given bool site option for the current site
		/// </summary>
		/// <param name="siteId">The site id</param>
		/// <param name="section">Site option section</param>
		/// <param name="name">Site option name</param>
		/// <returns></returns>
		/// <exception cref="SiteOptionNotFoundException"></exception>
		/// <exception cref="SiteOptionInvalidTypeException"></exception>
		public bool GetSiteOptionValueBool(int siteId, string section, string name)
		{
			return _siteList.GetSiteOptionValueBool(siteId, section, name);
		}

		/// <summary>
        /// Gets the given string site option for the current site
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public string GetSiteOptionValueString(int siteId, string section, string name)
        {
            return _siteList.GetSiteOptionValueString(siteId, section, name);
        }

		/// <summary>
		/// <see cref="IAppContext"/>
		/// </summary>
		public bool FileCacheGetItem(string cacheName, string itemName, ref DateTime expires, ref string XMLText)
		{
			return FileCache.GetItem(_dnaConfig.CachePath, cacheName, itemName, ref expires, ref XMLText);
		}

		/// <summary>
		/// Put a cache item into the file cache
		/// </summary>
		/// <param name="cacheName">Name of cache directory</param>
		/// <param name="itemName">name of cache file</param>
		/// <param name="text">Text to store in the cache file</param>
		/// <returns></returns>
		public bool FileCachePutItem(string cacheName, string itemName, string text)
		{
			return FileCache.PutItem(_dnaConfig.CachePath, cacheName, itemName, text);
		}

        /// <summary>
        /// Invalidates a particular Cache Item.
        /// </summary>
        /// <param name="cacheName"></param>
        /// <param name="itemName"></param>
        /// <returns></returns>
        public bool FileCacheInvalidateItem(string cacheName, string itemName)
        {
            return FileCache.InvalidateItem(_dnaConfig.CachePath, cacheName, itemName);
        }

	}
}
