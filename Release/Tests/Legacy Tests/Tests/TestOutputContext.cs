using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Text;
using System.Web;
using System.Xml.Xsl;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace Tests
{
	/// <summary>
	/// A base class to allow you to write a testable implementation of OutputContext
	/// </summary>
	public class TestOutputContext : IOutputContext
	{
		/// <summary>
		/// Constructor
		/// </summary>
		public TestOutputContext()
		{
		}
        /// <summary>
        /// Maximum number of concurrent requests
        /// </summary>
        public int MaximumRequestCount
        {
            get { return 0; }
        }
        
        /// <summary>
        /// The SiteList for the application
        /// </summary>
        public ISiteList TheSiteList
        {
            get { return null; }
        }
        /// <summary>
        /// 
        /// </summary>
        public IAllowedURLs AllowedURLs
        {
            get { throw new NotImplementedException(); }
        }
        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual bool DoesParamExist(string paramName, string description)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual bool TryGetParamString(string paramName, ref string value, string description)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual string GetParamStringOrEmpty(string paramName, string description)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual DnaCookie GetCookie(string cookieName)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual IUser ViewingUser
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual ISite CurrentSite
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual IDnaDataReader CreateDnaDataReader(string name)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IAppContext"/>
        /// </summary>
        public virtual IDnaDiagnostics Diagnostics
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual int GetParamIntOrZero(string name, string description)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual List<string> GetAllParamNames()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual string UrlEscape(string text)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual void EnsureSiteListExists(bool recacheData, IAppContext context)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual void EnsureAllowedURLsExists(bool recacheData, IAppContext context)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual void SendSignal(string signal)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual string CurrentServerName
        {
            get { throw new NotImplementedException("CurrentServerName"); }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual bool IsRunningOnDevServer
        {
            get { throw new NotImplementedException("CurrentServerName"); }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual string UserAgent
        {
            get { throw new NotImplementedException("UserAgent"); }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual int GetSiteOptionValueInt(string section, string name)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual bool GetSiteOptionValueBool(string section, string name)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual string GetSiteOptionValueString(string section, string name)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual void AddAllSitesXmlToPage()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public int GetParamCount(string paramName, string description)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="index"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public string GetParamString(string paramName, int index, string description)
        {
            throw new NotImplementedException();
        }

        /// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
		public virtual void SetContentType(string contentType)
		{
			throw new NotImplementedException("SetContentType method not implemented in TestOutputContext");
		}

		/// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
		public virtual string GetSkinPath(string leaf)
		{
			throw new NotImplementedException("GetSkinPath not implemented in TestOutputContext");
		}

		/// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
		public virtual void Redirect(string url)
		{
			throw new NotImplementedException("Redirect not implemented in TestOutputContext");
		}

		/// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
		public virtual TextWriter Writer
		{
			get { throw new NotImplementedException("Writer not implemented in TestOutputContext"); }
		}

		/// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
		public virtual XslCompiledTransform GetCachedXslTransform(string xsltFileName)
		{
			throw new NotImplementedException("GetCachedXslTransform not implemented in TestOutputContext");
		}

		/// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
        public virtual string DebugSkinFile
        {
            get { throw new NotImplementedException("DebugSkinFile not implemented in TestOutputContext"); }
            set { throw new NotImplementedException("DebugSkinFile not implemented in TestOutputContext"); }
        }

        /// <summary>
        /// <see cref="IOutputContext"/>
        /// </summary>
        public virtual bool IsHtmlCachingEnabled()
        {
            throw new NotImplementedException("IsHtmlCachingEnabled not implemented in TestOutputContext");
        }

        /// <summary>
        /// <see cref="IOutputContext"/>
        /// </summary>
        public virtual int GetHtmlCachingTime()
        {
            throw new NotImplementedException("GetHtmlCachingTime not implemented in TestOutputContext");
        }

        /// <summary>
        /// <see cref="IOutputContext"/>
        /// </summary>
        public virtual string CreateRequestCacheKey()
        {
            throw new NotImplementedException("CreateRequestCacheKey not implemented in TestOutputContext");
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual ConnectionStringSettingsCollection GetConnectionDetails
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// <see cref="IAppContext"/>
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public virtual object GetCachedObject(string key)
        {
            throw new NotImplementedException("GetCachedObject not implemented in TestOutputContext");
        }

        /// <summary>
        /// <see cref="IAppContext"/>
        /// </summary>
        /// <param name="key"></param>
        /// <param name="o"></param>
        /// <param name="seconds"></param>
        public virtual void CacheObject(string key, object o, int seconds)
        {
            throw new NotImplementedException("CacheObject not implemented in TestOutputContext");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="name"></param>
        /// <param name="dnaDiagnostics"></param>
        /// <returns></returns>
        public IDnaDataReader CreateDnaDataReader(string name, IDnaDiagnostics dnaDiagnostics)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public int GetSiteOptionValueInt(int siteId, string section, string name)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public bool GetSiteOptionValueBool(int siteId, string section, string name)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public string GetSiteOptionValueString(int siteId, string section, string name)
        {
            throw new NotImplementedException();
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="pCacheName"></param>
		/// <param name="pItemName"></param>
		/// <param name="pdExpires"></param>
		/// <param name="oXMLText"></param>
		/// <returns></returns>
		public bool FileCacheGetItem(string pCacheName, string pItemName, ref DateTime pdExpires, ref string oXMLText)
		{
			throw new NotImplementedException("FileCacheGetItem not implemented");
		}
		/// <summary>
		/// 
		/// </summary>
		/// <param name="a"></param>
		/// <param name="b"></param>
		/// <param name="c"></param>
		/// <returns></returns>
		public bool FileCachePutItem(string a, string b, string c)
		{
			throw new NotImplementedException("FileCachePutItem not implemented");
		}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="skinName"></param>
        /// <param name="skinSet"></param>
        /// <returns></returns>
        public bool VerifySkinFileExists(string skinName, string skinSet)
        {
            throw new NotImplementedException("VerifySkinFileExists not implemented.");
        }

        /// <summary>
        /// Gets the cookie collection for the response
        /// </summary>
        public HttpCookieCollection Cookies { get { throw new NotImplementedException(); }  }
    }
}
