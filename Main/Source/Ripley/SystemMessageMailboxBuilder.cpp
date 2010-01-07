#include "stdafx.h"
#include ".\systemmessagemailboxbuilder.h"
#include ".\systemmessagemailbox.h"
#include ".\tdvassert.h"
#include ".\user.h"

CSystemMessageMailboxBuilder::CSystemMessageMailboxBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CSystemMessageMailboxBuilder::~CSystemMessageMailboxBuilder(void)
{
}
/*********************************************************************************

	CSystemMessageMailboxBuilder::Build()

	Author:		James Conway
	Created:	08/06/2005
	Inputs:		-
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Builds System Message Mailbox page. 

*********************************************************************************/
bool CSystemMessageMailboxBuilder::Build(CWholePage* pPage)
{
	// Create and initialize the page
	if (!InitPage(pPage, "SYSTEMMESSAGEMAILBOX", true))
	{
		TDVASSERT(false, "Failed To Build System Message Mailbox Page");
		return false;
	}

	// Get the current user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		SetDNALastError("CSystemMessageMailboxBuilder::Build","NotLoggedIn","User Not logged in!!!");
		return pPage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	// Get the user's id & site
	int iUserID = pViewingUser->GetUserID();
	int iSiteID = m_InputContext.GetSiteID();

	// Check to see super user or editor is specifying userid and siteid
	if (m_InputContext.ParamExists("userid") && pViewingUser->GetIsEditor())
	{
		// Get the value
		iUserID = m_InputContext.GetParamInt("userid");
	}

	bool bOk = true;
	bool bPageOk = true;
	CSystemMessageMailbox SystemMessageMailbox(m_InputContext);

	if(SystemMessageMailbox.ProcessParams())
	{
		bPageOk = bPageOk && pPage->AddInside("H2G2",&SystemMessageMailbox);
	}
	else
	{
		// Get the last error from the object
		bPageOk = bPageOk && pPage->AddInside("H2G2",SystemMessageMailbox.GetLastErrorAsXMLString());
	}

	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");

	// Now get the user's system message mailbox
	if (SystemMessageMailbox.GetUsersSystemMessageMailbox(iUserID, iSiteID, iSkip, iShow == 0 ? 20 : iShow))
	{
		// Insert the object into the page
		bPageOk = bPageOk && pPage->AddInside("H2G2",&SystemMessageMailbox);
	}
	else
	{
		// Get the last error from the object
		bPageOk = bPageOk && pPage->AddInside("H2G2",SystemMessageMailbox.GetLastErrorAsXMLString());
	}

	// Return the verdict
	return bOk;
}