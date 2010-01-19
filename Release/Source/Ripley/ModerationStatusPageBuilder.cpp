// ModerationStatusPageBuilder.cpp: implementation of the CModerationStatusPageBuilder class.
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
#include "ModerationStatusPageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include <map>

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CModerationStatusPageBuilder::CModerationStatusPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	07/03/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CModerationStatusPageBuilder object.

*********************************************************************************/

CModerationStatusPageBuilder::CModerationStatusPageBuilder(CInputContext& inputContext) 
:
CXMLBuilder(inputContext),
m_sTimePeriod("year")
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CModerationStatusPageBuilder::~CModerationStatusPageBuilder()

	Author:		Kim Harries
	Created:	07/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CModerationStatusPageBuilder::~CModerationStatusPageBuilder()
{
}

/*********************************************************************************

	CWholePage* CModerationStatusPageBuilder::Build()

	Author:		Kim Harries
	Created:	07/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the moderation status page.

*********************************************************************************/

bool CModerationStatusPageBuilder::Build(CWholePage* pWholePage)
{
	InitPage(pWholePage, "MODERATE-STATS", true);
	bool bSuccess = true;

	// get the viewing user
	CUser* pViewer = m_InputContext.GetCurrentUser();
	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// get any request parameters
		if (!m_InputContext.GetParamString("TimePeriod", m_sTimePeriod))
		{
			m_sTimePeriod = "year";
		}
		// process any form submission
		bSuccess = bSuccess && ProcessSubmission(pViewer);
		// create the XML for the form
		CTDVString	sFormXML = "";
		bSuccess = bSuccess && CreateForm(pViewer, &sFormXML);
		// and insert it into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);
	}
	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CModerationStatusPageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CModerationStatusPageBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	07/03/2001
	Inputs:		pViewer
	Outputs:	-
	Returns:	true if successful
	Purpose:	Processes any form submission.

*********************************************************************************/

bool CModerationStatusPageBuilder::ProcessSubmission(CUser* pViewer)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CModerationStatusPageBuilder::ProcessSubmission(...)");
	// fail if no viewing user
	if (pViewer == NULL)
	{
		return false;
	}

	bool bSuccess = true;

	int iUserID = m_InputContext.GetParamInt("UserID");
	if (iUserID > 0 && m_InputContext.ParamExists("Unlock"))
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);

		bSuccess = bSuccess && SP.UnlockAllForumModerations(iUserID);
		bSuccess = bSuccess && SP.UnlockAllArticleModerations(iUserID,
			pViewer->GetUserID(), 0);
		bSuccess = bSuccess && SP.UnlockAllGeneralModerations(iUserID);
		bSuccess = bSuccess && SP.UnlockAllForumReferrals(iUserID);
		bSuccess = bSuccess && SP.UnlockAllArticleReferrals(iUserID,
			pViewer->GetUserID());
		bSuccess = bSuccess && SP.UnlockAllGeneralReferrals(iUserID);
		bSuccess = bSuccess && SP.UnlockAllNicknameModerations(iUserID,0);
	}

	return bSuccess;
}

/*********************************************************************************

	bool CModerationStatusPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	07/03/2001
	Inputs:		pViewer
	Outputs:	psFormXML
	Returns:	true if successful
	Purpose:	Constructs the XML for the form containing all the data for the
				moderation status page.

*********************************************************************************/

bool CModerationStatusPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CModerationStatusPageBuilder::CreateForm(...)");
	TDVASSERT(pViewer != NULL, "NULL pViewer in CModerationStatusPageBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL || pViewer == NULL)
	{
		return false;
	}

	CTDVString		sUserName;
	int				iUserID = 0;
	int				iIsOnline = 0;
	int				iMinutesIdle = 0;
	CTDVDateTime	dtDateStarted;
	CTDVDateTime	dtDateLastLogged;
	CTDVDateTime	dtDateClosed;
	CTDVString		sTemp;
	bool			bSuccess = true;

	int				iTotalEntries = 0;
	int				iTotalPosts = 0;
	int				iTotalNicknames = 0;
	int				iTotalGeneral = 0;

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CStoredProcedure SP2;
	m_InputContext.InitialiseStoredProcedureObject(&SP2);

	// now create the form XML
	*psFormXML = "<MODERATION-STATS>";
	// fetch the stats on all the locked and referred items
	bSuccess = bSuccess && SP.FetchLockedItemsStats();
	// whilst we still have data stick it in the form XML
	while (bSuccess && !SP.IsEOF())
	{
		iUserID = SP.GetIntField("UserID");
		SP.GetField("UserName", sUserName);
		iTotalEntries = SP.GetIntField("TotalEntries");
		iTotalPosts = SP.GetIntField("TotalPosts");
		iTotalNicknames = SP.GetIntField("TotalNicknames");
		iTotalGeneral = SP.GetIntField("TotalGeneral");
		*psFormXML << "<USER>";
		*psFormXML << "<USERID>" << iUserID << "</USERID>";
		*psFormXML << "<USERNAME>" << sUserName << "</USERNAME>";
		*psFormXML << "<TOTAL-ENTRIES>" << iTotalEntries << "</TOTAL-ENTRIES>";
		*psFormXML << "<TOTAL-POSTS>" << iTotalPosts << "</TOTAL-POSTS>";
		*psFormXML << "<TOTAL-NICKNAMES>" << iTotalNicknames << "</TOTAL-NICKNAMES>";
		*psFormXML << "<TOTAL-GENERAL>" << iTotalGeneral << "</TOTAL-GENERAL>";
		// also get session info for each user
		*psFormXML << "<SESSION>";
		if (SP2.FetchUsersLastSession(iUserID))
		{
			// check we have some data => possible user may never have logged on!
			if (!SP2.IsEOF())
			{
				iIsOnline = SP2.GetIntField("Online");
				iMinutesIdle = SP2.GetIntField("MinutesIdle");
				dtDateStarted = SP2.GetDateField("DateStarted");
				dtDateLastLogged = SP2.GetDateField("DateLastLogged");
				dtDateClosed = SP2.GetDateField("DateClosed");
				*psFormXML << "<ONLINE>" << iIsOnline << "</ONLINE>";
				*psFormXML << "<MINUTES-IDLE>" << iMinutesIdle << "</MINUTES-IDLE>";
				dtDateStarted.GetAsXML(sTemp);
				*psFormXML << "<STARTED>" << sTemp << "</STARTED>";
				dtDateLastLogged.GetAsXML(sTemp);
				*psFormXML << "<LAST-LOGGED>" << sTemp << "</LAST-LOGGED>";
				dtDateClosed.GetAsXML(sTemp);
				*psFormXML << "<CLOSED>" << sTemp << "</CLOSED>";
			}
		}
		*psFormXML << "</SESSION>";
		*psFormXML << "</USER>";
		SP.MoveNext();
	}
	*psFormXML << "</MODERATION-STATS>";
	return bSuccess;
}

#endif // _ADMIN_VERSION
