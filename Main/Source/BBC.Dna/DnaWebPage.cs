using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using System.Web.UI;
using System.Web;
using System.Web.UI.WebControls;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

//Build you bugger!!

namespace BBC.Dna.Page
{
    /// <summary>
    /// The new DNA web page. All pages are derived from this class
    /// </summary>
    public abstract class DnaWebPage : System.Web.UI.Page, IDnaWebPage
    {
        /// <summary>
        /// The DnaWebPage constructor
        /// Creates a new DnaBasePage for the web page
        /// </summary>
        public DnaWebPage()
        {
            _basePage = new DnaBasePage(this);
            
        }

        /// <summary>
        /// The DnaBasePage object. This handles all the work needed to complete the request
        /// </summary>
        protected DnaBasePage _basePage;
        private IRequest _request;
        private Response _response;
        private ServerUtility _serverUtility;
        private bool _setDnaXmlDataSource = false;
        private List<DnaXmlSourceDetails> _xmlDataSourceControlIDs = new List<DnaXmlSourceDetails>();

        /// <param name="writer">The <see cref="T:System.Web.UI.HtmlTextWriter"></see> that receives the page content.</param>
        protected override void Render(HtmlTextWriter writer)
        {
            _basePage.Render(writer);
        }

        /// <summary>
        /// This method is called from the DnaBasePage, and basically gets this page to render itself.
        /// </summary>
        /// <param name="writer">The writer in which to render</param>
        public void DotNetRender(HtmlTextWriter writer)
        {
            base.Render(writer);
        }

        /// <summary>
        /// Called by ASP.NET when the page is called
        /// </summary>
        /// <param name="sender">The object that sent the request</param>
        /// <param name="e">Arguments passed in</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            DnaStaticCache.InitialiseCache(Page.Cache);
            _basePage.Page_Load(sender, e);
        }
        
        /// <summary>
        /// Called by ASP.NET at the end of the request
        /// </summary>
        /// <param name="sender">The object that sent the request</param>
        /// <param name="e">Arguments passed in</param>
        protected void Page_Unload(object sender, EventArgs e)
        {
            _basePage.Page_Unload(sender, e);
        }

        /// <summary>
        /// Called by ASP.NET when it recieves an unhandled exception
        /// </summary>
        /// <param name="sender">The object that sent the request</param>
        /// <param name="e">Arguments passed in</param>
        protected void Page_Error(object sender, EventArgs e)
        {
            _basePage.Page_Error(sender,e);
        }

        /// <summary>
        /// Get the string representing the page type.
        /// </summary>
        public abstract string PageType { get; }

        /// <summary>
        /// Base function that gets overriden by the different DNA Pages.
        /// </summary>
        public abstract void OnPageLoad();

        /// <summary>
        /// Get property for getting the list of control ids that require the whole page xml to be
        /// set as there data source.
        /// </summary>
        public List<DnaXmlSourceDetails> DnaXmlDataSourceContolIDs
        {
            get { return _xmlDataSourceControlIDs; }
        }

        /// <summary>
        /// Used to update any xml data source controls after the page components have finished processing the request
        /// </summary>
        public void UpdateDataSourceControls()
        {
            // Check to see if we're doing .net rendering, if so bind data.
            // This allows aspx pages to access the whole page xml for their values.
            if (UseDotNetRendering)
            {
                // Check to see if we've been told to set the data source
                if (SetDnaXmlDataSource && _xmlDataSourceControlIDs.Count > 0)
                {
                    // Go through the list of control IDs finding the control and setting the data soource to the webpage XML
                    foreach (DnaXmlSourceDetails controlDetails in _xmlDataSourceControlIDs)
                    {
                        DataBoundControl dataSourceContol = (DataBoundControl)FindControl(controlDetails.ControlID);
                        if (dataSourceContol != null)
                        {
                            string xpath = controlDetails.XPath;
                            if (xpath.Length == 0)
                            {
                                xpath = "//H2G2";
                            }
                            dataSourceContol.DataSource = DnaWebPageXml.SelectSingleNode(xpath);
                        }
                    }

                    // Now bind the data to the page
                    this.DataBind();
                }
            }
        }

        /// <summary>
        /// Called after the components have processed the request.
        /// Override this if you need to do any post process request actions.
        /// </summary>
        public virtual void OnPostProcessRequest()
        {
        }

        /// <summary>
        /// Gets the allowed user for the current page. Can be overriden by derived pages
        /// The default is to allow all users.
        /// </summary>
        /// <seealso cref="DnaBasePage.UserTypes"/>
        public virtual DnaBasePage.UserTypes AllowedUsers
        {
            get { return DnaBasePage.UserTypes.Any; }
        }

        /// <summary>Gets whether the page must be accessed securely. Can be overriden by derived pages
        /// The default is to allow all requests (ie not secure).
        /// </summary>
        public virtual bool MustBeSecure
        {
            get { return false; }
        }

        /// <summary>
        /// Defaultly includes the topfives in the current page. Override this to stop the inclusion.
        /// </summary>
        public virtual bool IncludeTopFives
        {
            get { return false; }
        }

        /// <summary>
        /// Adds a component to base page
        /// </summary>
        /// <param name="component">The component that you want to add to the base page</param>
        protected void AddComponent(IDnaComponent component)
        {
            _basePage.AddComponent(component);
        }

        /// <summary>
        /// Gets the DNA wrapped Request object
        /// If it does not exist, it will create it on demand
        /// </summary>
        public new IRequest Request
        {
            get
            {
                if (_request == null)
                {
                    _request = new Request(Page.Request);
                }
                return _request;
            }
        }

        /// <summary>
        /// Gets the DNA wrapped Response object
        /// If it does not exist, it will create it on demand
        /// </summary>
        public new IResponse Response
        {
            get
            {
                if (_response == null)
                {
                    _response = new Response(Page.Response);
                }
                return _response;
            }
        }

        /// <summary>
        /// Gets the DNA wrapped Server object
        /// If it does not exist, it will create it on demand
        /// </summary>
        public new IServerUtility Server
        {
            get
            {
                if (_serverUtility == null)
                {
                    _serverUtility = new ServerUtility(Page.Server);
                }
                return _serverUtility;
            }
        }

        /// <summary>
        /// Gets the timestamp for the request
        /// </summary>
        public DateTime Timestamp
        {
            get { return HttpContext.Current.Timestamp; }
        }

        /// <summary>
        /// Used to see if htlm caching has been enabled or not
        /// </summary>
        /// <returns>True if enables, fasle if not</returns>
        public virtual bool IsHtmlCachingEnabled()
        {
            return GetSiteOptionValueBool("cache", "HTMLCaching");
        }

        /// <summary>
        /// Used to get the length of time html is cached for
        /// </summary>
        /// <returns>The length of time in seconds</returns>
        public virtual int GetHtmlCachingTime()
        {
            return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
        }

        /// <summary>
        /// Property indicating whether we should use .NET rendering of the aspx page.
        /// True if we should (overriding the transformation step
        /// False if we should use the XSLT transform mechanism
        /// </summary>
        protected bool UseDotNetRendering
        {
            get { return _basePage.UseDotNetRendering; }
            set { _basePage.UseDotNetRendering = value; }
        }

        /// <summary>
        /// Property to state whether or not to set the data for the DnaXmlDataSource control in a page
        /// to that of the Outer Text of the DnaWebPage XML
        /// </summary>
        protected bool SetDnaXmlDataSource
        {
            get { return _setDnaXmlDataSource; }
            set { _setDnaXmlDataSource = value; }
        }

        /// <summary>
        /// <see cref="AppContext.GetSiteOptionValueInt"/>
        /// </summary>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        protected int GetSiteOptionValueInt(string section, string name)
        {
            return _basePage.GetSiteOptionValueInt(section, name);
        }

        /// <summary>
        /// <see cref="AppContext.GetSiteOptionValueBool"/>
        /// </summary>
        /// <param name="section"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        protected bool GetSiteOptionValueBool(string section, string name)
        {
            return _basePage.GetSiteOptionValueBool(section, name);
        }

        /// <summary>
        /// Used to see if the user is allowed to vview the requested page
        /// </summary>
        /// <returns>True if allowed, fasle if not</returns>
        protected bool IsDnaUserAllowed()
        {
            return _basePage.IsDnaUserAllowed();
        }

        /// <summary>
        /// Get the User object representing the viewing user.
        /// </summary>
        protected IUser ViewingUser
        {
            get { return _basePage.ViewingUser; }
        }

        /// <summary>
        /// Get the Site object representing the current site.
        /// </summary>
        protected ISite CurrentSite
        {
            get { return _basePage.CurrentSite; }
        }

        /// <summary>
        /// Gets the ISite object representing the give site
        /// </summary>
        /// <param name="siteName">Name of the site</param>
        /// <returns>An ISite object, or null if not found</returns>
        protected ISite GetSite(string siteName)
        {
            return _basePage.TheSiteList.GetSite(siteName);
        }

        /// <summary>
        /// Gets the root node of the current dna page
        /// </summary>
        protected XmlNode DnaWebPageXml
        {
            get { return _basePage.WholePageBaseXmlNode; }
        }
    }
}
