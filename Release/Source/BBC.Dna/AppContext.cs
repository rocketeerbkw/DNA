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
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using BBC.Dna.Users;
using BBC.Dna.Moderation;
using System.Diagnostics;

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
        /// The DNA Cache manager get property
        /// Used to cache objects as defined by the config cache settings
        /// </summary>
        public static ICacheManager DnaCacheManager { get { return _dnaCacheManager; } }
        private static ICacheManager _dnaCacheManager;

        /// <summary>
        /// 
        /// </summary>
        public static List<string> BannedCookies
        {
            get { return AppContext._bannedCoookies; }
        }

        /// <summary>
        /// 
        /// </summary>
        public List<string> BannedUserAgents
        {
            get;
            private set;
        }

		/// <summary>
		/// Designed to be called once at application Start-up
		/// </summary>
		/// <param name="rootPath">The folder that's the root of the application</param>
		public static void OnDnaStartup(string rootPath)
		{
#if DEBUG
            /**************************************
             *                                    *
             *    DEBUGGING FROM THE WORD GO!     *
             *                                    *
             **************************************/
             System.Diagnostics.Debugger.Launch();
#endif
			_appContext = new AppContext(rootPath);

            _dnaCacheManager = CacheFactory.GetCacheManager();
		    

			DnaDiagnostics.Initialise(TheAppContext.Config.InputLogFilePath, "DNALOG");
#if DEBUG
			DnaDiagnostics.WriteHeader("OnDnaStartup - DEBUG");
#else
                DnaDiagnostics.WriteHeader("OnDnaStartup - RELEASE");
#endif

			Statistics.InitialiseIfEmpty(null,false);

            //load the smiley list
            SmileyTranslator.LoadSmileys(ReaderCreator);

            ICacheManager cacheMemcachedManager = null;
            try
            {
                cacheMemcachedManager = CacheFactory.GetCacheManager("Memcached");
            }
            catch (Exception error)
            {
                DnaDiagnostics.Default.WriteWarningToLog("OnDnaStartup", "Unable to use memcached cachemanager - falling back to static inmemory");
                DnaDiagnostics.Default.WriteExceptionToLog(error);
                cacheMemcachedManager = new StaticCacheManager();
            }

            //new signal objects below here
            _appContext.TheSiteList = new SiteList(AppContext.ReaderCreator, DnaDiagnostics.Default, cacheMemcachedManager, TheAppContext._dnaConfig.RipleyServerAddresses, TheAppContext._dnaConfig.DotNetServerAddresses);
            var bannedEmails = new BannedEmails(AppContext.ReaderCreator, DnaDiagnostics.Default, cacheMemcachedManager, TheAppContext._dnaConfig.RipleyServerAddresses, TheAppContext._dnaConfig.DotNetServerAddresses);
            var userGroups = new UserGroups(AppContext.ReaderCreator, DnaDiagnostics.Default, cacheMemcachedManager, TheAppContext._dnaConfig.RipleyServerAddresses, TheAppContext._dnaConfig.DotNetServerAddresses);
            var profanityFilter = new ProfanityFilter(AppContext.ReaderCreator, DnaDiagnostics.Default, cacheMemcachedManager, TheAppContext._dnaConfig.RipleyServerAddresses, TheAppContext._dnaConfig.DotNetServerAddresses);
            var moderationClasses = new ModerationClassListCache(AppContext.ReaderCreator, DnaDiagnostics.Default, cacheMemcachedManager, TheAppContext._dnaConfig.RipleyServerAddresses, TheAppContext._dnaConfig.DotNetServerAddresses);

            // Setup the banned user agents list
            InitialiseBannedUserAgents();
		}

        private static void InitialiseBannedUserAgents()
        {
            _appContext.BannedUserAgents = new List<string>();
            string bannedUserAgentsString = TheAppContext.Config.BannedUserAgentsString;
            if (bannedUserAgentsString.Length > 0)
            {
                foreach (string agent in bannedUserAgentsString.Split('|'))
                {
                    _appContext.BannedUserAgents.Add(agent);
                }
            }
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
        private AllowedURLs _allowedURLs = null;

		/// <summary>
		/// Creates an AppContext, given the root path of the app, where it can find config info
		/// </summary>
		/// <param name="rootPath">Path where app lives</param>
		public AppContext(string rootPath)
		{
			_dnaConfig = new DnaConfig(rootPath);
			//_dnaConfig.Initialise();
			_dnaAppDiagnostics = new DnaDiagnostics(-1, DateTime.Now);

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
			get;set;
		}


		private bool IsSitelistEmpty()
		{
            return (TheSiteList == null);
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
            return TheSiteList.GetSiteOptionValueInt(siteId, section, name);
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
            return TheSiteList.GetSiteOptionValueBool(siteId, section, name);
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
            return TheSiteList.GetSiteOptionValueString(siteId, section, name);
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
