using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the UserPage object, holds the list of posts for a user
    /// </summary>
    public class UserPage : DnaInputComponent
    {
        private const string _docDnaSecretKey = @"The secret key string for registering.";
        private const string _docDnaUserID = @"The userID of the page that is being looked at.";

        private const string _docDnaI_UGE = @"Parameter to include Users Guide Entries.";
        private const string _docDnaI_UGEF = @"Parameter to include Users Guide Entry Forums.";
        private const string _docDnaI_J = @"Parameter to include their Journal.";
        private const string _docDnaI_RP = @"Parameter to include Recent Posts.";
        private const string _docDnaI_RC = @"Parameter to include Recent Comments.";
        private const string _docDnaI_RGE = @"Parameter to include Recent Guide Entries.";
        private const string _docDnaI_U = @"Parameter to include Uploads.";
        private const string _docDnaI_RASU = @"Parameter to include Recent Articles of Subscribed Users.";

        private const string _docDnaI_WI = @"Parameter to include Watch Info.";
        private const string _docDnaI_C = @"Parameter to include Clubs.";
        private const string _docDnaI_PF = @"Parameter to include Private Forums.";
        private const string _docDnaI_L = @"Parameter to include Links.";
        private const string _docDnaI_TN = @"Parameter to include TaggedNodes.";
        private const string _docDnaI_N = @"Parameter to include Noticeboard.";
        private const string _docDnaI_P = @"Parameter to include Postcoder.";
        private const string _docDnaI_SO = @"Parameter to include Site Options.";

        private const string _docDnaClip = @"Parameter whether to clip this page to your own user page.";
        private const string _docDnaPrivate = @"Parameter to state whether it is private.";

        private const string _docDnaLinkGroup = @"Parameter to state the link group it belongs to.";

        private const string _docDnaLinkID = @"Parameter for the LinkID.";
        private const string _docDnaChangePublic = @"Parameter to state change in public links.";
        private const string _docDnaMoveLinks = @"Parameter to state whether to Move Links.";
        private const string _docDnaNewLocation = @"Parameter to state where the new link location is.";
        private const string _docDnaPrivateLinkID = @"Parameter to state the privacy link ID.";
        private const string _docDnaCurrentPrivacy = @"Parameter to state of the current privacy.";
        private const string _docDnaNewPrivateLinkID = @"Parameter to state the new privacy link ID.";
        private const string _docDnaDeleteLinks = @"Parameter to whether the action is to Delete a list of given links.";
        
        string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor for the MorePosts component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public UserPage(IInputContext context)
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

            TryCreateUserPage();

        }

        private bool TryCreateUserPage()
        {
            UserPageParameters userPageParameters = new UserPageParameters();

            TryGetPageParams(ref userPageParameters);

            GenerateUserPageXml(userPageParameters);

            return true;
        }

        private void TryGetPageParams(ref UserPageParameters userPageParameters)
        {
            userPageParameters.UserID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);

            string secretKeyParam = InputContext.GetParamStringOrEmpty("Key", _docDnaSecretKey);

		    // if the secret key start with "3D" we must strip this off
		    // - it is caused by a mime encoding problem, 3D is the ascii hex for =
            if (secretKeyParam.StartsWith("3D"))
            {
                secretKeyParam = secretKeyParam.Substring(2);
            }

            int secretKey = 0;
            if ( Int32.TryParse(secretKeyParam, out secretKey))
            {
                userPageParameters.IsRegistering = true;
            }

            userPageParameters.IncludeUsersGuideEntries = InputContext.GetParamBoolOrFalse("i_uge", _docDnaI_UGE);
            userPageParameters.IncludeUsersGuideEntriesForums = InputContext.GetParamBoolOrFalse("i_ugef", _docDnaI_UGEF);
            userPageParameters.IncludeJournals = InputContext.GetParamBoolOrFalse("i_j", _docDnaI_J);
            userPageParameters.IncludeRecentPosts = InputContext.GetParamBoolOrFalse("i_rp", _docDnaI_RP);
            userPageParameters.IncludeRecentComments = InputContext.GetParamBoolOrFalse("i_rc", _docDnaI_RC);
            userPageParameters.IncludeRecentGuideEntries = InputContext.GetParamBoolOrFalse("i_rge", _docDnaI_RGE);
            userPageParameters.IncludeRecentUploads = InputContext.GetParamBoolOrFalse("i_u", _docDnaI_U);
            userPageParameters.IncludeRecentArticlesOfSubscribedUsers = InputContext.GetParamBoolOrFalse("i_rasu", _docDnaI_RASU);

            userPageParameters.Clip = InputContext.DoesParamExist("clip", _docDnaClip);
            userPageParameters.Private = (InputContext.GetParamIntOrZero("private", _docDnaPrivate) > 0);

            userPageParameters.LinkGroup = InputContext.GetParamStringOrEmpty("linkgroup", _docDnaLinkGroup);

            if (InputContext.DoesParamExist("moveLinks", _docDnaMoveLinks))
            {
                userPageParameters.LinksToMove = true;
                int count = InputContext.GetParamCountOrZero("linkid", _docDnaLinkID);
                for(int i = 0; i < count; i++)
                {
                    int linkID = InputContext.GetParamIntOrZero("linkid", i, _docDnaLinkID);
                    string newLocation = InputContext.GetParamStringOrEmpty("newgroup", _docDnaNewLocation);
                    if (newLocation == "default")
                    {
                        newLocation = String.Empty;
                    }
                    KeyValuePair<int, string> linkLocation = new KeyValuePair<int, string>(linkID, newLocation);
                    userPageParameters.MoveLinksList.Add(linkLocation);
                }
            }
            /*
            if (InputContext.DoesParamExist("moveclublinks", _docDnaMoveClubLinks))
            {
                int count = InputContext.GetParamCountOrZero("linkid", _docDnaLinkID);
                for (int i = 0; i < count; i++)
                {
                    int linkID = InputContext.GetParamCountOrZero("linkid", i, _docDnaLinkID);
                    string newLocation = InputContext.GetParamStringOrEmpty("newgroup", _docDnaNewLocation);
                    if (newLocation == "default")
                    {
                        newLocation = String.Empty;
                    }
                    userPageParameters.MoveLinksList.Add(KeyValuePair<linkID, newLocation>);
                }
            }*/
            // fields:
            // hidden: privlinkid = 1234
            // hidden: curprivacy = 0/1
            // checkbox: newprivlinkid = 1234
            // or
            // radio: newprivlinkid = 0, radio: newprivlinkid = 1234
            // 
            // thus, the absence of newprivlinkid=1234 indicates hidden
            // So for each privlinkid, we get the current privacy setting,
            // look for newprivlinkid = privlinkid, and if we don't find it
            // the new privacy state is 0, otherwise it's 1
            if (InputContext.DoesParamExist("changepublic", _docDnaChangePublic))
            {
                userPageParameters.LinksPrivacyChange = true;
                int count = InputContext.GetParamCountOrZero("privlinkid", _docDnaPrivateLinkID);
                for (int i = 0; i < count; i++)
                {
                    int linkID = InputContext.GetParamIntOrZero("privlinkid", i, _docDnaPrivateLinkID);
                    bool currentPrivacy = true;
                    if (InputContext.GetParamIntOrZero("curprivacy", i, _docDnaCurrentPrivacy) == 0)
                    {
                        currentPrivacy = false;
                    }
                    // Now look for newprivlinkid=iLinkID
                    int newCount = InputContext.GetParamCountOrZero("newprivlinkid", _docDnaNewPrivateLinkID);
                    bool foundLinkID = false;
                    for (int j = 0; j < newCount; j++)
                    {
                        if (InputContext.GetParamIntOrZero("newprivlinkid", newCount, _docDnaNewPrivateLinkID) == linkID)
                        {
                            // Found it, privacy must be on
                            foundLinkID = true;
                            break;
                        }
                    }
                    // foundLinkID now represents the privacy state
                    if (foundLinkID != currentPrivacy)
                    {
                        KeyValuePair<int, bool> linkPrivacy = new KeyValuePair<int, bool>(linkID, foundLinkID);
                        userPageParameters.LinksPrivacy.Add(linkPrivacy);
                    }
                }
            }
            /*
	        if (m_InputContext.ParamExists("copytoclub")) 
	        {
		        CUser* pViewingUser = m_InputContext.GetCurrentUser();
		        int iUserID = pViewingUser->GetUserID();
		        int iClubID = m_InputContext.GetParamInt("clubid");
		        CClub Club(m_InputContext);
		        if (Club.CanUserEditClub(iUserID, iClubID)) 
		        {
			        CTDVString sLinkGroup;
			        m_InputContext.GetParamString("linkgroup", sLinkGroup);
			        Link.CopyLinksToClub(iUserID, iClubID, sLinkGroup);
			        pPage->AddInside("H2G2", &Link);
		        }
	        }
	        if (m_InputContext.ParamExists("copyselectedtoclub")) 
	        {
		        CUser* pViewingUser = m_InputContext.GetCurrentUser();
		        int iUserID = pViewingUser->GetUserID();
		        int iClubID = m_InputContext.GetParamInt("clubid");
		        CClub Club(m_InputContext);
		        if (Club.CanUserEditClub(iUserID, iClubID)) 
		        {
			        // try copying all the links
			        int iCount = 0;
			        while (m_InputContext.ParamExists("linkid", iCount)) 
			        {
				        if (iCount == 0)
				        {
					        Link.StartCopyLinkToClub();
				        }
				        int iLinkID = m_InputContext.GetParamInt("linkid", iCount);
				        CTDVString sNewLocation;
				        m_InputContext.GetParamString("clubgroup", sNewLocation);
				        if (sNewLocation.CompareText("default")) 
				        {
					        sNewLocation = "";
				        }
				        Link.CopyLinkToClub(iLinkID, iClubID, sNewLocation);
				        iCount++;
			        }
			        Link.EndCopyLinkToClub();
			        pPage->AddInside("H2G2", &Link);
		        }
	        }*/
            if (InputContext.DoesParamExist("deletelinks", _docDnaDeleteLinks))
	        {
                userPageParameters.LinksToDelete = true;

		        // try deleting all the links
                int count = InputContext.GetParamCountOrZero("linkid", _docDnaLinkID);
                for (int i = 0; i < count; i++)
                {
                    int linkID = InputContext.GetParamIntOrZero("linkid", i, _docDnaLinkID);
                    userPageParameters.DeleteLinks.Add(linkID);
		        }
	        }
        }

        /// <summary>
        /// Calls the individual objects to generate the User Page XML
        /// </summary>
        /// <param name="userPageParameters"></param>
        private void GenerateUserPageXml(UserPageParameters userPageParameters)
        {
            // all the XML objects we need to build the page
            if (userPageParameters.IsRegistering)
            {
                //TODO REGISTER USER STUFF
            }
            else
            {
	            // introducing the players - these will point to the BBC.DNA Component objects required
	            // to construct a user page
                PageUI          pageInterface = new PageUI(userPageParameters.UserID);
	            User			owner = new User(InputContext);
	            GuideEntry		masthead = null;
	            Forum			pageForum = new Forum(InputContext);
	            Forum			journal = new Forum(InputContext);
	            PostList		recentPosts = new PostList(InputContext);
	            ArticleList	    recentArticles = new ArticleList(InputContext);
	            ArticleList	    recentApprovals = new ArticleList(InputContext);
	            CommentsList	recentComments = new CommentsList(InputContext);
                ArticleSubscriptionsList subscribedUsersArticles = new ArticleSubscriptionsList(InputContext);

                // get or create all the appropriate xml objects
                bool gotMasthead = false;
                bool gotPageForum = false;
                bool gotJournal = false;
                bool gotRecentPosts = false;
                bool gotRecentArticles = false;
                bool gotRecentApprovals = false;
                bool gotRecentComments = false;
                bool gotSubscribedToUsersRecentArticles = false;

                bool gotOwner = CreatePageOwner(userPageParameters.UserID, ref owner);

		        if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeUsersGuideEntry")      || userPageParameters.IncludeUsersGuideEntries ||
                    InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeUsersGuideEntryForum") || userPageParameters.IncludeUsersGuideEntriesForums)
		        {
                    gotMasthead = CreatePageArticle(userPageParameters.UserID, owner, out masthead);

                    if (gotMasthead && (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeUsersGuideEntryForum") || userPageParameters.IncludeUsersGuideEntriesForums))
			        {
				        // GuideEntry forum can not be returned if GuideEntry is not being returned.
                        gotPageForum = CreatePageForum(masthead, ref pageForum);
			        }
		        }

                bool gotInterface = CreateUserInterface(owner, masthead, ref pageInterface);
        		
		        // Only display other information if the page has a valid masthead
		        if (gotMasthead)
		        {
                    if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeJournal") || userPageParameters.IncludeJournals)
			        {
                        gotJournal = CreateJournal(owner, ref journal);
			        }

                    if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeRecentPosts") || userPageParameters.IncludeRecentPosts)
			        {
                        gotRecentPosts = CreateRecentPosts(owner, ref recentPosts);
			        }

                    if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeRecentComments") || userPageParameters.IncludeRecentComments)
			        {
                        gotRecentComments = CreateRecentComments(owner, ref recentComments);
			        }

                    if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeRecentGuideEntries") || userPageParameters.IncludeRecentGuideEntries)
			        {
                        gotRecentArticles = CreateRecentArticles(owner, ref recentArticles);
                        gotRecentApprovals = CreateRecentApprovedArticles(owner, ref recentApprovals);
			        }

                    if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeUploads") || userPageParameters.IncludeRecentUploads)
			        {
				        //string sUploadsXML;
				        //CUpload Upload(m_InputContext);
				        //Upload.GetUploadsForUser(iUserID,sUploadsXML);
				        //pWholePage->AddInside("H2G2",sUploadsXML);
			        }

                    if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeRecentArticlesOfSubscribedToUsers") || userPageParameters.IncludeRecentArticlesOfSubscribedUsers)
			        {
                        gotSubscribedToUsersRecentArticles = CreateSubscribedToUsersRecentArticles(owner, InputContext.CurrentSite.SiteID, ref subscribedUsersArticles); 
			        }
                }


                XmlElement pageOwner = AddElementTag(RootElement, "PAGE-OWNER");
                if(gotOwner)
                {
                    AddInside(pageOwner, owner);
                }
                else
                {
                    XmlElement pretendUser = AddElementTag(pageOwner, "USER");
                    AddIntElement(pretendUser, "USERID", userPageParameters.UserID);
                    AddTextTag(pretendUser, "USERNAME", "Researcher " + userPageParameters.UserID.ToString());
                }
                if(gotInterface)
                {
                    AddInside(pageInterface, "");
                }

                if (userPageParameters.Clip)
                {
                    string clipSubject = String.Empty;
                    if (gotOwner)
                    {
                        clipSubject = owner.UserName;
                    }
                    else
                    {
                        clipSubject = "U" + userPageParameters.UserID.ToString();
                    }
                    Link link = new Link(InputContext);
                    //TODO ClipPageToUser page
                    link.ClipPageToUserPage("userpage", userPageParameters.UserID, clipSubject, String.Empty, InputContext.ViewingUser, userPageParameters.Private);
                    AddInside(link);                       
                }

                // if masthead NULL stylesheet should do the default response
                if (gotMasthead && (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeUsersGuideEntry") || userPageParameters.IncludeUsersGuideEntries))
                {
                    AddInside(masthead);
                }
                // add page forum if there is one => this is the forum associated with
                // the guide enty that is the masthead for this user
                if (gotPageForum && (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeUsersGuideEntryForum") || userPageParameters.IncludeUsersGuideEntriesForums))
                {
                    XmlElement articleForumTag = AddElementTag(RootElement, "ARTICLEFORUM");
                    AddInside(articleForumTag, pageForum);
                }
                // add journal if it exists
                if ( gotJournal)
                {
                    XmlElement journalTag = AddElementTag(RootElement, "JOURNAL");
                    AddInside(journalTag, journal);
                }
                // add recent posts if they exist, this may add an empty
                // POST-LIST tag if the user exists but has never posted
                if ( gotRecentPosts)
                {
                    XmlElement recentPostsTag = AddElementTag(RootElement, "RECENT-POSTS");
                    AddInside(recentPostsTag, recentPosts);
                }
                // add recent articles if they exist, this may add an empty
                // ARTICLES-LIST tag if the user exists but has never written a guide entry
                if ( gotRecentArticles)
                {
                    XmlElement recentEntries = AddElementTag(RootElement, "RECENT-ENTRIES");
                    AddInside(recentEntries, recentArticles);
                    // add the user XML for the owner too
                    if (gotOwner)
                    {
                        AddInside(recentEntries, owner);
                    }
                }
                // add recent approvals if they exist, this may add an empty
                // ARTICLES-LIST tag if the user exists but has never had an entry approved
                if ( gotRecentApprovals)
                {
                    XmlElement recentApprovalsTag = AddElementTag(RootElement, "RECENT-APPROVALS");
                    AddInside(recentApprovalsTag, recentApprovals);
                    // add the user XML for the owner too
                    if (gotOwner)
                    {
                        AddInside(recentApprovalsTag, owner);
                    }
                }
                // add recent comments if they exist, this may add an empty
                // COMMENTS-LIST tag if the user exists but has never posted
                if ( gotRecentComments)
                {
                    XmlElement recentCommentsTag = AddElementTag(RootElement, "RECENT-COMMENTS");
                    AddInside(recentCommentsTag, recentComments);
                }

                if ( gotSubscribedToUsersRecentArticles)
                {
                    XmlElement subscribedUsersArticlesTag = AddElementTag(RootElement, "RECENT-SUBSCRIBEDARTICLES");
                    AddInside(subscribedUsersArticlesTag, subscribedUsersArticles);
                }

                SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
                RootElement.AppendChild(ImportNode(siteXml.GenerateAllSitesXml(InputContext.TheSiteList).FirstChild));

                AddWatchListSection(userPageParameters, gotMasthead);

                AddWhosOnlineSection();

                AddClubsSection(userPageParameters, gotMasthead);

                AddPrivateForumSection(userPageParameters, gotMasthead, gotOwner);

                AddLinksSection(userPageParameters, owner, gotMasthead, gotOwner);

                AddTaggedNodesSection(userPageParameters, owner, gotMasthead);

                AddNoticeBoardPostcoderSection(userPageParameters, gotMasthead);

                AddSiteOptionSection(userPageParameters);
            }
        }

        private bool CreateSubscribedToUsersRecentArticles(IUser user, int siteID, ref ArticleSubscriptionsList subscribedUsersArticles)
        {
            return subscribedUsersArticles.CreateArticleSubscriptionsList(user.UserID, siteID, 0, 10);
        }

        private bool CreateRecentApprovedArticles(IUser user, ref ArticleList recentApprovals)
        {
            return recentApprovals.CreateRecentApprovedArticlesList(user.UserID, InputContext.CurrentSite.SiteID, 0, 100, 0);
        }

        private bool CreateRecentArticles(IUser user, ref ArticleList recentArticles)
        {
            return recentArticles.CreateRecentArticleList(user.UserID, InputContext.CurrentSite.SiteID, 0, 100, 0);
        }

        private bool CreateRecentComments(IUser user, ref CommentsList recentComments)
        {
            return recentComments.CreateRecentCommentsList(user.UserID, InputContext.CurrentSite.SiteID, 0, 100);
        }

        private bool CreateRecentPosts(IUser user, ref PostList recentPosts)
        {
            return recentPosts.CreateRecentPostsList(user.UserID, 0, 100, 0, InputContext.CurrentSite.SiteID);
        }

        private bool CreateJournal(User owner, ref Forum journal)
        {
            int journalID = owner.Journal;
            journal.GetJournal(journalID, 5, 0, false);
            return true;
        }

        private bool CreateUserInterface(User owner, GuideEntry masthead, ref PageUI pageInterface)
        {
		    bool allowDiscuss = true;
            bool allowEdit = false;

            // get the ID of the forum if we have been given a masthead article and
            // it actually has a forum (which it should)
            int forumID = 0;
            if (masthead != null)
            {
                forumID = masthead.ForumID;
            }
            if (forumID == 0)
            {
                allowDiscuss = false;
            }
            // check if we have a registered viewer and also if this happens to be their
            // own home page and set the appropriate button flags
            if (InputContext.ViewingUser.UserID > 0 && InputContext.ViewingUser.UserLoggedIn)
            {
                if (InputContext.ViewingUser.UserID == owner.UserID)
                {
                    // also if this is their own home page they have an edit page button
                    allowEdit = true;
                }
            }

            string discussLink = "AddThread?forum=" + forumID.ToString() + "&amp;article=";

            int h2g2ID = 0;
            if (owner != null)
            {
                h2g2ID = owner.Masthead;
            }
            if (h2g2ID == 0)
            {
                if (masthead != null)
                {
                    h2g2ID = masthead.H2G2ID;
                }
            }

            discussLink += h2g2ID.ToString();

            string editLink = "/UserEdit" + h2g2ID.ToString() + "?Masthead=1";

		    // now set the apppropriate buttons in the UI object
		    // currently you only get the edit page button if this is actually your homepage, i.e. you
		    // wont get it if you have editor status
            pageInterface.SetDiscussVisibility(allowDiscuss, discussLink);
            pageInterface.SetEditPageVisibility(allowEdit, editLink);

            return true;
        }

        private bool CreatePageForum(GuideEntry masthead, ref Forum pageForum)
        {
            bool gotPageForum = false;

            int forumID = masthead.ForumID;
            if (forumID > 0)
            {
                pageForum.GetMostRecent(forumID);
                gotPageForum = true;
            }
            return gotPageForum;
        }

        private bool CreatePageArticle(int userID, User pageOwner, out GuideEntry masthead)
        {
            bool gotMasthead = false;
            masthead = null;

            if (pageOwner.UserID > 0 && pageOwner.Masthead > 0)
            {
                GuideEntrySetup setup = new GuideEntrySetup(pageOwner.Masthead);
                setup.ShowEntryData = true;
                setup.ShowPageAuthors = true;
                setup.ShowReferences = true;
                setup.SafeToCache = true;

                masthead = new GuideEntry(InputContext, setup);
                masthead.Initialise();

                //TODO do we need to do the XSLT parsing here if so how???
                gotMasthead = true;
            }
            return gotMasthead;
        }

        private bool CreatePageOwner(int userID, ref User owner)
        {
            owner.CreateUser(userID);
            return owner.UserID > 0;
        }

        private void AddWatchListSection(UserPageParameters userPageParameters, bool gotMasthead)
        {
            if (gotMasthead && (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeWatchInfo") || userPageParameters.IncludeWatchInfo))
            {
                WatchList watchList = new WatchList(InputContext);
                watchList.Initialise(userPageParameters.UserID);
                AddInside(watchList);
                watchList.WatchingUsers(userPageParameters.UserID, InputContext.CurrentSite.SiteID);
                AddInside(watchList);
            }
        }

        private void AddWhosOnlineSection()
        {
            WhosOnline online = new WhosOnline(InputContext);
            online.Initialise("none", 1, true, false);
            AddInside(online);
        }

        private void AddClubsSection(UserPageParameters userPageParameters, bool gotMasthead)
        {
            if (gotMasthead && (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeClubs") || userPageParameters.IncludeClubs))
            {
                //TODO Clubs when we need them
                /*
                bool isOwner = (InputContext.ViewingUser.UserID == userPageParameters.UserID);
                if (isOwner)
                {
                    Club club = new Club(InputContext);
                    club.GetUserActionList(userPageParameters.UserID, 0, 20);
                    AddInside(club);
                }
                CurrentClubs clubs = new CurrentClubs((InputContext);
                clubs.CreateList(userPageParameters.UserID, true);
                */
            }
        }

        private void AddPrivateForumSection(UserPageParameters userPageParameters, bool gotMasthead, bool gotOwner)
        {
            if (gotMasthead && (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludePrivateForums") || userPageParameters.IncludePrivateForums))
            {
                XmlElement privateForum = AddElementTag(RootElement, "PRIVATEFORUM");
                if (gotOwner)
                {
                    //TODO Fix up Private Forum
                    /* 
                     * Forum forum = new Forum(InputContext);
                    int privateForumID = 0;
                     
                    privateForumID = owner.GetPrivateForum();
                    forum.GetPostsInForum(privateForumID, 0, 10);
                    AddInside(privateForum, forum);

                    EmailAlertList alerts = new EmailAlertList(InputContext);
                    alerts.GetUserEmailAlertSubscriptionForForumAndThreads(userPageParameters.UserID, privateForumID);

                    AddInside(privateForum, alerts);
                    */
                }
            }
        }

        private void AddLinksSection(UserPageParameters userPageParameters, User owner, bool gotMasthead, bool gotOwner)
        {
            if (gotMasthead && (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeLinks") || userPageParameters.IncludeLinks))
            {
                bool isOwnerViewing = (InputContext.ViewingUser.UserID == owner.UserID);
                if (gotOwner && InputContext.ViewingUser.UserID > 0 && isOwnerViewing)
                {
                    ManagedClippedLinks(userPageParameters, owner);
                }
                if (gotOwner)
                {
                    Link link = new Link(InputContext);

                    link.GetUserLinks(owner.UserID, userPageParameters.LinkGroup, isOwnerViewing, 0, 0);
                    AddInside(link);

                    link.GetUserLinkGroups(owner.UserID);
                    AddInside(link);
                }
            }

        }

        private void ManagedClippedLinks(UserPageParameters userPageParameters, User owner)
        {
            Link link = new Link(InputContext);
            if (userPageParameters.LinksToMove)
            {
                link.MoveLinks(userPageParameters.MoveLinksList);
                AddInside(link);

            }
            if (userPageParameters.LinksPrivacyChange)
            {
                link.ChangeLinksPrivacy(userPageParameters.LinksPrivacy);
                AddInside(link);

            }
            if (userPageParameters.LinksToDelete)
            {
                link.DeleteLinks(userPageParameters.DeleteLinks, owner.UserID, InputContext.CurrentSite.SiteID);
                AddInside(link);

            }
        }

        private void AddTaggedNodesSection(UserPageParameters userPageParameters, User owner, bool gotMasthead)
        {
            if (gotMasthead && (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeTaggedNodes") || userPageParameters.IncludeUsersGuideEntriesForums))
            {
                //Get the Users Crumbtrail - all the nodes + ancestors the user is tagged to .
                Category category = new Category(InputContext);
                category.GetUserCrumbTrail(owner.UserID);
                AddInside(category);

            }
        }

        private void AddNoticeBoardPostcoderSection(UserPageParameters userPageParameters, bool gotMasthead)
        {
            if (gotMasthead)
            {
                if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludePostcoder") || userPageParameters.IncludeUsersGuideEntriesForums ||
                    InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeNoticeboard") || userPageParameters.IncludeUsersGuideEntriesForums)
                {
                    if (InputContext.ViewingUser.UserID >= 0)
                    {
                        /*
                        string postCodeToFind = string.Empty;
                        if (InputContext.ViewingUser.Postcode != String.Empty)
                        {
                            Notice notice = new Notice(InputContext);
                            notice.GetLocalNoticeBoardForPostCode(sPostCodeToFind, iSiteID);
                        }
                        */
                    }
                }
            }
        }

        private void AddSiteOptionSection(UserPageParameters userPageParameters)
        {
            if (InputContext.GetSiteOptionValueBool("PersonalSpace", "IncludeSiteOptions") || userPageParameters.IncludeUsersGuideEntriesForums)
            {
                if (InputContext.GetSiteOptionValueBool(InputContext.CurrentSite.SiteID, "General", "UseSystemMessages"))
                {
                    XmlElement siteOptionSystemMessage = AddElementTag(RootElement, "SITEOPTION");
                    AddTextTag(siteOptionSystemMessage, "NAME", "UseSystemMessages");
                    AddIntElement(siteOptionSystemMessage, "VALUE", 1);
                }
            }
        }
    }
}
