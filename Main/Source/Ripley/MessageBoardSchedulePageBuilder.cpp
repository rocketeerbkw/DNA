//MessageBoardSchedulePageBuilder.cpp: implementation of the CMessageBoardSchedulePageBuilder class.
//

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
#include "MessageBoardSchedulePageBuilder.h"
#include "ForumSchedule.h"
#include "Link.h"
#include "TDVASSERT.h"


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMessageBoardSchedulePageBuilder::CMessageBoardSchedulePageBuilder(CInputContext& inputContext)
: m_pViewingUser(NULL), m_pPage(NULL), CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CMessageBoardSchedulePageBuilder::~CMessageBoardSchedulePageBuilder()
{
}

/*********************************************************************************

	CWholePage* CMessageBoardSchedulePageBuilder::Build()

		Author:		James Conway
        Created:	29/03/2006
        Inputs:		-
        Outputs:	-
        Returns:	WholePage object pointer
        Purpose:	Initialises the page object and instantiates a SiteOpenCloseSchedule
					object passing it to ProcessParams() to do the work.
					The SiteOpenCloseSchedule object XML data is added inside the builder page

*********************************************************************************/
bool CMessageBoardSchedulePageBuilder::Build(CWholePage* pPage)
{
	// Initialise the page object
	m_pPage = pPage;
	if (!InitPage(m_pPage, "MESSAGEBOARDSCHEDULE", true))
	{
		// assert the problem for debugging
		TDVASSERT(false,"CMessageBoardSchedulePageBuilder - Failed to create Whole Page object!");

		// now handle the error
		SetDNALastError("CMessageBoardSchedulePageBuilder::Build", "FailedToInitialisePage", "Failed to initialise the page object");
		return m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	// Handle the user
	m_pViewingUser = m_InputContext.GetCurrentUser();
	if (m_pViewingUser == NULL || !m_pViewingUser->GetIsEditor())
	{
		//handle the error -we don't want to assert here as this is not a functional error
		SetDNALastError("CMessageBoardSchedulePageBuilder::Build", "UserNotLoggedInOrAuthorised", "User not logged in or not authorised");
		return m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	// Add all the options for this site
	bool bParamSiteIDPassedIn = true; 
	int iProcessingSiteID = m_InputContext.GetParamInt("siteid"); 
	if (iProcessingSiteID == 0)
	{
		bParamSiteIDPassedIn = false; 
		iProcessingSiteID = m_InputContext.GetSiteID(); 
	}

	// Add list of sites the viewing user is an editor of
	CTDVString sXML;
	sXML.Empty();
	int iFirstSiteID; // default to the first site user is editor of if no SiteID passed in. 
	bool bHasEditPermission = m_pViewingUser->GetSitesUserIsEditorOfXMLWithEditPermissionCheck(m_pViewingUser->GetUserID(), sXML, iFirstSiteID, iProcessingSiteID);
	m_pPage->AddInside("H2G2",sXML);		

	if (!bHasEditPermission)
	{
		//handle the error -we don't want to assert here as this is not a functional error
		SetDNALastError("CMessageBoardSchedulePageBuilder::Build", "UserNotLoggedInOrAuthorised", "User not logged in or not authorised for the site they are trying to update.");
		m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}


	// Insert the Schedule TAG
	bool bPageOk = m_pPage->AddInside("H2G2", "<SITETOPICSSCHEDULE/>");

	if (bHasEditPermission)
	{
		// Setup and process the URL params
		CSiteOpenCloseSchedule SiteOpenCloseSchedule(m_InputContext);
		bPageOk = bPageOk && ProcessParams(iProcessingSiteID,SiteOpenCloseSchedule);

		// insert schedule objects into the page
		if (!SiteOpenCloseSchedule.IsEmpty())
		{
			bPageOk = bPageOk && m_pPage->AddInside("SITETOPICSSCHEDULE", &SiteOpenCloseSchedule);
		}
	}
	
	// Add processing sites information - i.e. the site that is being changed. 
	sXML.Empty();
	sXML << "<PROCESSINGSITE>"; 
	sXML << m_InputContext.GetSiteAsXML(iProcessingSiteID, 1);
	sXML << "</PROCESSINGSITE>"; 
	m_pPage->AddInside("H2G2",sXML);

	// insert site's Closed flag.
	if (bPageOk && bHasEditPermission)
	{
		bool bSiteClosed = false;
		if (!m_InputContext.IsSiteEmergencyClosed(iProcessingSiteID,bSiteClosed))
		{
			//handle the error -we don't want to assert here as this is not a functional error
			SetDNALastError("CMessageBoardSchedulePageBuilder::Build", "FailedToGetSiteDetails", "Failed to get site details");
			return m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		}

		CTDVString sXMLTopicClosed;
		sXMLTopicClosed << "<SITETOPICSEMERGENCYCLOSED>" << bSiteClosed << "</SITETOPICSEMERGENCYCLOSED>";
		bPageOk = bPageOk && m_pPage->AddInside("SITETOPICSSCHEDULE", sXMLTopicClosed);
	}

	TDVASSERT(bPageOk, "CMessageBoardSchedulePageBuilder::Build() page failed");
	return bPageOk;
}

/*********************************************************************************

	bool CMessageBoardSchedulePageBuilder::ProcessParams(int iSiteID, CSiteOpenCloseSchedule& SiteOpenCloseSchedule)

		Author:		James Conway
        Created:	29/03/2006
        Inputs:		iSiteID - the site that you want to change the schedule for.
					SiteOpenCloseSchedule object by reference
        Outputs:	-
        Returns:	success boolean
        Purpose:	If viewing user, check if action is 'update', 'display' or 'setactive', 
					'setinactive'. Calls appropriate functionality of SiteOpenCloseSchedule object.
					If no expected 'action' value is available an error is thrown.

*********************************************************************************/
bool CMessageBoardSchedulePageBuilder::ProcessParams(int iSiteID, CSiteOpenCloseSchedule& SiteOpenCloseSchedule)
{
	bool bPageOk = true;

	CTDVString sAction;
	m_InputContext.GetParamString("action", sAction);

	if (sAction.IsEmpty() || sAction.CompareText("display"))
	{
		bPageOk = bPageOk && m_pPage->AddInside("SITETOPICSSCHEDULE", "<SCHEDULING-REQUEST>DISPLAY</SCHEDULING-REQUEST>");

		// Get the schedule of Sites open/close times.
		bPageOk = bPageOk && SiteOpenCloseSchedule.GetSiteOpenCloseSchedule(iSiteID);
	}
	else if (sAction.CompareText("update"))
	{
		if (UpdateSchedule(iSiteID, SiteOpenCloseSchedule))
		{
			// Refresh site data. Signal also reaches local
			// server, but only if local ip is in config file, and I
			// don't like relying on config file. So update data anyway. 
			m_InputContext.SiteDataUpdated();
			if (!m_InputContext.Signal("/Signal?action=recache-site"))
			{
				TDVASSERT(false, "Failed to signal recache site");
			}
		}

		// Put in the request XML and return the current site schedules
		if (bPageOk)
		{
			bPageOk = bPageOk && m_pPage->AddInside("SITETOPICSSCHEDULE", "<SCHEDULING-REQUEST>CREATE</SCHEDULING-REQUEST>");
		}

		bPageOk = bPageOk && SiteOpenCloseSchedule.GetSiteOpenCloseSchedule(iSiteID);
	}
	else if (sAction.CompareText("setsitetopicsactive") || sAction.CompareText("OpenSite")) 
	{
		int iConfirm = 0;
		if (m_InputContext.ParamExists("confirm"))
		{
			iConfirm = m_InputContext.GetParamInt("confirm");
		}

		CTDVString sSchedRequest;
		if (iConfirm == 1)
		{
			sSchedRequest << "CONFIRMED";
			bPageOk = bPageOk && UpdateSiteClosed(iSiteID, false);
		}

		if (bPageOk && !SiteOpenCloseSchedule.GetSiteOpenCloseSchedule(iSiteID))
		{
			// insert the last error
			bPageOk = m_pPage->AddInside("H2G2", SiteOpenCloseSchedule.GetLastErrorAsXMLString());
		}

		if (bPageOk)
		{
			CTDVString sXML;
			sXML << "<SCHEDULING-REQUEST>" << sSchedRequest << sAction << "</SCHEDULING-REQUEST>";
			sXML.MakeUpper();
			bPageOk = bPageOk && m_pPage->AddInside("SITETOPICSSCHEDULE", sXML);
		}
	}	
	else if (sAction.CompareText("setsitetopicsinactive") || sAction.CompareText("CloseSite"))
	{		
		int iConfirm = 0;
		if (m_InputContext.ParamExists("confirm"))
		{
			iConfirm = m_InputContext.GetParamInt("confirm");
		}

		CTDVString sSchedRequest;
		if (iConfirm == 1)
		{
			sSchedRequest << "CONFIRMED";
			bPageOk = bPageOk && UpdateSiteClosed(iSiteID,true);
		}

		if (bPageOk && !SiteOpenCloseSchedule.GetSiteOpenCloseSchedule(iSiteID))
		{
			// insert the last error
			bPageOk = m_pPage->AddInside("H2G2", SiteOpenCloseSchedule.GetLastErrorAsXMLString());
		}

		if (bPageOk)
		{
			CTDVString sXML;
			sXML << "<SCHEDULING-REQUEST>" << sSchedRequest << sAction << "</SCHEDULING-REQUEST>";
			sXML.MakeUpper();
			bPageOk = bPageOk && m_pPage->AddInside("SITETOPICSSCHEDULE", sXML);
		}
	}
	else
	{
		TDVASSERT(false,"CMessageBoardSchedulePageBuilder - Unsupported action param value passed!");

		// now handle the error
		SetDNALastError("CMessageBoardSchedulePageBuilder::ProcessParams", "UnknownAction", "Unknown action given");
		bPageOk = bPageOk && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	return bPageOk;
}

/*********************************************************************************

	bool CMessageBoardSchedulePageBuilder::UpdateSiteClosed(int iSiteID, bool bCloseSite)

		Author:		James Conway
		Created:	20/07/2006
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	-

*********************************************************************************/
bool CMessageBoardSchedulePageBuilder::UpdateSiteClosed(int iSiteID, bool bCloseSite)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		SetDNALastError("CMessageBoardSchedulePageBuilder::UpdateSiteicsClosed", "FailedToInitialiseSP", "Failed to initialise stored procedure");
		return m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}
	
	// Update Site's Closed on db.
	if (!SP.UpdateSiteClosed(iSiteID, bCloseSite))
	{
		SetDNALastError("CMessageBoardSchedulePageBuilder::UpdateSiteClosed", "FailedToUpdateForumActivestatus", "Failed to update forum active status");
		return m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	// change cgi object's Closed status flag.
	if (!m_InputContext.SetSiteIsEmergencyClosed(iSiteID,bCloseSite))
	{
		SetDNALastError("CMessageBoardSchedulePageBuilder::UpdateSiteClosed", "FailedToUpdateSiteEmergencyClosedStatus", "Failed to update site emergency closed status");
		return m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	// Refresh site data. Signal also reaches local
	// server, but only if local ip is in config file, and I
	// don't like relying on config file. So update data anyway. 
	m_InputContext.SiteDataUpdated();
	if (!m_InputContext.Signal("/Signal?action=recache-site"))
	{
		TDVASSERT(false, "Failed to signal recache site");
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardSchedulePageBuilder::UpdateSchedule(int iSiteID, CSiteOpenCloseSchedule& SiteOpenCloseSchedule)

		Author:		James Conway
		Created:	20/07/2006
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	-

*********************************************************************************/
bool CMessageBoardSchedulePageBuilder::UpdateSchedule(int iSiteID, CSiteOpenCloseSchedule& SiteOpenCloseSchedule)
{
	CTDVString sType;
	m_InputContext.GetParamString("updatetype", sType);

	bool bSuccess = true;
	if (sType.CompareText("twentyfourseven"))
	{
		// delete all scheduled events 		
		if (!SiteOpenCloseSchedule.DeleteScheduledEvents(iSiteID))
		{
			return m_pPage->AddInside("H2G2", SiteOpenCloseSchedule.GetLastErrorAsXMLString());
		}
	}
	else if (sType.CompareText("sameeveryday"))
	{
		// delete all scheduled events 
		int iRecurrentEventOpenHours = 0, iRecurrentEventCloseHours = 0, iRecurrentEventOpenMinutes = 0, iRecurrentEventCloseMinutes = 0;

		if (m_InputContext.ParamExists("recurrenteventopenhours") && m_InputContext.ParamExists("recurrenteventclosehours")
			&& m_InputContext.ParamExists("recurrenteventopenminutes") && m_InputContext.ParamExists("recurrenteventcloseminutes"))
		{
			iRecurrentEventOpenHours = m_InputContext.GetParamInt("recurrenteventopenhours");
			iRecurrentEventCloseHours = m_InputContext.GetParamInt("recurrenteventclosehours");
			iRecurrentEventOpenMinutes = m_InputContext.GetParamInt("recurrenteventopenminutes");
			iRecurrentEventCloseMinutes = m_InputContext.GetParamInt("recurrenteventcloseminutes");
		}
		else
		{
			SetDNALastError("CMessageBoardSchedulePageBuilder", "UpdateSchedule()", "Bad input parameters for same each day schedule");
			return m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		}

		if (!SiteOpenCloseSchedule.CreateDailyRecurSchedule(iSiteID, iRecurrentEventOpenHours, iRecurrentEventCloseHours, iRecurrentEventOpenMinutes, iRecurrentEventCloseMinutes))
		{
			return m_pPage->AddInside("H2G2", SiteOpenCloseSchedule.GetLastErrorAsXMLString());
		}
	}
	else if (sType.CompareText("eachday"))
	{
		// delete all scheduled events 
		int iNumberOfEvents = m_InputContext.GetParamCount("eventdaytype");
		if (iNumberOfEvents > 28)
		{
			SetDNALastError("CMessageBoardSchedulePageBuilder", "UpdateSchedule", "Too many events. Maximum of 28 allowed.");
			return m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		}

		std::vector<CTDVString> SQLParamVector;
		for ( int i = 0; i < iNumberOfEvents; ++i )
		{
			CTDVString sSQLParam;
			sSQLParam << m_InputContext.GetParamInt("eventdaytype", i) << "_";
			sSQLParam << m_InputContext.GetParamInt("eventhours", i) << "_";
			sSQLParam << m_InputContext.GetParamInt("eventminutes", i) << "_";
			sSQLParam << m_InputContext.GetParamInt("eventaction", i);
			SQLParamVector.push_back(sSQLParam);
		}

		if (!SiteOpenCloseSchedule.UpdateSchedule(iSiteID, SQLParamVector))
		{
			return m_pPage->AddInside("H2G2", SiteOpenCloseSchedule.GetLastErrorAsXMLString());
		}
	}

	return true;
}