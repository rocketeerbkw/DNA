// UserPageBuilder.cpp: implementation of the CUserPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#include "stdafx.h"
#include "TDVAssert.h"
#include "UserPageBuilder.h"
#include "GuideEntry.h"
#include "WholePage.h"
#include "PageUI.h"
#include "PostList.h"
#include "WatchList.h"
#include "Club.h"
#include "WhosonlineObject.h"
#include "Link.h"
#include "Upload.h"
#include "Notice.h"
#include "CurrentClubs.h"
#include "PostcodeBuilder.h"
#include "Postcoder.h"
#include "Category.h"
#include "EMailAlertList.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CUserPageBuilder::CUserPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	28/02/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CUserPageBuilder object.

*********************************************************************************/

CUserPageBuilder::CUserPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
// no further construction
}

/*********************************************************************************

	CUserPageBuilder::~CUserPageBuilder()
																			 ,
	Author:		Kim Harries
	Created:	28/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CUserPageBuilder::~CUserPageBuilder()
{
// no destruction required
}

/*********************************************************************************

	CWholePage* CUserPageBuilder::Build()
																			 ,
	Author:		Kim Harries, Oscar Gillespie
	Created:	28/02/2000
	Modified:	15/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML representation of the user page.
	Purpose:	Construct a user page from its various constituent parts based
				on the request info available from the input context supplied during
				construction.

*********************************************************************************/

bool CUserPageBuilder::Build(CWholePage* pWholePage)
{
	// introducing the players - these will point to the XML objects required
	// to construct a user page
	CPageUI			Interface(m_InputContext);
	CUser*			pViewer = NULL;
	CUser			Owner(m_InputContext);
	CGuideEntry		Masthead(m_InputContext);
	CForum			PageForum(m_InputContext);
	CForum			Journal(m_InputContext);
	CPostList		RecentPosts(m_InputContext);
	CArticleList	RecentArticles(m_InputContext);
	CArticleList	RecentApprovals(m_InputContext);
	CCommentsList	RecentComments(m_InputContext);
	CArticleSubscriptionList	SubscribedUsersArticles(m_InputContext);
	
	CTDVString	sSecretKey;
	int			iSecretKey = 0;
	int			iUserID = 0;		// the user ID in the URL
	bool		bRegistering = false;
	bool		bSuccess = true;	// our success flag

	// get the user ID from the URL => zero if not present
	// TODO: something appropriate if no ID provided	
	iUserID = m_InputContext.GetParamInt("UserID");
	// now get the secret key if there is one
	// we may need to process it so get it as a string
	if (m_InputContext.GetParamString("Key", sSecretKey))
	{
		// if the secret key start with "3D" we must strip this off
		// - it is caused by a mime encoding problem, 3D is the ascii hex for =
		if (sSecretKey.Find("3D") == 0)
		{
			sSecretKey =  sSecretKey.Mid(2);
		}
		iSecretKey = atoi(sSecretKey);
		if (iSecretKey > 0)
		{
			// if there is a secret key then it is a registration attempt
			bRegistering = true;
		}
	}
	// now give appropriate page depending on whether this is a registration or not
	if (bRegistering)
	{
//		CStoredProcedure* pSP = m_InputContext.CreateStoredProcedureObject();
		CTDVString sPageContent = "";
		CTDVString sPageSubject = "";
//		CTDVString sCookie;

		// check we got our SP okay
//		if (pSP == NULL)
//		{
//			bSuccess = false;
//		}
		// if so then call the activate user method, which should return us a nice
		// warm cookie if all goes well
//		if (bSuccess)
//		{
//			bSuccess = pSP->ActivateUser(iUserID, iSecretKey, &sCookie);
			// make sure cookie is not empty
//			if (sCookie.IsEmpty())
//			{
//				bSuccess = false;
//			}
//		}
		// if okay then build page with the cookie in and a message to the user
		if (bSuccess)
		{
			// we have a cookie and we are prepared to use it
			// TODO: what about the MEMORY tag?
			// TODO: put this in stylesheet? Deal with delayed refresh?
//			CTDVString sCookieXML = "<SETCOOKIE><COOKIE>" + sCookie + "</COOKIE></SETCOOKIE>";

//			sPageSubject = "Registration in process ...";
//			sPageContent << "<GUIDE><BODY>";
//			sPageContent << "<P>Thank you for registering as an official Researcher for The Hitch Hiker's ";
//			sPageContent << "Guide to the Galaxy: we do hope you enjoy contributing to the Guide.</P>";
//			sPageContent << "<P>Please wait while you are transferred to <LINK BIO=\"U" << iUserID << "\">";
//			sPageContent << "your Personal Home Page</LINK> ... or click the link if nothing happens.</P>";
//			sPageContent << "</BODY></GUIDE>";
//			pWholePage = CreateSimplePage(sPageSubject, sPageContent);
//			if (pWholePage == NULL)
//			{
//				bSuccess = false;
//			}

			if (bSuccess)
			{
				bSuccess = InitPage(pWholePage, "USERPAGE",false);
			}
			// put the cookie xml inside the H2G2 tag
//			bSuccess = pWholePage->AddInside("H2G2", sCookieXML);

//			CTDVString sUserXML = "";
//			sUserXML << "<REGISTERING-USER>";
//			sUserXML << "<USER>";
//			sUserXML << "<USERNAME></USERNAME>";
//			sUserXML << "<USERID>" << iUserID << "</USERID>";
//			sUserXML << "</USER>";
//			sUserXML << "</REGISTERING-USER>";
//			bSuccess = pWholePage->AddInside("H2G2", sUserXML);
//			bSuccess = bSuccess && pWholePage->SetPageType("REGISTER-CONFIRMATION");

		CTDVString sRedirect;
		sRedirect << "ShowTerms" << iUserID;
		sRedirect << "?key=" << sSecretKey;
		pWholePage->Redirect(sRedirect);
		}
		else
		{
			sPageSubject = "Sorry ...";
			sPageContent << "<GUIDE><BODY>";
			sPageContent << "<P>The URL you've given is wrong. Please re-check your email, or <LINK HREF=\"/Register\">click here to re-enter your email address</LINK>.</P>";
			sPageContent << "</BODY></GUIDE>";
			bSuccess = CreateSimplePage(pWholePage, sPageSubject, sPageContent);
		}
		// make sure we delete the SP if any
//		delete pSP;
//		pSP = NULL;
	}
	else
	{
		// get or create all the appropriate xml objects
		pViewer		= m_InputContext.GetCurrentUser();
		bool bGotMasthead = false; 
		bool bGotPageForum = false; 
		bool bGotJournal = false; 
		bool bGotRecentPosts = false; 
		bool bGotRecentArticles = false; 
		bool bGotRecentApprovals = false; 
		bool bGotRecentComments = false; 
		bool bGotSubscribedToUsersRecentArticles = false; 

		bool bGotOwner		= CreatePageOwner(iUserID, Owner);

		CreatePageTemplate(pWholePage);
		if (m_InputContext.IncludeUsersGuideEntryInPersonalSpace() || (m_InputContext.GetParamInt("i_uge") == 1) ||
			m_InputContext.IncludeUsersGuideEntryForumInPersonalSpace() || (m_InputContext.GetParamInt("i_ugef") == 1))
		{
			bGotMasthead = CreatePageArticle(iUserID, Owner, Masthead);

			if (m_InputContext.IncludeUsersGuideEntryForumInPersonalSpace() || (m_InputContext.GetParamInt("i_ugef") == 1))
			{
				// GuideEntry forum can not be returned if GuideEntry is not being returned.
				bGotPageForum = CreatePageForum(pViewer, Masthead, PageForum);
			}
		}

		bool bGotInterface = CreateUserInterface(pViewer, Owner, Masthead, Interface);
		
		// Only display other information if the page has a valid masthead
		if (bGotMasthead)
		{
			if (m_InputContext.IncludeJournalInPersonalSpace() || (m_InputContext.GetParamInt("i_j") == 1))
			{
				bGotJournal = CreateJournal(Owner, pViewer, Journal);
			}

			if (m_InputContext.IncludeRecentPostsInPersonalSpace() || (m_InputContext.GetParamInt("i_rp") == 1))
			{
				bGotRecentPosts = CreateRecentPosts(Owner, pViewer, RecentPosts);
			}

			if (m_InputContext.IncludeRecentCommentsInPersonalSpace() || (m_InputContext.GetParamInt("i_rc") == 1))
			{
				bGotRecentComments = CreateRecentComments(Owner, pViewer, RecentComments);
			}

			if (m_InputContext.IncludeRecentGuideEntriesInPersonalSpace() || (m_InputContext.GetParamInt("i_rge") == 1))
			{
				bGotRecentArticles = CreateRecentArticles(Owner, RecentArticles);
				bGotRecentApprovals = CreateRecentApprovedArticles(Owner, RecentApprovals);
			}

			if (m_InputContext.IncludeUploadsInPersonalSpace() || (m_InputContext.GetParamInt("i_u") == 1))
			{
				CTDVString sUploadsXML;
				CUpload Upload(m_InputContext);
				Upload.GetUploadsForUser(iUserID,sUploadsXML);
				pWholePage->AddInside("H2G2",sUploadsXML);
			}

			if (m_InputContext.IncludeRecentArticlesOfSubscribedToUsersInPersonalSpace() || (m_InputContext.GetParamInt("i_rasu") == 1))
			{
				bGotSubscribedToUsersRecentArticles = CreateSubscribedToUsersRecentArticles(Owner, m_InputContext.GetSiteID(), SubscribedUsersArticles); 
			}
		}

		// See if the user wants to swap to this site and change their masthead and journal (if it exists)
/*
	This feature is now redundant. There's no concept of a homesite.
		if (m_InputContext.ParamExists("homesite"))
		{
			if (pViewer == NULL)
			{
				// error: Not registered - ignore request
			}
			else if (!bGotOwner)
			{
				// error - no actual owner, ignore request
			}
			else if (pViewer->GetIsEditor())
			{
				int iCurrentSiteID = m_InputContext.GetSiteID();
				int iThisSite = iCurrentSiteID;
				if (bGotMasthead)
				{
					iCurrentSiteID = Masthead.GetSiteID();
				}
				if ( iThisSite != iCurrentSiteID && m_InputContext.CanUserMoveToSite(iCurrentSiteID, iThisSite))
				{
					CStoredProcedure SP;
					m_InputContext.InitialiseStoredProcedureObject(&SP);
					if (bGotMasthead)
					{
						SP.MoveArticleToSite(Masthead.GetH2G2ID(), m_InputContext.GetSiteID());
						//delete pMasthead;
						Masthead.Destroy();
						bGotMasthead = CreatePageArticle(iUserID, Owner, Masthead);
					}
					int iJournal;
					Owner.GetJournal(&iJournal);
					if (iJournal > 0)
					{
						SP.MoveForumToSite(iJournal, m_InputContext.GetSiteID());
					}

					int iPrivateForum;
					if (Owner.GetPrivateForum(&iPrivateForum))
					{
						SP.MoveForumToSite(iPrivateForum, m_InputContext.GetSiteID());
					}
					pWholePage->AddInside("H2G2", "<SITEMOVED RESULT='success'/>");
				}
			}
		}
*/
		// check that all the *required* objects have been created successfully
		// note that pViewer can be NULL if an unregistered viewer
		// pOwner can be NULL if we are serving a default page because this user ID
		// does not exist
		// bGotJournal can be false if the user doesn't exist, or has no journal
		// bGotRecentPosts can be false if the user doesn't exist
		// pRecentArticles can be NULL if the user doesn't exist
		// pRecentApprovals can be NULL if the user doesn't exist
		// bGotPageForum can be false if there is no masthead, or if it has no forum yet
		// pMasthead could be NULL if the user has not created one yet
		if (pWholePage->IsEmpty() || bGotInterface == false)
		{
			bSuccess = false;
		}
		// now add all the various subcomponents into the whole page xml
		// add owner of page
		if (bSuccess)
		{
			// if we have a page owner then put their details in, otherwise make
			// up a pretend user from the ID we were given
			if (bGotOwner)
			{
				bSuccess = pWholePage->AddInside("PAGE-OWNER", &Owner);
			}
			else
			{
				CTDVString sPretendUserXML = "";
				sPretendUserXML << "<USER><USERID>" << iUserID << "</USERID>";
				sPretendUserXML << "<USERNAME>Researcher " << iUserID << "</USERNAME></USER>";
				bSuccess = pWholePage->AddInside("PAGE-OWNER", sPretendUserXML);
			}
		}
		// there should always be an interface but check anyway
		if (bSuccess && bGotInterface)
		{
			bSuccess = pWholePage->AddInside("H2G2", &Interface);
		}
		if (bSuccess && m_InputContext.ParamExists("clip"))
		{
			CTDVString sSubject;
			if (bGotOwner)
			{
				Owner.GetUsername(sSubject);
			}
			else
			{
				sSubject << "U" << iUserID;
			}

			bool bPrivate = m_InputContext.GetParamInt("private") > 0;
			CLink Link(m_InputContext);
			if ( Link.ClipPageToUserPage("userpage", iUserID, sSubject, NULL, pViewer, bPrivate) )
				pWholePage->AddInside("H2G2", &Link);
		}
		// if masthead NULL stylesheet should do the default response
		if (bSuccess && bGotMasthead && (m_InputContext.IncludeUsersGuideEntryInPersonalSpace() || (m_InputContext.GetParamInt("i_uge") == 1)))
		{
			bSuccess = pWholePage->AddInside("H2G2", &Masthead);
		}
		// add page forum if there is one => this is the forum associated with
		// the guide enty that is the masthead for this user
		if (bSuccess && bGotPageForum && (m_InputContext.IncludeUsersGuideEntryForumInPersonalSpace() || (m_InputContext.GetParamInt("i_ugef") == 1)))
		{
			bSuccess = pWholePage->AddInside("H2G2", &PageForum);
		}
		// add journal if it exists
		if (bSuccess && bGotJournal)
		{
			bSuccess = pWholePage->AddInside("JOURNAL", &Journal);
		}
		// add recent posts if they exist, this may add an empty
		// POST-LIST tag if the user exists but has never posted
		if (bSuccess && bGotRecentPosts)
		{
			bSuccess = pWholePage->AddInside("RECENT-POSTS", &RecentPosts);
		}
		// add recent articles if they exist, this may add an empty
		// ARTICLES-LIST tag if the user exists but has never written a guide entry
		if (bSuccess && bGotRecentArticles)
		{
			bSuccess = pWholePage->AddInside("RECENT-ENTRIES", &RecentArticles);
			// add the user XML for the owner too
			if (bGotOwner)
			{
				bSuccess = bSuccess && pWholePage->AddInside("RECENT-ENTRIES", &Owner);
			}
		}
		// add recent articles if they exist, this may add an empty
		// ARTICLES-LIST tag if the user exists but has never had an entry approved
		if (bSuccess && bGotRecentApprovals)
		{
			bSuccess = pWholePage->AddInside("RECENT-APPROVALS", &RecentApprovals);
			// add the user XML for the owner too
			if (bGotOwner)
			{
				bSuccess = bSuccess && pWholePage->AddInside("RECENT-APPROVALS", &Owner);
			}
		}
		// add recent comments if they exist, this may add an empty
		// COMMENTS-LIST tag if the user exists but has never posted
		if (bSuccess && bGotRecentComments)
		{
			bSuccess = pWholePage->AddInside("RECENT-COMMENTS", &RecentComments);
		}

		if (bSuccess && bGotSubscribedToUsersRecentArticles)
		{
			bSuccess = pWholePage->AddInside("RECENT-SUBSCRIBEDARTICLES", &SubscribedUsersArticles);
		}

		CTDVString sSiteXML;
		m_InputContext.GetSiteListAsXML(&sSiteXML);
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", sSiteXML);

		if (bGotMasthead && (m_InputContext.IncludeWatchInfoInPersonalSpace() || (m_InputContext.GetParamInt("i_wi") == 1)))
		{
			CWatchList WatchList(m_InputContext);
			bSuccess = bSuccess && WatchList.Initialise(iUserID);
			bSuccess = bSuccess && pWholePage->AddInside("H2G2",&WatchList);
			int iSiteID = m_InputContext.GetSiteID();
			bSuccess = bSuccess && WatchList.WatchingUsers(iUserID, iSiteID);
			bSuccess = bSuccess && pWholePage->AddInside("H2G2",&WatchList);
		}

		CWhosOnlineObject Online(m_InputContext);
		bSuccess = bSuccess && Online.Initialise(NULL, 1, true);
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", &Online);

		if (bGotMasthead && (m_InputContext.IncludeClubsInPersonalSpace() || (m_InputContext.GetParamInt("i_c") == 1)))
		{
			if (pViewer != NULL && pViewer->GetUserID() == iUserID) 
			{
				CClub Club(m_InputContext);
				Club.GetUserActionList(iUserID, 0, 20);
				pWholePage->AddInside("H2G2", &Club);
			}

			// Now add all the clubs the user belongs to
			CCurrentClubs Clubs(m_InputContext);
			if (bSuccess && Clubs.CreateList(iUserID,true))
			{
				bSuccess = pWholePage->AddInside("H2G2",&Clubs);
			}
		}
		
		if (bGotMasthead && bSuccess && (m_InputContext.IncludePrivateForumsInPersonalSpace() || (m_InputContext.GetParamInt("i_pf") == 1)))
		{
			pWholePage->AddInside("H2G2", "<PRIVATEFORUM/>");
			CForum Forum(m_InputContext);
			int iPrivateForum = 0;
			if (bGotOwner)
			{
				Owner.GetPrivateForum(&iPrivateForum);
			}
			Forum.GetThreadList(pViewer, iPrivateForum, 10,0);
			pWholePage->AddInside("PRIVATEFORUM", &Forum);

			// Now check to see if the user has alerts set for their private forum
			if (bGotOwner)
			{
				CEmailAlertList Alert(m_InputContext);
				Alert.GetUserEMailAlertSubscriptionForForumAndThreads(iUserID,iPrivateForum);
				pWholePage->AddInside("PRIVATEFORUM", &Alert);
			}
		}

		if (bGotMasthead && bSuccess && (m_InputContext.IncludeLinksInPersonalSpace() || (m_InputContext.GetParamInt("i_l") == 1)))
		{
			CTDVString sLinkGroup;
			m_InputContext.GetParamString("linkgroup", sLinkGroup);
			if (bGotOwner && pViewer != NULL && Owner.GetUserID() == pViewer->GetUserID()) 
			{
				ManageClippedLinks(pWholePage);
			}
			if (bGotOwner)
			{
				CLink Link(m_InputContext);
				bool bShowPrivate = (pViewer != NULL && Owner.GetUserID() == pViewer->GetUserID());
				Link.GetUserLinks(Owner.GetUserID(), sLinkGroup, bShowPrivate);
				pWholePage->AddInside("H2G2", &Link);
				Link.GetUserLinkGroups(Owner.GetUserID());
				pWholePage->AddInside("H2G2", &Link);
			}
		}

		if (bGotMasthead && m_InputContext.IncludeTaggedNodesInPersonalSpace() || (m_InputContext.GetParamInt("i_tn") == 1))
		{
			//Get the Users Crumtrail - all the nodes + ancestors the user is tagged to .
			CCategory CCat(m_InputContext);
			if ( bSuccess && CCat.GetUserCrumbTrail(Owner.GetUserID()) )
			{
				bSuccess = pWholePage->AddInside("H2G2",&CCat);
			}
		}

		if (bSuccess && bGotMasthead)
		{
			CTDVString sPostCodeXML;
			CTDVString sNoticeXML;
			if (m_InputContext.IncludeNoticeboardInPersonalSpace() || (m_InputContext.GetParamInt("i_n") == 1) ||
				m_InputContext.IncludePostcoderInPersonalSpace() || (m_InputContext.GetParamInt("i_p") == 1))
			{
				if (pViewer != NULL)
				{
					// Insert the notice board information!
					CTDVString sPostCodeToFind;
					if(pViewer->GetPostcode(sPostCodeToFind))
					{
						int iSiteID = m_InputContext.GetSiteID();
						CNotice Notice(m_InputContext);
						if (!Notice.GetLocalNoticeBoardForPostCode(sPostCodeToFind,iSiteID,sNoticeXML,sPostCodeXML))
						{
							sNoticeXML << "<NOTICEBOARD><ERROR>FailedToFindLocalNoticeBoard</ERROR></NOTICEBOARD>";
						}
					}
					else
					{
						//if the user has not entered a postcode then flag an Notice Board error
						sNoticeXML << "<NOTICEBOARD><ERROR>UserNotEnteredPostCode</ERROR></NOTICEBOARD>";
					}
				}
				else
				{
					sNoticeXML << "<NOTICEBOARD><ERROR>UserNotLoggedIn</ERROR></NOTICEBOARD>";
				}

				if (m_InputContext.IncludeNoticeboardInPersonalSpace() || (m_InputContext.GetParamInt("i_n") == 1))
				{
					bSuccess = pWholePage->AddInside("H2G2",sNoticeXML);
				}
			}

			if (m_InputContext.IncludePostcoderInPersonalSpace() || (m_InputContext.GetParamInt("i_p") == 1))
			{
				// Insert the postcoder if it's not empty
				if (bSuccess && !sPostCodeXML.IsEmpty())
				{
					bSuccess = bSuccess && pWholePage->AddInside("H2G2",sPostCodeXML);
				}
			}
		}

		if (m_InputContext.IncludeSiteOptionsInPersonalSpace() || (m_InputContext.GetParamInt("i_so") == 1))
		{
			// Return SiteOption SystemMessageOn if set. 
			if (bSuccess && m_InputContext.IsSystemMessagesOn(m_InputContext.GetSiteID()))
			{
				CTDVString sSiteOptionSystemMessageXML = "<SITEOPTION><NAME>UseSystemMessages</NAME><VALUE>1</VALUE></SITEOPTION>"; 

				bSuccess = bSuccess && pWholePage->AddInside("H2G2",sSiteOptionSystemMessageXML);
			}
		}
		
/*
		Mark Howitt 11/8/05 - Removing the civic data from the user page as it is nolonger used by any sites.
							  The only place civic data is used now is on the postcoder page.

		//include civic data
		if (bSuccess)
		{
			if ( m_InputContext.GetSiteID( ) == 16 )
			{
				CTDVString sActualPostCode;				
				bool bFoundLocalInfo = false;
				// First check to see if there is a postcode in the URL
				if (m_InputContext.ParamExists("postcode"))
				{
					// Get the postcode and use this to display the noticeboard
					if (m_InputContext.GetParamString("postcode", sActualPostCode))
					{
						//dont do any validations
						bFoundLocalInfo = true;				
					}
				}

				//next if no postcode variable is included in URL
				//or if the specified postcode value is invalid 
				//or if the specified postcode value has no entries on the db				
				if (!bFoundLocalInfo)
				{
					// No postcode given, try to get the viewing users postcode if we have one.
					if (pViewer)
					{
						if (pViewer->GetPostcode(sActualPostCode))
						{
							if ( sActualPostCode.IsEmpty( ) == false)
							{
								//dont do any validations
								bFoundLocalInfo = true;
							}
						}							
					}
					else
					{
						//try session cookie, if any 
						CTDVString sPostCodeToFind;
						CPostcoder postcoder(m_InputContext);
						CTDVString sActualPostCode = postcoder.GetPostcodeFromCookie();
						if ( !sActualPostCode.IsEmpty() )
						{
							//dont do any validations
							bFoundLocalInfo = true;
						}
					}
				}

				if ( bFoundLocalInfo )
				{
					if (!sActualPostCode.IsEmpty())
					{
						bool bHitPostcode = false;
						CPostcoder cPostcoder(m_InputContext);
						cPostcoder.MakePlaceRequest(sActualPostCode, bHitPostcode);
						if (bHitPostcode)
						{
							CTDVString sXML = "<CIVICDATA POSTCODE='";
							sXML << sActualPostCode << "'/>";
							pWholePage->AddInside("H2G2", sXML);
							bSuccess = pWholePage->AddInside("CIVICDATA",&cPostcoder);
						}
					}
				}
			}
		}
*/
	}

	return bSuccess;
}

/*********************************************************************************

	CWholePage* CUserPageBuilder::CreatePageTemplate()
																			 ,
	Author:		Kim Harries
	Created:	03/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage object created by this method.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CWholePage object to act as a template within which to insert
				the other XML objects that make up the page.

*********************************************************************************/

bool CUserPageBuilder::CreatePageTemplate(CWholePage* pPage)
{

	bool bSuccess = false;
	// once we have the object initialise it and then add in empty tags
	// for the various special sections on the user page
	bSuccess = InitPage(pPage, "USERPAGE",false);
	if (bSuccess)
	{
		bSuccess =	pPage->AddInside("H2G2", "<PAGE-OWNER></PAGE-OWNER>") &&
					pPage->AddInside("H2G2", "<JOURNAL></JOURNAL>") &&
					pPage->AddInside("H2G2", "<RECENT-POSTS></RECENT-POSTS>") &&
					pPage->AddInside("H2G2", "<RECENT-ENTRIES></RECENT-ENTRIES>") &&
					pPage->AddInside("H2G2", "<RECENT-APPROVALS></RECENT-APPROVALS>");
					pPage->AddInside("H2G2", "<RECENT-COMMENTS></RECENT-COMMENTS>");
					pPage->AddInside("H2G2", "<RECENT-SUBSCRIBEDARTICLES></RECENT-SUBSCRIBEDARTICLES>");
	}
	return bSuccess;
}

/*********************************************************************************

	bool CUserPageBuilder::CreateUserInterface(CUser* pViewer, CUser* pOwner, CGuideEntry* pMasthead, CPageUI* oInterface)

	Author:		Kim Harries
	Created:	07/03/2000
	Inputs:		pViewer - pointer to an object representing the viewing user, or
					NULL if they are not a registered user.
				pOwner - pointer to an object representing the owner of this page
				pMasthead - ptr to the article that is this users masthead
	Outputs:	-
	Returns:	Pointer to a CPageUI object created by this method.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CPageUI object with the relevant UI xml for this page.

*********************************************************************************/

bool CUserPageBuilder::CreateUserInterface(CUser* pViewer, CUser& Owner, CGuideEntry& Masthead, CPageUI &Interface)
{
	// TODO: will need to take into account viewing users preferences at some
	// point if they are allowed to switch off some buttons

	bool bSuccess = Interface.Initialise(pViewer);
	// I've guessed at what the URLs might look like => should the url
	// parameters be filled in at this time as well?
	if (bSuccess)
	{
		bool bDiscuss = true;
		bool bEdit = false;
		bool bViewerActive = false;
		int iViewerID = 0;
		int iOwnerID = 0;
		int iForumID = 0;

		// get the ID of the forum if we have been given a masthead article and
		// it actually has a forum (which it should)
		if (!Masthead.IsEmpty())
		{
			iForumID = Masthead.GetForumID();
		}
		if (iForumID == 0)
		{
			bDiscuss = false;
		}
		// check if we have a registered viewer and also if this happens to be their
		// own home page and set the appropriate button flags
		if (pViewer != NULL && pViewer->GetActive(&bViewerActive) && bViewerActive)
		{
			if (pViewer->GetUserID(&iViewerID) &&
				!Owner.IsEmpty() &&
				Owner.GetUserID(&iOwnerID) &&
				iViewerID == iOwnerID &&
				iViewerID != 0)
			{
				// also if this is their own home page they have
				// an edit page button
				bEdit = true;
			}
		}
		// TODO: forum ID seems to not work???
		CTDVString sDiscuss = "AddThread?forum=";
		sDiscuss << iForumID << "&amp;article=";
		int ih2g2ID = 0;
		CTDVString sEditLink = "";

		// get masthead ID if there is one
		if (!Owner.IsEmpty())
		{
			ih2g2ID = Owner.GetMasthead();
		}
		else if (!Masthead.IsEmpty())
		{
			ih2g2ID = Masthead.GetH2G2ID();
		}
		sEditLink << "/UserEdit" << ih2g2ID << "?Masthead=1";
		sDiscuss << ih2g2ID;
		// now set the apppropriate buttons in the UI object
		// currently you only get the eidt page button if this is actually your homepage, i.e. you
		// wont get it if you have editor status
		bSuccess =	Interface.SetDiscussVisibility(bDiscuss, sDiscuss) &&
					Interface.SetEditPageVisibility(bEdit, sEditLink);
		// TODO: may wish to fail in this case, but just log the error currently
		TDVASSERT(bSuccess, "Couldn't set a visibility option in CUserPageBuilder::CreateUserInterface()");
	}
	// if something went wrong then delete object and return NULL
	// return object or NULL for failure
	return bSuccess;
}

/*********************************************************************************

	CUser* CUserPageBuilder::CreatePageOwner(int iUserID)

	Author:		Kim Harries
	Created:	07/03/2000
	Inputs:		iUserID - the user ID from the requests URL.
	Outputs:	-
	Returns:	Pointer to a CUser object created by this method, or NULL if it
				couldn't be created or the user is not active.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CUser representing the data for the owner of this page.

*********************************************************************************/

bool CUserPageBuilder::CreatePageOwner(int iUserID, CUser& Owner)
{
	TDVASSERT(iUserID > 0, "CUserPageBuilder::CreatePageOwner(...) called with non-positive ID");

	// create the user object from this ID
	// note that even if the ID is invalid it may not fail at this point
	// due to delayed DB access or whatnot, hence must continue to check
	// all return values for methods called
	Owner.SetSiteID(m_InputContext.GetSiteID());
	bool bSuccess = Owner.CreateFromID(iUserID);
	// check if user is actually active and not a dud
	if (bSuccess)
	{
		bool bActive = false;
		bSuccess = Owner.GetActive(&bActive);
		bSuccess = bSuccess && bActive;
	}
	// return the new object, or NULL for failure
	return bSuccess;
}

/*********************************************************************************

	bool CUserPageBuilder::CreatePageArticle(int iUserID, CUser& PageOwner, CGuideEntry &Article)

	Author:		Kim Harries
	Created:	07/03/2000
	Inputs:		iUserID - the user ID from the requests URL.
				pPageOwner - the xml object representing the page owner, or NULL
					if there isn't one.
	Outputs:	-
	Returns:	Pointer to a CGuideEntry object created by this method.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CGuideEntry representing the data for content of this users
				home page.

*********************************************************************************/

bool CUserPageBuilder::CreatePageArticle(int iUserID, CUser& PageOwner, CGuideEntry &Article)
{
	bool bSuccess = false;
	int ih2g2ID = 0;
	// if we have a page owner and can get their masthead then try to
	// initialise it in an appropriate way for the user page
	// are these flags right ???
	if (!PageOwner.IsEmpty() &&
		PageOwner.GetMasthead(&ih2g2ID) &&
		ih2g2ID > 0)
	{
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		bSuccess = Article.Initialise(ih2g2ID, m_InputContext.GetSiteID(), pViewingUser, true, true, true, true);
	}
	// now check if the XSLT parser finds any errors in the XML
	// if it does then try to fail gracefully by keeping the rest of the page
	// and just not displaying the masthead
	if (bSuccess)
	{
		CTDVString sArticleXML;
		CTDVString sErrors;
		CTDVString sErrorLine;
		int iLine;
		int iChar;

		// get the article in text form and see if the xslt parser chokes on it
		bSuccess = Article.GetAsString(sArticleXML);
//		OutputDebugString(sArticleXML);
		bSuccess = bSuccess && m_InputContext.GetParsingErrors(sArticleXML, &sErrors, &sErrorLine, &iLine, &iChar);
		if (!bSuccess)
		{
			// XSLT object had parse errors, so keep the ARTICLEINFO stuff
			// but throw away anything else inside the ARTICLE tag
			CTDVString sArticleInfoXML;
			int iLeftPos, iRightPos;

			iLeftPos = sArticleXML.FindText("<ARTICLEINFO");
			iRightPos = sArticleXML.FindText("</ARTICLEINFO>");
			if (iLeftPos >= 0 && iRightPos >= 0 && iRightPos >= iLeftPos)
			{
				// adjust right pos to end of tag
				iRightPos += 14;
				sArticleInfoXML = sArticleXML.Mid(iLeftPos, iRightPos - iLeftPos);
			}
			else
			{
				// no article info available
				// TODO: could try to construct it from other data
				sArticleInfoXML = "<ARTICLEINFO></ARTICLEINFO>";
			}
			bSuccess = Article.RemoveTagContents("ARTICLE");
			TDVASSERT(bSuccess, "RemoveTagContents(...) failed in CUserPageBuilder::CreatePageArticle(...)");
			// insert an ERROR tag with a type and some contents that can be used by the stylesheet or
			// ignored as it sees fit
			sArticleXML = "<ERROR TYPE='XML-PARSE-ERROR'>Error parsing GuideML</ERROR>";
			bSuccess = Article.AddInside("ARTICLE", sArticleXML);
			bSuccess = bSuccess && Article.AddInside("ARTICLE", sArticleInfoXML);
		}
	}
	// return the object, or NULL if couldn't make one
	return bSuccess;
}


/*********************************************************************************

	CForum* CUserPageBuilder::CreatePageForum(CUser* pViewer, CGuideEntry* pArticle)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		pArticle - pointer to the article for this user page, from which
					we want to get the articles forum.
	Outputs:	-
	Returns:	Pointer to a CForum object created by this method.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CForum representing the data for content of this users
				mastheads forum.

*********************************************************************************/

bool CUserPageBuilder::CreatePageForum(CUser* pViewer, CGuideEntry& Article, CForum& PageForum)
{
	if (Article.IsEmpty())
	{
		// if no article then clearly no forum
		return false;
	}
	
	// now create the forum as a list of threads
	bool bSuccess = false;
	int iForumID = Article.GetForumID();

	// if there is no forum an ID of zero will be returned
	if (iForumID > 0)
	{
		// get the first five threads in the forum
		int iUserID = 0;
		if (pViewer != NULL)
		{
			iUserID = pViewer->GetUserID();
		}
		bSuccess = PageForum.GetMostRecent(iForumID, pViewer);
	}
	// return the new forum object, or NULL for failure
	return bSuccess;
}

/*********************************************************************************

	CForum* CUserPageBuilder::CreateJournal(CUser* pPageOwner, CUser* pViewer)

	Author:		Kim Harries
	Created:	07/03/2000
	Inputs:		pPageOwner - the xml object representing the page owner, or NULL
					if there isn't one.
	Outputs:	-
	Returns:	Pointer to a CForum object created by this method.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CForum representing the data for this users journal.

*********************************************************************************/

bool CUserPageBuilder::CreateJournal(CUser& PageOwner, CUser* pViewer, CForum& Journal)
{
	int iJournalID = 0;
	bool bSuccess =	!PageOwner.IsEmpty() &&
					PageOwner.GetJournal(&iJournalID) &&
					Journal.GetJournal(pViewer, iJournalID, 5, 0);
	return bSuccess;
}

/*********************************************************************************

	CPostList* CUserPageBuilder::CreateRecentPosts(CUser* pPageOwner)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		pPageOwner - the xml object representing the page owner, or NULL
					if there isn't one.
	Outputs:	-
	Returns:	Pointer to a CPostList object created by this method, or NULL if
				it couldn't be created.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CPostList representing the data for this users most recent posts.

*********************************************************************************/

bool CUserPageBuilder::CreateRecentPosts(CUser& PageOwner, CUser* pViewer, CPostList& RecentPosts)
{
	bool bSuccess = false;
	int iUserID = 0;

	// if we have a page owner and can get their ID then create the most recent
	// post list for them
	bSuccess =	!PageOwner.IsEmpty() &&
				PageOwner.GetUserID(&iUserID) &&
				RecentPosts.CreateRecentPostsList(pViewer, iUserID,100);
	// return created object or NULL for failure
	return bSuccess;
}

/*********************************************************************************

	bool CUserPageBuilder::CreateRecentArticles(CUser* pPageOwner, CArticleList& RecentArticles)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		pPageOwner - the xml object representing the page owner, or NULL
					if there isn't one.
				RecentArticles - articlelist object to populate
	Outputs:	-
	Returns:	Pointer to a CArticleList object created by this method, or NULL if
				it couldn't be created.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CArticleList representing the data for this users most recent
				guide entries.

*********************************************************************************/

bool CUserPageBuilder::CreateRecentArticles(CUser& PageOwner, CArticleList& RecentArticles)
{
	bool bSuccess = false;
	int iUserID = 0;

	// if we have a page owner and can get their ID then create the most recent
	// article list for them
	bSuccess =	!PageOwner.IsEmpty() &&
				PageOwner.GetUserID(&iUserID) &&
				RecentArticles.CreateRecentArticlesList(iUserID,100);
	// return created object or NULL for failure
	return bSuccess;
}

/*********************************************************************************

	CArticleList* CUserPageBuilder::CreateRecentApprovedArticles(CUser* pPageOwner)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		pPageOwner - the xml object representing the page owner, or NULL
					if there isn't one.
	Outputs:	-
	Returns:	Pointer to a CArticleList object created by this method, or NULL if
				it couldn't be created.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CArticleList representing the data for this users most recent
				approved guide entries.

*********************************************************************************/

bool CUserPageBuilder::CreateRecentApprovedArticles(CUser& PageOwner, CArticleList& RecentApprovals)
{
	bool bSuccess = false;
	int iUserID = 0;

	// if we have a page owner and can get their ID then create the most recent
	// article list for them
	bSuccess =	!PageOwner.IsEmpty() &&
				PageOwner.GetUserID(&iUserID) &&
				RecentApprovals.CreateRecentApprovedArticlesList(iUserID,100);
	// return success or failure
	return bSuccess;
}

/*********************************************************************************

	bool CUserPageBuilder::CreateSubscribedToUsersRecentArticles(CUser& PageOwner, int iSiteID, CArticleSubscriptionList& SubscribedUsersArticles)

	Author:		James Conway
	Created:	10/09/2007
	Inputs:		PageOwner - the xml object representing the page owner, or NULL
					if there isn't one.
				iSiteID - SiteID recent articles are to be viewed from.
				SubscribedUsersArticles - SubscribedUsers object to populate
	Outputs:	-
	Returns:	Pointer to CSubscribedUsers object created by this method, or NULL if
				it couldn't be created.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CArticlesSubscriptionList representing the data for this user's most recent
				guide entries written by authors they have subscribed to.

*********************************************************************************/

bool CUserPageBuilder::CreateSubscribedToUsersRecentArticles(CUser& PageOwner, int iSiteID, CArticleSubscriptionList& SubscribedUsersArticles)
{
	bool bSuccess = false;
	int iUserID = 0;

	// if we have a page owner and can get their ID then create the most recent articles by users they have subscribed to.
	bSuccess =	!PageOwner.IsEmpty() &&
				PageOwner.GetUserID(&iUserID) &&
				SubscribedUsersArticles.GetRecentArticles(iUserID, iSiteID);
	
	// return success or failure
	return bSuccess;
}

/*********************************************************************************

	bool CUserPageBuilder::AddClubsUserBelongsTo(CWholePage* pPage,int iUserID)

	Author:		Mark Neves
	Created:	25/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CUserPageBuilder::AddClubsUserBelongsTo(CWholePage* pPage,int iUserID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetAllClubsThatUserBelongsTo(iUserID))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	CTDVString sXML, sClubName, sDateCreated;
	int iClubID = 0;

	sXML << "<USERMYCLUBS>";
	sXML << "<CLUBSSUMMARY>";
	while (!SP.IsEOF())
	{
		
		int iOwner			= SP.GetIntField("Owner");
		int iHidden			= SP.GetIntField("Hidden");


		SP.GetField("Name",sClubName);
		SP.GetField("DateCreated",sDateCreated);
		iClubID = SP.GetIntField("ClubID");

		// if club is hidden, hide if the user is not allowed to see it
		if(iHidden > 0)
		{
			bool bHide = true;

			CUser* pViewingUser	= m_InputContext.GetCurrentUser();
			if (pViewingUser != NULL)
			{
				CClub Club(m_InputContext);
				Club.InitialiseViaClubID(iClubID);

				bHide = !Club.CanUserEditClub(pViewingUser->GetUserID(),iClubID) && !pViewingUser->HasSpecialEditPermissions(Club.GetArticleID());
			}

			if (bHide)
			{
				sClubName = "hidden";
			}
		}

		CTDVDateTime dDateCreated = SP.GetDateField("DateCreated");
		CTDVString sDate;
		dDateCreated.GetAsXML(sDate);

		sXML << "<CLUB ID='" << iClubID << "'>";
		sXML << "<NAME>" << sClubName << "</NAME>";
		sXML << "<MEMBERSHIPSTATUS>";
		if (SP.GetIntField("Owner") == 1)
		{
			sXML << "Owner";
		}
		else
		{
			sXML << "Supporter";
		}
		sXML << "</MEMBERSHIPSTATUS>";
		sXML << "<DATECREATED>" << sDate << "</DATECREATED>";
		sXML << "<MEMBERSHIPCOUNT>" << SP.GetIntField("MembershipCount") << "</MEMBERSHIPCOUNT>";
		sXML << "</CLUB>";
		


		SP.MoveNext();
	}

	sXML << "</CLUBSSUMMARY>";
	sXML << "</USERMYCLUBS>";

	pPage->AddInside("H2G2",sXML);

	return true;
}
/*********************************************************************************

	bool CUserPageBuilder::CreateRecentComments(CUser& PageOwner, CUser* pViewer, CCommentsList& RecentComments)

	Author:		Steven Francis
	Created:	15/06/2007
	Inputs:		pPageOwner - the xml object representing the page owner, or NULL
					if there isn't one.
	Outputs:	-
	Returns:	Pointer to a CCommentList object created by this method, or NULL if
				it couldn't be created.
	Purpose:	Helper method for use by the Build() method. It constructs a
				CCommentList representing the data for this users most recent comments.

*********************************************************************************/

bool CUserPageBuilder::CreateRecentComments(CUser& PageOwner, CUser* pViewer, CCommentsList& RecentComments)
{
	bool bSuccess = false;
	int iUserID = 0;

	// if we have a page owner and can get their ID then create the most recent
	// comment list for them
	bSuccess =	!PageOwner.IsEmpty() &&
				PageOwner.GetUserID(&iUserID) &&
				RecentComments.CreateRecentCommentsList(pViewer, iUserID, 0, 100);
	// return created object or NULL for failure
	return bSuccess;
}
