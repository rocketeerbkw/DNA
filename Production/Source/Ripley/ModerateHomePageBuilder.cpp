// ModerateHomePageBuilder.cpp: implementation of the CModerateHomePageBuilder class.
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
#include "ModerateHomePageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "modstats.h"
#include ".\moderationclasses.h"
#include "moderateposts.h"
#include "moderatenicknames.h"
#include "moderatorinfo.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CModerateHomePageBuilder::CModerateHomePageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	13/02/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CModerateHomePageBuilder object.

*********************************************************************************/

CModerateHomePageBuilder::CModerateHomePageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pSP(NULL),
	m_pPage(0)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CModerateHomePageBuilder::~CModerateHomePageBuilder()

	Author:		Kim Harries
	Created:	13/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CModerateHomePageBuilder::~CModerateHomePageBuilder()
{
	// make sure SP object is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	CWholePage* CModerateHomePageBuilder::Build()

	Author:		Kim Harries
	Created:	13/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the moderation home page.

*********************************************************************************/

bool CModerateHomePageBuilder::Build(CWholePage* pWholePage)
{
	InitPage(pWholePage, "MODERATE-HOME", true);
	m_pPage = pWholePage;
	int iOwnerID = 0;
	bool bSuccess = true;
	// get the viewing user
	CUser* pViewer = m_InputContext.GetCurrentUser();
	
	// get any user ID parameter
	iOwnerID = m_InputContext.GetParamInt("UserID");
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator() || pViewer->IsUserInGroup("HOST")) )
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or a Moderator.</ERROR>");
	}
	else if (iOwnerID != 0 && pViewer->GetUserID() != iOwnerID && !pViewer->GetIsEditor())
	{
		// only editors can view other peoples moderation home page
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot view someone elses Moderation Home Page unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// if no user ID specified then we wish to see the viewers oown page
		if (iOwnerID == 0)
		{
			iOwnerID = pViewer->GetUserID();
		}
		// try to create the page owner object from this user ID
		// TODO: give a useful error message if this fails
		CUser owner(m_InputContext);
		bSuccess = bSuccess && owner.CreateFromID(iOwnerID);
		// add the owners XML into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<PAGE-OWNER></PAGE-OWNER>");
		bSuccess = bSuccess && pWholePage->AddInside("PAGE-OWNER", &owner);
		// process any form submission
		bSuccess = bSuccess && ProcessSubmission(pViewer, &owner);
		// create the XML for the form
		CTDVString	sFormXML = "";
		bSuccess = bSuccess && CreateForm(pViewer, &sFormXML, &owner);
		// and insert it into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);

		CModerationClasses moderationClasses(m_InputContext);
		moderationClasses.GetModerationClasses();
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", &moderationClasses);
	}
	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CModerateHomePageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CModerateHomePageBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		pViewer
	Outputs:	-
	Returns:	true if successful
	Purpose:	Processes any form submission.

*********************************************************************************/

bool CModerateHomePageBuilder::ProcessSubmission(CUser* pViewer, CUser* pOwner)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CModerateHomePageBuilder::ProcessSubmission(...)");
	// fail if no viewing user
	if (pViewer == NULL)
	{
		return false;
	}
	// get an SP object if we haven't already
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we still have no SP then die like the pigs we are
	if (m_pSP == NULL)
	{
		return false;
	}

	int iFastMod = m_InputContext.GetParamInt("fastmod");
	int iNotFastMod = m_InputContext.GetParamInt("notfastmod");

	CTDVString sRedirect;
	if (iFastMod == 1)
	{
		sRedirect += "fastmod=1&";
	}
	if (iNotFastMod == 1)
	{
		sRedirect += "notfastmod=1";
	}

	// Check to see if we've been given a class mod id
	int iModClassId = m_InputContext.GetParamInt("modclassid");

	bool	bSuccess = true;
	// now find out what the command is
	if (m_InputContext.ParamExists("UnlockForums"))
	{
		bSuccess = bSuccess && m_pSP->UnlockAllForumModerations(pOwner->GetUserID());
		if (m_pPage)
		{
			m_pPage->Redirect("Moderate?" + sRedirect);
		}
	}
	else if (m_InputContext.ParamExists("UnlockForumReferrals"))
	{
		bSuccess = bSuccess && m_pSP->UnlockAllForumReferrals(pOwner->GetUserID());
		if (m_pPage)
		{
			m_pPage->Redirect("Moderate?" + sRedirect);
		}
	}
	else if ( m_InputContext.ParamExists("UnlockUserPosts") )
	{
		//Unlock Posts for moderator
		CModeratePosts moderateposts(m_InputContext);
		bSuccess = bSuccess && moderateposts.UnlockModeratePostsForUser(pOwner->GetUserID(), iModClassId);
	}
	else if ( m_InputContext.ParamExists("UnlockSitePosts") )
	{
		CModeratePosts moderateposts(m_InputContext);
		int iSiteId = m_InputContext.GetParamInt("siteid");
		if ( iSiteId > 0 )
		{
			//Unlock posts for given site - user must be an editor for given site / superuser
			bSuccess = bSuccess && moderateposts.UnlockModeratePostsForSite(pOwner->GetUserID(), iSiteId,pOwner->GetIsSuperuser());
		}
		else
			TDVASSERT(false,"Invalid SiteId");
	}
	else if ( m_InputContext.ParamExists("UnlockAllPosts") )
	{
		//Unlock all posts for all sites user is an editor / superuser.
		CModeratePosts moderateposts(m_InputContext);
		bSuccess = bSuccess && moderateposts.UnlockModeratePosts(pOwner->GetUserID(), pOwner->GetIsSuperuser());
	}
	else if (m_InputContext.ParamExists("UnlockArticles"))
	{
		bSuccess = bSuccess && m_pSP->UnlockAllArticleModerations(pOwner->GetUserID(), pViewer->GetUserID(), iModClassId);
	}
	else if (m_InputContext.ParamExists("UnlockArticleReferrals"))
	{
		bSuccess = bSuccess && m_pSP->UnlockAllArticleReferrals(pOwner->GetUserID(),
			pViewer->GetUserID());
	}
	else if (m_InputContext.ParamExists("UnlockGeneral"))
	{
		bSuccess = bSuccess && m_pSP->UnlockAllGeneralModerations(pOwner->GetUserID());
	}
	else if (m_InputContext.ParamExists("UnlockGeneralReferrals"))
	{
		bSuccess = bSuccess && m_pSP->UnlockAllGeneralReferrals(pOwner->GetUserID());
	}
	else if (m_InputContext.ParamExists("UnlockNicknames"))
	{
		CModerateNickNames modNickName(m_InputContext);
		bSuccess = bSuccess && modNickName.UnlockNickNamesForUser(pOwner->GetUserID(), iModClassId);
	}
	else if (m_InputContext.ParamExists("UnlockAll"))
	{
		bSuccess = m_pSP->UnlockAllForumModerations(pOwner->GetUserID()) && bSuccess;
		bSuccess = m_pSP->UnlockAllArticleModerations(pOwner->GetUserID(),
			pViewer->GetUserID(), 0) && bSuccess;
		bSuccess = m_pSP->UnlockAllGeneralModerations(pOwner->GetUserID()) && bSuccess;
		bSuccess = m_pSP->UnlockAllForumReferrals(pOwner->GetUserID()) && bSuccess;
		bSuccess = m_pSP->UnlockAllArticleReferrals(pOwner->GetUserID(),
			pViewer->GetUserID()) && bSuccess;
		bSuccess = m_pSP->UnlockAllGeneralReferrals(pOwner->GetUserID()) && bSuccess;
		bSuccess = m_pSP->UnlockAllNicknameModerations(pOwner->GetUserID(),0) && bSuccess;
	}
	else
	{
		// else do nothing as there is no recognised command
	}
	return bSuccess;
}

/*********************************************************************************

	bool CModerateHomePageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	13/02/2001
	Inputs:		pViewer
	Outputs:	psFormXML
	Returns:	true if successful
	Purpose:	Constructs the XML for the form containing all the data for the moderationhome page.

*********************************************************************************/

bool CModerateHomePageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML, CUser* pOwner)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CModerateHomePageBuilder::CreateForm(...)");
	TDVASSERT(pViewer != NULL, "NULL pViewer in CModerateHomePageBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL || pViewer == NULL)
	{
		return false;
	}

	// get an SP object if we haven't already
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we still have no SP then die like the pigs we are
	if (m_pSP == NULL)
	{
		return false;
	}

	int		iOwnerID = pOwner->GetUserID();
	bool	bSuccess = true;
	bool bIsReferee;
	bSuccess = bSuccess && m_pSP->IsRefereeForAnySite(pViewer->GetUserID(), bIsReferee);

	//New style fetches fastmod and nonfastmod items.
	int iFastMod = m_InputContext.GetParamInt("fastmod", 0);
	int iNotFastMod = m_InputContext.GetParamInt("notfastmod", 0);

	// now create the form XML
	*psFormXML = "";
	*psFormXML << "<MODERATOR-HOME USER-ID='" << iOwnerID << "' ISREFEREE='" << bIsReferee << "'";
	*psFormXML << " FASTMOD='" << iFastMod << "' NOTFASTMOD='" << iNotFastMod << "'>";

	CModeratorInfo moderatorInfo(m_InputContext);
	moderatorInfo.GetModeratorInfo(iOwnerID);
	CTDVString sModeratorInfo;
	moderatorInfo.GetAsString(sModeratorInfo);
	*psFormXML << sModeratorInfo;

	bSuccess = bSuccess && GetStatsXml(iOwnerID, *psFormXML);
	if (m_InputContext.GetParamInt("newstyle") == 0  && pViewer->GetIsSuperuser())
	{
		bSuccess = bSuccess && GetQueuedModPerSiteXml(iOwnerID, *psFormXML);
	}
	
	*psFormXML << "</MODERATOR-HOME>";
	return bSuccess;
}


/***************************************************
bool CModerateHomePageBuilder::GetStatsXml(int iOwnerId, bool bFastMod, CTDVString& sXml)
Author:	Igor Loboda
Created:	29/07/2005
Purpose:	Appends moderation stats xml to given string for requested fastmod mode
***************************************************/

/*bool CModerateHomePageBuilder::GetStatsXml(int iOwnerId, bool bFastMod, CTDVString& sXml)
{
	CModStats modStats(m_InputContext);
	if (m_InputContext.GetParamInt("newstyle") != 0)
	{
		bool bOk = modStats.Fetch(iOwnerId);
		if (bOk)
		{
			modStats.GetAsXml(sXml);
		}
		else
		{
			sXml << "<ERROR TYPE='NO-DATA'>No moderation statistics could be found</ERROR>";
		}
		
		return bOk;
	}
	else
	{
		bool bOk = modStats.FetchOld(iOwnerId, bFastMod);
		if (bOk)
		{
			modStats.GetAsXmlOld(sXml);
		}
		else
		{
			sXml << "<ERROR TYPE='NO-DATA'>No moderation statistics could be found</ERROR>";
		}
		
		return bOk;
	}
}*/


/***************************************************
bool CModerateHomePageBuilder::GetStatsXml(int iOwnerId, CTDVString& sXml)
Author:	Igor Loboda
Created:	29/07/2005
Purpose:	Appends moderation stats xml to given string for both or either fastmod
			and notfastmod depending on cgi parameters "fastmod" and "notfastmod".
			if "notfastmod" is not present it's treated as notfastmod = 1. If
			"fastmod" is not present it's treated as fastmod = 0 (for backwards
			compatibility)
***************************************************/

bool CModerateHomePageBuilder::GetStatsXml(int iOwnerId, CTDVString& sXml)
{
	bool bOk = true;

	if (m_InputContext.GetParamInt("newstyle") != 0)
	{
		//Fetch New style XML.
		CModStats modStats(m_InputContext);
		bOk = modStats.Fetch(iOwnerId);
		if (bOk)
			modStats.GetAsXml(sXml);
		else
			sXml << "<ERROR TYPE='NO-DATA'>No moderation statistics could be found</ERROR>";
		return bOk;
	}
	else
	{
		//If fastmod specified fetch fastmod queues.
		CModStats modStats(m_InputContext);
		bool bFastMod = m_InputContext.GetParamInt("fastmod") > 0 ? true : false;
		if (bFastMod && bOk )
		{
			bOk = modStats.FetchOld(iOwnerId, true);
			if (bOk)
				modStats.GetAsXmlOld(sXml);
			else
				sXml << "<ERROR TYPE='NO-DATA'>No moderation statistics could be found</ERROR>";
		}

		bool bNotFastMod = true;
		if (m_InputContext.ParamExists("notfastmod"))
		{
			bNotFastMod = m_InputContext.GetParamInt("notfastmod") > 0 ? true : false;
		}

		//If nonfastmod specified fetch non fast mod queues.
		if (bNotFastMod && bOk)
		{
			bOk = modStats.FetchOld(iOwnerId, false);
			if (bOk)
				modStats.GetAsXmlOld(sXml);
			else
				sXml << "<ERROR TYPE='NO-DATA'>No moderation statistics could be found</ERROR>";
		}
	}

	return bOk;
}

bool CModerateHomePageBuilder::GetQueuedModPerSiteXml(int iOwnerId, CTDVString& sXml)
{
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
}

#endif // _ADMIN_VERSION
