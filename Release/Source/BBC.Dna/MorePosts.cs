using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the MorePosts object, holds the list of posts for a user
    /// </summary>
    public class MorePosts : DnaInputComponent
    {
        private const string _docDnaShow = @"The number of posts to show.";
        private const string _docDnaSkip = @"The number of posts to skip.";
        private const string _docDnaUserID = @"User ID of the posts to look at.";
        private const string _docDnaPostType = @"Specific post type to look for.";
        private const string _docDnaMarkAllRead = @"Param that marks the posts as all read";


        string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor for the MorePosts component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MorePosts(IInputContext context)
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

            TryCreateMorePosts();

        }
        /// <summary>
        /// Method called to try to create the TryCreateMorePosts xml, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <returns>Whether the search has suceeded with out error</returns>
        private bool TryCreateMorePosts()
        {
            int userID = 0;
            int skip = 0;
            int show = 0;
            int postType = 0;

            bool markAllRead = false;

            TryGetPageParams(ref userID, ref skip, ref show, ref postType, ref markAllRead);

            if (markAllRead && InputContext.ViewingUser != null)
            {
                int viewingUserID = InputContext.ViewingUser.UserID;
                PostList PostList = new PostList(InputContext);
                PostList.MarkAllRead(viewingUserID);
            }

            //bool cached = GetMorePostsCachedXml(userID, skip, show, postType);

            //if (!cached)
            //{
                GenerateMorePostsPageXml(userID, skip, show, postType);
            //}

            return true;
        }


        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// 
        private void TryGetPageParams(ref int userID, ref int skip, ref int show, ref int postType, ref bool markAllRead)
        {
            userID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);
            if (show > 200)
            {
                show = 200;
            }
            else if (show < 1)
            {
                show = 25;
            }
            if (skip < 1)
            {
                skip = 0;
            }

            // See if we've been given a specific type of post to look for
            postType = 0;
            if (InputContext.DoesParamExist("posttype", _docDnaPostType))
            {
                string postTypeParam = InputContext.GetParamStringOrEmpty("posttype", _docDnaPostType);
                if (postTypeParam == "notice")
                {
                    postType = 1;
                }
                else if (postTypeParam == "event")
                {
                    postType = 2;
                }
            }

            markAllRead = InputContext.DoesParamExist("allread", _docDnaMarkAllRead);
        }

        /// <summary>
        /// Calls the post list class to generate the most recent posts
        /// </summary>
        private void GenerateMorePostsPageXml(int userID, int skip, int show, int postType)
        {
            // all the XML objects we need to build the page
            PostList postList = new PostList(InputContext);

            // get the journal posts we want from the forum
            postList.CreateRecentPostsList(userID, skip, show, postType, InputContext.CurrentSite.SiteID);

            // Put in the wrapping <POSTS> tag which has the user ID in it
            XmlElement posts = AddElementTag(RootElement, "POSTS");
            AddAttribute(posts, "USERID", userID);
            AddInside(posts, postList);

            //FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "recentposts", _cacheName, posts.OuterXml);

            if(InputContext.GetSiteOptionValueBool(InputContext.CurrentSite.SiteID, "General", "UseSystemMessages"))
            {
	            // Setup the SiteOption Xml
                XmlElement siteOption = AddElementTag(RootElement, "SITEOPTION");
                AddTextTag(siteOption, "NAME", "UseSystemMessages");
                AddTextTag(siteOption, "VALUE", "1");
            }
            
            // Add the sites topic list
            //RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetTopicListXml()));
            // Add site list xml
            //RootElement.AppendChild(ImportNode(InputContext.TheSiteList.GenerateAllSitesXml().FirstChild));
        }

        /// <summary>
        /// Gets the XML from cache
        /// </summary>
        /// <returns>Whether we have got the XML from the File Cache</returns>
        private bool GetMorePostsCachedXml(int userID, int skip, int show, int postType)
        {
            bool gotFromCache = false;

            _cacheName = "moreposts-";
            _cacheName += userID + "-";
            _cacheName += postType + "-";
            _cacheName += skip + "-";
            _cacheName += show;
            _cacheName += ".xml"; ;
            /*
            //Try to get a cached copy.
            DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(10);  // expire after 10 minutes
            string recentPostsXML = String.Empty;

            if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "recentposts", _cacheName, ref expiry, ref recentPostsXML))
            {
                RipleyAddInside(RootElement, recentPostsXML);
                gotFromCache = true;
            }
            */
            return gotFromCache;
        }
    }
}
