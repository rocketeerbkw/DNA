// ModerateHomePageBuilder.cpp: implementation of the CModManageFastModBuilder class.
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
#include "ModManageFastModBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "Topic.h"
#include "TDVString.h"
#include "ModerationClasses.h"
#include "BasicSiteList.h"


/*********************************************************************************
CModManageFastModBuilder::CModManageFastModBuilder(CInputContext& inputContext)
Author:		Igor Loboda
Created:	15/07/2005
Inputs:		inputContext - input context object.
Purpose:	Constructs the minimal requirements for a CModManageFastModBuilder object.
*********************************************************************************/

CModManageFastModBuilder::CModManageFastModBuilder(CInputContext& inputContext) 
	:
	CXMLBuilder(inputContext),
	m_iSiteId(0)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************
CWholePage* CModManageFastModBuilder::Build()
Author:		Igor Loboda
Created:	15/07/2005
Returns:	Pointer to a CWholePage containing the entire XML for this page
Purpose:	Constructs the XML for the fast moderation management page.
*********************************************************************************/

bool CModManageFastModBuilder::Build(CWholePage* pPage)
{
	if (pPage == NULL)
	{
		TDVASSERT(false, "CModManageFastModBuilder::Build() pPage is NULL");
		return false;
	}

	bool bOk = InitPage(pPage, "MANAGE-FAST-MOD", true);

	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL)
	{
		bOk = bOk && pPage->SetPageType("ERROR");
		bOk = bOk && pPage->AddInside("H2G2", "<ERROR TYPE='NOT-REFEREE'>You cannot " \
			"perform fast moderation management unless you are logged in as an "\
			"Super user or a Referee.</ERROR>");
	}


	//Create a list of sites relevant for the current user.
	CBasicSiteList modsitedetails(m_InputContext);
	if ( pViewer->GetIsSuperuser() )
		bOk = bOk && modsitedetails.PopulateList(); 
	else if ( pViewer->IsUserInGroup("REFEREE") )
	{
		//Get Sites XML for which the user is a referee.
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		bOk = bOk && SP.GetSitesModerationDetails(pViewer->GetUserID(),false,true);

		while ( bOk && !SP.IsEOF() )
		{
			CSite site;
			site.SetId(SP.GetIntField("siteid"));
			site.SetModerationClass(SP.GetIntField("modclassid"));
			CTDVString sName;
			SP.GetField("shortname",sName);
			site.SetName(sName);
			modsitedetails.AddSite(site);
			SP.MoveNext();
		}
	}

	// If site id is provided check that it is in the list of sites to which the user has access.
	int iRecordsUpdated = 0;
	if (m_InputContext.ParamExists("siteid"))
	{
		//m_InputContext.GetParamString("site", m_sSiteName);
		m_iSiteId = m_InputContext.GetParamInt("siteid");

		if ( modsitedetails.GetSite(m_iSiteId) == NULL )
		{
			bOk = bOk && pPage->SetPageType("ERROR");
			bOk = bOk && pPage->AddInside("H2G2", "<ERROR TYPE='NOT-REFEREE'>Cannot " \
				"perform fast moderation for specified site. "  \
				"Fast moderation is restricted to referees / superusers.</ERROR>");
		}

		bOk = bOk && ProcessSubmission(iRecordsUpdated);
	}
	else
	{
		//Set default to current site.
		m_iSiteId = m_InputContext.GetSiteID();
	}

	CTDVString sXml;
	bOk = GetManageFastModXml(iRecordsUpdated, sXml);
	bOk = bOk && pPage->AddInside("H2G2", sXml);

	//Add SiteList
	pPage->AddInside("H2G2",modsitedetails.GetAsXML2());

	//Add the Moderation Classes
	CModerationClasses modclasses(m_InputContext);
	if ( modclasses.GetModerationClasses() )
		pPage->AddInside("H2G2",&modclasses);
	else if ( modclasses.ErrorReported() )
		pPage->AddInside("H2G2",modclasses.GetLastErrorAsXMLString());
	
	bOk = bOk && GetTopicsXml(sXml);
	bOk = bOk && pPage->AddInside("MANAGE-FAST-MOD", sXml);

	TDVASSERT(bOk, "CModManageFastModBuilder::Build() failed");
	return bOk;
}

/*********************************************************************************
bool CModManageFastModBuilder::CheckUserCanManageFastModForSite()
Author:		Igor Loboda
Created:	18/07/2005
Returns:	true if current user is a superuser or a referee for
			current (m_iSiteId) site.
Puropse:	Checks user can manage a particular site. ( Not called ).
*********************************************************************************/

bool CModManageFastModBuilder::CheckUserCanManageFastModForSite()
{
	if (m_InputContext.GetCurrentUser()->GetIsSuperuser() == true)
	{
		return true;
	}

	CStoredProcedure sp;
	m_InputContext.InitialiseStoredProcedureObject(&sp);
	if (sp.GetGroupsFromUserAndSite(m_InputContext.GetCurrentUser()->GetUserID(), m_iSiteId) == false)
	{
		return false;
	}

	while (sp.IsEOF() == false)
	{
		CTDVString sGroupName;
		sp.GetField("groupname", sGroupName);
		if (sGroupName.CompareText("referee"))
		{
			return true;
		}

		sp.MoveNext();
	}

	return false;
}

/*********************************************************************************
bool CModManageFastModBuilder::ProcessSubmission(int& iRecordsUpdated)
Author:		Igor Loboda
Created:	15/07/2005
Returns:	true if successful
Purpose:	Processes any form submission.
*********************************************************************************/

bool CModManageFastModBuilder::ProcessSubmission(int& iRecordsUpdated)
{
	iRecordsUpdated = -1;
	CTDVString sCommand;
	m_InputContext.GetParamString("c", sCommand);
	if (sCommand.CompareText("update"))
	{
		if (DoUpdate(iRecordsUpdated) == false)
		{
			return false;
		}
	}

	return true;
}

/*********************************************************************************
bool CModManageFastModBuilder::GetManageFastModXml(
	int iRecordsUpdated, CTDVString& sXml)
Author:		Igor Loboda
Created:	15/07/2005
Returns:	true if successful
Purpose:	Constucts empty MANAGE-FAST-MOD element 
			Adds Feedback XML - <FEEDBACK PROCESSED=''/> standard Feedback XML.
								<FEEDBACK><RECORDSUPDATED/> XML for legacy use.
*********************************************************************************/

bool CModManageFastModBuilder::GetManageFastModXml(int iRecordsUpdated, 
	CTDVString& sXml)
{
	sXml = "<MANAGE-FAST-MOD><SITE ID='";
	sXml << m_iSiteId << "'/>" << "<FEEDBACK PROCESSED='" << iRecordsUpdated << "'>"
		<< "<RECORDSUPDATED>" << iRecordsUpdated << "</RECORDSUPDATED></FEEDBACK></MANAGE-FAST-MOD>";
	return true;
}

/*********************************************************************************
bool CModManageFastModBuilder::DoUpdate(in& iRecordsUpdated)
Author:		Igor Loboda
Created:	15/07/2005
Returns:	true if successful
Purpose:	updates fast mod flag as requested by the form data submitted. 
			As a security feature all updates check siteid stored in forums
			agains siteid submitted from the form. The check that user can
			manage fast mod for given sited takes place before call to this
			method
*********************************************************************************/

bool CModManageFastModBuilder::DoUpdate(int& iRecordsUpdated)
{
	iRecordsUpdated = 0;
	for (int i = 0; m_InputContext.ParamExists("forumid", i); i++)
	{
		int iForumId = m_InputContext.GetParamInt("forumid", i);
		CTDVString sCheckboxName = "check";
		sCheckboxName << iForumId;
		CTDVString sOldFastModName = "oldfastmod";
		sOldFastModName << iForumId;
		if (m_InputContext.ParamExists(sCheckboxName))
		{
			if (m_InputContext.GetParamInt(sOldFastModName) == 0)
			{
				if (UpdateFastMod(iForumId, true))
				{
					iRecordsUpdated++;
				}
			}
		}
		else if(m_InputContext.GetParamInt(sOldFastModName) == 1)
		{
			if (UpdateFastMod(iForumId, false))
			{
				iRecordsUpdated++;
			}
		}
	}

	return true;
}

/*********************************************************************************
bool CModManageFastModBuilder::UpdateFastMod(int iForumId, bool bFastMod)
Author:		Igor Loboda
Created:	15/07/2005
Returns:	true if successful
Purpose:	updates fast mod flag for a given forum
*********************************************************************************/

bool CModManageFastModBuilder::UpdateFastMod(int iForumId, bool bFastMod)
{
	CStoredProcedure sp;
	m_InputContext.InitialiseStoredProcedureObject(&sp);
	return sp.UpdateFastMod(m_iSiteId, iForumId, bFastMod);
}


/*********************************************************************************
bool CModManageFastModBuilder::GetTopicsXml(int iSiteId, CTDVString& sXml)
Author:		Igor Loboda
Created:	15/07/2005
Returns:	true if successful
Purpose:	fetches topics list for given site and creates MANAGEABLE-TOPICS xml
*********************************************************************************/

bool CModManageFastModBuilder::GetTopicsXml(CTDVString& sXml)
{
	sXml = "<MANAGEABLE-TOPICS>";
	CTopic m_Topic(m_InputContext);
	if (m_Topic.GetTopicsForSiteID(m_iSiteId, CTopic::TS_LIVE, false))
	{
		CTDVString sTopicXml;
		m_Topic.GetAsString(sTopicXml);
		sXml << sTopicXml;
	}
	else
	{
		sXml = m_Topic.GetLastErrorAsXMLString();
		return false;
	}
	sXml << "</MANAGEABLE-TOPICS>";
	return true;
}
