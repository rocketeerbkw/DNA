// ArticlePageBuilder.cpp: implementation of the CArticlePageBuilder class.
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
#include "ArticlePageBuilder.h"
#include "GuideEntry.h"
#include "RandomArticle.h"
#include "Forum.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "Club.h"
#include "ReviewForum.h"
#include "User.h"
#include "Category.h"
#include ".\EMailAlertList.h"
#include "polls.h"
#include "link.h"
#include "EMailAlertGroup.h"
#include "MediaAsset.h"
#include "ArticleSearchPhrase.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CArticlePageBuilder::CArticlePageBuilder(CInputContext& inputContext)
	Author:		Kim Harries
	Created:	28/02/2000
	Inputs:		inputContext - input context object.
					but will normally be supplied unless no database access is required.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CArticlePageBuilder object.

*********************************************************************************/

CArticlePageBuilder::CArticlePageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
// no further construction required
}

/*********************************************************************************

	CArticlePageBuilder::~CArticlePageBuilder()
																			 ,
	Author:		Kim Harries
	Created:	28/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CArticlePageBuilder::~CArticlePageBuilder()
{
// no explicit destruction required
}

/*********************************************************************************

	CWholePage* CArticlePageBuilder::Build()

	Author:		Kim Harries, Oscar Gillespie
	Created:	28/02/2000
	Modified:	28/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for the article page.
	Purpose:	Construct an article page from its various constituent parts based
				on the request info available from the input context supplied during
				construction.

*********************************************************************************/

bool CArticlePageBuilder::Build(CWholePage* pPageXML)
{
	CGuideEntry		GuideEntry(m_InputContext); // the real xml object to contain the body of the article
	CForum			Forum(m_InputContext);     // the forum object that sits at the bottom of the article page
	CPageUI			UIXML(m_InputContext); // xml object to contain the UI elements
	CUser*			pViewer = NULL; // the viewing user xml object
	CRandomArticle	Random(m_InputContext);

	CTDVString sArticleName;	// the article name if it is a keyarticle instead
	int ih2g2ID = 0;			// article ID for standard entries
	int iForumID = 0;			// the ID for the forum of this page
	CTDVString sRandomType;		// the type of random article requested

	CMediaAsset oMediaAssets(m_InputContext); //For handling linked media assets
	bool bRemovedAsset = false;

	int iCurrentSiteID = m_InputContext.GetSiteID();

	// get the current viewing user
	pViewer = m_InputContext.GetCurrentUser();

	bool bPageSuccess = false;
	bool bSuccess = true;

	// initialise the page
	bPageSuccess = InitPage(pPageXML,"ARTICLE",false);
	bSuccess = bPageSuccess && UIXML.Initialise(pViewer);

	// now get either an article ID or article name from the URL
	// and use it to create the article xml inside the PageBody object
	if (bSuccess)
	{
		// first check for a random entry request
		if (m_InputContext.GetParamString("Random", sRandomType))
		{
			Random.SetCurrentSite(iCurrentSiteID);
			// create a random entry selection depending on the type specified in the request
			if (sRandomType.CompareText("Edited"))
			{
				bSuccess = bSuccess && Random.CreateRandomEditedEntry();
			}
			else if (sRandomType.CompareText("Recommended"))
			{
				bSuccess = bSuccess && Random.CreateRandomRecommendedEntry();
			}
			else if (sRandomType.CompareText("Normal"))
			{
				bSuccess = bSuccess && Random.CreateRandomNormalEntry();
			}
			else if (sRandomType.CompareText("Any"))
			{
				bSuccess = bSuccess && Random.CreateRandomAnyEntry();
			}
			else
			{
				bSuccess = bSuccess && Random.CreateRandomNormalEntry();
			}
			// now get the h2g2ID for the random article - by setting this variable
			// it will force this article to be loaded instead of any specified in the URL
			ih2g2ID = Random.Geth2g2ID();
		}
		// otherwise check for a named article, if this fails then check for
		// and article ID
		else if (!m_InputContext.GetParamString("name", sArticleName))
		{
			ih2g2ID = m_InputContext.GetParamInt("id");
			// surely no one would be daft enough to type in a negative ID?
			// that would be insane...
			if (ih2g2ID <= 0)
			{
				ih2g2ID = 0;
				bSuccess = false;
			}
		}
		// TODO: could send user to a named key article if they have typed in rubbish?
	}
	if (bSuccess)
	{
		CUser* pViewingUser = m_InputContext.GetCurrentUser();

		// we have got a name or ID, so initialise from whichever we have
		if (ih2g2ID == 0)
		{
			// ID is zero, so must have a name
			// show all associated info on the article
			// TODO: may not want to show article info for named entries
			// => key articles often don't want to show them...
			bSuccess = GuideEntry.Initialise(sArticleName, iCurrentSiteID, pViewingUser, true, true, true, true);
		}
		else
		{
			// we have an ID and we're not afraid to use it
			bSuccess = GuideEntry.Initialise(ih2g2ID, iCurrentSiteID, pViewingUser, true, true, true, true);
		}
	}

	if (HandleRedirect(pPageXML,GuideEntry))
	{
		return true;	// HandleRedirect() will have updated pPageXML
	}

	// check that the article has not been deleted
	bool bArticleDeleted = false;
	if (bSuccess)
	{
		if (GuideEntry.IsDeleted())
		{
			bArticleDeleted = true;
			// delete any page we have created so far and replace it with
			// a simple error page instead
//			delete pPageXML;
//			pPageXML = NULL;
//			pPageXML = CreateSimplePage("Article Deleted", "<GUIDE><BODY>This Guide Entry has been deleted.</BODY></GUIDE>");
//			bSuccess = false;
//			if (pPageXML != NULL)
//			{
//				bPageSuccess = true;
//			}
		}
	}
	
	// If this site doesn't match this article, either swap sites or put up a faulty page
	if (bSuccess)
	{
		int iArticleSite = GuideEntry.GetSiteID();
		CTDVString sURL;
		sURL << "A" << ih2g2ID;
		if (DoSwitchSites(pPageXML, sURL, iCurrentSiteID, iArticleSite, &pViewer))
		{
			return true;
		}
/*
		if (iArticleSite > 0 && iArticleSite != iCurrentSiteID)
		{
			// If they've specified NoAutoSwitch then produce an error of some kind
			if (m_InputContext.GetNoAutoSwitch())
			{
				CTDVString sSiteName;
				m_InputContext.GetNameOfSite(iArticleSite, &sSiteName);
				CTDVString sXML;
				sXML << "<SITECHANGE><SITEID>" << iArticleSite << "</SITEID>";
				sXML << "<SITENAME>" << sSiteName << "</SITENAME>";
				sXML << "<URL>A" << ih2g2ID << "</URL></SITECHANGE>";
				// Some kind of error
				pPageXML->AddInside("H2G2",sXML);
				pPageXML->SetPageType("SITECHANGE");
				return pPageXML;
			}
			else
			{
				m_InputContext.ChangeSite(iArticleSite);
				pViewer = m_InputContext.GetCurrentUser();
			}
		}
*/
	}
	
	// Process any commands passed in
	if (m_InputContext.ParamExists("cmd"))
	{
		CTDVString sCommand;
		m_InputContext.GetParamString("cmd",sCommand);
		if (sCommand.CompareText("UpdateArticleModerationStatus"))
		{
			if (pViewer->GetIsEditor() || pViewer->GetIsSuperuser())
			{
				int iNewStatus = m_InputContext.GetParamInt("status");
				GuideEntry.UpdateArticleModerationStatus(iNewStatus);
			}
		}
		else if(sCommand.CompareText("RemoveLinkedAsset"))
		{
			if(pViewer->HasSpecialEditPermissions(ih2g2ID))
			{
				if(!oMediaAssets.ExternalRemoveLinkedArticleAsset(ih2g2ID))
				{
					TDVASSERT(false, "CArticlePageBuilder::Build() oMediaAssets.ExternalRemoveLinkedArticleAsset() failed");
					bSuccess = false;
				}
				else
				{
					bRemovedAsset = true;
					if(!pPageXML->AddInside("H2G2", &oMediaAssets))
					{
						TDVASSERT(false, "CArticlePageBuilder::Build() pPageXML->AddInside failed");
						bSuccess = false;
					}
				}
			}
		}
	}
	
	// if all okay then add the UI and forum stuff
	if (bSuccess)
	{
		// initialise the UI XML and set the appropriate buttons, then add
		// it inside the H2G2 tag
		CTDVString sEditLink = "/UserEdit";
		bool bEditable = false;
//		if (pViewer != NULL && pViewer->GetUserID() == GuideEntry.GetEditorID())
		if (!bArticleDeleted && pViewer != NULL && GuideEntry.HasEditPermission(pViewer))
		{
			bEditable = true;
			sEditLink << GuideEntry.GetH2G2ID();
		}
		// now set the recommend button for editors and scouts
		CTDVString sRecommendLink = "RecommendEntry?h2g2ID=";
		sRecommendLink << ih2g2ID << "&amp;mode=POPUP";
		bool bRecommendable = false;
		if (GuideEntry.GetStatus() == 3 && pViewer != NULL && (pViewer->GetIsEditor() || pViewer->GetIsScout()))
		{
			bRecommendable = true;
		}
		// if this is a sub editors copy of a recommended entry, and the viewer is
		// the sub editor, then give them a button to say they have finished subbing
		// it and want to return the entry to the editors
		CTDVString sSubbedLink = "SubmitSubbedEntry?h2g2ID=";
		sSubbedLink << ih2g2ID << "&amp;mode=POPUP";
		bool bSubbedLink = false;
		if (pViewer != NULL &&
			(pViewer->GetIsEditor() || pViewer->GetIsSub()) &&
			GuideEntry.CheckIsSubEditor(pViewer))
		{
			bSubbedLink = true;
		}

		CTDVString sDiscussLink = "AddThread?forum=";
		bool bDiscuss = true;

		iForumID = GuideEntry.GetForumID();
		sDiscussLink << iForumID;

		int iThisID = GuideEntry.GetH2G2ID();
		sDiscussLink << "&amp;article=" << iThisID;

		// if no forum then can't dicuss entry
		// TODO: are all articles created with a forum?
		if (bArticleDeleted || iForumID == 0 || pViewer == NULL)
		{
			bDiscuss = false;
		}
		if (UIXML.SetHomeVisibility(true, "/") &&
			UIXML.SetDontPanicVisibility(true, "/DONTPANIC") &&
			UIXML.SetSearchVisibility(true, "/Search") &&
			UIXML.SetDiscussVisibility(bDiscuss, sDiscussLink) &&
			UIXML.SetEditPageVisibility(bEditable, sEditLink) &&
			UIXML.SetRecommendEntryVisibility(bRecommendable, sRecommendLink) &&
			UIXML.SetEntrySubbedVisibility(bSubbedLink, sSubbedLink))
		{
			// if all buttons set correctly then add UI to the page
			bSuccess = pPageXML->AddInside("H2G2", &UIXML);
		}
		else
		{
			bSuccess = false;
		}
		// TODO: do we really want to be failing if we can't set the UI? - Kim
	}

	// BODGE! If the article belongs to 606 and it does not contain a <DYNAMIC-LIST> tag, 
	// we don't want to include the dynamic list XML, because it takes too much CPU!
	bool bIncludeDynamicLists = true;

	CTDVString sSiteName;
	m_InputContext.GetNameOfSite(GuideEntry.GetSiteID(),&sSiteName);
	if (sSiteName.CompareText("606"))
	{
		CTDVString sBodyText;
		GuideEntry.GetBody(sBodyText);

		if (sBodyText.Find("<DYNAMIC-LIST") < 0)
		{
			bIncludeDynamicLists = false;
		}
	}

	if (bSuccess && !bArticleDeleted)
	{
		// attempt to put the forum xml in the page
		iForumID = GuideEntry.GetForumID();
//		bSuccess = Forum.GetMostRecent(iForumID, pViewer);
		//Check that the ForumID is not 0 entry might not exist but no need to ASSERT
		if (iForumID > 0)
		{
			int iForumStyle = 0;
			Forum.GetForumStyle(iForumID, iForumStyle);

			if (iForumStyle == 1)
			{
				bSuccess = Forum.GetPostsInForum(pViewer,iForumID,10,0);
				bSuccess = bSuccess && pPageXML->AddInside("H2G2", "<ARTICLEFORUM/>");
				bSuccess = bSuccess && pPageXML->AddInside("ARTICLEFORUM", &Forum);
			}
			else
			{
				bSuccess = Forum.GetMostRecent(iForumID, pViewer);
				bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
			}
		}
	}
	// if all still well then add the article xml inside the H2G2 tag
	if (bSuccess)
	{
		if (bArticleDeleted)
		{
			CTDVString sXML = "<ARTICLE><ARTICLEINFO><STATUS TYPE='7'>Cancelled</STATUS>";
			sXML << "<H2G2ID>" << GuideEntry.GetH2G2ID() << "</H2G2ID>";
			sXML << "</ARTICLEINFO><SUBJECT>Article Deleted</SUBJECT>";
			sXML << "<GUIDE><BODY>This Guide Entry has been deleted.</BODY></GUIDE>";
			sXML << "</ARTICLE>";
			bSuccess = pPageXML->AddInside("H2G2", sXML);
		}
		else
		{
			//set the guide entry data
			// try and clip the page
			if (m_InputContext.ParamExists("clip"))
			{
				CTDVString sSubject;
				GuideEntry.GetSubject(sSubject);
				bool bPrivate = m_InputContext.GetParamInt("private") > 0;
				
				CLink Link(m_InputContext);
				if ( Link.ClipPageToUserPage("article", GuideEntry.GetH2G2ID(), sSubject, NULL, pViewer, bPrivate ) )
					pPageXML->AddInside("H2G2", &Link);
			}

		
			bSuccess = pPageXML->AddInside("H2G2", &GuideEntry);
	
		}
	}

	// If we have a user, lets check their subscription for the article and it's forum
	if (pViewer != NULL && ih2g2ID != 0)
	{
		// Get the users subsciption status for this forum
		CEmailAlertList EMailAlert(m_InputContext);
		if (EMailAlert.GetUserEMailAlertSubscriptionForArticleAndForum(pViewer->GetUserID(),ih2g2ID))
		{
			pPageXML->AddInside("H2G2",&EMailAlert);
		}
	}

	// State whether user has any group alerts on this article
	if(pViewer != NULL)
	{
		CEMailAlertGroup EMailAlertGroup(m_InputContext);
		int iGroupID = 0;

		if(!EMailAlertGroup.HasGroupAlertOnItem(iGroupID, pViewer->GetUserID(), m_InputContext.GetSiteID(), CEmailAlertList::IT_H2G2, ih2g2ID))
		{
			TDVASSERT(false, "CArticlePageBuilder::Build() EMailAlertGroup.HasGroupAlert failed");
		}
		else if(iGroupID != 0)
		{
			// Put XML
			CTDVString sGAXml;
			sGAXml << "<GROUPALERTID>" << iGroupID << "</GROUPALERTID>";
			
			if(!pPageXML->AddInside("H2G2", sGAXml))
			{
				TDVASSERT(false, "CArticlePageBuilder::Build() m_pPage->AddInside failed");
			}	
		}
	}

	// Create POLL-LIST xml
	CPolls polls(m_InputContext);
	if(!polls.MakePollList(ih2g2ID, CPoll::ITEMTYPE_ARTICLE))
	{
		TDVASSERT(false, "CArticlePageBuilder::Build() polls.MakePollList failed");
		bSuccess = false;
	}
	else
	{
		// Add it to page
		if(!pPageXML->AddInside("H2G2",&polls))
		{
			TDVASSERT(false, "CArticlePageBuilder::Build() pPageXML->AddInside failed");
			bSuccess = false;
		}
	}

	// Create and add club list xml (all clubs that this article links to)
	CLink clublinks(m_InputContext);
	if(!clublinks.GetClubsArticleLinksTo(ih2g2ID))
	{
		TDVASSERT(false, "CArticlePageBuilder::Build() clublinks.GetClubsArticleLinksTo() failed");
		bSuccess = false;
	}
	else
	{
		if(!pPageXML->AddInside("H2G2", &clublinks))
		{
			TDVASSERT(false, "CArticlePageBuilder::Build() pPageXML->AddInside failed");
			bSuccess = false;
		}
	}

	if (bIncludeDynamicLists)
	{
		// Create and add <dynamic-lists> to page
		CTDVString sDyanmicListsXml;
		if(!m_InputContext.GetDynamicLists(sDyanmicListsXml, m_InputContext.GetSiteID()))
		{
			TDVASSERT(false, "CArticlePageBuilder::Build() m_InputContext.GetDynamicLists failed");
			bSuccess = false;
		}
		else
		{
			if(!pPageXML->AddInside("H2G2", sDyanmicListsXml))
			{
				TDVASSERT(false, "CArticlePageBuilder::Build() pPageXML->AddInside failed");
				bSuccess = false;
			}
		}
	}

	/****************************************************************************
	 New for Article Key Phrases adds in the Key phrase xml
	****************************************************************************/
	if ( bSuccess && m_InputContext.DoesCurrentSiteHaveSiteOptionSet("General","ArticleKeyPhrases") )
	{
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CArticleSearchPhrase oArticleKeyPhrases(m_InputContext,delimit);

		// Fetch and add media asset xml
		if(!oArticleKeyPhrases.GetKeyPhrasesFromArticle(ih2g2ID))
		{
			TDVASSERT(false, "CArticlePageBuilder::Build() oArticleKeyPhrases.GetKeyPhrasesFromArticle() failed");
			bSuccess = false;
		}
		else
		{
			if(!pPageXML->AddInside("H2G2", &oArticleKeyPhrases))
			{
				TDVASSERT(false, "CArticlePageBuilder::Build() oArticleKeyPhrases pPageXML->AddInside failed");
				bSuccess = false;
			}
		}
	}
	/****************************************************************************/

	/****************************************************************************
	 New for Media Assets
	****************************************************************************/
	if (!bRemovedAsset)
	{
		// Create and add media asset xml
		if(!oMediaAssets.ExternalGetLinkedArticleAsset(ih2g2ID, m_InputContext.GetSiteID()))
		{
			TDVASSERT(false, "CArticlePageBuilder::Build() oMediaAssets.ExternalGetLinkedArticleAsset() failed");
			bSuccess = false;
		}
		else
		{
			if(!pPageXML->AddInside("H2G2", &oMediaAssets))
			{
				TDVASSERT(false, "CArticlePageBuilder::Build() pPageXML->AddInside failed");
				bSuccess = false;
			}
		}
	}
	/****************************************************************************/

	// no longer need the Guide Entry and UI xml objects
	// if everything worked, or we at least produced some page then return
	// the page that was built
	if (bSuccess || bPageSuccess)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CArticlePageBuilder::HandleRedirect(CWholePage* pPageXML)

	Author:		Mark Neves
	Created:	03/09/2003
	Inputs:		pPageXML
	Outputs:	pPageXML is updated with redirect XML if necessary
	Returns:	-
	Purpose:	Tests to see if this article should be redirected to its high-level owner
				e.g. Club, review forum, etc.

*********************************************************************************/

bool CArticlePageBuilder::HandleRedirect(CWholePage* pPageXML,CGuideEntry& GuideEntry)
{
	if (pPageXML == NULL)
	{
		return false;
	}

	bool bRedirected = false;

	CTDVString sRedirectTo;
	if (GuideEntry.IsTypeOfClub())
	{
		CClub Club(m_InputContext);
		if (Club.InitialiseViaH2G2ID(GuideEntry.GetH2G2ID()))
		{
			sRedirectTo << "G" << Club.GetClubID();
		}
	}

	if (GuideEntry.IsTypeOfReviewForum())
	{
		CReviewForum ReviewForum(m_InputContext);
		if (ReviewForum.InitialiseViaH2G2ID(GuideEntry.GetH2G2ID()))
		{
			sRedirectTo << "RF" << ReviewForum.GetReviewForumID();
		}
	}

	if (GuideEntry.IsTypeOfUserPage())
	{
		CUser User(m_InputContext);
		if (User.CreateFromH2G2ID(GuideEntry.GetH2G2ID(), m_InputContext.GetSiteID()))
		{
			sRedirectTo << "U" << User.GetUserID();
		}
	}

	if (GuideEntry.IsTypeOfCategoryPage())
	{
		CCategory Category(m_InputContext);
		if (Category.InitialiseViaH2G2ID(GuideEntry.GetH2G2ID()))
		{
			sRedirectTo << "C" << Category.GetNodeID();
		}
	}

	if (!sRedirectTo.IsEmpty())
	{
		bRedirected = pPageXML->Redirect(sRedirectTo);
	}

	return bRedirected;
}


/********************************************************************************

	bool CArticlePageBuilder::IsRequestHTMLCacheable()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if the current request can be cached
        Purpose:	Determines if the HTML for this request can be cached.
					Basically it boils down to "Is this request read-only?".

*********************************************************************************/

bool CArticlePageBuilder::IsRequestHTMLCacheable()
{
	if (m_InputContext.ParamExists("cmd"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	CTDVString CArticlePageBuilder::GetRequestHTMLCacheFolderName()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Returns the path, under the ripleycache folder, where HTML cache files 
					should be stored for this builder

*********************************************************************************/

CTDVString CArticlePageBuilder::GetRequestHTMLCacheFolderName()
{
	return CTDVString("html\\articles");
}

/*********************************************************************************

	CTDVString CArticlePageBuilder::GetRequestHTMLCacheFileName()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Creates the HTML cache file name that uniquely identifies this request.

*********************************************************************************/

CTDVString CArticlePageBuilder::GetRequestHTMLCacheFileName()
{ 
	CTDVString sHash;
	m_InputContext.GetQueryHash(sHash);

	// We add these params to the name to make it human-readable.  The hash alone isn't!
	int ih2g2ID = m_InputContext.GetParamInt("id");

	CTDVString sCacheName;
	sCacheName << "A-" << m_InputContext.GetNameOfCurrentSite() << "-" << ih2g2ID << "-" << sHash << ".html";

	return sCacheName;
}
