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
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using System.Web;



namespace BBC.Dna.Services
{

    public class baseService
    {
        
        private string _connectionString;

        protected readonly ISiteList siteList = null;
        protected readonly ICacheManager cacheManager = null;
        protected const string CacheLastupdated = "|LASTUPDATED";
        protected const string CacheDelimiter = "|";
        protected const int Cacheexpiryminutes = 10;
        protected readonly IDnaDataReaderCreator readerCreator = null;
        protected delegate DateTime CheckCacheDelegate(params object[] args);
        
        //querystring variables
        protected string outputContentType = String.Empty;
        protected WebFormat.format format = WebFormat.format.UNKNOWN;
        protected int itemsPerPage=20;
        protected int startIndex;
        protected string prefix = string.Empty;
        protected SortBy sortBy = SortBy.Created;
        protected SortDirection sortDirection = SortDirection.Ascending;
        protected FilterBy filterBy = FilterBy.None;
        protected string filterByData = String.Empty;
        //user based querystring variables
        protected string signOnType = string.Empty;
        protected int summaryLength = 256;
        protected Guid bbcUidCookie = Guid.Empty;
        protected string _iPAddress = String.Empty;
        protected string debugDnaUserId;
        protected IDnaDiagnostics dnaDiagnostic;
        protected string _languageCode = "en";
        protected bool _internalRequest = false; //if request comes from bbc servers or not

        public baseService(string connectionString, ISiteList siteList, IDnaDiagnostics dnaDiag)
        {
            if (ConfigurationManager.AppSettings["MaintenanceMode"] == "1")
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.MaintenanceMode));
            }
            
            _connectionString = connectionString;
            this.siteList = siteList;
            readerCreator = new DnaDataReaderCreator(connectionString, dnaDiag);
            dnaDiagnostic = dnaDiag;
            cacheManager = CacheFactory.GetCacheManager();

            if (WebOperationContext.Current == null)
            {
                throw new Exception("Error creating web operation context object.");
            }

            WebFormat.getReturnFormat((WebOperationContext.Current.IncomingRequest.ContentType == null ? "" : WebOperationContext.Current.IncomingRequest.ContentType),
                ref outputContentType, ref format);

            if (format == WebFormat.format.UNKNOWN)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.UnknownFormat));
            }
            itemsPerPage = QueryStringHelper.GetQueryParameterAsInt("itemsPerPage", 20);
            startIndex = QueryStringHelper.GetQueryParameterAsInt("startIndex", 0);
            try
            {
                sortBy = (SortBy)Enum.Parse(typeof(SortBy), QueryStringHelper.GetQueryParameterAsString("sortBy", ""));
            }
            catch { }

            try
            {
                sortDirection = (SortDirection)Enum.Parse(typeof(SortDirection), QueryStringHelper.GetQueryParameterAsString("sortDirection", ""));
            }
            catch { }

            string filter = QueryStringHelper.GetQueryParameterAsString("filterBy", "");
            if (!String.IsNullOrEmpty(filter))
            {
                try
                {
                    filterBy = (FilterBy)Enum.Parse(typeof(FilterBy), filter);
                }
                catch { }
            }

            switch (filterBy)
            {//add parsing of filter by data here.
                case FilterBy.UserList: filterByData = QueryStringHelper.GetQueryParameterAsString("userList", ""); break;
                case FilterBy.PostsWithinTimePeriod: filterByData = QueryStringHelper.GetQueryParameterAsString("timeperiod", ""); break;
            }

            prefix = QueryStringHelper.GetQueryParameterAsString("prefix", "");
            signOnType = QueryStringHelper.GetQueryParameterAsString("signOnType", "identity");
            summaryLength= QueryStringHelper.GetQueryParameterAsInt("summaryLength", 256);
            string cookie = QueryStringHelper.GetCookieValueAsString("BBC-UID", Guid.Empty.ToString());
            bbcUidCookie = UidCookieDecoder.Decode(cookie, ConfigurationManager.AppSettings["SecretKey"]);
            _iPAddress = QueryStringHelper.GetQueryParameterAsString("clientIP", "");
            if (string.IsNullOrEmpty(_iPAddress))
            {
                _iPAddress = QueryStringHelper.GetHeaderValueAsString("REMOTE_ADDR", "");
            }
            _internalRequest = (QueryStringHelper.GetQueryParameterAsString("_bbc_", "") == "1");
            debugDnaUserId = "";
#if DEBUG
            debugDnaUserId = QueryStringHelper.GetQueryParameterAsString("d_identityuserid", "");
#endif
            
        }

        ///// <summary>
        ///// Helper method for getting the site object given a sitename
        ///// </summary>
        ///// <param name="siteName">The name of the site you want to get</param>
        ///// <returns>The site object for the given sitename</returns>
        ///// <exception cref="ApiException">Thrown if the site does not exist</exception>
        protected ISite GetSite(string urlName)
        {
            ISite site = siteList.GetSite(urlName);
            if (site == null)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.UnknownSite));
            }

            //set the language code
            _languageCode = siteList.GetSiteOptionValueString(site.SiteID, "General", "SiteLanguage");

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
                    callingUser = new CallingUser(SignInSystem.SSO, readerCreator, dnaDiagnostic, cacheManager, debugDnaUserId, siteList);
                    userSignedIn = callingUser.IsUserSignedIn(QueryStringHelper.GetCookieValueAsString("SSO2-UID", ""), site.SSOService, site.SiteID, "");
                }
                else
                {
                    callingUser = new CallingUser(SignInSystem.Identity, readerCreator, dnaDiagnostic, cacheManager, debugDnaUserId, siteList);
                    userSignedIn = callingUser.IsUserSignedInSecure(QueryStringHelper.GetCookieValueAsString("IDENTITY", ""), QueryStringHelper.GetCookieValueAsString("IDENTITY-HTTPS", ""), site.IdentityPolicy, site.SiteID);
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
        /// Gets the user from the cookies and signs them in
        /// </summary>
        /// <param name="site">The site</param>
        protected CallingUser TryGetCallingUser(ISite site)
        {
            CallingUser callingUser = null;
            bool userSignedIn = false;
            if (site != null)
            {
                if (String.IsNullOrEmpty(site.IdentityPolicy))
                {
                    callingUser = new CallingUser(SignInSystem.SSO, readerCreator, dnaDiagnostic, cacheManager, debugDnaUserId, siteList);
                    userSignedIn = callingUser.IsUserSignedIn(QueryStringHelper.GetCookieValueAsString("SSO2-UID", ""), site.SSOService, site.SiteID, "");
                }
                else
                {
                    callingUser = new CallingUser(SignInSystem.Identity, readerCreator, dnaDiagnostic, cacheManager, debugDnaUserId, siteList);
                    userSignedIn = callingUser.IsUserSignedInSecure(QueryStringHelper.GetCookieValueAsString("IDENTITY", ""), QueryStringHelper.GetCookieValueAsString("IDENTITY-HTTPS", ""), site.IdentityPolicy, site.SiteID);
                }
                // Check to see if we've got a user who's signed in, but not logged in. This usualy means they haven't agreed T&Cs
                if (callingUser.GetSigninStatus == CallingUser.SigninStatus.SignedInNotLoggedIn)
                {
                    throw new DnaWebProtocolException(new ApiException(site.IdentityPolicy, ErrorType.FailedTermsAndConditions));
                }
            }

            if (callingUser == null || !userSignedIn)
            {
                return null;
            }

            return callingUser;
        }

        /// <summary>
        /// gets the calling user or uses the notsignedin forum user
        /// </summary>
        /// <param name="site"></param>
        /// <param name="forum"></param>
        /// <returns></returns>
        protected CallingUser GetCallingUserOrNotSignedInUser(ISite site, CommentForum forum)
        {
            CallingUser callingUser = null;
            bool userSignedIn = false;
            if (site != null)
            {
                if (String.IsNullOrEmpty(site.IdentityPolicy))
                {
                    callingUser = new CallingUser(SignInSystem.SSO, readerCreator, dnaDiagnostic, cacheManager, debugDnaUserId, siteList);
                    userSignedIn = callingUser.IsUserSignedIn(QueryStringHelper.GetCookieValueAsString("SSO2-UID", ""), site.SSOService, site.SiteID, "");
                }
                else
                {
                    callingUser = new CallingUser(SignInSystem.Identity, readerCreator, dnaDiagnostic, cacheManager, debugDnaUserId, siteList);
                    userSignedIn = callingUser.IsUserSignedInSecure(QueryStringHelper.GetCookieValueAsString("IDENTITY", ""), QueryStringHelper.GetCookieValueAsString("IDENTITY-HTTPS", ""), site.IdentityPolicy, site.SiteID);
                }
                // Check to see if we've got a user who's signed in, but not logged in. This usualy means they haven't agreed T&Cs
                if (callingUser.GetSigninStatus == CallingUser.SigninStatus.SignedInNotLoggedIn)
                {
                    throw new DnaWebProtocolException(new ApiException(site.IdentityPolicy, ErrorType.FailedTermsAndConditions));
                }
            }

            if ((callingUser == null || !userSignedIn) && (forum.allowNotSignedInCommenting && forum.NotSignedInUserId != 0))
            {
                userSignedIn = callingUser.CreateUserFromDnaUserID(forum.NotSignedInUserId, site.SiteID);
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
            switch (format)
            {
                case WebFormat.format.XML:
                    WebOperationContext.Current.OutgoingResponse.ContentType = outputContentType;
                    WebOperationContext.Current.OutgoingResponse.Headers.Add("Content-Language", _languageCode);
                    return StringUtils.SerializeToXml(data);
                    //output = output.Replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "<?xml version=\"1.0\" encoding=\"utf-8\"?>" + Entities.GetEntities());
                    break;

                case WebFormat.format.JSON:
                    WebOperationContext.Current.OutgoingResponse.ContentType = outputContentType;
                    WebOperationContext.Current.OutgoingResponse.Headers.Add("Content-Language", _languageCode);
                    return StringUtils.SerializeToJson(data);
                    break;

                //case WebFormat.format.HTML:
                    //string xsltFile = String.Format("{0}/{1}.xsl", ConfigurationManager.AppSettings["xslt_directory"], data.GetType().Name);
                    //int errorCount = 0;
                    //output = ((baseContract)data).ToHtml(xsltFile, ref errorCount);
                    //if (errorCount != 0)
                    //{
                    //    throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, "Error during xslt transformation", new Exception(output));
                    //}
               //     throw new DnaWebProtocolException(System.Net.HttpStatusCode.Unauthorized, "Not implemented yet", null);
               //     break;

                    //TODO Convert to streams
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
            //NOTE as soon as these are set - the output status is set and cannot be overwritten!
            WebOperationContext.Current.OutgoingResponse.ContentType = outputContentType;
            WebOperationContext.Current.OutgoingResponse.Headers.Add("Content-Language", _languageCode);
            MemoryStream memoryStream = new MemoryStream(StringUtils.StringToUTF8ByteArray(output));
            XmlTextWriter xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);

            
            return xmlTextWriter.BaseStream;
        }

        /// <summary>
        /// Generates a service url cache key
        /// </summary>
        /// <returns>A string cache key</returns>
        protected string GetCacheKey()
        {
                   

            return GetType().Namespace + CacheDelimiter +
                WebOperationContext.Current.IncomingRequest.UriTemplateMatch.RequestUri.PathAndQuery + CacheDelimiter +
                itemsPerPage.ToString() + CacheDelimiter +
                startIndex + CacheDelimiter +
                sortBy + CacheDelimiter +
                sortDirection + CacheDelimiter +
                filterBy + CacheDelimiter +
                filterByData + CacheDelimiter +
                format + CacheDelimiter +
                prefix + CacheDelimiter;
        }

    }
}
