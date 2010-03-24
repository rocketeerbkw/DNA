// PageUI.cpp: implementation of the CPageUI class.
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
#include <time.h>
#include "PageUI.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CPageUI::CPageUI(CInputContext& inputContext) : CXMLObject(inputContext)
{

}

CPageUI::~CPageUI()
{

}

/*********************************************************************************

	bool CPageUI::Initialise(CUser* pUser)

	Author:		Jim Lynn
	Created:	23/03/2000
	Inputs:		pUser - current viewing user or NULL
	Outputs:	-
	Returns:	true on success, false otherwise
	Purpose:	Initialises the UI with information from the current viewing user

*********************************************************************************/

bool CPageUI::Initialise(CUser* pUser)
{
	// First get a random number to give to the banner ad
	srand((unsigned)time(NULL));
	int iRandom = rand();
	iRandom = rand();		// Call it twice otherwise it returns the seed!

	int iUserID = 0;
	CTDVString sPassword;

	if (pUser != NULL)
	{
		pUser->GetUserID(&iUserID);
		pUser->GetPassword(sPassword);
	}
	
	// Now build the tree
	CTDVString sTreeText = "<PAGEUI>\
<SITEHOME VISIBLE='1' LINKHINT='/' />\
<SEARCH VISIBLE='1' LINKHINT='/search' />\
<DONTPANIC VISIBLE='1' LINKHINT='/dontpanic' />";
	if (iUserID > 0)
	{
		sTreeText << "<MYHOME VISIBLE='1' LINKHINT='/U" << iUserID << "'/>\n";
		sTreeText << "<REGISTER VISIBLE='0'/>\n";
		sTreeText << "<MYDETAILS VISIBLE='1' LINKHINT='/UserDetails'/>\n";
		
		// Don't display the logout button if the user hasn't defined a password
//		if (sPassword.GetLength() > 0)
//		{
			sTreeText << "<LOGOUT VISIBLE='1' LINKHINT='/Logout' />";
//		}
//		else
//		{
//			sTreeText << "<LOGOUT VISIBLE='0' />";
//		}
	}
	else
	{
		sTreeText << "<MYHOME VISIBLE='0'/>\n";
		sTreeText << "<MYDETAILS VISIBLE='0' LINKHINT=''/>\n";
		sTreeText << "<REGISTER VISIBLE='1' LINKHINT='/Register'/>\n";
		sTreeText << "<LOGOUT VISIBLE='0' LINKHINT='' />";
	}
	sTreeText << "<EDITPAGE VISIBLE='0' LINKHINT='' />";
	sTreeText << "<RECOMMEND-ENTRY VISIBLE='0' LINKHINT='' />";
	sTreeText << "<ENTRY-SUBBED VISIBLE='0' LINKHINT='' />";
	sTreeText << "<DISCUSS VISIBLE='0' LINKHINT='' />";
	sTreeText << "<BANNER NAME='main' SEED='";
	sTreeText << iRandom << "' SECTION='frontpage' />\
<BANNER NAME='small' SEED='";
	sTreeText << iRandom << "' SECTION='frontpage' />\
</PAGEUI>";

	return CreateFromXMLText(sTreeText);
}

/*********************************************************************************

	bool CPageUI::SetHomeVisibility(bool bState, const TDVCHAR *pLinkHint)

	Author:		Jim Lynn
	Created:	29/02/2000
	Inputs:		bState - true if button should be visible, false if not
				pLinkHint - URL button should go to
	Outputs:	-
	Returns:	true if succeeded, false otherwise
	Purpose:	Sets the main 'home' button (the h2g2 logo in the goo for example
				to be visible or invisible, and gives a URL hint for it.

*********************************************************************************/

bool CPageUI::SetHomeVisibility(bool bState, const TDVCHAR *pLinkHint)
{
	return SetVisibility("SITEHOME",bState, pLinkHint);
}

bool CPageUI::SetDontPanicVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("DONTPANIC",bState, pLinkHint);
}

bool CPageUI::SetSearchVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("SEARCH",bState, pLinkHint);
}

bool CPageUI::SetMyHomeVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("MYHOME",bState, pLinkHint);
}

bool CPageUI::SetRegisterVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("REGISTER",bState, pLinkHint);
}

bool CPageUI::SetMyDetailsVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("MYDETAILS",bState, pLinkHint);
}

bool CPageUI::SetLogoutVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("LOGOUT",bState, pLinkHint);
}

bool CPageUI::SetEditPageVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("EDITPAGE",bState, pLinkHint);
}

bool CPageUI::SetRecommendEntryVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("RECOMMEND-ENTRY", bState, pLinkHint);
}

bool CPageUI::SetEntrySubbedVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("ENTRY-SUBBED", bState, pLinkHint);
}


bool CPageUI::SetDiscussVisibility(bool bState, const TDVCHAR* pLinkHint)
{
	return SetVisibility("DISCUSS",bState, pLinkHint);
}

/*********************************************************************************

	bool CPageUI::SetVisibility(const TDVCHAR *pNodeName, bool bState, const TDVCHAR *pLinkHint)

	Author:		Jim Lynn
	Created:	29/02/2000
	Inputs:		pNodeName - name of node within UI structure to update
				bState - true if button should be visible, false if not
				pLinkHint - hint as to which URL should be called. Might be
				ignored by the stylesheet or changed by the transformer
	Outputs:	-
	Returns:	true if succeeded, false if failed
	Purpose:	Protected helper function to set the visibility flag and
				link hint on a given button element. Only for internal
				use.

*********************************************************************************/

bool CPageUI::SetVisibility(const TDVCHAR *pNodeName, bool bState, const TDVCHAR *pLinkHint)
{
	CTDVString hint = pLinkHint;
	if (hint.GetLength() > 1 && hint.GetAt(0) == '/')
	{
		hint.RemoveLeftChars(1);
	}

	bool bSuccess = true;
	
	// Find the node we're after
	CXMLTree* pNode = m_pTree->FindFirstTagName(pNodeName);
	if (pNode == NULL)
	{
		bSuccess = false;
	}
	else
	{
		// Set the VISIBLE attribute to reflect the state flag
		if (bState)
		{
			pNode->SetAttribute("VISIBLE","1");
		}
		else
		{
			pNode->SetAttribute("VISIBLE","0");
		}
		// Set the LINKHINT attribute if passed to us
		if (pLinkHint != NULL)
		{
			pNode->SetAttribute("LINKHINT", hint);
		}
		bSuccess = true;
	}
	return bSuccess;
}
