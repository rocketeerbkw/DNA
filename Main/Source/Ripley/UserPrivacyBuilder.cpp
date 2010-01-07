#include "stdafx.h"
#include ".\userprivacybuilder.h"
#include ".\userprivacy.h"
#include ".\tdvassert.h"
#include ".\user.h"
#include ".\TagItem.h"
#include ".\Postcoder.h"

CUserPrivacyBuilder::CUserPrivacyBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CUserPrivacyBuilder::~CUserPrivacyBuilder(void)
{
}

bool CUserPrivacyBuilder::Build(CWholePage* pPage)
{
	// Create and initialize the page
	if (!InitPage(pPage, "USERPRIVACY", true))
	{
		TDVASSERT(false, "Failed To Build Tag Item Page");
		return false;
	}

	// Get the current user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		SetDNALastError("CUserPrivacyBuilder::Build","NotLoggedIn","User Not logged in!!!");
		return pPage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	// Check to see if we've been given user id. Make sure we're a super user or editor
	int iUserID = 0;
	if (m_InputContext.ParamExists("userid") && pViewingUser->GetIsEditor())
	{
		// Get the value
		iUserID = m_InputContext.GetParamInt("userid");
	}

	// Setup some local variables
	bool bOk = true;
	bool bPageOk = true;
	bool bApplyChanges = false;
	CUserPrivacy UserPrivacy(m_InputContext);
	if (!UserPrivacy.InitialiseUserPrivacyDetails(iUserID))
	{
		// Report the error and return. Nothing else to do!
		return pPage->AddInside("H2G2",UserPrivacy.GetLastErrorAsXMLString());
	}
	
	// See if we've been asked to hide or unhide the users location
	if (m_InputContext.ParamExists("hidelocation"))
	{
		// Hide or unhide?
		bool bHideLocation = m_InputContext.GetParamInt("hidelocation") > 0;
		bOk = bOk && UserPrivacy.UpdateHideLocation(bHideLocation);
		bApplyChanges = true;
	}

	// Check to see if we've also been asked to hide or unhide the users username details
	if (m_InputContext.ParamExists("hideusername"))
	{
		// Hide or unhide?
		bool bHideUserName = m_InputContext.GetParamInt("hideusername") > 0;
		bOk = bOk && UserPrivacy.UpdateHideUserName(bHideUserName);
		bApplyChanges = true;
	}

	// See if we need to apply any changes we've made
	CUser* pOtherUser = NULL;
	if (bApplyChanges)
	{
		// Call the update user privacy details
		bOk = bOk && UserPrivacy.CommitChanges();

		// Check to see if everything went ok
		if (bOk)
		{
			// Add the object to the XML
			bPageOk = bPageOk && pPage->AddInside("H2G2",&UserPrivacy);
		}
		else
		{
			// Report the error
			bPageOk = bPageOk && pPage->AddInside("H2G2",UserPrivacy.GetLastErrorAsXMLString());
		}
	}

	// Now get the users privacy details and insert them into the page
	if (UserPrivacy.GetUserPrivacyDetails())
	{
		// Insert the object into the page
		bPageOk = bPageOk && pPage->AddInside("H2G2",&UserPrivacy);
	}
	else
	{
		// Get the last error from the object
		bPageOk = bPageOk && pPage->AddInside("H2G2",UserPrivacy.GetLastErrorAsXMLString());
	}

	// Return the verdict
	return bPageOk;
}