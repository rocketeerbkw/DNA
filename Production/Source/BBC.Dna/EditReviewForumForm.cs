using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// EditReviewForumForm object
    /// </summary>
    public class EditReviewForumForm : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public EditReviewForumForm(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Updates the review forum with the supplied data if it is valid, otherwise
		///		produces the form with valid error messages, false if it didn't handle the reques
        /// </summary>
        /// <param name="reviewForumID"></param>
        /// <param name="name"></param>
        /// <param name="url"></param>
        /// <param name="recommendable"></param>
        /// <param name="incubateTime"></param>
        /// <param name="currentSiteID"></param>
        /// <returns></returns>
        public bool RequestUpdate(int reviewForumID, string name, string url, bool recommendable, int incubateTime, int currentSiteID)
        {
            ReviewForum reviewForum = new ReviewForum(InputContext);

            reviewForum.InitialiseViaReviewForumID(reviewForumID, true);

            if (!reviewForum.IsInitialised)
            {
                AddErrorXml("BADID", "Invalid Review Forum ID", RootElement);
                return false;
            }

            //check that the site the request is from is the same as the site for the reviewforum
            if (reviewForum.SiteID != currentSiteID)
            {
                AddErrorXml("SITE", "This review forum does not belong to this site", RootElement);
                return false;
            }

            reviewForum.Update(name, url, recommendable, incubateTime);

            XmlElement success = AddElementTag(RootElement, "SUCCESS");
            AddAttribute(success, "TYPE", "UPDATE");

            AddInside(reviewForum);
            return true;
        }

        /// <summary>
        /// Adds in a new edit review forum
        /// </summary>
        /// <param name="name"></param>
        /// <param name="url"></param>
        /// <param name="recommendable"></param>
        /// <param name="incubateTime"></param>
        /// <param name="currentSiteID"></param>
        /// <param name="userID"></param>
        /// <returns></returns>
        public bool DoAddNew(string name, string url, bool recommendable, int incubateTime, int currentSiteID, int userID)
        {
            if (name == String.Empty)
            {
                AddErrorXml("BADNAME", "The review forum name is invalid", RootElement);
                return false;
            }

            if (url == String.Empty || url.IndexOf(" ") >= 0)
            {
                AddErrorXml("BADURL", "The url name is invalid", RootElement);
                return false;
            }

            if (incubateTime < 0)
            {
                AddErrorXml("BADINCUBATE", "The incubate time is invalid", RootElement);
                return false;
            }

            ReviewForum reviewForum = new ReviewForum(InputContext);

            if (!reviewForum.AreNamesUniqueWithinSite(name, url, currentSiteID))
            {
                AddErrorXml("BADNAMES", "The names supplied already exist for this site", RootElement);
                return false;
            }

            try
            {
                reviewForum.CreateAndInitialiseNewReviewForum(name, url, incubateTime, recommendable, currentSiteID, userID);

                XmlElement success = AddElementTag(RootElement, "SUCCESS");
                AddAttribute(success, "TYPE", "ADDNEW");
            }
            catch (DnaException ex)
            {
                AddElementTag(RootElement, "BLANKFORM");
                AddErrorXml("ADDNEW", "There was an error while adding the review forum." + ex.Message, RootElement);

                reviewForum.InitialiseFromData(0, name, url, incubateTime, recommendable, 0, userID);
            }

            AddInside(reviewForum);

            return true;
        }

        /// <summary>
        /// Creates the EditReviewForumForm with data from the reviewforum
        /// </summary>
        /// <param name="reviewForumID"></param>
        /// <param name="currentSiteID"></param>
        /// <returns>true if created from database or if it generated a proper error</returns>
        public bool CreateFromDB(int reviewForumID, int currentSiteID)
        {
	        ReviewForum reviewForum = new ReviewForum(InputContext);
        	
            reviewForum.InitialiseViaReviewForumID(reviewForumID, true);

            if (!reviewForum.IsInitialised)
	        {
		        AddErrorXml("BADID", "Invalid Review Forum ID", RootElement);
		        return false;
	        }

	        if (reviewForum.SiteID != currentSiteID)
	        {
                AddErrorXml("SITE", "This review forum does not belong to this site", RootElement);
		        return false;
	        }

            AddInside(reviewForum);
            return true;
        }
    }
}