// URLFilterAdminBuilder.cpp: implementation of the CURLFilterAdminBuilder class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2006.

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
#include "tdvassert.h"
#include "PageUI.h"
#include "URLFilterAdmin.h"
#include "URLFilterAdminBuilder.h"
#include "URLFilterList.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CURLFilterAdminBuilder::CURLFilterAdminBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CURLFilterAdminBuilder::~CURLFilterAdminBuilder(void)
{
}

bool CURLFilterAdminBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	if (!InitPage(m_pPage, "URLFILTERADMIN", true))
	{
		return false;
	}

	// Create and initialise CURLFilterAdmin <URLFILTERADMIN>
	//
	CTDVString sAction;
	m_InputContext.GetParamString("Action", sAction);
	
	CURLFilterList URLFilterList(m_InputContext);
	URLFilterList.GetURLFilterList();
	
	CURLFilterAdmin URLFilterAdmin(m_InputContext);
	URLFilterAdmin.Create(sAction);

	// Get current user permissions
	//
	bool bIsSuperUser = false;
	bool bIsEditor    = false;

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (pViewingUser != NULL)
	{
		bIsSuperUser = pViewingUser->GetIsSuperuser();
		if (bIsSuperUser)
		{
			if (!sAction.CompareText("list"))
			{
				//New Allowed URL Management
				if (m_InputContext.ParamExists("Process"))
				{
					URLFilterAdmin.ProcessAllowedURLs();	
				}
				else if (sAction.CompareText("AddAllowedURL"))
				{
					URLFilterAdmin.AddAllowedURL();
				}
				else if (sAction.CompareText("ImportAllowedURLs"))
				{
					URLFilterAdmin.ImportURLFilterList();
				}
				else if (sAction.CompareText("UpdateAllowedURL"))
				{
					URLFilterAdmin.ProcessAllowedURLs();
				}		

				m_InputContext.RefreshAllowedURLList();
				m_InputContext.Signal("/Signal?action=recache-site");
			}
			CTDVString sXML;
			int iFirstSiteID; // default to the first site user is editor of if no SiteID passed in. 
			pViewingUser->GetSitesUserIsEditorOfXML(pViewingUser->GetUserID(), sXML, iFirstSiteID); 
			m_pPage->AddInside("H2G2", sXML);
		}
		else
		{
			SetDNALastError("URLFilterAdminPageBuilder", "NOTSUPERUSER", "User is not a super user.");
		}
	}
	else
	{
		SetDNALastError("URLFilterAdminPageBuilder", "INVALIDUSER", "No valid viewing user found");
	}

	// Check if errors have been reported
	//
	if (ErrorReported())
	{
		m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}
	else if (URLFilterAdmin.ErrorReported())
	{
		m_pPage->AddInside("H2G2", URLFilterAdmin.GetLastErrorAsXMLString());
	}
	
	m_pPage->AddInside("H2G2", &URLFilterAdmin);
	
	return true;
}
