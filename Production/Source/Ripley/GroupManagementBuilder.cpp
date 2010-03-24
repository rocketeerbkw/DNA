// GroupManagementBuilder.cpp: implementation of the CGroupManagementBuilder class.
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
#include "GroupManagementBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "GuideEntry.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CGroupManagementBuilder::CGroupManagementBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CGroupManagementBuilder object.

*********************************************************************************/

CGroupManagementBuilder::CGroupManagementBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pViewer(NULL),
	m_sCommand("View"),
	m_sErrorXML(""),
	m_sMessageXML("")
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CGroupManagementBuilder::~CGroupManagementBuilder()

	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CGroupManagementBuilder::~CGroupManagementBuilder()
{
}

/*********************************************************************************

	CWholePage* CGroupManagementBuilder::Build()

	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing staff to inspect a user.

*********************************************************************************/

bool CGroupManagementBuilder::Build(CWholePage* pWholePage)
{
	bool			bSuccess = true;
	CUserList		UserList(m_InputContext);

	// get the viewing user
	m_pViewer = m_InputContext.GetCurrentUser();
	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "GROUP-MANAGEMENT",true);
	// do an error page if not an editor
	if (m_pViewer == NULL || !m_pViewer->GetIsEditor())
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot manage user groups unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// process any submission and then fetch details on this user
		CTDVString	sFormXML = "";
		// first process any submission that may have been made
		bSuccess = bSuccess && ProcessSubmission();
		// then create the XML for the form to be displayed
		bSuccess = bSuccess && CreateForm(&sFormXML,UserList);
		// insert the form XML into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);
	}
	TDVASSERT(bSuccess, "CGroupManagementBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CGroupManagementBuilder::ProcessSubmission()

	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of this page.

*********************************************************************************/

bool CGroupManagementBuilder::ProcessSubmission()
{
	bool		bSuccess = true;

	// set message XML and error XML to blank
	m_sMessageXML = "";
	m_sErrorXML = "";

//???

	return bSuccess;
}

/*********************************************************************************

	bool CGroupManagementBuilder::CreateForm(CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Creates the XML for the form on the inspect user page.

*********************************************************************************/

bool CGroupManagementBuilder::CreateForm(CTDVString* psFormXML,CUserList& UserList)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CGroupManagementBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL)
	{
		return false;
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	CTDVString	sXML = "";
	CTDVString	sGroupsListXML = "";
	CTDVString	sGroupName = "";
	int			iTotalGroups = 0;
	int			i = 0;
	bool		bSuccess = true;

	// fetch the list of available groups
	bSuccess = bSuccess && SP.FetchUserGroupsList();
	sGroupsListXML = "<GROUPS-LIST>";
	while (!SP.IsEOF())
	{
		SP.GetField("Name", sGroupName);
		sGroupsListXML << "<GROUP NAME='" << sGroupName << "' ID='";
		sGroupName.MakeUpper();
		sGroupsListXML << sGroupName << "'/>";
		SP.MoveNext();
	}
	sGroupsListXML << "</GROUPS-LIST>";
	// build up the XML for the group management form
	*psFormXML = "";
	*psFormXML << "<GROUP-MANAGEMENT-FORM>";
	*psFormXML << sGroupsListXML;
	// for each group name specified in the URL produce a list of that groups membership
	iTotalGroups = m_InputContext.GetParamCount("GroupName");
	for (i = 0; i < iTotalGroups; i++)
	{
		m_InputContext.GetParamString("GroupName", sGroupName, i);
		// do XML for this groups membership
		*psFormXML << "<GROUP NAME='" << sGroupName << "'>";
		// make sure any existing user list is destroyed
		bSuccess = bSuccess && UserList.Destroy();
		bSuccess = bSuccess && UserList.CreateGroupMembershipList(sGroupName, m_InputContext.GetSiteID());
		// get the XML for this user list and place it in the form
		sXML = "";
		bSuccess = bSuccess && UserList.GetAsString(sXML);
		*psFormXML << sXML;
		*psFormXML << "</GROUP>";
	}
	// put any message or error xml into the form
	*psFormXML << m_sMessageXML;
	*psFormXML << m_sErrorXML;
	*psFormXML << "</GROUP-MANAGEMENT-FORM>";
	return bSuccess;
}

#endif // _ADMIN_VERSION
