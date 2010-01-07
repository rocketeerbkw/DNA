// ClubListPageBuilder.cpp: implementation of the CClubListPageBuilder class.
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
	not not warrant that the code is error-free or bug-free.
	  
	All information, data etc relating to the code is confidential 
	information to the BBC and as such must not be disclosed to 
	any other party whatsoever.
		
		  						  
*/

#include "stdafx.h"
#include "ClubListPageBuilder.h"
#include "ClubList.h"
#include "User.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CClubListPageBuilder::CClubListPageBuilder(CInputContext& inputContext)
:
CXMLBuilder(inputContext)
{
	
}

CClubListPageBuilder::~CClubListPageBuilder()
{
	
}



/*********************************************************************************

	CWholePage* CClubListPageBuilder::Build()

	Author:		Nick Stevenson
	Created:	11/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CClubListPageBuilder::Build(CWholePage* pPage)
{
	if (!InitPage(pPage,"CLUBLIST", true))
	{
		return false;
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser != NULL && !m_InputContext.ParamExists("action") && (pViewingUser->GetIsBBCStaff() || pViewingUser->GetIsEditor()) )
	{
			DisplayClubList(pPage);				
	}
	else
	{
		pPage->SetPageType("ERROR");
		pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot view club list unless you are logged in as an Editor.</ERROR>");
	}

	return true;
}


/*********************************************************************************

	CWholePage* CClubListPageBuilder::DisplayClubList()

	Author:		Nick Stevenson
	Created:	11/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage object
	Purpose:	Obtains and adds XML containing data for a list of new clubs created
				in the last month

*********************************************************************************/

bool CClubListPageBuilder::DisplayClubList(CWholePage* pPage)
{

	bool bSuccess = false;

	// create instance of clublist
	CClubList ClubList(m_InputContext);

	int iSkip = 0;
	int iShow = 20;

	if (m_InputContext.ParamExists("skip"))
	{
		iSkip = m_InputContext.GetParamInt("skip");
	}

	if (m_InputContext.ParamExists("show"))
	{
		iShow = m_InputContext.GetParamInt("show");
	}

	bool bOrderByLastUpdated = (m_InputContext.GetParamInt("order") == 1);

	//call clublist function to get the list
	int iSiteID = m_InputContext.GetSiteID();
	ClubList.ListClubs(iSiteID, bOrderByLastUpdated, iSkip, iShow);

	// create the page
	bSuccess =	pPage->AddInside("H2G2",&ClubList);
	if (!bSuccess)
	{
		return ErrorMessage(pPage, "XML","Failed to build the XML");
	}

	return true; 
}



/*********************************************************************************

	bool CClubListPageBuilder::ErrorMessage(CWholePage* pPage, const TDVCHAR* sType, const TDVCHAR* sMsg)

	Author:		Nick Stevenson
	Created:	26/06/2003
	Inputs:		pPage - page to modify with error
				sType - type of error
				sMsg - Default message
	Outputs:	-
	Returns:	true
	Purpose:	default error message

*********************************************************************************/

bool CClubListPageBuilder::ErrorMessage(CWholePage* pPage, const TDVCHAR* sType, const TDVCHAR* sMsg)
{
	InitPage(pPage, "CLUBLIST", true);

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	pPage->AddInside("H2G2", sError);

	return true;
}