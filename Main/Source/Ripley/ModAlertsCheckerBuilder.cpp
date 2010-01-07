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
#include "ModAlertsCheckerBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "TDVString.h"
#include "ModComplaintsStats.h"


/*********************************************************************************
CModAlertsCheckerBuilder::CModAlertsCheckerBuilder(CInputContext& inputContext)
Author:		Igor Loboda
Created:	15/07/2005
Inputs:		inputContext - input context object.
Purpose:	Constructs the minimal requirements for a CModAlertsCheckerBuilder object.
*********************************************************************************/

CModAlertsCheckerBuilder::CModAlertsCheckerBuilder(CInputContext& inputContext) 
	:
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************
CWholePage* CModAlertsCheckerBuilder::Build()
Author:		Igor Loboda
Created:	19/07/2005
Returns:	Pointer to a CWholePage containing the entire XML for this page
Purpose:	Constructs the XML for moderation alerts page
*********************************************************************************/

bool CModAlertsCheckerBuilder::Build(CWholePage* pPage)
{
	if (pPage == NULL)
	{
		TDVASSERT(false, "CModAlertsCheckerBuilder::Build() pPage is NULL");
		return false;
	}

	bool bOk = pPage->Initialise();
	bOk = bOk && pPage->SetPageType("MOD-ALERTS-CHECKER");

	if (m_InputContext.GetCurrentUser() == NULL)
	{
		bOk = bOk && pPage->SetPageType("ERROR");
		bOk = bOk && pPage->AddInside("H2G2", "<ERROR TYPE='NOT-SIGNEDIN'>You need " \
			"to be signed in to use this page</ERROR>");
	}
	else
	{
		CTDVString sXml;
		bOk = GetComplaintsStatsXml(sXml);
		bOk = bOk && pPage->AddInside("H2G2", sXml);
	}

	return bOk;
}

/*********************************************************************************
bool CModAlertsCheckerBuilder::GetComplaintsStatsXml(CTDVString& sXml)
Author:		Igor Loboda
Created:	20/07/2005
Purpose:	Constructs COMPLAINTS-STATS element
*********************************************************************************/

bool CModAlertsCheckerBuilder::GetComplaintsStatsXml(CTDVString& sXml)
{
	CModComplaintsStats complaintsStats(m_InputContext);
	if (complaintsStats.Fetch(m_InputContext.GetCurrentUser()->GetUserID()) == false)
	{
		return false;
	}
	CModComplaintsStats::CStats stats = complaintsStats.Stats();

	sXml = "<COMPLAINTS-STATS>";

	if (m_InputContext.GetParamInt("forums") == 1)
	{
		 sXml << "<FORUMS COUNT='" << stats[CModComplaintsStats::FORUMS] << "'/>";
	}
	if (m_InputContext.GetParamInt("forums_fastmod") == 1)
	{
		 sXml << "<FORUMS-FASTMOD COUNT='" << stats[CModComplaintsStats::FORUMS_FASTMOD] << "'/>";
	}
	if (m_InputContext.GetParamInt("general") == 1)
	{
		 sXml << "<GENERAL COUNT='" << stats[CModComplaintsStats::GENERAL] << "'/>";
	}
	if (m_InputContext.GetParamInt("entries") == 1)
	{
		 sXml << "<ENTRIES COUNT='" << stats[CModComplaintsStats::ENTRIES] << "'/>";
	}

	sXml << "</COMPLAINTS-STATS>";

	return true;
}
