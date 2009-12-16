using System;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Syndication;
using System.ServiceModel.Web;
using System.Text;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;



namespace BBC.Dna.Services
{
    public class baseService
    {
        protected ICacheManager _cacheManager = null;
        protected const string CACHE_LASTUPDATED = "|LASTUPDATED";
        protected const string CACHE_DELIMITER = "|";
        protected const int CACHEEXPIRYMINUTES = 10;
        private string _connectionString = string.Empty;
        private ISiteList _siteList = null;
        protected delegate DateTime CheckCacheDelegate(params object[] args);
        
        //querystring variables
        protected string _outputContentType = String.Empty;
        protected WebFormat.format _format = WebFormat.format.UNKNOWN;
        protected int _itemsPerPage=20;
        protected int _startIndex=0;
        protected string _prefix = string.Empty;
        protected SortBy _sortBy = SortBy.Created;
        protected SortDirection _sortDirection = SortDirection.Ascending;
        protected FilterBy _filterBy = FilterBy.None;
        protected string _filterByData = String.Empty;
        //user based querystring variables
        protected string _signOnType = string.Empty;
        protected int _summaryLength = 256;
        protected Guid _BBCUidCookie = Guid.Empty;
        protected string _iPAddress = String.Empty;

        public baseService(string connectionString, ISiteList siteList)
        {
            _siteList = siteList;
            _connectionString = connectionString;

            _cacheManager = CacheFactory.GetCacheManager();

            WebFormat.getReturnFormat((WebOperationContext.Current.IncomingRequest.ContentType == null ? "" : WebOperationContext.Current.IncomingRequest.ContentType),
                ref _outputContentType, ref _format);

            if (_format == WebFormat.format.UNKNOWN)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.UnknownFormat));
            }
            _itemsPerPage = QueryStringHelper.GetQueryParameterAsInt("itemsPerPage", 20);
            _startIndex = QueryStringHelper.GetQueryParameterAsInt("startIndex", 0);
            try
            {
                _sortBy = (SortBy)Enum.Parse(typeof(SortBy), QueryStringHelper.GetQueryParameterAsString("sortBy", ""));
            }
            catch { }

            try
            {
                _sortDirection = (SortDirection)Enum.Parse(typeof(SortDirection), QueryStringHelper.GetQueryParameterAsString("sortDirection", ""));
            }
            catch { }

            string filter = QueryStringHelper.GetQueryParameterAsString("filterBy", "");
            if (!String.IsNullOrEmpty(filter))
            {
                try
                {
                    _filterBy = (FilterBy)Enum.Parse(typeof(FilterBy), filter);
                }
                catch { }
            }

            switch (_filterBy)
            {//add parsing of filter by data here.
                case FilterBy.UserList: _filterByData = QueryStringHelper.GetQueryParameterAsString("userList", ""); break;
            }

            _prefix = QueryStringHelper.GetQueryParameterAsString("prefix", "");
            _signOnType = QueryStringHelper.GetQueryParameterAsString("signOnType", "identity");
            _summaryLength= QueryStringHelper.GetQueryParameterAsInt("summaryLength", 256);
            string cookie = QueryStringHelper.GetCookieValueAsString("BBC-UID", Guid.Empty.ToString());
            ApiCookies.CheckGUIDCookie(cookie, ref _BBCUidCookie);
            _iPAddress = QueryStringHelper.GetQueryParameterAsString("clientIP", "");
            if (string.IsNullOrEmpty(_iPAddress))
            {
                _iPAddress = QueryStringHelper.GetHeaderValueAsString("REMOTE_ADDR", "");
            }
        }

        ///// <summary>
        ///// Helper method for getting the site object given a sitename
        ///// </summary>
        ///// <param name="siteName">The name of the site you want to get</param>
        ///// <returns>The site object for the given sitename</returns>
        ///// <exception cref="ApiException">Thrown if the site does not exist</exception>
        protected ISite GetSite(string urlName)
        {
            ISite site = _siteList.GetSite(urlName);
            if (site == null)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.UnknownSite));
            }
            return site;
        }

        /// <summary>
        /// Gets the user from the cookies and signs them in
        /// </summary>
        /// <param name="site">The site</param>
        protected CallingUser GetCallingUser(ISite site)
        {
            CallingUser callingUser = null;
            bool userSignedIn = false;
            if (site != null)
            {
                if (String.IsNullOrEmpty(site.IdentityPolicy))
                {
                    callingUser = new CallingUser(SignInSystem.SSO, _connectionString, _cacheManager);
                    userSignedIn = callingUser.IsUserSignedIn(QueryStringHelper.GetCookieValueAsString("SSO2-UID", ""), site.SSOService, site.SiteID, "");
                }
                else
                {
                    callingUser = new CallingUser(SignInSystem.Identity, _connectionString, _cacheManager);
                    userSignedIn = callingUser.IsUserSignedIn(QueryStringHelper.GetCookieValueAsString("IDENTITY", ""), site.IdentityPolicy, site.SiteID, QueryStringHelper.GetCookieValueAsString("IDENTITY-USERNAME", ""));
                    Statistics.AddNonSSORequest();
                }
                // Check to see if we've got a user who's signed in, but not logged in. This usualy means they haven't agreed T&Cs
                if (callingUser.GetSigninStatus == CallingUser.SigninStatus.SignedInNotLoggedIn)
                {
                    throw new DnaWebProtocolException(new ApiException(site.IdentityPolicy, ErrorType.FailedTermsAndConditions));
                }
            }

            if (callingUser == null || !userSignedIn)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.MissingUserCredentials));

            }
            

            return callingUser;
        }

        /// <summary>
        /// Gets the formatated output
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        protected Stream GetOutputStream(object data)
        {
            return GetOutputStream(data, DateTime.MinValue);
        }

        /// <summary>
        /// Gets the output stream depending on the format.
        /// </summary>
        /// <param name="data">The data to return</param>
        /// <returns>A output stream</returns>
        protected Stream GetOutputStream(object data, DateTime lastUpdated)
        {
            
            string output = String.Empty;
            switch (_format)
            {
                case WebFormat.format.XML:
                    output = ((baseContract)data).ToXml();
                    break;

                case WebFormat.format.JSON:
                    output = ((baseContract)data).ToJson();
                    break;

                case WebFormat.format.HTML:
                    string xsltFile = String.Format("{0}/{1}.xsl", ConfigurationManager.AppSettings["xslt_directory"], data.GetType().Name);
                    int errorCount = 0;
                    output = ((baseContract)data).ToHtml(xsltFile, ref errorCount);
                    if (errorCount != 0)
                    {
                        throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, "Error during xslt transformation", new Exception(output));
                    }
                    break;

                case WebFormat.format.RSS:

                    SyndicationFeed feed = ((baseContract)data).ToFeed();
                    if (feed == null)
                    {
                        throw new DnaWebProtocolException(System.Net.HttpStatusCode.NotImplemented, "Not implemented yet", null);
                    }
                    output = StringUtils.SerializeToRss(feed);
                    break;

                case WebFormat.format.ATOM:
                    feed = ((baseContract)data).ToFeed();
                    if (feed == null)
                    {
                        throw new DnaWebProtocolException(System.Net.HttpStatusCode.NotImplemented, "Not implemented yet", null);
                    }
                    output = StringUtils.SerializeToAtom10(feed);
                    break;

                default:
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.NotImplemented, "Not implemented yet", null);

            }
            //get output stream
            WebOperationContext.Current.OutgoingResponse.ContentType = _outputContentType;
            MemoryStream memoryStream = new MemoryStream(StringUtils.StringToUTF8ByteArray(output));
            XmlTextWriter xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);
            //add to cache
            AddOutputToCache(output, GetCacheKey(), lastUpdated);

            return xmlTextWriter.BaseStream;
            
        }

        /// <summary>
        /// Adds the current output to the cache
        /// </summary>
        /// <param name="output"></param>
        /// <param name="lastUpdated"></param>
        /// <returns></returns>
        private bool AddOutputToCache(string output, string cacheKey, DateTime lastUpdated)
        {
            if (WebOperationContext.Current.IncomingRequest.Method.ToUpper() != "GET")
            {//only cache for GET's nothing else
                return true;
            }
            if (lastUpdated != DateTime.MinValue)
            {//dont add if no update value
                //ICacheItemExpiration expiry = SlidingTime.
                _cacheManager.Add(cacheKey + CACHE_LASTUPDATED, lastUpdated, CacheItemPriority.Normal,
                null, new SlidingTime(TimeSpan.FromMinutes(CACHEEXPIRYMINUTES)));

                _cacheManager.Add(cacheKey, output, CacheItemPriority.Normal,
                null, new SlidingTime(TimeSpan.FromMinutes(CACHEEXPIRYMINUTES)));
            }

            return true;
        }

        /// <summary>
        /// Returns the cached data from cache
        /// </summary>
        /// <param name="output">The output stream reference</param>
        /// <param name="method">A delegate method which takes params and returns a datetime of lastupdate.
        /// A Null method means not to check the db for cache key.</param>
        /// <param name="args">The args for the delegate</param>
        /// <returns>True if cache ok</returns>
        protected bool GetOutputFromCache(ref Stream output, Delegate method, params object[]args)
        {
            string cacheKey = GetCacheKey();
            object tempLastUpdated = _cacheManager.GetData(cacheKey + CACHE_LASTUPDATED);

            if (tempLastUpdated == null)
            {//not found
                output = null;
                return false;
            }
            DateTime lastUpdated = (DateTime)tempLastUpdated;
            //check if cache is up to date
            if (method != null)
            {
                if (DateTime.Compare(lastUpdated, (DateTime)method.DynamicInvoke(new Object[]{args})) != 0)
                {//cache out of date so delete
                    output = null;
                    return false;
                }
            }
            //get actual cached object
            string outputStr = (string)_cacheManager.GetData(cacheKey);
            if (outputStr == null)
            {//cache out of date so delete
                output = null;
                return false;
            }
            WebOperationContext.Current.OutgoingResponse.ContentType = _outputContentType;
            MemoryStream memoryStream = new MemoryStream(StringUtils.StringToUTF8ByteArray(outputStr));
            XmlTextWriter xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);
            output = xmlTextWriter.BaseStream;

            Statistics.AddHTMLCacheHit();

            return true;
        }

        /// <summary>
        /// Generates a service url cache key
        /// </summary>
        /// <returns>A string cache key</returns>
        protected string GetCacheKey()
        {
                   

            return GetType().Namespace + CACHE_DELIMITER +
                WebOperationContext.Current.IncomingRequest.UriTemplateMatch.RequestUri.PathAndQuery + CACHE_DELIMITER +
                _itemsPerPage.ToString() + CACHE_DELIMITER +
                _startIndex + CACHE_DELIMITER +
                _sortBy + CACHE_DELIMITER +
                _sortDirection + CACHE_DELIMITER +
                _filterBy + CACHE_DELIMITER +
                _filterByData + CACHE_DELIMITER +
                _format + CACHE_DELIMITER +
                _prefix + CACHE_DELIMITER;
        }
    }
}
