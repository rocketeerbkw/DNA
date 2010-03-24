using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the More Article Subscriptions Page object, holds the list of articles written by users that have been subscribed to.
    /// </summary>
    public class MoreArticleSubscriptions : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of ArticleSubscriptions to skip.";
        private const string _docDnaShow = @"The number of ArticleSubscriptions to show.";
        private const string _docDnaUserID = @"User ID of the More Article Subscriptions to look at.";

        string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor for the MoreArticleSubscriptions component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MoreArticleSubscriptions(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            bool skipCache = false;
            int userID = 0;
            int skip = 0;
            int show = 0;
            string action = String.Empty;

            TryGetPageParams(ref userID, ref skip, ref show);

            TryCreateMoreArticleSubscriptions(userID, skip, show, skipCache);

        }
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        private void TryGetPageParams(ref int userID, ref int skip, ref int show)
        {
            userID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);

            if (show < 1)
            {
                show = 25;
            }
            
            if (skip < 0)
            {
                skip = 0;
            }
        }

        /// <summary>
        /// Method called to try to create the TryCreateMoreArticleSubscriptions, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="skipCache">Whether to skip the cache read and always create the page.</param>
        /// <returns>Whether the search has suceeded with out error.</returns>
        private bool TryCreateMoreArticleSubscriptions(int userID, int skip, int show, bool skipCache)
        {
            bool cached = false;
            GetCacheName(userID, InputContext.CurrentSite.SiteID, skip, show);
            if (!skipCache)
            {
                cached = GetMoreArticleSubscriptionsCachedXml(userID, skip, show);
            }
            if (!cached)
            {
                GenerateMoreArticleSubscriptionsPageXml(userID, skip, show);
            }
            return true;
        }

        /// <summary>
        /// Calls the User Subscription list class to generate the most recent UserSubscriptions
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        private void GenerateMoreArticleSubscriptionsPageXml(int userID, int skip, int show)
        {
            ArticleSubscriptionsList articleSubscriptionList = new ArticleSubscriptionsList(InputContext);

            articleSubscriptionList.CreateArticleSubscriptionsList(userID, InputContext.CurrentSite.SiteID, skip, show);

            // Put in the wrapping <MoreUserSubscriptions> tag which has the user ID in it
            XmlElement moreArticleSubscriptions = AddElementTag(RootElement, "MoreArticleSubscriptions");
            AddAttribute(moreArticleSubscriptions, "USERID", userID);
			if ( InputContext.ViewingUser.UserID != 0 && InputContext.ViewingUser.UserLoggedIn)
			{
				AddAttribute(moreArticleSubscriptions, "ACCEPTSUBSCRIPTIONS", Convert.ToInt32(InputContext.ViewingUser.AcceptSubscriptions));
			}

            AddInside(moreArticleSubscriptions, articleSubscriptionList);

            FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "ArticleSubscriptions", _cacheName, moreArticleSubscriptions.OuterXml);
        }

        /// <summary>
        /// Gets the Cache name 
        /// </summary>
        /// <param name="userID">The user requesting their subscriptions</param>
        /// <param name="siteID">The site the user is getting their subscriptions from</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        private void GetCacheName(int userID, int siteID, int skip, int show)
        {
            _cacheName = "MAS-";
            _cacheName += userID + "-";
            _cacheName += siteID + "-";
            _cacheName += skip + "-";
            _cacheName += show;
            _cacheName += ".xml";
        }

        /// <summary>
        /// Gets the XML from cache
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        /// <returns>Whether we have got the XML from the File Cache</returns>
        private bool GetMoreArticleSubscriptionsCachedXml(int userID, int skip, int show)
        {
			return false;
			////Clear any exisitng xml
			//RootElement.RemoveAll();

			//bool gotFromCache = false;

			////Try to get a cached copy.
			//DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(10);  // expire after 10 minutes
			//string moreArticleSubscriptionsXML = String.Empty;

			//if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "ArticleSubscriptions", _cacheName, ref expiry, ref moreArticleSubscriptionsXML))
			//{
			//    RipleyAddInside(RootElement, moreArticleSubscriptionsXML);
			//    gotFromCache = true;
			//}

			//return gotFromCache;
        }
    }
}