using System;
using System.IO;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Text;
using System.Net;
using BBC.Dna;
using BBC.Dna.Component;
using DnaIdentityWebServiceProxy;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using BBC.Dna.Data;

using BBC.Dna.Moderation.Utils;
using BBC.Dna.Moderation.Utils.Tests;
using Microsoft.Practices.EnterpriseLibrary.Caching;


namespace Tests
{
    /// <summary>
    /// <para>
    /// This test implementation of the input context provides a full implementation of the 'real' input context.
    /// ie has sitedata, current user etc .
    /// It does not 'bluff' data but gives the called the chance to set-up the imput context with desired parameters 
    /// and choose a desired test user account and current site.
    /// </para>
    /// <para>
    /// Created for use in the unit test project
    /// </para>
    /// </summary>
    public class FullInputContext : IInputContext, IDisposable
    {
        private static SiteList _siteList = null;
        //private static SiteOptionList _siteOptionList = null;
        private string _currentSiteName;
        private BBC.Dna.User _viewingUser = null;
        private static DnaConfig _dnaConfig = null;
        private DnaDiagnostics _dnaDiagnostics = new DnaDiagnostics(1, DateTime.Now);
        //private DnaCookie _ssocookie = null;
        private DnaCookie _identityCookie = null;
        private DnaCookie _identitySecureCookie = null;
        private IDnaIdentityWebServiceProxy _signInComponent = null;
        private bool _useIdentity = false;
        private bool _isSecure = false;
        System.Collections.SortedList _params = new System.Collections.SortedList();
        public IDnaDataReaderCreator ReaderCreator{get;private set;}
        private string _debugUserDetails = "";

        /// <summary>
        /// Constructor
        /// </summary>
        public FullInputContext(string debugUserDetails)
        {
            _useIdentity = true;
            _debugUserDetails = debugUserDetails;
            InitialiseFromConfig(null);
        }

        /// <summary>
        /// Safty net incase the class is not used correctly!
        /// </summary>
        ~FullInputContext()
        {
            Dispose();
        }

        /// <summary>
        /// Set property for the identity switch
        /// </summary>
        public bool SetUseIdentity
        {
            set { _useIdentity = value; }
        }

        /// <summary>
        /// The dispose method
        /// </summary>
        public void Dispose()
        {
            // The profile api MUST be disposed of correctly, else we nick all the connections!
            if (_signInComponent != null)
            {
                _signInComponent.Dispose();
                _signInComponent = null;
            }
        }

        /// <summary>
        /// Add the parameters required to drive the test.
        /// </summary>
        public void AddParam(string paramName, string value)
        {
            _params.Add(paramName, value);
        }

        /// <summary>
        /// Set the desired site.
        /// </summary>
        public void SetCurrentSite(string sitename)
        {
            if (_params.Contains("_si"))
            {
                _params["_si"] = sitename;
            }
            else
            {
                _params.Add("_si", sitename);
            }
            _currentSiteName = _params["_si"].ToString();
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
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <param name="o"></param>
        /// <param name="seconds"></param>
        public void CacheTimedObject(string key, object o, int seconds)
        {
            throw new NotImplementedException("CacheObject not implemented in TestOutputContext");
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
        /// <param name="key"></param>
        /// <param name="expires"></param>
        /// <returns></returns>
        public virtual object GetCachedObject(string key, ref DateTime expires)
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
        /// Get the current profileapi object for this request
        /// </summary>
        /// <returns>The current profile api for the request</returns>
        public IDnaIdentityWebServiceProxy GetCurrentSignInObject
        {
            get { return _signInComponent; }
        }

        /// <summary>
        /// returns the dna config connection string
        /// </summary>
        public DnaConfig DnaConfig
        {
            get { return _dnaConfig; }
        }

        private void InitialiseFromConfig(string rootPath)
        {
            if (rootPath == null)
            {
                //Use the config frm the dnapages directory.
                rootPath = TestConfig.GetConfig().GetRipleyServerPath();
            }

            if (_signInComponent == null)
            {
                if (_useIdentity)
                {
                    string identityWebServiceConnetionDetails = GetConnectionDetails["IdentityURL"].ConnectionString;
                    if (_debugUserDetails.Length == 0)
                    {
                        _signInComponent = new DnaIdentityWebServiceProxy.IdentityRestSignIn(identityWebServiceConnetionDetails, "");
                        Console.WriteLine("Using REAL Identity signin system");
                    }
                    else
                    {
                        _signInComponent = new DnaIdentityWebServiceProxy.IdentityDebugSigninComponent(_debugUserDetails);
                        Console.WriteLine("Using DEBUG Identity signin system");
                    }
                }
                else
                {
                    throw new Exception("SSO Sign in is nologer supported! Please rewrite your test to use identity.");
                }
            }

            if (_dnaConfig == null)
            {
                _dnaConfig = new DnaConfig(rootPath);
                //_dnaConfig.Initialise();

                string dir = System.Environment.CurrentDirectory + @"\logs\";
                Directory.CreateDirectory(dir);

                DnaDiagnostics.Initialise(dir, "DNATestUtils");
                DnaDiagnostics.WriteHeader("TEST-FullInputContext");
            }

            ReaderCreator = new DnaDataReaderCreator(_dnaConfig.ConnectionString, _dnaDiagnostics);

            _siteList = new SiteList(ReaderCreator, dnaDiagnostics, CacheFactory.GetCacheManager(), null, null);
            Statistics.InitialiseIfEmpty();

            ProfanityFilterTests.InitialiseProfanities();

        }

        /// <summary>
        /// Initialises a new default user from a hard coded cookie value
        /// </summary>
        public void InitDefaultUser()
        {
            //InitUserFromCookie("3420578cf0c5a180d2de517ce172cf15a1d75962e850da37b546589db499466a00");
            InitUserFromCookie("6042002|DotNetNormalUser|DotNetNormalUser|1273497514775|0|bf78fdd57a1f70faee630c07ba31674eab181a3f6c6f",
            "1eda650cb28e56156217427336049d0b8e164765");
        }

        /// <summary>
        /// Initialises a new default user from a sso uid
        /// </summary>
        public void InitUserFromCookie(string identity, string identityHttps)
        {
            /*if (_ssocookie == null)
            {
                _ssocookie = new DnaCookie(new System.Web.HttpCookie("SS02-UID"));
            }
            _ssocookie.Value = ssouid2;*/

            if (_identityCookie == null)
            {
                _identityCookie = new DnaCookie(new System.Web.HttpCookie("IDENTITY"));
                _identitySecureCookie = new DnaCookie(new System.Web.HttpCookie("IDENTITY-HTTPS"));
            }
            _identityCookie.Value = identity;
            _identitySecureCookie.Value = identityHttps;

            _viewingUser = new BBC.Dna.User(this);
            _viewingUser.CreateUser();
        }

        /// <summary>
        /// Get the User object representing the viewing user.
        /// </summary>
        public virtual IUser ViewingUser
        {
            get
            {
                return _viewingUser;
            }
        }

        /// <summary>
        /// Get the Site object representing the current site.
        /// </summary>
        public ISite CurrentSite
        {
            get
            {
                return _siteList.GetSite(_currentSiteName);
            }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual bool DoesParamExist(string paramName, string description)
        {
            return _params.ContainsKey(paramName);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual bool TryGetParamString(string paramName, ref string value, string descripion)
        {
            if (_params.ContainsKey(paramName))
            {
                value = _params[paramName].ToString();
                return true;
            }
            return false;
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual int TryGetParamIntOrKnownValueOnError(string paramName, int knownValue, string description)
        {
            throw new NotImplementedException("Not implimented!!!");
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual string GetParamStringOrEmpty(string paramName, string description)
        {
            if (_params.ContainsKey(paramName))
            {
                return _params[paramName].ToString();
            }
            return string.Empty;
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual DnaCookie GetCookie(string cookieName)
        {
            //return _ssocookie;
            if (cookieName == "IDENTITY-HTTPS")
            {
                return _identitySecureCookie;
            }
            else
            {
                return _identityCookie;
            }
        }


        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual IDnaDataReader CreateDnaDataReader(string name)
        {
            return new BBC.Dna.Data.StoredProcedureReader(name, _dnaConfig.ConnectionString, _dnaDiagnostics);
        }



        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public virtual ConnectionStringSettingsCollection GetConnectionDetails
        {
            get
            {
                ConnectionStringSettingsCollection profileConnectionDetails = new ConnectionStringSettingsCollection();
                profileConnectionDetails.Add(new ConnectionStringSettings("ProfileRead", "server=ops-dbdev1.national.core.bbc.co.uk; port=3312; user id=profile; password=crudmeister; database=mdb; pooling=true"));
                profileConnectionDetails.Add(new ConnectionStringSettings("ProfileWrite", "server=ops-dbdev1.national.core.bbc.co.uk; port=3312; user id=profile; password=crudmeister; database=mdb; pooling=true"));

                //profileConnectionDetails.Add(new ConnectionStringSettings("IdentityURL", @"http://fmtdev16.national.core.bbc.co.uk:10854/opensso/identityservices/IdentityServices;;http://www-cache.reith.bbc.co.uk:80"));
                profileConnectionDetails.Add(new ConnectionStringSettings("IdentityURL", @"https://api.test.bbc.co.uk/opensso/identityservices/IdentityServices;dna;http://www-cache.reith.bbc.co.uk:80"));
                //profileConnectionDetails.Add(new ConnectionStringSettings("IdentityURL", @"https://api.stage.bbc.co.uk/opensso/identityservices/IdentityServices;dna live;http://www-cache.reith.bbc.co.uk:80"));

                return profileConnectionDetails;
            }
        }

        /// <summary>
        /// All diagnostics should be written through this instance of IDnaDiagnostics
        /// </summary>
        /// <see cref="IDnaDiagnostics"/>
        /// <remarks>It's this object that implements log writing</remarks>
        public IDnaDiagnostics Diagnostics
        {
            get { return _dnaDiagnostics; }
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
        public int GetParamIntOrZero(string name, string description)
        {
            if (DoesParamExist(name, description))
            {
                int val;
                if (Int32.TryParse(GetParamStringOrEmpty(name, description), out val))
                {
                    return val;
                }
                else
                {
                    return 0;
                }
            }
            return 0;
        }
        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public List<string> GetAllParamNames()
        {
            List<string> paramnames = new List<string>();

            foreach (string paramname in _params.GetKeyList())
            {
                if (paramname != null)
                {
                    paramnames.Add(paramname);
                }
            }
            return paramnames;
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public string UrlEscape(string text)
        {
            return Uri.EscapeDataString(text);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public void EnsureSiteListExists(bool recacheData, IAppContext context)
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
        /// Sends a control signal to all the other front end servers. Used for recaching site data and the likes.
        /// </summary>
        /// <param name="signal">The action that you want to perform</param>
        public void SendSignal(string signal)
        {
            //Not using the DnaTestUrlRequest.
            //DnaTestUrlRequest ensures that the test web site h2g2Unittesting is listening so instantiate to this end.
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");

            // Make sue the requested signal does not contain any page specific information, as we need to call both the .net and ripley
            // versions of the signal builder. Get everything after the first ? if it exists
            signal = signal.Substring(signal.IndexOf('?') + 1);

            // Go through each ripley server sending the signal.
            foreach (string address in _dnaConfig.RipleyServerAddresses)
            {
                // Send the signal to the selected server
                SendSignalToServer(address, "signal?" + signal + "&skin=purexml");
            }

            // Go through each .net server sending the signal.
            foreach (string address in _dnaConfig.DotNetServerAddresses)
            {
                // Send the signal to the selected server
                SendSignalToServer(address, "dnasignal?" + signal + "&skin=purexml");
            }
        }

        /// <summary>
        /// Send a given signal to a given server
        /// </summary>
        /// <param name="serverName">the ip or name of the server to send the signal to</param>
        /// <param name="signal">The action you want to perform</param>
        private void SendSignalToServer(string serverName, string signal)
        {
            // Setup the request to send the signal action
            Uri URL = new Uri("http://" + serverName + "/dna/h2g2/" + signal);


            // Add the proxy to the request
            //            webRequest.Proxy = new WebProxy("http://www-cache.reith.bbc.co.uk:80");
            HttpWebRequest webRequest = null;

            try
            {
                webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
                Diagnostics.WriteToLog("Signal", "Sending this signal: " + URL.ToString());
                // Try to send the request and get the response
                WebResponse response = webRequest.GetResponse();
                response.Close();
            }
            catch (Exception ex)
            {
                // Problems!
                Diagnostics.WriteWarningToLog("Signal", "Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
            }
            finally
            {
                webRequest = null;
            }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public string CurrentServerName
        {
            get
            {
                return "DUMMYNAME";
            }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public bool IsRunningOnDevServer
        {
            get { return true; }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public string UserAgent
        {
            get
            {
                return "TestUserAgent";
            }
        }

        /// <summary>
        /// The site list
        /// </summary>
        public SiteList SiteList
        {
            get { return _siteList; }
        }

        /// <summary>
        /// Public accessor
        /// </summary>
        public DnaDiagnostics dnaDiagnostics
        {
            get { return _dnaDiagnostics; }
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public int GetSiteOptionValueInt(string section, string name)
        {
            return _siteList.GetSiteOptionValueInt(CurrentSite.SiteID, section, name);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public bool GetSiteOptionValueBool(string section, string name)
        {
            return _siteList.GetSiteOptionValueBool(CurrentSite.SiteID, section, name);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public string GetSiteOptionValueString(string section, string name)
        {
            return _siteList.GetSiteOptionValueString(CurrentSite.SiteID, section, name);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public void AddAllSitesXmlToPage()
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
        public IAppContext TheAppContext
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// 
        /// </summary>
        public ISiteList TheSiteList
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// 
        /// </summary>
        public IAllowedURLs AllowedURLs
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
            //get { return @"https://api.stage.bbc.co.uk/opensso/identityservices/IdentityServices;dna live;http://www-cache.reith.bbc.co.uk:80"; }
            get { return @"https://api.test.bbc.co.uk/opensso/identityservices/IdentityServices;dna;http://www-cache.reith.bbc.co.uk:80"; }
        }

        /// <summary>
        /// The details for read connecting to ProfileAPI
        /// </summary>
        public string ProfileAPIReadConnectionDetails
        {
            get { return "server=ops-dbdev1.national.core.bbc.co.uk; port=3312; user id=profile; password=crudmeister; database=mdb; pooling=true"; }
        }

        /// <summary>
        /// The details for write connecting to ProfileAPI
        /// </summary>
        public string ProfileAPIWriteConnectionDetails
        {
            get { return "server=ops-dbdev1.national.core.bbc.co.uk; port=3312; user id=profile; password=crudmeister; database=mdb; pooling=true"; }
        }

        /// <summary>
        /// The details for update storedprocedure
        /// </summary>
        public string UpdateSPConnectionDetails
        {
            get { throw new NotImplementedException(); }
        }
        /// <summary>
        /// Gets whether the request is secure
        /// </summary>
        public bool IsSecureRequest
        {
            get { return _isSecure; }
            set { _isSecure = value; }
        }

        public bool IsPreviewMode()
        {
            return false;
        }

        public SkinSelector SkinSelector
        {
            get { return null; }
        }
    }
}
