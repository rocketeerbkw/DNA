using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Text;
using System.Xml.Xsl;
using System.Web.Caching;
using BBC.Dna.Page;
using DnaIdentityWebServiceProxy;
using BBC.Dna.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// <para>
    /// Derive from this class to partially implement IInputContext, instead of having to 
    /// supply empty implementations of every method and property
    /// </para>
    /// <para>
    /// Created for use in the unit test project
    /// </para>
    /// </summary>
    public class TestInputContext : IInputContext
    {
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
		/// <param name="pCacheName"></param>
		/// <param name="pItemName"></param>
		/// <param name="pText"></param>
		/// <returns></returns>
		public bool FileCachePutItem(string pCacheName, string pItemName, string pText)
		{
			throw new NotImplementedException("FileCachePutItem not implemented");
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
        public virtual int TryGetParamIntOrKnownValueOnError(string paramName, int knownValue, string description)
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
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual ConnectionStringSettingsCollection GetConnectionDetails
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual IDnaDiagnostics Diagnostics
        {
            get 
            {
                IDnaDiagnostics _testDiagnostics = new DnaDiagnostics(0, DateTime.Now);
                return _testDiagnostics;
            }
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
        public virtual double GetParamDoubleOrZero(string name, string description)
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
            get { return false; }
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
        public int GetParamCountOrZero(string paramName, string description)
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
        public string GetParamStringOrEmpty(string paramName, int index, string description)
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
        public double GetParamDoubleOrZero(string paramName, int index, string description)
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
        public int GetParamIntOrZero(string paramName, int index, string description)
        {
            throw new NotImplementedException();
        }
        /// <summary>
        /// 
        /// </summary>
        public IAppContext TheAppContext
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// 
        /// </summary>
        public int MaximumRequestCount
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// 
        /// </summary>
        virtual public ISiteList TheSiteList
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// 
        /// </summary>
        virtual public IAllowedURLs AllowedURLs
        {
            get { throw new NotImplementedException(); }
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
        /// <see cref="AppContext.GetSiteOptionValueString"/>
        /// </summary>
        /// /// <param name="siteId"></param>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public string GetSiteOptionValueString(int siteId, string section, string name)
        {
            throw new NotFiniteNumberException();
        }
        
        /// <summary>
        /// Get the current profileapi object for this request
        /// </summary>
        /// <returns>The current profile api for the request</returns>
        public IDnaIdentityWebServiceProxy GetCurrentSignInObject
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public string BbcUid
        {
            get { throw new NotImplementedException("The BbcUid property not implemented!"); }
        }
    
        /// <summary>
        /// The current dna request object
        /// </summary>
        public IRequest CurrentDnaRequest
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// Gets whether the current site is a messageboard
        /// </summary>
        public bool IsCurrentSiteMessageboard
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// Gets the named parameter from the query string or form data in bool format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="name">Name of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>bool value of parameter or zero if param doesn't exist</returns>
        public bool GetParamBoolOrFalse(string name, string description)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Gets one of multiple named parameters from the query string or form data in bool format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="name">Name of parameter</param>
        /// <param name="index">Index of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>bool value of parameter or zero if param doesn't exist</returns>
        public bool GetParamBoolOrFalse(string name, int index, string description)
        {
            throw new NotImplementedException();
        }

		/// <summary>
		/// 
		/// </summary>
		public string IpAddress
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		/// <summary>
		/// 
		/// </summary>
		public Guid BBCUid
		{
			get
			{
				throw new NotImplementedException();
			}
		}

        /// <summary>
        /// Gets the site URL
        /// </summary>
        /// <param name="siteid">Site ID involved</param>
        /// <returns>Site Url to fill in</returns>
        public string GetSiteRoot(int siteid)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Sends a DNA System Message
        /// </summary>
        /// <param name="sendToUserID">User id to send the system message to</param>
        /// <param name="siteID">Site ID involved</param>
        /// <param name="messageBody">Body of the SYstem Message</param>
        public void SendDNASystemMessage(int sendToUserID, int siteID, string messageBody)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Sends a mail or DNA System Message
        /// </summary>
        /// <param name="email">Email address </param>
        /// <param name="subject">Subject of the email</param>
        /// <param name="body">Body of the email</param>
        /// <param name="fromAddress">email of the from address</param>
        /// <param name="fromName">From whom is the message</param>
        /// <param name="insertLineBreaks">Put the line breaks in of not</param>
        /// <param name="userID">User ID involved</param>
        /// <param name="siteID">For which Site</param>
        public void SendMailOrSystemMessage(string email, string subject, string body, string fromAddress, string fromName, bool insertLineBreaks, int userID, int siteID)
        {
            throw new NotImplementedException();
        }
        /// <summary>
        /// Returns the name value pairs of all the parameters in the current query that have the given prefix
        /// </summary>
        /// <param name="prefix"></param>
        /// <returns>A name value collection of all parameters in the query that have the given prefix</returns>
        public NameValueCollection GetAllParamsWithPrefix(string prefix)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// The details for connecting to the DNA database
        /// </summary>
        public string DataBaseConnectionDetails
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// The details for connecting to Identity
        /// </summary>
        public string IdentityConnectionDetails
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// The details for read connecting to ProfileAPI
        /// </summary>
        public string ProfileAPIReadConnectionDetails
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// The details for write connecting to ProfileAPI
        /// </summary>
        public string ProfileAPIWriteConnectionDetails
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// The details for update storedprocedure
        /// </summary>
        public string UpdateSPConnectionDetails
        {
            get { throw new NotImplementedException(); }
        }
    }
}
