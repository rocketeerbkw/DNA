// ForumPageBuilder.cpp: implementation of the CForumPageBuilder class.
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
#include "ForumPageBuilder.h"
#include "PageBody.h"
#include "user.h"
#include "Forum.h"
#include "WhosOnlineObject.h"
#include "tdvassert.h"
#include "PageUI.h"
#include "StoredProcedure.h"
#include "EMailAlertList.h"
#include "ThreadSearchPhrase.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CForumPageBuilder::CForumPageBuilder(CInputContext& inputContext)
																			 
	Author:		Oscar Gillespie
	Created:	28/02/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
				curiously similar to the base class
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for our fun forums building utility page

*********************************************************************************/

CForumPageBuilder::CForumPageBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

/*********************************************************************************

	CForumPageBuilder::~CForumPageBuilder()

	Author:		Oscar Gillespie
	Created:	28/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CForumPageBuilder class. Functionality when we start allocating memory

*********************************************************************************/

CForumPageBuilder::~CForumPageBuilder()
{

}

/*********************************************************************************

	CXMLObject* CForumPageBuilder::Build()

	Author:		Jim Lynn
	Created:	29/02/2000
	Modified:	06/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	Makes an Whole Page (the one that's needed to send to the transformer)
				and puts inside it an XML PageBody object which represents the text/XML
				body part of a page.

*********************************************************************************/

bool CForumPageBuilder::Build(CWholePage* pPage)
{
	// We build different results depending on what kind of frame stuff we're doing
	
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	int iForumID = m_InputContext.GetParamInt("ID");
	int iOtherID = m_InputContext.GetParamInt("forum");
	if (iForumID == 0 && iOtherID > 0)
	{
		iForumID = iOtherID;
	}
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	int iPost = m_InputContext.GetParamInt("post");
	int iShowLatest = m_InputContext.GetParamInt("latest");
	CTDVDateTime dDateFrom;
	bool bGotDate = m_InputContext.ParamExists("date");
	if (bGotDate)
	{
		CTDVString sDateParam;
		m_InputContext.GetParamString("date", sDateParam);
		dDateFrom.SetFromString(sDateParam);
	}

	// Do update forum permissions or alert setting if necessary 
	if (m_InputContext.ParamExists("cmd") && pViewingUser != NULL )
	{
		CTDVString cmd;
		m_InputContext.GetParamString("cmd", cmd);
        if (cmd.CompareText("closethread") && iThreadID > 0)
	    {
            CStoredProcedure tSP;
	        m_InputContext.InitialiseStoredProcedureObject(&tSP);
            bool bAuthorise = pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser();
            if ( !bAuthorise && m_InputContext.DoesCurrentSiteHaveSiteOptionSet("Forum","ArticleAuthorCanCloseThreads") )
            {
                tSP.IsUserAuthorForArticle(pViewingUser->GetUserID(),iForumID, bAuthorise);
            }

		    if ( bAuthorise )
            {
		        if ( !tSP.CloseThread(iThreadID,false) )
                    pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CForumPageBuilder::Build","CloseThread","Unable to close thread"));
            }
	    }
        

        if (pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser())
        {
            if (cmd.CompareText("reopenthread") && iThreadID > 0)
	        {
                CStoredProcedure tSP;
	            m_InputContext.InitialiseStoredProcedureObject(&tSP);
          
		        CForum forum(m_InputContext);
		        if ( !forum.UnHideThreadFromUsers(iThreadID, iForumID) )
			        pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CForumPageBuilder::Build","UnHideThread","Unable to open thread"));
	        }
            else if (cmd.CompareText("forumperm"))
		    {
                CStoredProcedure tSP;
	            m_InputContext.InitialiseStoredProcedureObject(&tSP);

			    bool bChangeRead = m_InputContext.ParamExists("read");
			    bool bChangeWrite = m_InputContext.ParamExists("write");
			    bool bChangeThreadRead = m_InputContext.ParamExists("threadread");
			    bool bChangeThreadWrite = m_InputContext.ParamExists("threadwrite");
			    int iRead = m_InputContext.GetParamInt("read");
			    int iWrite = m_InputContext.GetParamInt("write");
			    int iThreadRead = m_InputContext.GetParamInt("threadread");
			    int iThreadWrite = m_InputContext.GetParamInt("threadwrite");
			    tSP.UpdateForumPermissions(iForumID, bChangeRead, iRead, bChangeWrite, iWrite, bChangeThreadRead, iThreadRead, bChangeThreadWrite, iThreadWrite);
		    }
		    else
		    if (cmd.CompareText("UpdateForumModerationStatus"))
		    {
			    if (pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser())
			    {
				    int iNewStatus = m_InputContext.GetParamInt("status");

				    if (!CForum::UpdateForumModerationStatus(m_InputContext,iForumID,iNewStatus))
				    {
					    //m_sErrorXML << "<ERROR TYPE='FORUM-MOD-STATUS-UPDATE'>Failed to update the moderation status of the forum!</ERROR>";
				    }
			    }
		    }
		    else if ( cmd.CompareText("hidethread") && iThreadID > 0 )
		    {
			    if ( pViewingUser->GetIsSuperuser() )
			    {
				    CForum forum(m_InputContext);
				    if ( !forum.HideThreadFromUsers(iThreadID, iForumID) )
					    pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CForumPageBuilder::Build","UnHideThread","Unable to hide thread"));
			    }
		    }
		    else if (cmd.CompareText("AlertInstantly"))
		    {
			    // Get the value from the URL
			    int iAlert = m_InputContext.GetParamInt("AlertInstantly") > 0 ? 1 : 0;
			    if (!CForum::UpdateAlertInstantly(m_InputContext, iAlert, iForumID))
			    {
				    TDVASSERT(false,"Failed to update forum alert instantly status");
			    }
		    }
        }
	}

	
//	int iThreadSkip = m_InputContext.GetParamInt("skipthreads");
//	CTDVString temp;
//	bool bSkipThreadExists = m_InputContext.GetParamString("skipthreads", temp);

	if (iShow < 1)
	{
		iShow = 20;
	}

	CTDVString sFramepart = "";
	bool bType = m_InputContext.GetParamString("type", sFramepart); 

	if (bType)
	{
		if (sFramepart.CompareText("fup"))
		{
			return BuildFrameTop(pPage);
		}
		else if (sFramepart.CompareText("test"))
		{
		}
		else if (sFramepart.CompareText("flft"))
		{
			return BuildFrameSide(pPage);
		}
		else if (sFramepart.CompareText("fsrc"))
		{
			return BuildFrameTitle(pPage);
		}
		else if (sFramepart.CompareText("fth"))
		{
			return BuildFrameThreads(pPage);
		}
		else if (sFramepart.CompareText("fmsg"))
		{
			return BuildFrameMessages(pPage);
		}
//		else if (sFramepart.CompareText("posts"))
//		{
//			return BuildMultiPostsPage(pPage);
//		}
		else if (sFramepart.CompareText("head"))
		{
			return BuildPostHeadersPage(pPage);
		}
		else if (sFramepart.CompareText("fthr"))
		{
			return BuildMoreThreadsFrame(pPage);
		}
		else if (sFramepart.CompareText("bigp"))
		{
			return BuildAllInOnePage(pPage);
		}
		else if (sFramepart.CompareText("subs"))
		{
			return BuildSubscribePage(pPage);
		}
		// No overall else clause - fall through to normal handling
	}
	
	// Make a decision here - do we do frames or not.


	int iSiteID = 0;
	CForum Forum(m_InputContext);
//	Forum.GetForumSiteID(iForumID,iThreadID, iSiteID);
	int type= 0;
	int ID = 0;
	CTDVString sTitle;
	CTDVString sUrl;
	Forum.GetTitle(iForumID, iThreadID, true, &type, &ID, &sTitle, &iSiteID, &sUrl );
	iForumID = Forum.GetForumID();

	// Type 9 forums are comment forums and use redirects
	if (type == 9)
	{
		pPage->Redirect(sUrl);
		return true;
	}

	int oldforumstyle = 0;
	if (m_InputContext.DoesCurrentSkinUseFrames() && pViewingUser != NULL)
	{
		pViewingUser->GetPrefForumStyle(&oldforumstyle);
	}
	
	if (iSiteID > 0)
	{
		CTDVString sURL;
		sURL << "F" << iForumID << "?thread=" << iThreadID;
		if (m_InputContext.ParamExists("skip"))
		{
			sURL << "&skip=" << iSkip << "&show=" << iShow;
		}
		if (m_InputContext.ParamExists("post"))
		{
			sURL << "&post=" << iPost;
		}

		// Check to see if we're needed to change sites or skins?
		if (DoSwitchSites(pPage, sURL, m_InputContext.GetSiteID(), iSiteID, &pViewingUser))
		{
			return true;
		}
	}

	int style = oldforumstyle;
//	if (bSwapSkins)
//	{
		style = 0;
		if (m_InputContext.DoesCurrentSkinUseFrames() && pViewingUser != NULL)
		{
			pViewingUser->GetPrefForumStyle(&style);
		}
//	}
	if (style == 0)
	{
		if (iThreadID == 0)
		{
			return BuildThreadsPage(pPage, Forum, type, ID, sTitle, iSiteID);
		}
		else
		{
			return BuildMultiPostsPage(pPage, Forum, type, ID, sTitle, iSiteID);
		}
	}
	
	// Do frames always until we decide otherwise.
	
	// IF the Thread parameter is 0, fetch a valid number
	
	int iRequestedThreadID = iThreadID;
	if (iThreadID == 0)
	{
		iThreadID = Forum.GetLatestThreadInForum(iForumID);
	}

	// If we got a Post ID, adjust the skip setting so that it always shows the
	// right post
	if (iPost > 0)
	{
		CStoredProcedure SP;
		if (m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			int iPostIndex = SP.GetIndexOfPostInThread(iThreadID, iPost);
			iSkip = iPostIndex / iShow;
			iSkip = iSkip * iShow;
		}
	}
	else if (iShowLatest > 0)
	{
		// show the latest block
		CStoredProcedure SP;
		if (m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			int iPostIndex = SP.GetIndexOfPostInThread(iThreadID, 2147483647) - 1;
			iSkip = iPostIndex / iShow;
			iSkip = iSkip * iShow;
		}
	}
	else if (bGotDate)
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
			int iPostIndex = SP.GetFirstNewPostInThread(iThreadID, dDateFrom);
			iSkip = iPostIndex / iShow;
			iSkip = iSkip * iShow;
	}

//We shoud cope with forums containing no threads
	
//	if (iThreadID == 0)
//	{
//		return NULL;
//	}
	
	InitPage(pPage, "FORUMFRAME",false);
	CTDVString sFrame = "<FORUMFRAME FORUM='";
	sFrame << iForumID 
			<< "' THREAD='" << iThreadID 
			<< "' REQUESTEDTHREAD='" << iRequestedThreadID
			<< "' POST='" << iPost 
			<< "' SHOW='" << iShow 
			<< "' SKIP='" << iSkip;
	
	// If the type is fslr then we're doing the smaller left/right pair containing
	// only the messages and the threads, so we set the SUBSET attribute to TWOSIDES
	if (sFramepart.CompareText("fslr"))
	{
		sFrame << "' SUBSET='TWOSIDES";
	}
	// close the tag
	sFrame << "' />";

	pPage->AddInside("H2G2", sFrame);
	
	// If we have a user, lets check their subscription for the forum
	if (pViewingUser != NULL)
	{
		// Get the users subsciption status for this category
		CEmailAlertList EMailAlert(m_InputContext);
		if (EMailAlert.GetUserEMailAlertSubscriptionForForumAndThreads(pViewingUser->GetUserID(),iForumID))
		{
			pPage->AddInside("H2G2",&EMailAlert);
		}
	}

	return true;
}

bool CForumPageBuilder::BuildFrameTop(CWholePage* pPageXML)
{
	return InitPage(pPageXML, "TOPFRAME",true);
}

bool CForumPageBuilder::BuildFrameSide(CWholePage* pPageXML)
{
	return InitPage(pPageXML, "SIDEFRAME",true);
}

bool CForumPageBuilder::BuildFrameThreads(CWholePage* pPageXML)
{
	int iForumID = m_InputContext.GetParamInt("ID");
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");

	if (iShow < 1)
	{
		iShow = 20;
	}
	
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	CTDVString sCommand;
	bool bGotCommand = m_InputContext.GetParamString("cmd",sCommand);

	CForum Forum(m_InputContext);
	
	bool bSuccess = InitPage(pPageXML, "FRAMETHREADS",true);

	if (bSuccess && bGotCommand && pViewingUser != NULL)
	{
		if (sCommand.CompareText("subscribethread"))
		{
			bSuccess = Forum.SetSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID, true);
			bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		}
		if (sCommand.CompareText("unsubscribethread"))
		{
			bSuccess = Forum.SetSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID, false);
			bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		}
		if (sCommand.CompareText("subscribeforum"))
		{
			bSuccess = Forum.SetSubscriptionState(pViewingUser->GetUserID(), 0, iForumID, true);
			bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		}
		if (sCommand.CompareText("unsubscribeforum"))
		{
			bSuccess = Forum.SetSubscriptionState(pViewingUser->GetUserID(), 0, iForumID, false);
			bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		}
	}
	


	// Create the thread list
	if (bSuccess)
	{
		//get the thread order preference
		int iThreadOrder = m_InputContext.GetThreadOrder();
		bSuccess = Forum.GetThreadList(pViewingUser, iForumID, 25, 0, iThreadID, false, iThreadOrder);
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}

	// Create the list of posts in the thread
	if (bSuccess)
	{
		bSuccess = Forum.GetPostHeadersInThread(pViewingUser, iForumID, iThreadID, iShow, iSkip);
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}

	if (bSuccess && (pViewingUser != NULL))
	{
		bSuccess = Forum.GetThreadSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
	}

	if (bSuccess)
	{
		CWhosOnlineObject Online(m_InputContext);
		bSuccess = bSuccess && Online.Initialise(NULL, 1, true);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Online);
	}
	
	return bSuccess;
}

bool CForumPageBuilder::BuildFrameMessages(CWholePage* pPageXML)
{
	int iForumID = m_InputContext.GetParamInt("ID");
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	if (iShow < 1)
	{
		iShow = 20;
	}
	
	int iPost = m_InputContext.GetParamInt("post");
	
	//used by Film Networks, causes post in thread result to be sorted in desc order
	bool bOrderByDatePostedDesc = false;
	if (1 == m_InputContext.GetParamInt("reverseorder"))
	{
		bOrderByDatePostedDesc = true;
	}


	CForum Forum(m_InputContext);
	
	bool bSuccess = InitPage(pPageXML, "MESSAGEFRAME",true);

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	int iLastPostID = 0;
	bool bReadLastPost = false;
	bool bGotLastPostInfo = false;
	// Create the thread list
	if (bSuccess)
	{
		bSuccess = Forum.GetPostsInThread(pViewingUser, iForumID, iThreadID, iShow, iSkip, iPost, bOrderByDatePostedDesc);
		if ( !bSuccess )
			return false;
		bGotLastPostInfo = Forum.WasLastPostRead(&iLastPostID, &bReadLastPost);
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}

	if (bSuccess && (pViewingUser != NULL))
	{
		bool bThreadSubscribed = false;
		bSuccess = Forum.GetThreadSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID, NULL, &bThreadSubscribed);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		if (bThreadSubscribed && bGotLastPostInfo) 
		{
			Forum.MarkThreadRead(pViewingUser->GetUserID(), iThreadID, iLastPostID);
		}
	}

	bSuccess = bSuccess && Forum.GetTitle(iForumID, iThreadID, true);
	bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);

	if (bSuccess)
	{
		CWhosOnlineObject Online(m_InputContext);
		bSuccess = bSuccess && Online.Initialise(NULL, 1, true);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Online);
	}
	
	return bSuccess;
}

bool CForumPageBuilder::BuildFrameTitle(CWholePage* pPageXML)
{
	int iForumID = m_InputContext.GetParamInt("ID");
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	if (iShow < 1)
	{
		iShow = 20;
	}
	

	CForum Forum(m_InputContext);
	
	bool bSuccess = InitPage(pPageXML, "FRAMESOURCE",false);

	// Create the thread list
	if (bSuccess)
	{
		bSuccess = Forum.GetTitle(iForumID, iThreadID, true);
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}
	
	return bSuccess;
}

bool CForumPageBuilder::BuildThreadsPage(CWholePage* pPageXML, CForum& TitleForum, int iForumType, int iObjectID, CTDVString& sForumTitle, int iSiteID)
{
	// Get the viewing user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	int iForumID = m_InputContext.GetParamInt("id");
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip	= m_InputContext.GetParamInt("skip");
	int iShow	= m_InputContext.GetParamInt("show");
	bool bIncludeArticle = true; //m_InputContext.ParamExists("inc");
	// tells us which thread block to show
	int iThreadBlock = m_InputContext.GetParamInt("showthread");

	if (iShow < 1)
	{
		iShow = 25;
	}

	CForum	Forum(m_InputContext);	// Object to get the forum information
	int iFSiteID;
	if(!Forum.GetForumSiteID(iForumID, iThreadID, iFSiteID))
	{
		return ErrorMessage(pPageXML, "Viewing User","No valid viewing user found");	    
	}

	bool bSuccess = InitPage(pPageXML, "THREADS",true);
	
	int iAllowRobots = m_InputContext.GetCurrentSiteOptionInt("General", "AllowRobots");
	if (iAllowRobots)
	{
		pPageXML->AddInside("H2G2", "<ALLOWROBOTS>1</ALLOWROBOTS>");
	}

	if (bSuccess)
	{
//		CTDVString sXML = "<P>Here are more conversations from the forum</P>";
//
//		bSuccess = pBody->CreatePageFromXMLText(sXML);
//		bSuccess = bSuccess && pPageXML->AddInside("H2G2", pBody);
	}

	// Check to see if the user is an editor
	if (pViewingUser && pViewingUser->GetIsEditor())
	{
		// Check to see if we're hiding or showing threads
		if (m_InputContext.ParamExists("HideThread"))
		{
			// Try to hide the given thread.
			if (!Forum.HideThreadFromUsers(m_InputContext.GetParamInt("HideThread"),iForumID))
			{
				TDVASSERT(false,"BuildThreadsPage - Failed to hide given thread!");
				pPageXML->AddInside("H2G2","<HIDETHREAD>HideThreadFailed</HIDETHREAD>");
			}
			else
			{
				pPageXML->AddInside("H2G2","<HIDETHREAD>HideThreadOK</HIDETHREAD>");
			}
		}
		else if (m_InputContext.ParamExists("UnHideThread"))
		{
			// Try to unhide the given thread.
			if (!Forum.UnHideThreadFromUsers(m_InputContext.GetParamInt("UnHideThread"),iForumID))
			{
				TDVASSERT(false,"BuildThreadsPage - Failed to unhide given thread!");
				pPageXML->AddInside("H2G2","<UNHIDETHREAD>UnHideThreadFailed</UNHIDETHREAD>");
			}
			else
			{
				pPageXML->AddInside("H2G2","<UNHIDETHREAD>UnHideThreadOK</UNHIDETHREAD>");
			}
		}
	}

	// If we have a user, lets check their subscription for the forum
	if (pViewingUser != NULL)
	{
		// Get the users subsciption status for this forum
		CEmailAlertList EMailAlert(m_InputContext);
		if (EMailAlert.GetUserEMailAlertSubscriptionForForumAndThreads(pViewingUser->GetUserID(),iForumID))
		{
			pPageXML->AddInside("H2G2",&EMailAlert);
		}
	}

//	int iForumType=0;
	if (bSuccess)
	{
//		bSuccess = Forum.GetTitle(iForumID, iThreadID, bIncludeArticle, &iForumType);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &TitleForum);
	}

	// Create the thread list
	if (bSuccess)
	{
//		bSuccess = pPageXML->AddInside("H2G2","<FORUMPAGE />");
		int iForumStyle = 0;
		Forum.GetForumStyle(iForumID, iForumStyle);

		if (iForumStyle == 1)
		{
			int iAscendingOrder = 0;
			if (m_InputContext.DoesCurrentSiteHaveSiteOptionSet("Forum", "AscendingGuestbookOrder"))
			{
				iAscendingOrder = 1;
			}
			if (m_InputContext.ParamExists("ascendingorder"))
			{
				iAscendingOrder = m_InputContext.GetParamInt("ascendingorder");
			}
			bSuccess = bSuccess && Forum.GetPostsInForum(pViewingUser, iForumID, iShow, iSkip, iAscendingOrder);
		}
		else
		{
			//get the site id if not already got
			//get the thread order preference
			int iThreadOrder = m_InputContext.GetThreadOrder();
			bSuccess = bSuccess && Forum.GetThreadList(pViewingUser, iForumID, iShow, iSkip, iThreadBlock, false, iThreadOrder);
		}
		
		// Redirect if it's the wrong site
/*
		int iCurrentSiteID = m_InputContext.GetSiteID();
		int iForumSiteID = Forum.GetSiteID();
		CTDVString sURL;
		sURL << "F" << iForumID;
		if (DoSwitchSites(pPageXML, sURL, iCurrentSiteID, iForumSiteID, &pViewingUser))
		{
			return pPageXML;
		}
*/
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
	}

	if (bSuccess && (pViewingUser != NULL))
	{
		bSuccess = Forum.GetThreadSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
	}

	return bSuccess;
}

bool CForumPageBuilder::BuildMultiPostsPage(CWholePage* pPageXML, CForum& TitleForum, int iForumType, int iObjectID, CTDVString& sForumTitle, int iSiteID)
{
	int iForumID = m_InputContext.GetParamInt("ID");
	int iOtherID = m_InputContext.GetParamInt("forum");
	if (iForumID == 0 && iOtherID > 0)
	{
		iForumID = iOtherID;
	}
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	int iPost = m_InputContext.GetParamInt("post");
	int iShowLatest = m_InputContext.GetParamInt("latest");
	bool bGotBookmark = m_InputContext.ParamExists("bookmark");
	int iBookmarkCount = m_InputContext.GetParamInt("bookmark");
	CTDVDateTime dDateFrom;
	bool bGotDate = m_InputContext.ParamExists("date");
	if (bGotDate)
	{
		CTDVString sDateParam;
		m_InputContext.GetParamString("date", sDateParam);
		dDateFrom.SetFromString(sDateParam);
	}

	//used by Film Networks, causes post in thread result to be sorted in desc order
	bool bOrderByDatePostedDesc = false;
	if (1 == m_InputContext.GetParamInt("reverseorder"))
	{
		bOrderByDatePostedDesc = true;
	}

	bool bIncludeArticle = true; //m_InputContext.ParamExists("inc");

	if (iShow < 1)
	{
		iShow = 20;
	}
	
	CForum	Forum(m_InputContext);	// Object to get the forum information
	
	bool bSuccess = InitPage(pPageXML, "MULTIPOSTS",true);

	int iAllowRobots = m_InputContext.GetCurrentSiteOptionInt("General", "AllowRobots");
	if (iAllowRobots)
	{
		pPageXML->AddInside("H2G2", "<ALLOWROBOTS>1</ALLOWROBOTS>");
	}

	// If we got a Post ID, adjust the skip setting so that it always shows the
	// right post
	if (iPost > 0)
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		int iPostIndex = SP.GetIndexOfPostInThread(iThreadID, iPost);
		iSkip = iPostIndex / iShow;
		iSkip = iSkip * iShow;
	}
	else if (iShowLatest > 0)
	{
		// show the latest block
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		int iPostIndex = SP.GetIndexOfPostInThread(iThreadID, 2147483647) - 1;
		iSkip = iPostIndex / iShow;
		iSkip = iSkip * iShow;
	}
	else if (bGotDate)
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
			int iPostIndex = SP.GetFirstNewPostInThread(iThreadID, dDateFrom);
			iSkip = iPostIndex / iShow;
			iSkip = iSkip * iShow;
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	int iLastPostID = 0;
	bool bReadLastPost = false;
	bool bGotLastPostInfo = false;
	// Create the thread list
	if (bSuccess)
	{
		bSuccess = Forum.GetPostsInThread(pViewingUser, iForumID, iThreadID, iShow, iSkip, iPost, bOrderByDatePostedDesc);
		if ( !bSuccess )
			return false;
			
		iForumID = Forum.GetForumID();
		bGotLastPostInfo = Forum.WasLastPostRead(&iLastPostID, &bReadLastPost);
		// Redirect if it's the wrong site
/*
		int iCurrentSiteID = m_InputContext.GetSiteID();
		int iForumSiteID = Forum.GetSiteID();
		CTDVString sURL;
		sURL << "F" << iForumID << "?thread=" << iThreadID;
		if (m_InputContext.ParamExists("skip"))
		{
			sURL << "&skip=" << iSkip << "&show=" << iShow;
		}
		if (m_InputContext.ParamExists("post"))
		{
			sURL << "&post=" << iPost;
		}
		if (DoSwitchSites(pPageXML, sURL, iCurrentSiteID, iForumSiteID, &pViewingUser))
		{
			return pPageXML;
		}
*/
		
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
	}

	if (bSuccess)
	{
		//bSuccess = Forum.GetTitle(iForumID, iThreadID, bIncludeArticle);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &TitleForum);
	}

	if (bSuccess && (pViewingUser != NULL))
	{
		bool bThreadSubscribed = false;
		bSuccess = Forum.GetThreadSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID, NULL, &bThreadSubscribed);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		if (bGotBookmark) 
		{
			bGotLastPostInfo = true;
			iLastPostID = iBookmarkCount;
		}
		if (bThreadSubscribed && bGotLastPostInfo) 
		{
			Forum.MarkThreadRead(pViewingUser->GetUserID(), iThreadID, iLastPostID, bGotBookmark);
		}
	}

	if (bSuccess)
	{
		//get the thread order preference
		int iThreadOrder = m_InputContext.GetThreadOrder();
		bSuccess = Forum.GetThreadList(pViewingUser, iForumID, 25, 0, iThreadID, true, iThreadOrder);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		CWhosOnlineObject Online(m_InputContext);
		bSuccess = bSuccess && Online.Initialise(NULL, iSiteID, true);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Online);
	}
	
	if ( bSuccess && m_InputContext.DoesCurrentSiteHaveSiteOptionSet("General","ThreadKeyPhrases")  )
	{
		pPageXML->AddInside("H2G2","<THREADSEARCHPHRASE/>");
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CThreadSearchPhrase searchphrase(m_InputContext, delimit);
		if ( m_InputContext.ParamExists("phrase") )
		{
			//Add Search Phrase Info 
			CTDVString sPhrases;
			m_InputContext.GetParamString("phrase",sPhrases);
			searchphrase.ParsePhrases(sPhrases);
			pPageXML->AddInside("H2G2/THREADSEARCHPHRASE", searchphrase.GeneratePhraseListXML());
		}

		//Add Phrases associated with this discussion/thread
		if ( searchphrase.GetKeyPhrasesFromThread(iForumID,iThreadID) )
			pPageXML->AddInside("H2G2/THREADSEARCHPHRASE",&searchphrase);

		//Add SiteKey Phrases
		if ( searchphrase.GetSiteKeyPhrasesXML() )
			pPageXML->AddInside("H2G2/THREADSEARCHPHRASE", &searchphrase);
	}

	return bSuccess;
}

bool CForumPageBuilder::BuildPostHeadersPage(CWholePage* pPageXML)
{
	int iForumID = m_InputContext.GetParamInt("ID");
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	if (iShow < 1)
	{
		iShow = 20;
	}
	

	CForum	Forum(m_InputContext);
	
	bool bSuccess = InitPage(pPageXML, "THREADPAGE",true);
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	// Create the thread list
	if (bSuccess)
	{
		bSuccess = Forum.GetPostHeadersInThread(pViewingUser, iForumID, iThreadID, iShow, iSkip);
		bSuccess = pPageXML->AddInside("H2G2","<FORUMPAGE />");
		bSuccess = bSuccess && pPageXML->AddInside("FORUMPAGE", &Forum);
	}

	return bSuccess;
}

bool CForumPageBuilder::BuildMoreThreadsFrame(CWholePage* pPageXML)
{
	int iForumID = m_InputContext.GetParamInt("ID");
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	if (iShow < 1)
	{
		iShow = 20;
	}
	
	CForum Forum(m_InputContext);
	
	bool bSuccess = InitPage(pPageXML, "MORETHREADSFRAME",true);

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	// Create the thread list
	if (bSuccess)
	{
		//get the thread order preference
		int iThreadOrder = m_InputContext.GetThreadOrder();
		bSuccess = Forum.GetThreadList(pViewingUser, iForumID, iShow, iSkip, 0, false, iThreadOrder);
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}

	return bSuccess;
}

bool CForumPageBuilder::BuildSubscribePage(CWholePage* pPageXML)
{
	int iForumID = m_InputContext.GetParamInt("ID");
	int iThreadID = m_InputContext.GetParamInt("thread");
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	int iUserID = 0;
	if (pViewingUser != NULL)
	{
		iUserID = pViewingUser->GetUserID();
	}

	CTDVString sCommand;
	m_InputContext.GetParamString("cmd", sCommand);

	CTDVString sReturnPage;
	bool bGotReturnPage = m_InputContext.ParamExists("return");
	if (bGotReturnPage)
	{
		m_InputContext.GetParamString("return", sReturnPage);
	}
	
	CTDVString pageparam;
	m_InputContext.GetParamString("page", pageparam);
	CTDVString sReturnMessage;
	m_InputContext.GetParamString("desc", sReturnMessage);
	
	CForum Forum(m_InputContext);
	
	bool bSuccess = InitPage(pPageXML, "SUBSCRIBE",true);

	if (sCommand.CompareText("subscribethread"))
	{
		bSuccess = bSuccess && Forum.SetSubscriptionState(iUserID, iThreadID, iForumID, true);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2",&Forum);
	}
	else if (sCommand.CompareText("unsubscribethread"))
	{
		bSuccess = bSuccess && Forum.SetSubscriptionState(iUserID, iThreadID, iForumID, false);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2",&Forum);
	}
	else if (sCommand.CompareText("subscribeforum"))
	{
		bSuccess = bSuccess && Forum.SetSubscriptionState(iUserID, 0, iForumID, true);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2",&Forum);
	}
	else if (sCommand.CompareText("unsubscribeforum"))
	{
		bSuccess = bSuccess && Forum.SetSubscriptionState(iUserID, 0, iForumID, false);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2",&Forum);
	}
	else if (sCommand.CompareText("unsubscribejournal"))
	{
		bSuccess = bSuccess && Forum.SetSubscriptionState(iUserID, iThreadID, iForumID, false, true);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
	}
	
	if (bGotReturnPage)
	{
		if (!pageparam.CompareText("normal"))
		{
			pPageXML->Redirect(sReturnPage);
		}
		else
		{
			CTDVString sReturnTo = "<RETURN-TO>";
			sReturnTo << "<URL>" << sReturnPage << "</URL>";
			sReturnTo << "<DESCRIPTION>" << sReturnMessage << "</DESCRIPTION>";
			sReturnTo << "</RETURN-TO>";
			pPageXML->AddInside("H2G2", sReturnTo);
		}
	}
	
	return true;
}

bool CForumPageBuilder::BuildAllInOnePage(CWholePage* pPageXML)
{
	int iForumID = m_InputContext.GetParamInt("ID");
	int iOtherID = m_InputContext.GetParamInt("forum");
	if (iForumID == 0 && iOtherID > 0)
	{
		iForumID = iOtherID;
	}
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	if (iShow < 1)
	{
		iShow = 20;
	}
	
	int iPost = m_InputContext.GetParamInt("post");
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	CTDVString sCommand;
	bool bGotCommand = m_InputContext.GetParamString("cmd",sCommand);

	//used by Film Networks, causes post in thread result to be sorted in desc order
	bool bOrderByDatePostedDesc = false;
	if (1 == m_InputContext.GetParamInt("reverseorder"))
	{
		bOrderByDatePostedDesc = true;
	}

	CForum Forum(m_InputContext);
	
	bool bSuccess = InitPage(pPageXML, "FRAMETHREADS",true);

	if (bSuccess && bGotCommand && pViewingUser != NULL)
	{
		if (sCommand.CompareText("subscribethread"))
		{
			bSuccess = Forum.SetSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID, true);
			bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		}
		if (sCommand.CompareText("unsubscribethread"))
		{
			bSuccess = Forum.SetSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID, false);
			bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		}
		if (sCommand.CompareText("subscribeforum"))
		{
			bSuccess = Forum.SetSubscriptionState(pViewingUser->GetUserID(), 0, iForumID, true);
			bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		}
		if (sCommand.CompareText("unsubscribeforum"))
		{
			bSuccess = Forum.SetSubscriptionState(pViewingUser->GetUserID(), 0, iForumID, false);
			bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
		}
	}
	
	// Create the thread list
	if (bSuccess)
	{
			//get the thread order preference
		int iThreadOrder = m_InputContext.GetThreadOrder();
		bSuccess = Forum.GetThreadList(pViewingUser, iForumID, 25, 0, iThreadID, 0, iThreadOrder);
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}

	// Create the list of posts in the thread
	if (bSuccess)
	{
		bSuccess = Forum.GetPostHeadersInThread(pViewingUser, iForumID, iThreadID, iShow, iSkip);
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}

	if (bSuccess)
	{
		bSuccess = Forum.GetPostsInThread(pViewingUser, iForumID, iThreadID, iShow, iSkip, iPost, bOrderByDatePostedDesc);
		if ( !bSuccess )
			return false;
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}

	if (bSuccess && (pViewingUser != NULL))
	{
		bSuccess = Forum.GetThreadSubscriptionState(pViewingUser->GetUserID(), iThreadID, iForumID);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Forum);
	}

	if (bSuccess)
	{
		bSuccess = Forum.GetTitle(iForumID, iThreadID);
	}
	if (bSuccess)
	{
		pPageXML->AddInside("H2G2", &Forum);
	}

	return bSuccess;
}

/*********************************************************************************

	bool CForumPageBuilder::UseGuestBookForumStyle(int iForumType)

	Author:		Mark Neves
	Created:	29/09/2003
	Inputs:		iForumType = the type of forum in question
	Outputs:	-
	Returns:	true if this forum type should use Guest Book style forums, false otherwise
	Purpose:	Determines the forum style for the given forum type

				It switches on the ArticleGuestBookForums flag in the current site

*********************************************************************************/

bool CForumPageBuilder::UseGuestBookForumStyle(int iForumType)
{
	if (m_InputContext.DoesSiteUseArticleGuestBookForums(m_InputContext.GetSiteID()))
	{
		// If forum belongs to an article (1) or a club (6),
		// then we should use the guest book style of forums
		if (iForumType == 1 || iForumType == 6)
		{
			return true;
		}
	}

	return false;
}


bool CForumPageBuilder::ErrorMessage(CWholePage* pPageXML, const TDVCHAR* sType, const TDVCHAR* sMsg)
{
	InitPage(pPageXML,"FORUM", true);

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	pPageXML->AddInside("H2G2", sError);

	return true;
}


/*********************************************************************************

	bool CForumPageBuilder::IsRequestHTMLCacheable()

		Author:		Mark Neves
        Created:	15/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if the current request can be cached
        Purpose:	Determines if the HTML for this request can be cached.
					Basically it boils down to "Is this request read-only?".

*********************************************************************************/

bool CForumPageBuilder::IsRequestHTMLCacheable()
{
	if (m_InputContext.ParamExists("cmd") || m_InputContext.ParamExists("type"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	CTDVString CForumPageBuilder::GetRequestHTMLCacheFolderName()

		Author:		Mark Neves
        Created:	15/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Returns the path, under the ripleycache folder, where HTML cache files 
					should be stored for this builder

*********************************************************************************/

CTDVString CForumPageBuilder::GetRequestHTMLCacheFolderName()
{
	return CTDVString("html\\forums");
}

/*********************************************************************************

	CTDVString CForumPageBuilder::GetRequestHTMLCacheFileName()

		Author:		Mark Neves
        Created:	15/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Creates the HTML cache file name that uniquely identifies this request.

*********************************************************************************/

CTDVString CForumPageBuilder::GetRequestHTMLCacheFileName()
{ 
	CTDVString sHash;
	m_InputContext.GetQueryHash(sHash);

	// We add these params to the name to make it human-readable.  The hash alone isn't!
	int iForumID = m_InputContext.GetParamInt("id");
	int iThreadID = m_InputContext.GetParamInt("thread");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");

	CTDVString sCacheName;
	sCacheName << "F-" << iForumID << "-" << iThreadID << "-" << iSkip << "-" << iShow << "-" << sHash << ".html";

	return sCacheName;
}
