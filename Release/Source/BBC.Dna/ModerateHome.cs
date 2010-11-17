using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Moderation;

namespace BBC.Dna.Component
{
    /// <summary>
    /// ModerateHome - A derived DnaComponent object
    /// </summary>
    public class ModerateHome : DnaInputComponent
    {
        private const string _docDnaOwnerID = @"User ID to look at.";
        private const string _docDnaSiteID = @"User ID to look at.";
        private const string _docDnaFastMod = @"User ID to look at.";
        private const string _docDnaNotFastMod = @"User ID to look at.";
        private const string _docDnaModClassID = @"User ID to look at.";

        private const string _docDnaUnlockForums = @"UnlockForums.";
        private const string _docDnaUnlockForumReferrals = @"UnlockForumReferrals.";
        private const string _docDnaUnlockUserPosts = @"UnlockUserPosts.";
        private const string _docDnaUnlockSitePosts = @"UnlockSitePosts.";
        private const string _docDnaUnlockAllPosts = @"UnlockAllPosts.";
        private const string _docDnaUnlockArticles = @"UnlockArticles.";
        private const string _docDnaUnlockArticleReferrals = @"UnlockArticleReferrals.";
        private const string _docDnaUnlockGeneral = @"UnlockGeneral.";
        private const string _docDnaUnlockGeneralReferrals = @"UnlockGeneralReferrals.";
        private const string _docDnaUnlockNicknames = @"UnlockNicknames.";
        private const string _docDnaUnlockAll = @"UnlockAll.";

        string _cacheName = String.Empty;

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
        /// Default constructor for the ModerateHome component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ModerateHome(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            RootElement.RemoveAll();

            TryGetModerateHomePageXml();
        }
        /// <summary>
        /// Method called to try and create the moderate home page xml, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        private void TryGetModerateHomePageXml()
        {
            ModHomeParameters modHomeParams = new ModHomeParameters();

            TryGetPageParams(ref modHomeParams);

            GenerateModerateHomePageXml(modHomeParams);
        }

        /// <summary>
        /// Function to get the XML representation of the Moderate Home results
        /// </summary>
        /// <param name="modHomeParams">Params.</param>
        public void GetModerateHomeXml(ModHomeParameters modHomeParams)
        {
            GenerateModerateHomePageXml(modHomeParams);
        }

        /// <summary>
        /// Try to gets the params for the page
        /// </summary>
        /// <param name="modHomeParams">Moderation Submission Parameters.</param>
        private void TryGetPageParams(ref ModHomeParameters modHomeParams)
        {
            modHomeParams.OwnerID = InputContext.GetParamIntOrZero("userid", _docDnaOwnerID);
            modHomeParams.SiteID = InputContext.GetParamIntOrZero("siteid", _docDnaSiteID);
            modHomeParams.FastMod = InputContext.GetParamIntOrZero("fastmod", _docDnaFastMod);
            modHomeParams.NotFastMod = InputContext.GetParamIntOrZero("notfastmod", _docDnaNotFastMod);
            modHomeParams.ModClassID = InputContext.GetParamIntOrZero("modclassid", _docDnaModClassID);

            modHomeParams.UnlockForums = InputContext.DoesParamExist("UnlockForums", _docDnaUnlockForums);
            modHomeParams.UnlockForumReferrals = InputContext.DoesParamExist("UnlockForumReferrals", _docDnaUnlockForumReferrals);
            modHomeParams.UnlockUserPosts = InputContext.DoesParamExist("UnlockUserPosts", _docDnaUnlockUserPosts);
            modHomeParams.UnlockSitePosts = InputContext.DoesParamExist("UnlockSitePosts", _docDnaUnlockSitePosts);
            modHomeParams.UnlockAllPosts = InputContext.DoesParamExist("UnlockAllPosts", _docDnaUnlockAllPosts);
            modHomeParams.UnlockArticles = InputContext.DoesParamExist("UnlockArticles", _docDnaUnlockArticles);
            modHomeParams.UnlockArticleReferrals = InputContext.DoesParamExist("UnlockArticleReferrals", _docDnaUnlockArticleReferrals);
            modHomeParams.UnlockGeneral = InputContext.DoesParamExist("UnlockGeneral", _docDnaUnlockGeneral);
            modHomeParams.UnlockGeneralReferrals = InputContext.DoesParamExist("UnlockGeneralReferrals", _docDnaUnlockGeneralReferrals);
            modHomeParams.UnlockNicknames = InputContext.DoesParamExist("UnlockNicknames", _docDnaUnlockNicknames);
            modHomeParams.UnlockAll = InputContext.DoesParamExist("UnlockAll", _docDnaUnlockAll);

        }

        /// <summary>
        /// Calls the correct stored procedure given the inputs selected
        /// </summary>
        /// <param name="modHomeParams">Parameters</param>
        private void GenerateModerateHomePageXml(ModHomeParameters modHomeParams)
        {
            //if not an editor then return an error
            if (InputContext.ViewingUser == null || !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsModerator || InputContext.ViewingUser.IsHost))
            {
                AddErrorXml("NOT-EDITOR", "You cannot perform moderation unless you are logged in as an Editor or a Moderator.", RootElement);
                return;
            }
            if (modHomeParams.OwnerID != 0 && InputContext.ViewingUser.UserID != modHomeParams.OwnerID && InputContext.ViewingUser.IsEditor)
            {
		        // only editors can view other peoples moderation home page
                AddErrorXml("NOT-EDITOR", "You cannot view someone elses Moderation Home Page unless you are logged in as an Editor.", RootElement);
                return;
            }

            // if no user ID specified then we wish to see the viewers own page
            if (modHomeParams.OwnerID == 0)
            {
                modHomeParams.OwnerID = InputContext.ViewingUser.UserID;
            }
            // try to create the page owner object from this user ID
            // TODO: give a useful error message if this fails

            _pageOwnerElement = AddElementTag(RootElement, "PAGE-OWNER");
            User pageOwner = new User(InputContext);
            pageOwner.CreateUser(modHomeParams.OwnerID);
            AddInside(_pageOwnerElement, pageOwner);

            ProcessSubmission(modHomeParams);
            CreateForm(modHomeParams);

            //ModClasses component added seperately in the aspx page
        }

        private void CreateForm(ModHomeParameters modHomeParams)
        {
            bool isRefereeForAnySite = false;
            isRefereeForAnySite = CheckRefereeForAnySite();

            XmlElement modHomeForm = AddElementTag(RootElement, "MODERATOR-HOME");
            AddAttribute(modHomeForm, "USER-ID", modHomeParams.OwnerID);
            AddAttribute(modHomeForm, "ISREFEREE", isRefereeForAnySite);
            AddAttribute(modHomeForm, "FASTMOD", modHomeParams.FastMod);
            AddAttribute(modHomeForm, "NOTFASTMOD", modHomeParams.NotFastMod);

            GenerateModStatsXml(modHomeForm, modHomeParams, isRefereeForAnySite);
        }

        private void GenerateModStatsXml(XmlElement parent, ModHomeParameters modHomeParams, bool isRefereeForAnySite)
        {
            var moderatorInfo = ModeratorInfo.GetModeratorInfo(AppContext.ReaderCreator, modHomeParams.OwnerID, InputContext.TheSiteList);
            SerialiseAndAppend(moderatorInfo, parent.Name);

            bool referrals = InputContext.ViewingUser.IsSuperUser;
	        if ( !referrals )
	        {
		        referrals = isRefereeForAnySite;
	        }

            XmlElement modQueues = AddElementTag(parent, "MODERATION-QUEUES");
            ModStats modStats = ModStats.FetchModStatsByModClass(AppContext.ReaderCreator, modHomeParams.OwnerID, moderatorInfo, referrals, modHomeParams.FastMod != 0);
            SerialiseAndAppend(modStats, parent.Name);
        }

        private bool CheckRefereeForAnySite()
        {
            bool isReferee = false;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("IsRefereeForAnySite"))
            {
                dataReader.AddParameter("userID", InputContext.ViewingUser.UserID);
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        int nOfSites = dataReader.GetInt32NullAsZero("NumberOfSites");
                        isReferee = (nOfSites != 0);
                    }
                }
            }
            return isReferee;
        }

        private bool IsUserASuperUser(int userID)
        {
            bool isSuperUser = false;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getuserstatus"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        int status = dataReader.GetInt32NullAsZero("Status");
                        isSuperUser = (status == 2);
                    }
                }
            }
            return isSuperUser;
        }


        private void ProcessSubmission(ModHomeParameters modHomeParams)
        {
            string redirect = String.Empty;
	        if (modHomeParams.FastMod == 1)
	        {
		        redirect += "fastmod=1&";
	        }
	        if (modHomeParams.NotFastMod == 1)
	        {
		        redirect += "notfastmod=1";
	        }

	        // now find out what the command is
	        if (modHomeParams.UnlockForums)
	        {
		        UnlockAllForumModerations(modHomeParams.OwnerID);
                ModerateRedirect(redirect);
	        }
	        else if (modHomeParams.UnlockForumReferrals)
	        {
		        UnlockAllForumReferrals(modHomeParams.OwnerID);
                ModerateRedirect(redirect);
	        }
	        else if (modHomeParams.UnlockUserPosts)
	        {
		        //Unlock Posts for moderator
                UnlockModeratePostsForUser(modHomeParams.OwnerID, modHomeParams.ModClassID);
	        }
	        else if (modHomeParams.UnlockSitePosts)
	        {
                if (modHomeParams.SiteID > 0)
                {
                    //Unlock posts for given site - user must be an editor for given site / superuser
                    UnlockModeratePostsForSite(modHomeParams.OwnerID, modHomeParams.SiteID);
                }
                else
                {
                    throw new DnaException("Invalid SiteId");
                }
	        }
	        else if (modHomeParams.UnlockAllPosts)
	        {
		        //Unlock all posts for all sites user is an editor / superuser.
		        UnlockModeratePosts(modHomeParams.OwnerID);
	        }
	        else if (modHomeParams.UnlockArticles)
	        {
		        UnlockAllArticleModerations(modHomeParams.OwnerID, InputContext.ViewingUser.UserID, modHomeParams.ModClassID);
	        }
	        else if (modHomeParams.UnlockArticleReferrals)
	        {
		        UnlockAllArticleReferrals(modHomeParams.OwnerID, InputContext.ViewingUser.UserID);
	        }
	        else if (modHomeParams.UnlockGeneral)
	        {
		        UnlockAllGeneralModerations(modHomeParams.OwnerID);
	        }
	        else if (modHomeParams.UnlockGeneralReferrals)
	        {
		        UnlockAllGeneralReferrals(modHomeParams.OwnerID);
	        }
	        else if (modHomeParams.UnlockNicknames)
	        {
                UnlockNickNamesForUser(modHomeParams.OwnerID, modHomeParams.ModClassID);
	        }
	        else if (modHomeParams.UnlockAll)
	        {
		        UnlockAllForumModerations(modHomeParams.OwnerID);
                UnlockAllArticleModerations(modHomeParams.OwnerID, InputContext.ViewingUser.UserID, 0);
		        UnlockAllGeneralModerations(modHomeParams.OwnerID);
		        UnlockAllForumReferrals(modHomeParams.OwnerID);
                UnlockAllArticleReferrals(modHomeParams.OwnerID, InputContext.ViewingUser.UserID);
		        UnlockAllGeneralReferrals(modHomeParams.OwnerID);
		        UnlockAllNicknameModerations(modHomeParams.OwnerID,0);
	        }
	        else
	        {
		        // else do nothing as there is no recognised command
	        }
	    }
        private void UnlockAllArticleModerations(int userID, int calledBy, int modClassID)
        {
            UnlockCalledBy("UnlockAllArticleModerations", userID, calledBy, modClassID);
        }
        private void UnlockAllArticleReferrals(int userID, int calledBy)
        {
            UnlockCalledBy("UnlockAllArticleReferrals", userID, calledBy, 0);
        }
        private void UnlockAllGeneralModerations(int userID)
        {
            Unlock("UnlockAllGeneralModerations", userID);
        }
        private void UnlockAllGeneralReferrals(int userID)
        {
            Unlock("UnlockAllGeneralReferrals", userID);
        }
        private void UnlockAllNicknameModerations(int userID, int modClassID)
        {
            Unlock("UnlockAllNicknameModerations", userID, modClassID);
        }
        private void UnlockModeratePostsForSite(int userID, int siteID)
        {
            bool isSuperUser = IsUserASuperUser(userID);
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("UnlockModeratePostsForSite"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.AddParameter("siteID", siteID);
                dataReader.AddParameter("superuser", isSuperUser);
                dataReader.Execute();
            }
        }

        private void UnlockModeratePosts(int userID)
        {
            bool isSuperUser = IsUserASuperUser(userID);
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("UnlockModeratePosts"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.AddParameter("superuser", isSuperUser);
                dataReader.Execute();
            }
        }
        private void UnlockNickNamesForUser(int userID, int modClassID)
        {
            Unlock("UnlockAllNicknameModerations", userID, modClassID);
        }
        private void UnlockModeratePostsForUser(int userID, int modClassID)
        {
            Unlock("UnlockModeratePostsForUser", userID, modClassID);
        }
        private void UnlockAllForumReferrals(int userID)
        {
            Unlock("UnlockAllForumReferrals", userID);
        }
        private void UnlockAllForumModerations(int userID)
        {
            Unlock("UnlockAllForumModerations", userID);
        }

        private void Unlock(string storedProcedure, int userID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedure))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.Execute();
            }
        }
        private void Unlock(string storedProcedure, int userID, int modClassID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedure))
            {
                dataReader.AddParameter("userID", userID);
                if (modClassID > 0)
                {
                    dataReader.AddParameter("modClassID", modClassID);
                }
                dataReader.Execute();
            }
        }
        private void UnlockCalledBy(string storedProcedure, int userID, int calledBy, int modClassID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedure))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.AddParameter("calledby", calledBy);
                if (modClassID > 0)
                {
                    dataReader.AddParameter("modClassID", modClassID);
                }
                dataReader.Execute();
            }
        }

        private void ModerateRedirect(string redirect)
        {
            XmlElement redirectNode = AddElementTag(RootElement, "REDIRECT");
            AddAttribute(redirectNode, "URL", "Moderate?" + redirect);
        }
        
        /* OLD IF NEWSTYLE==0 NOT NEEDED
        XmlElement GetQueuedModPerSiteXml(int ownerId)
        {
            XmlElement QueuedModPerSite = AddElementTag(RootElement, "QUEUED-PER-SITE");
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchedithistory"))
            {
                dataReader.AddParameter("entryid", entryID);
                dataReader.Execute();

                bool bOk = m_pSP->GetQueuedModPerSite(iOwnerId);

	            if (bOk == false)
	            {
		            sXml << "<ERROR TYPE='NO-QUEUED-MOD-PER-SITE'>No moderation statistics " \
			            "per site could be found</ERROR>";
		            return false;
	            }

                int iPrevSiteID = -1;
	            int iSiteID = -1;
	            int iComplaints = 0;
	            int iComplaintsRef = 0;
	            int iNotComplaints = 0;
	            int iNotComplaintsRef = 0;
	            int iIsModerator = 0;
	            int iIsReferee = 0;
	            CTDVString sShortName;
	            CTDVString sURL;
	            sXml << "<QUEUED-PER-SITE>";
	            while (!m_pSP->IsEOF())
	            {
		        iSiteID = m_pSP->GetIntField("SiteID");

		        if (iPrevSiteID != iSiteID )
		        {
			        if (iPrevSiteID != -1)
			        {
				        sXml << "<SITE>";
				        sXml << "<NAME>" << sShortName << "</NAME>";
				        sXml << "<COMPLAINTS>" << iComplaints << "</COMPLAINTS>";
				        sXml << "<COMPLAINTS-REF>" << iComplaintsRef << "</COMPLAINTS-REF>";
				        sXml << "<NOT-COMPLAINTS>" << iNotComplaints << "</NOT-COMPLAINTS>";
				        sXml << "<NOT-COMPLAINTS-REF>" << iNotComplaintsRef << "</NOT-COMPLAINTS-REF>";
				        sXml << "<ISMODERATOR>" << iIsModerator << "</ISMODERATOR>";
				        sXml << "<ISREFEREE>" << iIsReferee << "</ISREFEREE>";
				        sXml << "<URL>" << sURL << "</URL>";
				        sXml << "</SITE>";
				        iComplaints = 0;
				        iNotComplaints = 0;
				        iComplaintsRef = 0;
				        iNotComplaintsRef = 0;
			        }

			        iIsModerator = m_pSP->GetIntField("Moderator");
			        iIsReferee = m_pSP->GetIntField("Referee");
			        m_pSP->GetField("ShortName", sShortName);
			        m_pSP->GetField("URLName", sURL);
		        }

		        if (m_pSP->GetIntField("Complaint"))
		        {
			        if (m_pSP->GetIntField("Status") == 2)
			        {
				        iComplaintsRef = m_pSP->GetIntField("Total");
			        }
			        else
			        {
				        iComplaints = m_pSP->GetIntField("Total");
			        }
		        }
		        else
		        {	
			        if (m_pSP->GetIntField("Status") == 2)
			        {
				        iNotComplaintsRef = m_pSP->GetIntField("Total");
			        }
			        else
			        {
				        iNotComplaints = m_pSP->GetIntField("Total");
			        }
		        }

		        iPrevSiteID = iSiteID;
		        m_pSP->MoveNext();
	        }
	        sXml << "<SITE>";
	        sXml << "<NAME>" << sShortName << "</NAME>";
	        sXml << "<COMPLAINTS>" << iComplaints << "</COMPLAINTS>";
	        sXml << "<COMPLAINTS-REF>" << iComplaintsRef << "</COMPLAINTS-REF>";
	        sXml << "<NOT-COMPLAINTS>" << iNotComplaints << "</NOT-COMPLAINTS>";
	        sXml << "<NOT-COMPLAINTS-REF>" << iNotComplaintsRef << "</NOT-COMPLAINTS-REF>";
	        sXml << "<ISMODERATOR>" << iIsModerator << "</ISMODERATOR>";
	        sXml << "<ISREFEREE>" << iIsReferee << "</ISREFEREE>";
	        sXml << "<URL>" << sURL << "</URL>";
	        sXml << "</SITE>";

	        sXml << "</QUEUED-PER-SITE>";

	        return bOk;
        }*/
    }
}
