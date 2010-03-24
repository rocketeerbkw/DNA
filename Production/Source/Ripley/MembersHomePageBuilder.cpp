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
#include ".\membershomepagebuilder.h"
#include ".\user.h"
#include ".\moderationclasses.h"
#include ".\userstatuses.h"
#include ".\basicsitelist.h"

CMembersHomePageBuilder::CMembersHomePageBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CMembersHomePageBuilder::~CMembersHomePageBuilder(void)
{
}

/* virtual */
bool CMembersHomePageBuilder::Build(CWholePage * pPage)
{
	bool bRetVal = true;

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	InitPage(pPage, "USERS-HOMEPAGE", true);

	if (!pViewingUser)
	{
		SetDNALastError("CMembersHomePageBuilder", "NotLoggedIn", "User is not logged in");		
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}

	if (!(pViewingUser->GetIsSuperuser() || pViewingUser->GetIsEditorOnAnySite()))
	{
		SetDNALastError("CMembersHomePageBuilder", "NotValidUser", "User has insufficient priveleges");		
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CTDVString sUsersList;

	int iSiteID = m_InputContext.GetParamInt("siteid");
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	int iDirection = m_InputContext.GetParamInt("direction");

	CDBXMLBuilder xml;

	int iSearchRowCount = 0;

	if (m_InputContext.ParamExists("search"))
	{
		//what are we searching on - UID, email, nickname
		CTDVString sSearchOption;
		m_InputContext.GetParamString("searchoption", sSearchOption);

		//term to search on
		CTDVString sSearchTerm;
		m_InputContext.GetParamString("searchterm", sSearchTerm);

		int iUserID = atoi(sSearchTerm);

		SP.SearchTrackedUsers(iSiteID, sSearchOption, sSearchTerm, iUserID, sSearchTerm, iSkip, iShow, &iSearchRowCount);
		xml.Initialise(&sUsersList, &SP);
		xml.OpenTag("USERS-LIST", true);
		xml.AddIntAttribute("SITEID", iSiteID, false);
		xml.AddAttribute("SEARCHTERM", sSearchTerm, false);
		xml.AddAttribute("SEARCHOPTION", sSearchOption, false);
		
		xml.AddIntAttribute("SKIP", iSkip, false);
		xml.AddIntAttribute("SHOW", iShow?iShow:10, true);
	}
	else
	{
		//what is list sorted on - Nickname, Status, Duration, Tags
		CTDVString sSortColumn;
		m_InputContext.GetParamString("sortedon", sSortColumn);

		SP.GetTrackedUsers(iSiteID, iSkip, iShow, iDirection, sSortColumn);
		
		xml.Initialise(&sUsersList, &SP);
		xml.OpenTag("USERS-LIST", true);
		xml.DBAddIntAttribute("TOTALUSERS", "TOTALUSERS", false, false);
		xml.AddIntAttribute("SKIP", iSkip, false);
		xml.AddIntAttribute("SHOW", iShow, false);
		xml.AddIntAttribute("DIRECTION", iDirection, false);
		xml.AddAttribute("SORTEDON", sSortColumn, false);
		xml.AddIntAttribute("SITEID", iSiteID, true);
	}
	
	int iPrevUserID = -1;
	while (!SP.IsEOF())
	{
		xml.OpenTag("USER", true);
		int iUserID = SP.GetIntField("UserID");
		xml.DBAddIntAttribute("USERID", "USERID", false, true);
		
		xml.DBAddTag("UserName", "UserName");
		xml.OpenTag("Status", true);
		xml.DBAddIntAttribute("PrefStatus", "StatusID", false, false);
		xml.DBAddIntAttribute("PrefStatusDuration", "Duration", false, true);
		xml.DBAddDateTag("PrefStatusChangedDate","StatusChangedDate", false);
		xml.CloseTag("Status");			
		
		SP.MoveNext();
		iPrevUserID = iUserID;
		iUserID = SP.GetIntField("UserID");
		while (iUserID == iPrevUserID)
		{
			xml.DBAddTag("UserTagDescription", "UserTag");
			SP.MoveNext();
			iUserID = SP.GetIntField("UserID");
		}
		xml.CloseTag("USER");
	}

	xml.CloseTag("USERS-LIST");	
	pPage->AddInside("H2G2", sUsersList);

	if (iSearchRowCount)
	{
		CTDVString sTotalUsers(iSearchRowCount);
		pPage->SetAttribute("USERS-LIST", "TOTALUSERS", sTotalUsers);
	}

	CModerationClasses moderationClasses(m_InputContext);
	moderationClasses.GetModerationClasses();
	pPage->AddInside("H2G2", &moderationClasses);

	CUserStatuses userStatuses(m_InputContext);
	userStatuses.GetUserStatuses();
	pPage->AddInside("H2G2", &userStatuses);

	CBasicSiteList sitedetails(m_InputContext);
	if ( sitedetails.PopulateList() )
		pPage->AddInside("H2G2", sitedetails.GetAsXML2());
	else
		pPage->AddInside("H2G2",sitedetails.GetLastErrorAsXMLString());

	return bRetVal;
}

