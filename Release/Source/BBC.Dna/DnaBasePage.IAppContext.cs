using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.Web.Configuration;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna.Page
{
    /// <summary>
    /// Summary description for DnaBasePage
    /// </summary>
    public partial class DnaBasePage : IInputContext, IOutputContext
    {
        /// <summary>
        /// Create a DnaDataReader for this input context.
        /// </summary>
        /// <param name="name">Name passed to DnaDataReader constructor</param>
        /// <returns>Instance of a DnaDataReader.</returns>
        public IDnaDataReader CreateDnaDataReader(string name)
        {
            return AppContext.TheAppContext.CreateDnaDataReader(name, Diagnostics);
        }

        /// <summary>
        /// Create a DnaDataReader for this input context.
        /// </summary>
        /// <param name="name">Name passed to DnaDataReader constructor</param>
        /// <param name="dnaDiagnostics">The diagnostics object to use for log writing</param>
        /// <returns>Instance of a DnaDataReader.</returns>
        public IDnaDataReader CreateDnaDataReader(string name, IDnaDiagnostics dnaDiagnostics)
        {
            return AppContext.TheAppContext.CreateDnaDataReader(name, dnaDiagnostics);
        }

        /// <summary>
        /// Get Profile Connection Details property. Just returns the web.config Connection Strings
        /// </summary>
        public ConnectionStringSettingsCollection GetConnectionDetails
        {
            get
            {
                return AppContext.TheAppContext.GetConnectionDetails;
            }
        }

        /// <summary>
        /// The SiteList for the app
        /// </summary>
        public ISiteList TheSiteList
        {
            get { return AppContext.TheAppContext.TheSiteList; }
        }

        /// <summary>
        /// Allowed URLs for the app
        /// </summary>
        public IAllowedURLs AllowedURLs
        {
            get { return AppContext.TheAppContext.AllowedURLs; }
        }

        /// <summary>
        /// All diagnostics should be written through this instance of IDnaDiagnostics
        /// </summary>
        /// <see cref="IDnaDiagnostics"/>
        /// <remarks>It's this object that implements log writing</remarks>
        public IDnaDiagnostics Diagnostics
        {
            get { return _dnaInputDiagnostics; }
        }

        /// <summary>
        /// <see cref="AppContext.UrlEscape"/>
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public string UrlEscape(string text)
        {
            return AppContext.TheAppContext.UrlEscape(text);
        }

        /// <summary>
        /// <see cref="AppContext.EnsureAllowedURLsExists"/>
        /// </summary>
        /// <param name="context">The context</param>
        /// <param name="recacheData"></param>
        public void EnsureAllowedURLsExists(bool recacheData, IAppContext context)
        {
            AppContext.TheAppContext.EnsureAllowedURLsExists(recacheData, context);
        }

        /// <summary>
        /// The maximum number of concurrent requests the app allows
        /// </summary>
        public int MaximumRequestCount
        {
            get { return AppContext.TheAppContext.MaximumRequestCount; }
        }

        /// <summary>
        /// <see cref="AppContext.CurrentServerName"/>
        /// </summary>
        public string CurrentServerName
        {
            get { return AppContext.TheAppContext.CurrentServerName; }
        }

        /// <summary>
        /// <see cref="AppContext.IsRunningOnDevServer"/>
        /// </summary>
        public bool IsRunningOnDevServer
        {
            get { return AppContext.TheAppContext.IsRunningOnDevServer; }
        }

        /// <summary>
        /// <see cref="AppContext.GetSiteOptionValueInt"/>
        /// </summary>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public int GetSiteOptionValueInt(string section, string name)
        {
            return AppContext.TheAppContext.GetSiteOptionValueInt(CurrentSite.SiteID, section, name);
        }

        /// <summary>
        /// <see cref="AppContext.GetSiteOptionValueBool"/>
        /// </summary>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public bool GetSiteOptionValueBool(string section, string name)
        {
            return AppContext.TheAppContext.GetSiteOptionValueBool(CurrentSite.SiteID, section, name);
        }

        /// <summary>
        /// <see cref="AppContext.GetSiteOptionValueString"/>
        /// </summary>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public string GetSiteOptionValueString(string section, string name)
        {
            return AppContext.TheAppContext.GetSiteOptionValueString(CurrentSite.SiteID, section, name);
        }

        /// <summary>
        /// <see cref="AppContext.GetSiteOptionValueInt"/>
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public int GetSiteOptionValueInt(int siteId, string section, string name)
        {
            return AppContext.TheAppContext.GetSiteOptionValueInt(siteId, section, name);
        }

        /// <summary>
        /// <see cref="AppContext.GetSiteOptionValueBool"/>
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public bool GetSiteOptionValueBool(int siteId, string section, string name)
        {
            return AppContext.TheAppContext.GetSiteOptionValueBool(siteId, section, name);
        }

        /// <summary>
        /// <see cref="AppContext.GetSiteOptionValueString"/>
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public string GetSiteOptionValueString(int siteId, string section, string name)
        {
            return AppContext.TheAppContext.GetSiteOptionValueString(siteId, section, name);
        }

    }
}
