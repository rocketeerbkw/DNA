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
    /// Summary of the ReviewForumBuilder Page object
    /// </summary>
    public class ReviewForumBuilder : DnaInputComponent
    {
        private const string _docDnaID = @"Review Forum ID to use.";
        private const string _docDnaShow = @"The number of items to show.";
        private const string _docDnaSkip = @"The number of items to skip.";

        private const string _docDnaOrder = @"Review Forum order by clause.";
        private const string _docDnaDirection = @"Review Forum order by direction";
        private const string _docDnaEntry = @"Whether to include guide entry info";

        XmlElement _GuideEntryElement = null;

        /// <summary>
        /// Gets the Guide Entry Entry Element
        /// </summary>
        public XmlElement GuideEntryElement
        {
            get { return _GuideEntryElement; }
            set { _GuideEntryElement = value; }
        }

        /// <summary>
        /// Default constructor for the ReviewForumBuilder component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ReviewForumBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int ID = 0; 
            ReviewForum.OrderBy orderBy = ReviewForum.OrderBy.LASTPOSTED;
            int skip = 0;
            int show = 0;
            bool direction = false;
            bool entry = false;

            //Clean any existing XML.
            RootElement.RemoveAll();

            TryGetPageParams(ref ID, ref skip, ref show, ref orderBy, ref direction, ref entry);

            TryCreateReviewForumBuilderXML(ID, skip, show, orderBy, direction, entry);
        }

        /// <summary>
        /// Functions generates the Try Create Review Forum Builder XML
        /// </summary>
        /// <param name="ID">ID of the review forum to get</param>
        /// <param name="skip">Number to skip</param>
        /// <param name="show">Number to show</param>
        /// <param name="orderBy">Ordering of the review forum</param>
        /// <param name="direction">Direction of ordering </param>
        /// <param name="entry">Whether we need to add a description at the top</param>
        public void TryCreateReviewForumBuilderXML(int ID, int skip, int show, ReviewForum.OrderBy orderBy, bool direction, bool entry)
        {
            ReviewForum reviewForum = new ReviewForum(InputContext);

            reviewForum.InitialiseViaReviewForumID(ID, false);

            if (SwitchSites(reviewForum.SiteID, ID, skip, show, orderBy, direction, entry))
            {
                return;
            }

            reviewForum.GetReviewForumThreadList(show, skip, orderBy, direction);
            //add the entry 
            if (entry)
            {
                GuideEntrySetup guideEntrySetup = new GuideEntrySetup(reviewForum.H2G2ID);
                //guideEntrySetup.ShowReferences = true;
                guideEntrySetup.SafeToCache = true;

                GuideEntry guideEntry = new GuideEntry(InputContext, guideEntrySetup);
                guideEntry.Initialise();

                _GuideEntryElement = CreateElement("ROOT");
                _GuideEntryElement.AppendChild(ImportNode(guideEntry.RootElement.FirstChild));
            }
            //add the fact that we don't want/have an entry
            else
            {
                _GuideEntryElement = CreateElement("ROOT");
                AddElementTag(_GuideEntryElement, "NOGUIDE");
            }

            AddInside(reviewForum);
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="ID">ID of the review forum to get</param>
        /// <param name="skip">Number to skip</param>
        /// <param name="show">Number to show</param>
        /// <param name="orderBy">Ordering of the review forum</param>
        /// <param name="direction">Direction of ordering </param>
        /// <param name="entry">Whether we need to add a description at the top</param>
        private void TryGetPageParams(ref int ID, ref int skip, ref int show, ref ReviewForum.OrderBy orderBy, ref bool direction, ref bool entry)
        {
            ID = InputContext.GetParamIntOrZero("ID", _docDnaID);
            if (ID <= 0)
            {
                throw new DnaException("Review Forum Builder - No Review Forum ID passed in.");
            }
	        skip = 0;
	        show = 20;       	
	        // get the skip and show parameters if any
            if (InputContext.DoesParamExist("Skip", _docDnaSkip))
	        {
                skip = InputContext.GetParamIntOrZero("Skip", _docDnaSkip);
                if (skip < 0)
		        {
                    skip = 0;
		        }
	        }
            if (InputContext.DoesParamExist("Show", _docDnaShow))
	        {
                show = InputContext.GetParamIntOrZero("Show", _docDnaShow);
                if (show <= 0)
		        {
                    show = 20;
		        }
	        }

            direction = false;
            if (InputContext.DoesParamExist("Dir", _docDnaDirection))
            {
                int dir = InputContext.GetParamIntOrZero("Dir", _docDnaDirection);
                if (dir == 1)
                {
                    direction = true;
                }
                else
                {
                    direction = false;
                }
            }

            entry = true;
            //check whether we need to add a guideentry description at the top
            if (InputContext.DoesParamExist("Entry", _docDnaEntry))
            {
                int showEntryBody = InputContext.GetParamIntOrZero("Entry", _docDnaEntry);
                if (showEntryBody == 1)
                {
                    entry = true;
                }
                else
                {
                    entry = false;
                }
            }

            orderBy = ReviewForum.OrderBy.LASTPOSTED;
            if (InputContext.DoesParamExist("Order", _docDnaOrder))
	        {
                string order = InputContext.GetParamStringOrEmpty("Order", _docDnaOrder);

                if (order == "dateentered")
		        {
                    orderBy = ReviewForum.OrderBy.DATEENTERED;
		        }
		        else if(order == "lastposted")
		        {
                    orderBy = ReviewForum.OrderBy.LASTPOSTED;
		        }
		        else if(order == "authorid")
		        {
                    orderBy = ReviewForum.OrderBy.AUTHORID;
		        }
		        else if(order == "authorname")
		        {
                    orderBy = ReviewForum.OrderBy.AUTHORNAME;
		        }
		        else if (order == "entry")
		        {
                    orderBy = ReviewForum.OrderBy.H2G2ID;
		        }
		        else if (order == "subject")
		        {
                    orderBy = ReviewForum.OrderBy.SUBJECT;
		        }
		        else
		        {
                    orderBy = ReviewForum.OrderBy.LASTPOSTED;
		        }
	        }

        }
        bool SwitchSites(int siteID, int ID, int skip, int show, ReviewForum.OrderBy orderBy, bool direction, bool entry)
        {
	        if (siteID != InputContext.CurrentSite.SiteID)
	        {
		        string URL = "RF" + ID;
		        URL += "&Skip=" + skip;
		        URL += "&Show=" + show;

			    URL += "&Order=" + orderBy.ToString();
			    URL += "&Dir=" + direction;
                URL += "&Entry=" + entry;

                return true;
	        }

	        return false;
        }
    }
}