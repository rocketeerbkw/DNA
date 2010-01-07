// ProfanityAdminPageBuilder.cpp: implementation of the CProfanityAdminPageBuilder class.
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
#include "ProfanityAdminPageBuilder.h"
#include "ProfanityAdmin.h"
#include "ProfanityGroup.h"
#include "ProfanityList.h"
#include "Profanity.h"
#include "User.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


/*********************************************************************************
CProfanityAdminPageBuilder::CProfanityAdminPageBuilder(CInputContext& inputContext)
Author:		David van Zijl
Created:	12/08/2004
Purpose:	Constructor
*********************************************************************************/

CProfanityAdminPageBuilder::CProfanityAdminPageBuilder(CInputContext& inputContext)
:
CXMLBuilder(inputContext),
m_pPage(NULL)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}


/*********************************************************************************
CProfanityAdminPageBuilder::~CProfanityAdminPageBuilder()
Author:		David van Zijl
Created:	12/08/2004
Purpose:	Destructor
*********************************************************************************/

CProfanityAdminPageBuilder::~CProfanityAdminPageBuilder()
{
	
}


/*********************************************************************************

	CWholePage* CProfanityAdminPageBuilder::Build()

	Author:		Nick Stevenson, David van Zijl
	Created:	13/01/2004
	Inputs:		-
	Outputs:	-
	Returns:	CWholePage*: pointer to the built page
	Purpose:	Checks the input params and the user status. If actions are correct and
				the viewing user is superuser of editor, the appropriate function is called
				to obtain the remainder of the input params. Object data is then added
				to the H2G2 XML element

*********************************************************************************/

bool CProfanityAdminPageBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	if (!InitPage(m_pPage, "PROFANITYADMIN", true))
	{
		return false;
	}

	// Create and initialise CProfanityAdmin <PROFANITYADMIN>
	//
	CTDVString sAction;
	m_InputContext.GetParamString("Action", sAction);

	// Get current user permissions
	//
	bool bIsSuperUser = false;
	bool bIsEditor    = false;

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (pViewingUser != NULL)
	{
		bIsSuperUser = pViewingUser->GetIsSuperuser();
	}
	else
	{
		m_pPage->AddInside("H2G2", "<ERROR TYPE='NOT-SUPERUSER'>You cannot perform profanity admin unless you are logged in as a superuser.</ERROR>");
		return true;
	}

	if (bIsSuperUser)
	{
		CProfanityAdmin PAdmin(m_InputContext);
		PAdmin.Create(sAction);
#if 0		
		if (sAction.FindText("group") >= 0 && !bIsSuperUser)
		{
			// Group functions only available to SuperUsers
			// (Make sure editors never need an 'action' param like %group% or this will break)
			//
			SetDNALastError("ProfanityAdminPageBuilder", "INVALIDUSER", "Sorry but you don't have the correct permissions to use this page");
			m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
			return true;
		}
		else if (sAction.FindText("profanity") >= 0)
		{
			// Always add current site or group to profanity pages
			//
			AddGroupOrSiteDetails(PAdmin);
		}
#endif
		//New Profanity Management
		if (m_InputContext.ParamExists("Process"))
		{
			PAdmin.ProcessProfanities();	
		}
		else if (sAction.CompareText("AddProfanities"))
		{
			PAdmin.AddProfanities();
		}
		else if (sAction.CompareText("ImportProfanityList"))
		{
			PAdmin.ImportProfanityList();
		}
		else if (sAction.CompareText("UpdateProfanities"))
		{
			PAdmin.ProcessProfanities();
		}		

		m_InputContext.RefreshProfanityList();
		m_InputContext.Signal("/Signal?action=recache-site");

#if 0
		//
		// Profanity Group Functions
		//
		if (sAction.CompareText("showgroups"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=showgroups&skin=purexml
			PAdmin.ShowGroupList();
		}
		else if (sAction.CompareText("addgroup"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=addgroup&groupsites=1%2C2%2C3&_msfinish=yes&groupname=NonRudeSites&skin=purexml
			SetDNALastError("ProfanityAdminPageBuilder", "NOGROUPADMIN", "Group admin no longer handled with this tool. See the moderator management interface.");
			//AddGroup(PAdmin);
		}
		else if (sAction.CompareText("showgroupfilter"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=showgroupfilter&groupid=1&skin=purexml
			ShowGroupFilter(PAdmin);
		}
		else if (sAction.CompareText("showupdategroup"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=showupdategroup&groupid=1&skin=purexml
			SetDNALastError("ProfanityAdminPageBuilder", "NOGROUPADMIN", "Group admin no longer handled with this tool. See the moderator management interface.");
			//ShowUpdateGroupPage(PAdmin);
		}
		else if (sAction.CompareText("updategroup"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=updategroup&groupid=1&groupsites=1%2C2%2C3&_msfinish=yes&groupname=Normal&skin=purexml
			SetDNALastError("ProfanityAdminPageBuilder", "NOGROUPADMIN", "Group admin no longer handled with this tool. See the moderator management interface.");
			//UpdateGroup(PAdmin);
		}
		else if (sAction.CompareText("deletegroup"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=deletegroup&groupid=3&skin=purexml
			SetDNALastError("ProfanityAdminPageBuilder", "NOGROUPADMIN", "Group admin no longer handled with this tool. See the moderator management interface.");
			//DeleteGroup(PAdmin);
		}
		//
		// Profanity functions 
		//
		else if(sAction.CompareText("showupdateprofanity"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=showupdateprofanity&groupid=1&skin=purexml
			ShowUpdateProfanityPage(PAdmin);
		}
		else if(sAction.CompareText("updateprofanity"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?_msfinish=yes&_msstage=1&action=addprofanity&profanitytext=arse&profanityrating=premod
			UpdateProfanity(PAdmin);				
		}
		else if(sAction.CompareText("showaddprofanity"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=showaddprofanity&skin=purexml
		}
		else if(sAction.CompareText("addprofanity"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?_msfinish=yes&action=addprofanity&profanity=arse&profanityrating=premod
			AddProfanity(PAdmin);				
		}
		else if(sAction.CompareText("deleteprofanity"))
		{
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?action=deleteprofanity&profanityid=1&skin=purexml
			DeleteProfanity(PAdmin);
		}	
		else
		{
			// Show the words for the current site.
			// http://local.bbc.co.uk/dna/ican/icandev/ProfanityAdmin?skin=purexml
			ShowSiteFilter(PAdmin);
		}
#endif
		// Check if errors have been reported
		//
		if (ErrorReported())
		{
			m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		}
		else if (PAdmin.ErrorReported())
		{
			m_pPage->AddInside("H2G2", PAdmin.GetLastErrorAsXMLString());
		}
		m_pPage->AddInside("H2G2", &PAdmin);
	}
	else
	{
		SetDNALastError("ProfanityAdminPageBuilder", "INVALIDUSER", "No valid viewing user found");
	}
	return true;
}

#if 0
/*********************************************************************************
bool CProfanityAdminPageBuilder::AddGroupOrSiteDetails(CProfanityAdmin& PAdmin)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		PAdmin - reference to a CProfanityAdmin object
Outputs:	-
Returns:	true on success
Purpose:	Generates the add profanity page by calling the relevant method inside 
			CProfanityAdmin. If adding to a group (indicated by the presence of the 
			'groupid' cgi param) then makes sure that the person is a superuser.
*********************************************************************************/

bool CProfanityAdminPageBuilder::AddGroupOrSiteDetails(CProfanityAdmin& PAdmin)
{
	bool bAddingToGroup = false;
	int iGroupId = 0;
	int iSiteId = 0;

	if (!GetGroupAndSiteIds(bAddingToGroup, iGroupId, iSiteId))
	{
		return false;
	}

	// If we have a groupid param then we know we are adding to the current group
	//
	if (bAddingToGroup)
	{
		return PAdmin.AddGroupOrSiteDetails(iGroupId, false);
	}
	else
	{
		CTDVString sSiteName;
		m_InputContext.GetShortName(sSiteName, iSiteId);

		return PAdmin.AddGroupOrSiteDetails(iSiteId, true, sSiteName);
	}
}

/*********************************************************************************

	bool CProfanityAdminPageBuilder::AddProfanity(CProfanityAdmin& PAdmin)

	Author:		Nick Stevenson, David van Zijl
	Created:	13/01/2004
	Inputs:		PAdmin: instance of CProfanityAdmin
	Outputs:	-
	Returns:	true on success
	Purpose:	Get the profanity from the input params and calls the appropriate 
				function of the ProfanityAdmin object

*********************************************************************************/

bool CProfanityAdminPageBuilder::AddProfanity(CProfanityAdmin& PAdmin)
{
	bool bReadyToUse;
	int iProfanityId = 0;
	int iProfanityRating = 0;
	CTDVString sProfanity, sProfanityReplacement;
	CreateAndProcessProfanityMultiStep(true, iProfanityId, sProfanity, iProfanityRating, sProfanityReplacement, bReadyToUse);

	if (bReadyToUse)
	{
		// If the action is 'replace' then we need sProfanityReplacement
		//
		if (iProfanityRating == PROFANITY_RATING_REPLACE && sProfanityReplacement.IsEmpty())
		{
			// Do nothing, the page will reload with the new Multistep
			// and the person will have to be prompted for a replacement
			// in the XSL
		}
		else
		{
			bool bAddingToGroup = false;
			int iGroupId = 0;
			int iSiteId = 0;

			if (!GetGroupAndSiteIds(bAddingToGroup, iGroupId, iSiteId))
			{
				return false;
			}

			return PAdmin.AddProfanity(iGroupId, iSiteId, sProfanity, iProfanityRating, sProfanityReplacement);
		}
	}

	return true;
}


/*********************************************************************************
bool CProfanityAdminPageBuilder::ShowUpdateProfanityPage(CProfanityAdmin& PAdmin, const bool bIsSuperUser)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		PAdmin - reference to a CProfanityAdmin object
			bIsSuperUser - true if the viewing user is a superuser
Outputs:	-
Returns:	true on success
Purpose:	Generates the add profanity page by calling the relevant method inside 
			CProfanityAdmin. If adding to a group (indicated by the presence of the 
			'groupid' cgi param) then makes sure that the person is a superuser.
*********************************************************************************/

bool CProfanityAdminPageBuilder::ShowUpdateProfanityPage(CProfanityAdmin& PAdmin)
{
	// Send info to form in a Multistep
	//
	int iProfanityId = m_InputContext.GetParamInt("profanityid");
	if (!iProfanityId)
	{
		SetDNALastError("ProfanityAdminPageBuilder", "INPUTPARAMS", "Please provide a profanity id to edit");
		return false;
	}

	bool bReadyToUse;

	// Need to pass current values to Multistep
	//
	CProfanity profanity(m_InputContext);
	if (!profanity.Populate(iProfanityId))
	{
		CopyDNALastError("Profanity", profanity);
		return false;
	}

	CTDVString sProfanity			 = profanity.GetName();
	int iProfanityRating			 = profanity.GetRating();
	CTDVString sProfanityReplacement = profanity.GetReplacement();

	CreateAndProcessProfanityMultiStep(false, iProfanityId, sProfanity, iProfanityRating, sProfanityReplacement, bReadyToUse);

	return true;
}

/*********************************************************************************

	bool CProfanityAdminPageBuilder::UpdateProfanity(CProfanityAdmin& PAdmin)

	Author:		Nick Stevenson, David van Zijl
	Created:	13/01/2004
	Inputs:		PAdmin: instance of CProfanityAdmin
	Outputs:	-
	Returns:	true on success
	Purpose:	Get the profanity from the input params and calls the appropriate 
				function of the ProfanityAdmin object

*********************************************************************************/

bool CProfanityAdminPageBuilder::UpdateProfanity(CProfanityAdmin& PAdmin)
{
	// Get form info from MultiStep
	//
	bool bReadyToUse;
	int iProfanityId = 0;
	int iProfanityRating = 0;
	CTDVString sProfanity, sProfanityReplacement;
	CreateAndProcessProfanityMultiStep(false, iProfanityId, sProfanity, iProfanityRating, sProfanityReplacement, bReadyToUse);

	if (bReadyToUse)
	{
		// If the action is 'replace' then we need sProfanityReplacement
		//
		if (iProfanityRating == PROFANITY_RATING_REPLACE && sProfanityReplacement.IsEmpty())
		{
			// Do nothing, the page will reload with the new Multistep
			// and the person will have to be prompted for a replacement
			// in the XSL
		}
		else
		{
			if (iProfanityId <= 0)
			{
				// This can't be right
				//
				SetDNALastError("ProfanityAdminPageBuilder", "INPUTPARAMS", "Can't update profanity, bad ID provided");
				return false;
			}

			// Find out if the word is in a group list
			// and also get GroupId and SiteId to pass to SP
			//
			int iGroupId, iSiteId;
			if (!CheckProfanityAndPermissions(iProfanityId, iGroupId, iSiteId))
			{
				return false;
			}

			// Everything okay, update word
			//
			return PAdmin.UpdateProfanity(iProfanityId, iGroupId, iSiteId, sProfanity, iProfanityRating, sProfanityReplacement);
		}
	}

	return true;
}


/*********************************************************************************

	bool CProfanityAdminPageBuilder::DeleteProfanity(CProfanityAdmin& PAdmin)

	Author:		Nick Stevenson, David van Zijl
	Created:	13/01/2004
	Inputs:		PAdmin: instance of CProfanityAdmin
	Outputs:	-
	Returns:	false if the person has provided bad params or has insufficient
				permissions, true otherwise
	Purpose:	Get the profanity id from the input params and calls the appropriate 
				function of the ProfanityAdmin object. If deleting a group profanity 
				checks if the user is super

*********************************************************************************/

bool CProfanityAdminPageBuilder::DeleteProfanity(CProfanityAdmin& PAdmin)
{
	int iProfanityId = 0;
	if( m_InputContext.ParamExists("ProfanityId") )
	{
		iProfanityId = m_InputContext.GetParamInt("ProfanityId", iProfanityId);
	}
	
	if(iProfanityId <= 0)
	{
		SetDNALastError("ProfanityAdminPageBuilder", "INPUTPARAMS", "Bad (or no) profanity ID provided");
		return false;
	}

	// If it is a global or group val, make sure the person is a superuser
	//
	int iScrapGroupId, iScrapSiteId;
	if (!CheckProfanityAndPermissions(iProfanityId, iScrapGroupId, iScrapSiteId))
	{
		return false;
	}

	PAdmin.DeleteProfanity(iProfanityId);

	// Show group or site page next, depending on whether there is a groupid or not
	//
	bool bBusyWithGroup;
	int iGroupId = 0, iSiteId = 0;
	if (!GetGroupAndSiteIds(bBusyWithGroup, iGroupId, iSiteId))
	{
		return false;
	}

	if (bBusyWithGroup)
	{
		PAdmin.ShowGroupFilter(iGroupId);
	}
	else
	{
		ShowSiteFilter(PAdmin);
	}

	return true;
}


/*********************************************************************************

	bool CProfanityAdminPageBuilder::ShowSiteFilter(CProfanityAdmin& PAdmin)

	Author:		Nick Stevenson, David van Zijl
	Created:	13/01/2004
	Inputs:		PAdmin: instance of CProfanityAdmin
	Outputs:	-
	Returns:	true on success
	Purpose:	Shows all profanities for the current site. Calls a similarly named 
				method inside CProfanityAdmin to do this.

*********************************************************************************/

bool CProfanityAdminPageBuilder::ShowSiteFilter(CProfanityAdmin& PAdmin)
{
	// Pass the object the current SiteId and SiteName
	//
	int iSiteId = m_InputContext.GetSiteID();
	CTDVString sSiteName;
	m_InputContext.GetShortName(sSiteName, iSiteId);

	return PAdmin.ShowSiteFilter(iSiteId, sSiteName);
}


/*********************************************************************************
bool CProfanityAdminPageBuilder::DeleteGroup(CProfanityAdmin& PAdmin)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		PAdmin - Reference to CProfanityAdmin object
Outputs:	-
Returns:	true on success
Purpose:	Checks params and calls relevant method inside CProfanityAdmin to 
			delete a profanity group. Afterwards it displays the group list
*********************************************************************************/

/*
bool CProfanityAdminPageBuilder::DeleteGroup(CProfanityAdmin& PAdmin)
{
	// Make sure we have all the relevant params
	//
	if( !m_InputContext.ParamExists("GroupId") )
	{
		SetDNALastError("ProfanityAdminPageBuilder", "INPUTPARAMS", "Incorrect parameters passed for deleting profanity group");
		return false;
	}

	// Get the group details from the form
	//
	int iGroupId = m_InputContext.GetParamInt("GroupId");

	if (PAdmin.DeleteGroup(iGroupId))
	{
		// Successfully deleted, show group page
		//
		return PAdmin.ShowGroupList();
	}
	else
	{
		return false;
	}
}
*/


/*********************************************************************************
bool CProfanityAdminPageBuilder::ShowUpdateGroupPage(CProfanityAdmin& PAdmin)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		PAdmin - Reference to CProfanityAdmin object
Outputs:	-
Returns:	true on success
Purpose:	The group being edited will be added to the XML along with all DNA sites 
			that are not already included.
*********************************************************************************/

/*
bool CProfanityAdminPageBuilder::ShowUpdateGroupPage(CProfanityAdmin& PAdmin)
{
	// Get groupid param and add profanity group to XML
	//
	int iGroupId = m_InputContext.GetParamInt("groupid");

	if (!iGroupId) // Either no groupid param or they actually passed in 0
	{
		SetDNALastError("ProfanityAdminPageBuilder", "INPUTPARAMS", "Bad or missing groupid");
		return false;
	}

	// Get the group details so that we can pass them to AddGroupAndCompleteSiteList()
	// instead of adding profanityGroup to the XML right now and then adding the site list
	// separately (minus the sites already in this group)
	//
	CProfanityGroup profanityGroup(m_InputContext);
	if (!profanityGroup.Populate(iGroupId))
	{
		CopyDNALastError("ProfanityGroup", profanityGroup);
		return false;
	}

	CTDVString sGroupName, sGroupSites;
	
	sGroupName = profanityGroup.GetName();
	profanityGroup.GetSiteListAsCsv(sGroupSites);

	// Add multistep
	//
	bool bReadyToUse;
	CreateAndProcessGroupMultiStep(false, iGroupId, sGroupName, sGroupSites, bReadyToUse);

	// Add current group and sites from DB
	//
	PAdmin.AddGroupAndCompleteSiteList(iGroupId, sGroupName, sGroupSites);

	return true;
}

*/

/*********************************************************************************
bool CProfanityAdminPageBuilder::UpdateGroup(CProfanityAdmin& PAdmin)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		PAdmin - Reference to CProfanityAdmin object
Outputs:	-
Returns:	true on success
Purpose:	If a form has been submitted, checks params and calls relevant method 
			inside CProfanityAdmin to update a profanity group.
*********************************************************************************/

/*
bool CProfanityAdminPageBuilder::UpdateGroup(CProfanityAdmin& PAdmin)
{
	bool bReadyToUse = false;
	int iGroupId = 0;
	CTDVString sGroupName, sGroupSites;

	CreateAndProcessGroupMultiStep(false, iGroupId, sGroupName, sGroupSites, bReadyToUse);

	if (bReadyToUse)
	{
		PAdmin.UpdateGroup(iGroupId, sGroupName, sGroupSites);

		if (PAdmin.ErrorReported())
		{
			// Update failed: Send current group info and site list back to form
			PAdmin.AddGroupAndCompleteSiteList(iGroupId, sGroupName, sGroupSites);
		}
	}

	return true;
}
*/


/*********************************************************************************
bool CProfanityAdminPageBuilder::AddGroup(CProfanityAdmin& PAdmin)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		PAdmin - Reference to CProfanityAdmin object
Outputs:	-
Returns:	true on success
Purpose:	Checks params and calls relevant method inside CProfanityAdmin to 
			add a profanity group
*********************************************************************************/

/*

bool CProfanityAdminPageBuilder::AddGroup(CProfanityAdmin& PAdmin)
{
	bool bReadyToUse = false;
	int iGroupId = 0;
	CTDVString sGroupName, sGroupSites = "";

	CreateAndProcessGroupMultiStep(true, iGroupId, sGroupName, sGroupSites, bReadyToUse);

	if (bReadyToUse)
	{
		PAdmin.AddGroup(sGroupName, sGroupSites);
	}

	// Add sites from DB
	//
	PAdmin.AddGroupAndCompleteSiteList(iGroupId, sGroupName, sGroupSites);

	return true;
}

*/


/*********************************************************************************
bool CProfanityAdminPageBuilder::CreateAndProcessGroupMultiStep(const bool bIsNew, int& iGroupId, 
		CTDVString& sGroupName, CTDVString& sGroupSites, bool& bReadyToUse)
Author:		David van Zijl
Created:	12/08/2004
Inputs:		bIsNew - true if adding a profanity i.e. don't require id
			iGroupId - id of group if we are updating (ie bIsNew is false)
			sGroupName - profanity group name
			sGroupSites - CSV string of sites for group
Outputs:	bReadyToUse - true if an add or update is ready to be done
			iGroupId, sGroupName, sGroupSites
Returns:	true on success
Purpose:	Set MultiStep required fields for groups and add to XML. Process inputs and pass
			params back if multistep is ReadyToUse()
*********************************************************************************/

bool CProfanityAdminPageBuilder::CreateAndProcessGroupMultiStep(const bool bIsNew, int& iGroupId, 
		CTDVString& sGroupName, CTDVString& sGroupSites, bool& bReadyToUse)
{
	// Create Multistep
	//
	CMultiStep Multi(m_InputContext, "PROFANITYGROUP");

	if (!bIsNew)
	{
		CTDVString sGroupId = iGroupId;
		Multi.AddRequiredParam("GroupId", sGroupId);
	}
	Multi.AddRequiredParam("GroupName", sGroupName);
	Multi.AddRequiredParam("GroupSites", sGroupSites);

	// Read in parameters from URL or form
	//
	if (!Multi.ProcessInput())
	{
		SetDNALastError("ProfanityAdminPageBuilder","INPUTPARAMS","There were bad input parameters in creating the group");
	}
	m_pPage->AddInside("H2G2", Multi.GetAsXML());

	if (Multi.ReadyToUse())
	{
		bReadyToUse = true;

		// Make sure we have all the relevant params
		//
		bool bGotParams = true;
		if (!bIsNew)
		{
			// Get the group id as well
			//
			bGotParams = bGotParams && Multi.GetRequiredValue("GroupId", iGroupId);
		}
		bGotParams = bGotParams && Multi.GetRequiredValue("groupname", sGroupName);
		bGotParams = bGotParams && Multi.GetRequiredValue("groupsites", sGroupSites);

		return bGotParams;
	}

	return true;
}


/*********************************************************************************
bool CProfanityAdminPageBuilder::CreateAndProcessProfanityMultiStep(const bool bIsNew, int& iProfanityId, 
		CTDVString& sProfanity, int& iProfanityRating, CTDVString& sProfanityReplacement, bool& bReadyToUse)
Author:		David van Zijl
Created:	12/08/2004
Inputs:		bIsNew - true if adding a profanity i.e. don't require id
			iProfanityId - id of group if we are updating (ie bIsNew is false)
			sProfanity - profanity
			iProfanityRating - action for profanity (see CProfanity for allowed types)
			sProfanityReplacement - string that profanity is to be replaced with if rating is 'replace'
Outputs:	bReadyToUse - true if an add or update is ready to be done
			iProfanityId, sProfanity, sProfanityRating, sProfanityReplacement
Returns:	true on success
Purpose:	Set MultiStep required fields for profanities and add to XML. Process inputs and pass
			params back if multistep is ReadyToUse()
*********************************************************************************/

bool CProfanityAdminPageBuilder::CreateAndProcessProfanityMultiStep(const bool bIsNew, int& iProfanityId, 
		CTDVString& sProfanity, int& iProfanityRating, CTDVString& sProfanityReplacement, bool& bReadyToUse)
{
	bool bOk = true;

	// Create Multistep
	//
	CMultiStep Multi(m_InputContext, "PROFANITY");

	// Turn profanity rating into string for xsl
	//
	CTDVString sProfanityRating;
	bOk = bOk && CProfanity::GetRatingAsString(iProfanityRating, sProfanityRating);

	if (!bIsNew)
	{
		CTDVString sProfanityId = iProfanityId;
		Multi.AddRequiredParam("ProfanityId", sProfanityId);
	}
	Multi.AddRequiredParam("Profanity", sProfanity);
	Multi.AddRequiredParam("ProfanityRating", sProfanityRating);
	Multi.AddRequiredParam("ProfanityReplacement", sProfanityReplacement);

	// Read in parameters from URL or form
	//
	if (!Multi.ProcessInput())
	{
		SetDNALastError("ProfanityAdminPageBuilder","INPUTPARAMS","There were bad input parameters in creating the profanity");
	}
	m_pPage->AddInside("H2G2", Multi.GetAsXML());

	if (Multi.ReadyToUse())
	{
		bReadyToUse = true;

		// Make sure we have all the relevant params
		//
		bool bGotParams = true;
		if (!bIsNew)
		{
			// Get the profanity id as well
			//
			bGotParams = bGotParams && Multi.GetRequiredValue("ProfanityId", iProfanityId);
		}
		bGotParams = bGotParams && Multi.GetRequiredValue("Profanity", sProfanity);
		bGotParams = bGotParams && Multi.GetRequiredValue("ProfanityRating", sProfanityRating);
		bGotParams = bGotParams && Multi.GetRequiredValue("ProfanityReplacement", sProfanityReplacement);

		// Make profanity rating numeric before we send it back
		//
		bGotParams = bGotParams && CProfanity::GetRatingAsInt(sProfanityRating, iProfanityRating);

		return bGotParams;
	}

	return true;
}


/*********************************************************************************
bool CProfanityAdminPageBuilder::ShowGroupFilter(CProfanityAdmin& PAdmin)
Author:		David van Zijl
Created:	12/08/2004
Inputs:		PAdmin - reference to a CProfanityAdmin object
Outputs:	-
Returns:	true on success
Purpose:	Show profanities for a group. Calls relevant method inside CProfanityAdmin
*********************************************************************************/

bool CProfanityAdminPageBuilder::ShowGroupFilter(CProfanityAdmin& PAdmin)
{
	// Make sure we have all the relevant params
	//
	if( !m_InputContext.ParamExists("GroupId") )
	{
		SetDNALastError("ProfanityAdmin","INPUTPARAMS","Please supply a GroupId");
		return false;
	}

	// Get the group details from the form
	//
	int iGroupId = m_InputContext.GetParamInt("GroupId");

	return PAdmin.ShowGroupFilter(iGroupId);
}


/*********************************************************************************
bool CProfanityAdminPageBuilder::GetGroupAndSiteIds(bool& bAddingToGroup, int& iGroupId, int& iSiteId)
Author:		David van Zijl
Created:	21/08/2004
Inputs:		-
Outputs:	bAddingtoGroup - true if a profanity is being added to a group
			iGroupId - id of profanity group (can be 0 for global)
			iSiteId - id of current site or 0 if we're adding to a group
Returns:	false if current user doesn't have the correct permissions, true otherwise
Purpose:	Determines of we are currently adding to a group or a site. Passes back
			the necessary IDs as well.
*********************************************************************************/

bool CProfanityAdminPageBuilder::GetGroupAndSiteIds(bool& bAddingToGroup, int& iGroupId, int& iSiteId)
{
	// If we have a groupid param then we know we are adding to the current group
	//
	if (m_InputContext.ParamExists("GroupId"))
	{
		if (!CheckIsSuperUser())
		{
			return false;
		}
		bAddingToGroup = true;
		iGroupId = m_InputContext.GetParamInt("GroupId");
		iSiteId = 0;
	}
	else
	{
		// Else we are adding to the current site
		bAddingToGroup = false;
		iGroupId = 0;
		iSiteId = m_InputContext.GetSiteID();
	}

	return true;
}
#endif

/*********************************************************************************
bool CProfanityAdminPageBuilder::CheckIsSuperUser()
Author:		David van Zijl
Created:	26/08/2004
Inputs:		-
Outputs:	-
Returns:	true if user is a super user
Purpose:	Checks that the current viewing user is a SuperUser. If it fails then
			it will call SetDNALastError so only use this when the person HAS to be
			a superuser
*********************************************************************************/

bool CProfanityAdminPageBuilder::CheckIsSuperUser()
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (pViewingUser == NULL)
	{
		return false;
	}

	if (!pViewingUser->GetIsSuperuser())
	{
		SetDNALastError("ProfanityAdminPageBuilder", "INVALIDUSER", "Only super users can access this functionality");
		return false;
	}

	return true;
}

#if 0
/*********************************************************************************
bool CProfanityAdminPageBuilder::CheckProfanityAndPermissions(const int iProfanityId, int& iGroupId, int& iSiteId)
Author:		David van Zijl
Created:	03/09/2004
Inputs:		iProfanityId - ID of profanity
Outputs:	iGroupId - Group that word belongs to
			iSiteId - Site that word belongs to
Returns:	true if profanity exists and viewing user has proper permissions
Purpose:	Checks if profanity exists and if it belongs to a group, checks that 
			the viewing user is a superuser.
*********************************************************************************/

bool CProfanityAdminPageBuilder::CheckProfanityAndPermissions(const int iProfanityId, int& iGroupId, int& iSiteId)
{
	CProfanity profanity(m_InputContext);
	if (profanity.Populate(iProfanityId))
	{
		if (profanity.GetSiteId() == 0)
		{
			// Group word allright, check SuperUser status
			//
			if (!CheckIsSuperUser())
			{
				return false;
			}
		}
	}
	else
	{
		SetDNALastError("ProfanityAdminPageBuilder", "INPUTPARAMS", "No profanity found for that id");
		return false;
	}

	// Return some values
	//
	iGroupId = profanity.GetGroupId();
	iSiteId = profanity.GetSiteId();
	return true;
}

#endif