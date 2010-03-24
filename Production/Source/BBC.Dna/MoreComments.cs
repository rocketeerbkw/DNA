using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the MoreComment Page object, holds the list of comments for a user
    /// </summary>
    public class MoreComments : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of comments to skip.";
        private const string _docDnaShow = @"The number of comments to show.";
        private const string _docDnaUserID = @"User ID of the more comments to look at.";
        

        string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor for the MoreComments component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MoreComments(IInputContext context)
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

            TryCreateMoreComments();

        }
        /// <summary>
        /// Method called to try to create the TryCreateMoreComments, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <returns>Whether the search has suceeded with out error</returns>
        private bool TryCreateMoreComments()
        {
            int userID=0;
            int skip=0;
            int show = 0;

            TryGetPageParams(ref userID, ref skip, ref show);

            bool cached = GetMoreCommentsCachedXml(userID, skip, show);

            if (!cached)
            {
                GenerateMoreCommentsPageXml(userID, skip, show);
            }
            return true;
        }


        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// 
        private void TryGetPageParams(ref int userID, ref int skip, ref int show)
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
            if (skip < 0)
            {
                skip = 0;
            }
        }

        /// <summary>
        /// Calls the comment list class to generate the most recent comments
        /// </summary>
        private void GenerateMoreCommentsPageXml(int userID, int skip, int show)
        {        	
	        // all the XML objects we need to build the page
            CommentsList commentList = new CommentsList(InputContext);

	        // get the recent comment list
            commentList.CreateRecentCommentsList(userID, InputContext.CurrentSite.SiteID, skip, show);

	        // Put in the wrapping <MORECOMMENTS> tag which has the user ID in it
            XmlElement moreComments = AddElementTag(RootElement, "MORECOMMENTS");
            AddAttribute(moreComments, "USERID", userID);
            AddInside(moreComments, commentList);

            FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "recentcomments", _cacheName, moreComments.OuterXml);
        }

        /// <summary>
        /// Gets the XML from cache
        /// </summary>
        /// <returns>Whether we have got the XML from the File Cache</returns>
        private bool GetMoreCommentsCachedXml(int userID, int skip, int show)
        {
            bool gotFromCache = false;

            _cacheName = "morecomments-";
            _cacheName += userID + "-";
            _cacheName += skip + "-";
            _cacheName += show;
            _cacheName += ".xml";;

            //Try to get a cached copy.
            DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(10);  // expire after 10 minutes
            string moreCommentsXML = String.Empty;

            if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "recentcomments", _cacheName, ref expiry, ref moreCommentsXML))
            {
                RipleyAddInside(RootElement, moreCommentsXML);
                gotFromCache = true;
            }

            return gotFromCache;
        }
    }
}
