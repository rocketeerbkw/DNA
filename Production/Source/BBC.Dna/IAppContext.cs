using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Interface representing all base Dna functionality at the application level
    /// </summary>
    public interface IAppContext
    {
        /// <summary>
        /// Creates concrete instance of a class that implements the IDnaDataReader interface.
        /// The context is responsible for creating the appropriate concrete instance.
        /// </summary>
        /// <param name="name">Name to be passed to the constructor of the concrete IDnaDataReader object.</param>
        /// <returns>IDnaDataReader interface of the concrete instance created.</returns>
        IDnaDataReader CreateDnaDataReader(string name);

        /// <summary>
        /// Creates concrete instance of a class that implements the IDnaDataReader interface.
        /// The context is responsible for creating the appropriate concrete instance.
        /// </summary>
        /// <param name="name">Name to be passed to the constructor of the concrete IDnaDataReader object.</param>
        /// <param name="dnaDiagnostics">The diagnostics object to use for log writing</param>
        /// <returns>IDnaDataReader interface of the concrete instance created.</returns>
        IDnaDataReader CreateDnaDataReader(string name, IDnaDiagnostics dnaDiagnostics);

        /// <summary>
        /// The Get profile connection details property interface
        /// </summary>
        ConnectionStringSettingsCollection GetConnectionDetails
        {
            get;
        }

        /// <summary>
        /// All diagnostics should be written through this instance of IDnaDiagnostics
        /// </summary>
        /// <see cref="IDnaDiagnostics"/>
        IDnaDiagnostics Diagnostics
        {
            get;
        }

        /// <summary>
        /// The SiteList for the app context
        /// </summary>
        ISiteList TheSiteList
        {
            get;
        }

        /// <summary>
        /// The AllowedURLs for the app context
        /// </summary>
        IAllowedURLs AllowedURLs
        {
            get;
        }

        /// <summary>
        /// 
        /// </summary>
        List<string> BannedUserAgents
        {
            get;
        }

        /// <summary>
        /// Escapes the string to make it safe for a URL
        /// </summary>
        /// <param name="text">The text to escape</param>
        /// <returns>an escaped version suitable for using on a URL</returns>
        string UrlEscape(string text);

        /// <summary>
        /// Ensures that the non allowed url list data is created and loaded. Can be called to reload the data from the database
        /// with the recacheData flag set to true.
        /// </summary>
        /// <param name="recacheData">Set to true will create a new list and replace the old. False will just ensure that there is a valid list to use</param>
        /// <param name="context">The context that it's running under</param>
        void EnsureAllowedURLsExists(bool recacheData, IAppContext context);

        /// <summary>
        /// Gets the current machine name
        /// </summary>
        string CurrentServerName
        {
            get;
        }

        /// <summary>
        /// Is the server this instance is running on a dev server?  This property reveals all
        /// </summary>
        bool IsRunningOnDevServer
        {
            get;
        }

        /// <summary>
        /// The maximum number of concurrent requests the app allows
        /// </summary>
        int MaximumRequestCount
        {
            get;
        }

        /// <summary>
        /// Gets the given int site option for the given site
        /// <see cref="SiteOptionList.GetValueInt"/>
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        int GetSiteOptionValueInt(int siteId, string section, string name);

        /// <summary>
        /// Gets the given bool site option for the given site
        /// <see cref="SiteOptionList.GetValueInt"/>
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        bool GetSiteOptionValueBool(int siteId, string section, string name);

		/// <summary>
        /// Gets the given bool site option for the current site
        /// <see cref="SiteOptionList.GetValueString"/>
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        string GetSiteOptionValueString(int siteId, string section, string name);

		/// <summary>
		/// Implementation of the Ripley XML caching method. Stores a string in a file in the RipleyCache folder in a 
		/// subdirectory called pCacheName with the filename pItemName
		/// </summary>
		/// <param name="cacheName">Name of folder in cache</param>
		/// <param name="itemName">name of filename</param>
		/// <param name="expires">earliest date we want from cache - returns with the actual date of the object</param>
		/// <param name="cachedString">Text from cached file</param>
		/// <returns>True if we found an object that's newer than the date passed in</returns>
		bool FileCacheGetItem(string cacheName, string itemName, ref DateTime expires, ref string cachedString);

		/// <summary>
		/// Implementation of the Ripley file caching method
		/// </summary>
		/// <param name="cacheName">Name of folder in cache</param>
		/// <param name="itemName">name of filename</param>
		/// <param name="stringToCache">string of XML to cache</param>
		/// <returns>True if cached successfully</returns>
		bool FileCachePutItem(string cacheName, string itemName, string stringToCache);
    }
}
