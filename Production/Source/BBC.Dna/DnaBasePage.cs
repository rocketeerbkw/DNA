using System;
using System.Diagnostics;
using System.Net;
using System.Threading;
using System.Web;
using System.Web.Caching;
using System.Web.Configuration;
using System.Web.UI;
using System.Xml;
using System.Xml.Xsl;
using BBC.Dna.Component;
using DnaIdentityWebServiceProxy;
using BBC.Dna.Utils;
using BBC.Dna.Objects;
using BBC.Dna.Users;
using System.Collections.Generic;

namespace BBC.Dna.Page
{
    /// <summary>
    /// Summary description for DnaBasePage
    /// </summary>
    public partial class DnaBasePage : IInputContext, IOutputContext
    {
		/// <summary>
        /// The DnaBasePage constructor.
        /// </summary>
        /// <param name="page">An interface to a DnaWebPage</param>
        public DnaBasePage(IDnaWebPage page)
        {
            _dnapage = page;
        }


        private SkinSelector _skinSelector = new SkinSelector(); 
        private IDnaWebPage _dnapage;

        private string pageDomain
        {
            get;
            set;
        }

        /// <summary>
		/// Enum representing the possible categories of user we might get
		/// </summary>
		[Flags]
		public enum UserTypes
		{
			/// <summary>
			/// Any user allowed, including anonymous users
			/// </summary>
			Any = 1,
			/// <summary>
			/// Any authenticated user (no anonymous users)
			/// </summary>
			Authenticated = 2,
			/// <summary>
			/// Tester
			/// </summary>
			Tester = 4,
			/// <summary>
			/// A member of one of the volunteer groups
			/// </summary>
			Volunteer = 8,
			/// <summary>
			/// A moderator
			/// </summary>
			Moderator = 16,
			/// <summary>
			/// Editor (or host)
			/// </summary>
			Editor = 32,
			/// <summary>
			/// Machine administrator
			/// </summary>
			Administrator = 64,
			/// <summary>
			/// All allowed admins
			/// </summary>
			EditorAndAbove = Editor | Administrator,
			/// <summary>
			/// Moderator, Editor and Administrator are allowed
			/// </summary>
			ModeratorAndAbove = Moderator | EditorAndAbove,
			/// <summary>
			/// Allow all users who are volunteers, moderators, editors and administrators
			/// </summary>
			VolunteerAndAbove = Volunteer | ModeratorAndAbove
		}

        /// <summary>
        /// Gets the DNA Wrapped Request object
        /// </summary>
        public IRequest Request
        {
            get { return _dnapage.Request; }
        }

        /// <summary>
        /// Gets the DNA Wrapped Response object
        /// </summary>
        public IResponse Response
        {
            get { return _dnapage.Response; }
        }

        /// <summary>
        /// Gets the DNA Wrapped Server object
        /// </summary>
        public IServerUtility Server
        {
            get { return _dnapage.Server; }
        }

        /// <summary>
        /// giving access to skinselector object
        /// </summary>
        public SkinSelector SkinSelector
        {
            get { return _skinSelector; }
        }


 		/// <summary>
		/// Which users are allowed to access this page. Default to any user.
		/// </summary>
		//protected UserTypes _allowedUsers = UserTypes.Any;

        private WholePage _page = null;

        private int _requestId = 0;

		private bool _useDotNetRendering = false;

		private static int _currentRequestCount = 0;

		private ParameterTracker _tracker;

        private IDnaIdentityWebServiceProxy _signInComponent = null;

        private string _botNotAllowedMessage = "Forbidden";

		/// <summary>
        /// The current dna request object
        /// </summary>
        public IRequest CurrentDnaRequest
        {
            get { return _dnapage.Request; }
        }

        /// <summary>
        /// Gets the root XmlNode for the current web page
        /// </summary>
        public XmlNode WholePageBaseXmlNode
        {
            get { return _page.RootElement; }
        }

        /// <summary>
        /// List for holding all the banned user agent names, or parts of.
        /// e.g. BingBot.htm or 'http://www.bing.com/bingbot.htm' or www.bing.com
        /// The more info, the more specific banning can be done.
        /// The list of banned agents is taken from the config file as a '|' seperated list
        /// </summary>
        public List<String> BannedUserAgents
        {
            get { return AppContext.TheAppContext.BannedUserAgents; }
        }

		/// <summary>
		/// Property indicating whether we should use .NET rendering of the aspx page.
		/// True if we should (overriding the transformation step
		/// False if we should use the XSLT transform mechanism
		/// </summary>
		public bool UseDotNetRendering
		{
			get
            {
                if (Request.DoesParamExist("skin", "Are we being told to render with a specific skin?"))
                {
                    return false;
                }
                else
                {
                    return _useDotNetRendering;
                }
            }
			set { _useDotNetRendering = value; }
		}

        /// <summary>
        /// Get the string representing the page type.
        /// </summary>
		public string PageType
		{
            get { return _dnapage.PageType; }
		}

        private bool IsCachedOutputAvailable()
        {
			if (Transformer != null)
			{
				return Transformer.IsCachedOutputAvailable();
			}
			else
			{
				return false;
			}
        }

        /// <summary>
        /// Get the current Signin object for this request. This could be either ProfileAPI or Identity web service
        /// depending on the sign in method for the site
        /// </summary>
        /// <returns>The current sign on object for the request</returns>
        public IDnaIdentityWebServiceProxy GetCurrentSignInObject
        {
            get { return _signInComponent; }
        }

        /// <summary>
        /// This is where the page is initialised and all components get added.
        /// </summary>
        /// <param name="sender">The object that sent the request</param>
        /// <param name="e">Arguments passed in</param>
        public void Page_Load(object sender, EventArgs e)
        {
            
            // Create the param tracker and request objects for this request
			_tracker = new ParameterTracker(this);

			if (WebConfigurationManager.AppSettings["aspneterrors"] == "1")
			{
				DoPageLoad();
			}
			else
			{
				bool wasExceptionCaught = false;
				try
				{
					DoPageLoad();
				}
				catch (Exception ex)
				{
                    if (ex.GetType() == typeof(HttpException) && ex.Message == _botNotAllowedMessage)
                    {
                        throw;
                    }

					wasExceptionCaught = true;
					if (Diagnostics != null)
					{
						Diagnostics.WriteExceptionToLog(ex);
					}
				}

				// Initialise an error page here if we don't have one already to stop a further error
				// masking the real one.
				if (_page == null)
				{
					if (_viewingUser == null)
					{
						_viewingUser = new User(this);
					}
					_page = new WholePage(this);
					_page.InitialisePage("ERROR");
				}
				
                if (wasExceptionCaught && _page != null)
				{
					XmlNode h2g2 = _page.RootElement.FirstChild;
					XmlNode errornode = _page.AddTextTag(h2g2, "ERROR", "An unknown error has occurred");
					_page.AddAttribute(errornode, "REQUESTID", _requestId.ToString());
					_page.AddAttribute(errornode, "TIME", DateTime.Now.ToString("dd MMMM yyyy, HH:mm:ss"));
					string originalType = h2g2.Attributes["TYPE"].InnerText;
					_page.AddAttribute(errornode, "ORIGINALPAGETYPE", originalType);
					// This will fail if there's no TYPE attribute - but that's a fatal bug at this point anyway
					h2g2.Attributes["TYPE"].InnerText = "ERROR";
				}
			}
        }
		
		/// <summary>
		/// This is the place where all the actual work is done
		/// Please add all new code here, and not in the main Page_Load method
		/// </summary>
		private void DoPageLoad()
		{
			Stopwatch requesttimer = new Stopwatch();
			requesttimer.Start();
            InitialiseRequest();

            // Check to see which sign in method we need to create
            if (_debugUserID.Length > 0)
            {
                SetupDebugUserSignin();
            }
            else if (CurrentSite.UseIdentitySignInSystem)
            {
                // Create a new Identity web service object
                string identityWebServiceConnetionDetails = GetConnectionDetails["IdentityURL"].ConnectionString;
                Diagnostics.WriteTimedEventToLog("IDENTITY", "Started with " + identityWebServiceConnetionDetails);
                string clientIPAddress = GetParamStringOrEmpty("__ip__", "Client IP Address");
                _signInComponent = new DnaIdentityWebServiceProxy.IdentityRestSignIn(identityWebServiceConnetionDetails, clientIPAddress);
                _signInComponent.SetService(CurrentSite.IdentityPolicy);
                Diagnostics.WriteTimedEventToLog("IDENTITY", "Finished");
            }
            else
            {
                // Create a new profileAPI signin object
                throw new NotSupportedException("The ProfileAPI is nolonger supported. Please set the site to use Identity as the Signin System.");
            }
			
			// If we have cached output available for this request, don't do any more work
			if (IsCachedOutputAvailable())
			{
				return;
			}

            CheckForForbiddenUserAgents(UserAgent, BannedUserAgents);
			
			int curRequests = Interlocked.Increment(ref _currentRequestCount);

			try
			{
                if (curRequests > MaximumRequestCount && _dnapage.PageType.Equals("SERVERTOOBUSY") == false )
				{
                    AddServerBusy();
                    Server.Transfer("ServerTooBusyPage.aspx"); 
					//_viewingUser = new User(this);
					//_page = new WholePage(this);
					//_page.InitialisePage("SERVERTOOBUSY");
					//_page.AddTextTag(_page.RootElement.FirstChild, "REQUESTTYPE", PageType);
                    //_skinSelector.Initialise(this, this);
				}

                InitialisePage();
                
				// Intialise the page
                Statistics.AddRawRequest();

                if (!IsDnaUserAllowed() && !_useDotNetRendering )
                {//not logged in
                    if (!_skinSelector.IsPureXml(this))
                    {
                        _skinSelector.SkinName = "admin";
                        _skinSelector.SkinSet = "vanilla";
                    }
                    _page = new WholePage(this);
                    _page.InitialisePage("ERROR");
                    _page.AddErrorXml("Authorization", "You are not authorised to view this page.", _page.RootElement.FirstChild);
                }
                else if (!IsSecureAccessAllowed())
                {//logged in but not secure
                    if (!_skinSelector.IsPureXml(this))
                    {
                        _skinSelector.SkinName = "admin";
                        _skinSelector.SkinSet = "vanilla";
                    }
                    _page = new WholePage(this);
                    _page.InitialisePage("ERROR");
                    _page.AddErrorXml("NotSecure", "You must access this page be secure methods.", _page.RootElement.FirstChild);
                }
                else
                {
                    // Now call the add components
                    _dnapage.OnPageLoad();

                    AddComponent(new SkinParams(this));

                    _page.ProcessRequest();

                    // Update any data source controls on the page
                    _dnapage.UpdateDataSourceControls();

                    // Allow the page to do any post process request actions.
                    _dnapage.OnPostProcessRequest();
                }

                //Finish off other related BasePage stuff
                FinalisePage();
                Statistics.AddRequestDuration((int)requesttimer.ElapsedMilliseconds);
                _page.AddTimeForPage(Diagnostics.ElapsedMilliseconds);
                _page.AddInside(_tracker, "H2G2");
			}
			finally
			{
				Interlocked.Decrement(ref _currentRequestCount);
			}

		}

        /// <summary>
        /// Checks to see if the user agent is one of the listed banned agents.
        /// </summary>
        /// <param name="userAgent">The user agent for the current request</param>
        /// <param name="bannedUserAgents">The list of banned agents to test against</param>
        /// <exception cref="HttpException">This methos will throw a 403 Forbidden exception if a match is found</exception>
        public void CheckForForbiddenUserAgents(string userAgent, List<string> bannedUserAgents)
        {
            foreach (string s in bannedUserAgents)
            {
                if (userAgent.ToLower().Contains(s.ToLower()))
                {
                    throw new HttpException(403, _botNotAllowedMessage);
                }
            }
        }

        private void SetupDebugUserSignin()
        {
#if DEBUG
            Diagnostics.WriteTimedEventToLog("IDENTITY", "Started using debugging user cookie mode");
            _signInComponent = new DnaIdentityWebServiceProxy.IdentityDebugSigninComponent(_debugUserID);

            HttpCookie idcookie = new HttpCookie("IDENTITY", _signInComponent.GetCookieValue);
            idcookie.Domain = ".bbc.co.uk";
            idcookie.Path = "/";
            Cookies.Add(idcookie);

            HttpCookie idsecurecookie = new HttpCookie("IDENTITY-HTTPS", _signInComponent.GetSecureCookieValue);
            idsecurecookie.Domain = ".bbc.co.uk";
            idsecurecookie.Path = "/";
            Cookies.Add(idsecurecookie);

            Diagnostics.WriteTimedEventToLog("IDENTITY", "Finished");
#endif
        }

		/// <summary>
		/// Add to the ServerTooBusy stats
		/// </summary>
		public void AddServerBusy()
		{
			Statistics.AddServerBusy();
		}

		/// <summary>
		/// Addto the tracking of average request duration
		/// </summary>
		/// <param name="ttaken"></param>
		public void AddRequestDuration(int ttaken)
		{
			Statistics.AddRequestDuration(ttaken);
		}

		/// <summary>
		/// Add a non SSO request to the stats
		/// </summary>
		public void AddLoggedOutRequest()
		{
			Statistics.AddLoggedOutRequest();
		}

		/// <summary>
		/// Add an XML cache hit
		/// </summary>
		public void AddCacheHit()
		{
			Statistics.AddCacheHit();
		}

		/// <summary>
		/// Add an XML cache miss
		/// </summary>
		public void AddCacheMiss()
		{
			Statistics.AddCacheMiss();
		}

		/// <summary>
		/// Add an RSS cache hit
		/// </summary>
		public void AddRssCacheHit()
		{
			Statistics.AddRssCacheHit();
		}

		/// <summary>
		/// Add an RSS cache miss
		/// </summary>
		public void AddRssCacheMiss()
		{
			Statistics.AddRssCacheMiss();
		}

		/// <summary>
		/// Add an SSI cache hit
		/// </summary>
		public void AddSsiCacheHit()
		{
			Statistics.AddSsiCacheHit();
		}

		/// <summary>
		/// Add an SSI cache miss
		/// </summary>
		public void AddSsiCacheMiss()
		{
			Statistics.AddSsiCacheMiss();
		}

		/// <summary>
		/// Add an HTML cache hit
		/// </summary>
		public void AddHTMLCacheHit()
		{
			Statistics.AddHTMLCacheHit();
		}

		/// <summary>
		/// Add an HTML cache miss
		/// </summary>
		public void AddHTMLCacheMiss()
		{
			Statistics.AddHTMLCacheMiss();
		}

        /// <summary>
        /// Called by the DnaWebPage when an exception goes off.
        /// Used to write the exception to the logs
        /// </summary>
        /// <param name="sender">The object that sent the request</param>
        /// <param name="e">Arguments passed in</param>
        public void Page_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            Diagnostics.WriteExceptionToLog(ex);
        }

        /// <summary>
        /// Initialises all the required objects needed for the current request 
        /// </summary>
        private void InitialiseRequest()
        {
            // Increment the request Id
			_requestId = RequestIdGenerator.GetNextRequestId();

            // Create a diagnostics object for this request
            _dnaInputDiagnostics = new DnaDiagnostics(_requestId, _dnapage.Timestamp);
            Diagnostics.WriteRequestToLog(Request);

            // Make sure that the site list exists
            if (1 == GetParamIntOrZero("_ns", "Force the framework to recache the static site list. Admin use only."))
            {
                TheSiteList.ReInitialise();
                EnsureAllowedURLsExists(true, this);
            }
           

            bool clearTemplates = (Request.Params["clear_templates"] != null);
#if DEBUG
            if (!clearTemplates)
            {
                string ripleyClearTemplates = Environment.GetEnvironmentVariable("RipleyClearTemplates");
                clearTemplates = (ripleyClearTemplates != null && ripleyClearTemplates.Equals("1"));
            }
#endif
            // Check to see if we've been told to recache the templates
            if (clearTemplates)
            {
                // Call the clear templates function
                ClearTemplates();
            }
            

            // Check to see if we've been told to recache the user groups
            if (Request.Params["_gc"] != null)
            {
                UserGroups.GetObject().ReInitialise();
            }

            // Set the pagedomain
            pageDomain = "uk";
            if (Request.DoesParamExist("hostsource", "Check the calling hostsource param"))
            {
                if (Request.GetParamStringOrEmpty("hostsource", "Check the calling hostsource param").ToLower() == "com")
                {
                    pageDomain = "com";
                }
            }

            _debugUserID = "";
#if DEBUG
            // Check to see if we're wanting to use the debug user or not
            if (Request.Params["d_identityuserid"] != null)
            {
                SetDebugUserCookie(Request.Params["d_identityuserid"]);
            }
            else if (Request.Params["d_clearidentityuserid"] != null)
            {
                ClearDebugUserCookie();
            }
            else if (GetCookie("DNADEBUGUSER") != null)
            {
                DnaCookie debuguser = GetCookie("DNADEBUGUSER");
                if (debuguser != null && debuguser.Value.Length > 0)
                {
                    _debugUserID = debuguser.Value.Substring(3);
                }
            }

            if (Request.Params["d_skinfile"] != null)
            {
                DebugSkinFile = Request.Params["d_skinfile"];
            }
#endif
            // Needs setting up before code that relies on current site is executed
            SetCurrentSiteName();

            // Create the transformer for this request
            CreateTransformer();
        }

        private string _debugUserID = "";

#if DEBUG
        private void SetDebugUserCookie(string userid)
        {
            HttpCookie identityDebugUser = new HttpCookie("DNADEBUGUSER", "ID-" + userid);
            identityDebugUser.Expires = DateTime.Now.AddYears(1);
            identityDebugUser.Domain = "bbc.co.uk";
            identityDebugUser.Path = "/";
            Response.Cookies.Add(identityDebugUser);
            _debugUserID = userid;
        }

        private void ClearDebugUserCookie()
        {
            HttpCookie identityDebugUser = new HttpCookie("DNADEBUGUSER", "ID-0");
            identityDebugUser.Expires = DateTime.Now.AddYears(-1);
            identityDebugUser.Domain = "bbc.co.uk";
            identityDebugUser.Path = "/";
            Response.Cookies.Add(identityDebugUser);
            
            HttpCookie identity = new HttpCookie("IDENTITY", "");
            identity.Expires = DateTime.Now.AddYears(-1);
            identity.Domain = "bbc.co.uk";
            identity.Path = "/";
            Response.Cookies.Add(identity);

            HttpCookie httpsIdentity = new HttpCookie("IDENTITY-HTTPS", "");
            httpsIdentity.Expires = DateTime.Now.AddYears(-1);
            httpsIdentity.Domain = "bbc.co.uk";
            httpsIdentity.Path = "/";
            Response.Cookies.Add(httpsIdentity);
            _debugUserID = "";
        }
#endif

        /// <summary>
        /// Initialises the page by setting up all the member vairables
        /// </summary>
        /// <returns>True if ok, false if not</returns>
        private void InitialisePage()
        {
            CreateViewingUser();
			_page = new WholePage(this);
			_page.InitialisePage(PageType);

            if (_dnapage.IncludeTopFives)
            {
                RecentActivity topFives = RecentActivity.GetSiteRecentActivity(CurrentSite.SiteID, AppContext.ReaderCreator, Diagnostics, AppContext.DnaCacheManager);
                _page.SerialiseAndAppend(topFives, "//H2G2");
            }

            //Ultimate Choice of skin may include users preferences.
            _skinSelector.Initialise(this, this);
        }

        /// <summary>
        /// Finalises the page by add required member variable XML to the page
        /// </summary>
        private void FinalisePage()
        {
            SiteXmlBuilder siteXml = new SiteXmlBuilder(this);
            Diagnostics.WriteToLog("FinalisePage", "Adding siteoption list for site " + CurrentSite.SiteID.ToString());

            XmlNode siteOptionList = siteXml.GetSiteOptionListForSiteXml(CurrentSite.SiteID, TheSiteList);
            siteXml.GenerateXml(siteOptionList, CurrentSite);
            InsertPageComponent(siteXml);

            // Add the domain tag to the page
            string domain = "bbc.co.uk";
            if (pageDomain == "com")
            {
                domain = "bbc.com";
            }
            _page.AddTextTag(_page.RootElement.FirstChild, "PAGEDOMAIN", domain);
        }

        /// <summary>
        /// Sets up the Viewing User component
        /// </summary>
        private void CreateViewingUser()
		{
            _viewingUser = new User(this);
			if (false == IsRequestAnonymous)
			{
				_viewingUser.CreateUser();
			}
		}

        /// <summary>
        /// Add a component to the Page.
        /// </summary>
        /// <param name="component">The component to add to the page.</param>
		public void AddComponent(IDnaComponent component)
		{
            _page.AddComponent(component);
		}

		/// <summary>
        /// This is used to insert Dna Components into the current page
        /// </summary>
        /// <param name="Component">The component that you want to insert into the page</param>
        /// <returns>True if ok, false if not</returns>
        protected bool InsertPageComponent(DnaComponent Component)
        {
            return _page.AddInside(Component,"H2G2");
        }

        private IDnaTransformer _transformer = null;
        private IDnaTransformer Transformer
        {
            get { return _transformer; }
            set { _transformer = value; }
        }

        /// <summary>
        /// Creates the correct transformer based on the request
        /// </summary>
        protected void CreateTransformer()
        {
            if (!UseDotNetRendering)
            {
                if ( _skinSelector.IsPureXml(this) )
                {
                    Transformer = new PureXmlTransformer(this);
                }
				else if ( _skinSelector.IsXmlSkin(this) )
				{
					Transformer = new XmlTransformer(this);
					IsRequestAnonymous = true;
				}
				else
                {
                    Transformer = DnaTransformer.CreateTransformer(this, this);
                }
            }
        }

        /// <param name="writer">The <see cref="T:System.Web.UI.HtmlTextWriter"></see> that receives the page content.</param>
        public void Render(HtmlTextWriter writer)
        {
            try
            {
                if (UseDotNetRendering)
                {
                    _dnapage.DotNetRender(writer);
                }
                else
                {
                    // Remove any DNA-#### message Cookies that exist in both the request and response
                    if (Request.Cookies["DNA-KVD"] != null && Response.Cookies["DNA-KVD"] != null)
                    {
                        Response.Cookies.Remove("DNA-KVD");
                    }

                    // Make sure we're not using html caching!!!
                    if (_page != null)
                    {
                        // Check to see if we're being asked to add a message cookie to the response
                        XmlNodeList cookies = _page.RootElement.SelectNodes("H2G2/KVD-COOKIES/COOKIE");
                        if (cookies.Count > 0)
                        {
                            // Add each of the cookie. For now only given them a 1 minute life span
                            foreach (XmlNode cookie in cookies)
                            {
                                HttpCookie dnaCookie = new HttpCookie(cookie.Attributes["NAME"].Value, cookie.InnerXml.ToString());
                                dnaCookie.Path = HttpUtility.UrlDecode(cookie.Attributes["PATH"].Value);
                                dnaCookie.Expires = DateTime.Now.AddMinutes(1);
                                Response.Cookies.Add(dnaCookie);
                            }
                        }
                    }

                    string encoding = String.Empty;
                    if (Request.TryGetParamString("dna_encoding", ref encoding, "Set this parameter to a valid encoding type (UTF-8 or iso-8859-1 are good examples) to force the encoding type. If you omit this parameter then UTF-8 is returned."))
                    {
                        Response.ContentEncoding = System.Text.Encoding.GetEncoding(encoding);
                    }
                    if (IsCachedOutputAvailable())
                    {
                        //Writer.Write(CachedOutput);
                        Transformer.WriteCachedOutput();
                        Diagnostics.WriteTimedEventToLog("CachedOutput", "");
                    }
                    else
                    {
                        Transformer.TransformXML(_page);
                    }
                }
            }
            catch (Exception ex)
            {
                if (WebConfigurationManager.AppSettings["aspneterrors"] == "1")
                {
                    throw;
                }
                else
                {
                    if (Diagnostics != null)
                    {
                        Diagnostics.WriteExceptionToLog(ex);
                    }

                    Response.ContentType = "text/html";
                    Response.Write("<!-- There was a problem rendering this page. -->");
                }
            }
		}

        /// <summary>
		/// The WholePage object containing the XML data as constructed
		/// Useful for a .NET rendered page
		/// </summary>
		protected WholePage PageData
		{
			get { return _page; }
		}

        /// <summary>
        /// Called by the DnaWebPage. Used to write to the logs and close any profile contections
        /// </summary>
        /// <param name="sender">The object that sent the request</param>
        /// <param name="e">Arguments passed in</param>
        public void Page_Unload(object sender, EventArgs e)
        {
            Diagnostics.WriteTimedEventToLog("Close", "Page_Unload");
            if (_signInComponent != null)
            {
                _signInComponent.Dispose();
            }
        }

        /// <summary>
        /// Used to impliment locking for the cached xslt transforms
        /// </summary>
        private static object cacheXsltLock = new object();
        private string[] recacheDepends = { "xsltransformcache" };

        /// <summary>
        /// Tries to find a cached transform using the xslt filename. If it doesn't find one, it creates it and caches it.
        /// </summary>
        /// <param name="xsltFileName">The name of the cache file you want to reuse</param>
        /// <returns>The Xsl transformer if it finds one or creates one</returns>
        public XslCompiledTransform GetCachedXslTransform(string xsltFileName)
        {
            // Check to see if we've already got a cached version for the requested file
            XslCompiledTransform transformer = DnaStaticCache.Get(xsltFileName) as XslCompiledTransform;
            if (transformer != null)
            {
                // Yes, return the cached transform
                return transformer;
            }

            // No cached transform, so create one. Make sure we do this in a locked section so
            // we don't get our knickers in a twist with multiple threads!
            lock (cacheXsltLock)
            {
                // Check again, as stacked threads might now be able to use a cached transform created from a previous thread.
                transformer = DnaStaticCache.Get(xsltFileName) as XslCompiledTransform;
                if (transformer != null)
                {
                    // Return the cached transform
                    return transformer;
                }

                // Check to see if we've got the xsl transform cache item in the cache.
                // This is used to trigger the clear templates functionality by making all cached transforms
                // dependant on this one!
                if (!DnaStaticCache.Exists(recacheDepends[0]))
                {
                    // Add the item to the cache
                    DnaStaticCache.Add(recacheDepends[0], "RecacheTrigger", null, DateTime.Now.AddMonths(12), TimeSpan.Zero, CacheItemPriority.High, null);
                }

                // No cached version, so create and load the file
				transformer = CreateCompiledTransform(xsltFileName);

                // Create a dependency for the cached transform based on the xsltransformcache cache item. When this gets removed, the transform will be removed at the same time.
                CacheDependency dep = new CacheDependency(null,recacheDepends);
                
                // Now add the new transform to the cache
                DnaStaticCache.Add(xsltFileName, transformer, dep, DateTime.Now.AddMonths(12), TimeSpan.Zero, CacheItemPriority.High, null);
                Diagnostics.WriteToLog("XSLT Caching", "Added cached file " + xsltFileName);
            }

            // Now return the transform
            return transformer;
        }

#if DEBUG
        /// <summary>
        /// A private class used to load XSLT files on another thread with a large stack
        /// Implemented to get around the reduced stack size in IIS 7
        /// </summary>
        private class TransformerLargeStack
        {
            private XslCompiledTransform transformer;

            private void LoadInternal(string xsltFileName)
            {
                transformer = new XslCompiledTransform(false /* xsltDebugging*/);

                // this stuff is necessary to cope with our stylesheets having DTDs
                // Without all this settings and resolver stuff, you can't use the Load method
                // and tell it to allow DTDs
                XmlReaderSettings xset = new XmlReaderSettings();
                xset.ProhibitDtd = false;
                using (XmlReader xread = XmlReader.Create(xsltFileName, xset))
                {
                    transformer.Load(xread, XsltSettings.TrustedXslt, new XmlUrlResolver());
                }
            }

            public XslCompiledTransform Load(string xsltFileName)
            {
                var thread = new Thread(() => LoadInternal(xsltFileName), 1024 * 1024);
                thread.Start();
                thread.Join();

                return transformer;
            }
        }
#endif

		/// <summary>
		/// Takes the path to an XSLT stylesheet and creates a compiled transformer
		/// </summary>
		/// <param name="xsltFileName">path to the .xsl file</param>
		/// <returns>the XslCompiledTransform object created from the stylesheet</returns>
		public static XslCompiledTransform CreateCompiledTransform(string xsltFileName)
		{
//            bool xsltDebugging = false;
//#if DEBUG
//            // Use xslt debugging?
//            xsltDebugging = true;
//#endif

            XslCompiledTransform transformer = new XslCompiledTransform(false /* xsltDebugging*/);

			// this stuff is necessary to cope with our stylesheets having DTDs
			// Without all this settings and resolver stuff, you can't use the Load method
			// and tell it to allow DTDs
			XmlReaderSettings xset = new XmlReaderSettings();
			xset.ProhibitDtd = false;
			using (XmlReader xread = XmlReader.Create(xsltFileName, xset))
			{
                try
                {
#if DEBUG
                    // Only need to do this on our IIS7 dev environments
                    var transLargeStack = new TransformerLargeStack();
                    transformer = transLargeStack.Load(xsltFileName);
#else
                    transformer.Load(xread, XsltSettings.TrustedXslt, new XmlUrlResolver());
#endif
                }
                catch (Exception e)
                {
                    Type exceptionType = e.GetType();
                    if (exceptionType.Name == "XslLoadException")
                    {
                        int lineNumber = (int)exceptionType.GetMethod("get_LineNumber").Invoke(e, null);
                        int linePosition = (int)exceptionType.GetMethod("get_LinePosition").Invoke(e, null);
                        string fileName = (string)exceptionType.GetMethod("get_SourceUri").Invoke(e, null);
                        throw new XsltException("XSLT Compile error in file " + fileName + " at line " + lineNumber + ", position " + linePosition, e);
                    }
                    else
                    {
                        throw new XsltException("Couldn't load xslt file: " + xsltFileName, e); 
                    }
                }
			}
			return transformer;
		}

		private static XslCompiledTransform CreateCompiledTransformLongWinded(string xsltFileName)
		{
			XslCompiledTransform transformer = new XslCompiledTransform();

			// this stuff is necessary to cope with our stylesheets having DTDs
			// Without all this settings and resolver stuff, you can't use the Load method
			// and tell it to allow DTDs
			XsltSettings settings = new XsltSettings();
			settings.EnableDocumentFunction = true;
			XmlUrlResolver resolver = new XmlUrlResolver();
			resolver.Credentials = CredentialCache.DefaultCredentials;

			XmlReaderSettings xset = new XmlReaderSettings();
			// Set the reader settings object to use the resolver.
			xset.XmlResolver = resolver;

			xset.ProhibitDtd = false;
			XmlReader xread = XmlReader.Create(xsltFileName, xset);
			transformer.Load(xread, XsltSettings.TrustedXslt, new XmlUrlResolver());
			return transformer;
		}
		
        /// <summary>
        /// This removes the xsltransformcache item from the Cache, which in turn forces all the cached transforms to be cleared form
        /// the cache as well.
        /// </summary>
        public void ClearTemplates()
        {
            // Remove the xsltransformcache item from the cache.
            DnaStaticCache.Remove(recacheDepends[0]);
            Diagnostics.WriteToLog("XSLT Caching", "Clear templates called");
        }

		/// <summary>
		/// Test whether the http authentication for this request is suitable for this page
		/// Some pages are not allowed for anonymous users. Some are restricted to editor only.
		/// Subclassed pages should change the value of _allowedUsers appropriately
		/// </summary>
		/// <returns>true if the current request has suitable authentication. False otherwise.</returns>
		public bool IsUserAllowed()
		{
			if ((_dnapage.AllowedUsers & UserTypes.Any) != 0)
			{
				return true;
			}
			if ((_dnapage.AllowedUsers & UserTypes.Volunteer) != 0)
			{
				return true;
			}

            if (_isSecureRequest)
            {
                return true;
            }
            else
            {
                return false;
            }

			/*string userName = Request.LogonUserIdentity.Name;
			if (userName.Contains(@"\"))
			{
				userName = userName.Substring(userName.IndexOf('\\')+1);
			}
            if (userName == String.Empty)
			{
				return false;
			}
            if ((_dnapage.AllowedUsers & UserTypes.Authenticated) != 0)
			{
				return true;
			}
            else if ((_dnapage.AllowedUsers & UserTypes.Tester) != 0 && userName == "tester")
			{
				return true;
			}
            else if ((_dnapage.AllowedUsers & UserTypes.Moderator) != 0 && userName == "moderator")
			{
				return true;
			}
            else if ((_dnapage.AllowedUsers & UserTypes.Editor) != 0 && userName == "editor")
			{
				return true;
			}
            else if ((_dnapage.AllowedUsers & UserTypes.Administrator) != 0 && userName == "editor")
			{
				return true;
			}
			else
			{
				return false;
			}*/
		}
		/// <summary>
		/// Checks whether if the page must be accessed by secure means that it is
		/// </summary>
        /// <returns>true if the page must be accessed securely.</returns>
        public bool IsSecureAccessAllowed()
        {
#if DEBUG
            switch (Environment.MachineName)
            {
                case "B1-L0S051473":
                    return true;
            }
#endif
            if (!_isSecureRequest)
            {//not a secure request
                if (_dnapage.AllowedUsers != UserTypes.Any && _dnapage.AllowedUsers != UserTypes.Volunteer)
                {//must be secure
                    return false;
                }
            }
            return true;

        }
        
		/// <summary>
		/// Checks whether the page is accessible by types of logged on user
		/// </summary>
		/// <returns>true if the current user is allowed to view the page. False otherwise.</returns>
        public bool IsDnaUserAllowed()
        {
            if ((_dnapage.AllowedUsers & UserTypes.Any) != 0)
			{
				return true;
			}
            if (ViewingUser.UserID != 0 && ViewingUser.UserLoggedIn)
            {
                //if ((AllowedUsers & UserTypes.Authenticated) != 0)
                //{
                //    return true;
                //}
                //else
				if ((_dnapage.AllowedUsers & UserTypes.Volunteer) != 0 && ViewingUser.IsVolunteer)
				{
					return true;
				}
				else if ((_dnapage.AllowedUsers & UserTypes.Moderator) != 0 && ViewingUser.IsModerator)
				{
					return true;
				}
				else if ((_dnapage.AllowedUsers & UserTypes.Editor) != 0 && ViewingUser.IsEditor)
				{
					return true;
				}
				else if ((_dnapage.AllowedUsers & UserTypes.Administrator) != 0 && ViewingUser.IsSuperUser)
				{
					return true;
				}
				else
				{
					return false;
				}
            }
            else
            {
                return false;
            }
        }

		/// <summary>
		/// <see cref="IAppContext"/>
		/// </summary>
		public bool FileCacheGetItem(string pCacheName, string pItemName, ref DateTime pdExpires, ref string oXMLText)
		{
			return AppContext.TheAppContext.FileCacheGetItem(pCacheName, pItemName, ref pdExpires, ref oXMLText);
		}

		private bool _isRequestAnonymous = false;

		/// <summary>
		/// Set this property to true if this request should not check for an SSO cookie and verify the user's identity
		/// This mode is used for RSS requests (requests where the skin = xml) but might be used in other scenarios.
		/// When this flag is set to true (and it must be set prior to the full initialisation of the page otherwise the
		/// default false will be used, and the user will be verified) the ViewingUser object will always show UserLoggedIn == false;
		/// </summary>
		public bool IsRequestAnonymous
		{
			get { return _isRequestAnonymous; }
			set { _isRequestAnonymous = value; }
		}

        /// <summary>
        /// Adds a cookie to the response
        /// </summary>
        /// <param name="cookie">The cookie you want to add</param>
        public void AddCookieToResponse(HttpCookie cookie)
        {
            Response.Cookies.Add(cookie);
        }
    }

	class RequestIdGenerator
	{
		private static int id = 0;
		static public int GetNextRequestId()
		{
			return Interlocked.Increment(ref id);
		}
	}

}
