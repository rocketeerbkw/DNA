using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the MorePages Page object
    /// </summary>
    public class MorePages : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of pages to skip.";
        private const string _docDnaShow = @"The number of pages to show.";
        private const string _docDnaUserID = @"The userID for the page.";
        private const string _docDnaType = @"Type of article to display.";
        private const string _docDnaGuideType = @"The Guide Type of the article to display";

        XmlElement _pageOwnerElement = null;

        /// <summary>
        /// Generated Page Owner Element
        /// </summary>
        public XmlElement PageOwnerElement
        {
            get { return _pageOwnerElement; }
            set { _pageOwnerElement = value; }
        }


        /// <summary>
        /// Default constructor for the MorePages component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MorePages(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int skip = 0;
            int show = 0;
            int type = 0;
            int guideType = 0;
            int userID = 0;

            TryGetPageParams(ref skip, ref show, ref userID, ref type, ref guideType);

            TryCreateMorePagesXML(skip, show, userID, type, guideType);
        }

        /// <summary>
        /// Implements generating the XML for the More Pages page
        /// </summary>
        /// <param name="skip">Number of articles to skip</param>
        /// <param name="show">Number of articles to show</param>
        /// <param name="userID">User ID of the page to return</param>
        /// <param name="type">type is either 1 (approved) 2 (normal) 3 (cancelled) or 4 (normal and approved)</param>
        /// <param name="guideType">See if we've been given a specified article type to search for</param>
        private void TryCreateMorePagesXML(int skip, int show, int userID, int type, int guideType)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            if ((type == (int) ArticleList.ArticleListType.ARTICLELISTTYPE_CANCELLED) && ((InputContext.ViewingUser.UserLoggedIn == false) || (InputContext.ViewingUser.UserID != userID)))
	        {
		        throw new DnaException("MorePages - TryCreateMorePagesXML - You cannot view the cancelled entries of another user");
	        }

            _pageOwnerElement = AddElementTag(RootElement, "PAGE-OWNER");
            User pageOwner = new User(InputContext);
            pageOwner.CreateUser(userID);
            AddInside(_pageOwnerElement, pageOwner);

            XmlElement articles = AddElementTag(RootElement, "ARTICLES");
            AddAttribute(articles, "USERID", userID);
            AddAttribute(articles, "WHICHSET", type);

            ArticleList articleList = new ArticleList(InputContext);

            if (type == (int) ArticleList.ArticleListType.ARTICLELISTTYPE_APPROVED)
		    {
			    articleList.CreateRecentApprovedArticlesList(userID, 0, skip, show, guideType);
		    }
            else if (type == (int) ArticleList.ArticleListType.ARTICLELISTTYPE_NORMAL)
		    {
                articleList.CreateRecentArticleList(userID, 0, skip, show, guideType);
		    }
		    else if (type == (int) ArticleList.ArticleListType.ARTICLELISTTYPE_NORMALANDAPPROVED)
		    {
                articleList.CreateRecentNormalAndApprovedArticlesList(userID, 0, skip, show, guideType);
		    }
		    else
		    {
                articleList.CreateCancelledArticlesList(userID, 0, skip, show, guideType);
		    }
            AddInside(articles, articleList);

            AddInside(articles, pageOwner);

        }


       /// <summary>
        /// Implements getting the params for the page
        /// </summary>
        /// <param name="skip">Number of posts to skip</param>
        /// <param name="show">Number of posts to show</param>
        /// <param name="userID">User ID of the page to return</param>
        /// <param name="type">type is either 1 (approved) 2 (normal) 3 (cancelled) or 4 (normal and approved)</param>
        /// <param name="guideType">See if we've been given a specified article type to search for</param>
        private void TryGetPageParams(ref int skip, ref int show, ref int userID, ref int type, ref int guideType)
        {
            userID = InputContext.GetParamIntOrZero("userID", _docDnaUserID);

            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);

            if (show > 25)
            {
                show = 25;
            }
            else if (show < 1)
            {
                show = 25;
            }
            if (skip < 0)
            {
                skip = 0;
            }

            type = InputContext.GetParamIntOrZero("type", _docDnaType);
            if (type < (int) ArticleList.ArticleListType.ARTICLELISTTYPE_FIRST || type > (int) ArticleList.ArticleListType.ARTICLELISTTYPE_LAST)
            {
                type = (int) ArticleList.ArticleListType.ARTICLELISTTYPE_APPROVED;
            }
            guideType = InputContext.GetParamIntOrZero("guideType", _docDnaGuideType);
        }
    }
}
