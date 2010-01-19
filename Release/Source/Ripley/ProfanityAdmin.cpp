// ProfanityAdmin.cpp: implementation of the CProfanityAdmin class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ProfanityAdmin.h"
#include "ProfanityList.h"
#include "ProfanityGroup.h"
#include "ProfanityGroupList.h"
#include "Site.h"
#include "XMLStringUtils.h"
#include "tdvassert.h"
#include "StoredProcedure.h"
#include "ModerationClasses.h"

#include <vector>

/*********************************************************************************
CProfanityAdmin::CProfanityAdmin(CInputContext& inputContext)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/

CProfanityAdmin::CProfanityAdmin(CInputContext& inputContext) :
	CXMLObject(inputContext), m_profanityList(inputContext)
{
}


/*********************************************************************************
CProfanityAdmin::~CProfanityAdmin()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/

CProfanityAdmin::~CProfanityAdmin()
{
	Clear();
}

/*********************************************************************************

	void CProfanityAdmin::Clear()

	Author:		Nick Stevenson
	Created:	21/01/2004
	Inputs:		-
	Outputs:	-
	Returns:	void
	Purpose:	deletes and makes null the Tree pointer, clearing the page

*********************************************************************************/

void CProfanityAdmin::Clear()
{
	if(m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
}


/*********************************************************************************

	bool CProfanityAdmin::Create(const TDVCHAR* pAction)

	Author:		Nick Stevenson, David van Zijl
	Created:	21/01/2004
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	calls a function to create the 'ProfanityAdmin' page element

*********************************************************************************/

bool CProfanityAdmin::Create(const TDVCHAR* pAction)
{
	if(m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML);

	int iModClassID = m_InputContext.GetParamInt("modclassid");

	OpenXMLTag("PROFANITYADMIN");
	OpenXMLTag("ACTION", true);
	AddXMLIntAttribute("MODCLASSID", iModClassID, true);
	CloseXMLTag("ACTION", pAction);
	//AddXMLTag("ACTION", pAction);
	CloseXMLTag("PROFANITYADMIN");

	if (!CreateFromXMLText(sXML))
	{
		SetDNALastError("ProfanityAdmin", "INPUTPARAMS", "Bad action parameter passed");
		return false;
	}

	m_profanityList.GetProfanities();
	AddInsideSelf(&m_profanityList);

	CModerationClasses moderationClasses(m_InputContext);
	moderationClasses.GetModerationClasses();
	AddInsideSelf(&moderationClasses);

	return true;
}

#if 0
/*********************************************************************************

	bool CProfanityAdmin::AddGroupOrSiteDetails(const int iId, const bool bIsSite, const TDVCHAR* pSiteName)

	Author:		David van Zijl
	Created:	26/08/2004
	Inputs:		iID - current group or site ID
				bIsSite - true if iId refers to a site
				pSiteName - name of current site (only necessary if bIsSite is true)
	Outputs:	-
	Returns:	true
	Purpose:	Adds the current site or group details to the current object 
				XML root node

*********************************************************************************/

bool CProfanityAdmin::AddGroupOrSiteDetails(const int iId, const bool bIsSite, const TDVCHAR* pSiteName)
{
	// Are they adding to a site or a group?
	// The page might want to inform the user
	//
	if (bIsSite)
	{
		return AddCurrentSiteDetails(iId, pSiteName);
	}
	else
	{
		return AddCurrentGroupDetails(iId);
	}
}


/*********************************************************************************

	bool CProfanityAdmin::AddProfanity(const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, 
									   const int iProfanityRating, const TDVCHAR* pProfanityReplacement)

	Author:		Nick Stevenson, David van Zijl
	Created:	15/01/2004
	Inputs:		pProfanity - expresses the profane word
				iProfanityRating - action to take (see CProfanity)
				pProfanityReplacement - word to replace profanity with
	Outputs:	-
	Returns:	true on success
	Purpose:	Generates a new page, calls the appropriate stored procedure to add
				the profanity to the DB, obtains the list of all existing profanities
				including the new one and builds the page XML, adding it to the object

*********************************************************************************/

bool CProfanityAdmin::AddProfanity(const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, 
								   const int iProfanityRating, const TDVCHAR* pProfanityReplacement)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (pProfanity == NULL || pProfanity[0] == 0 || iProfanityRating == 0)
	{
		SetDNALastError("ProfanityAdmin", "INPUTPARAMS", "Bad parameters for profanity / profanityrating passed");
		return false;
	}

	//TODO:: Update to reflect changed signature
	/*
	if (!SP.AddNewProfanity(iGroupId, iSiteId, pProfanity, iProfanityRating, pProfanityReplacement))
	{
		SetDNALastError("ProfanityAdmin","DATABASE","An Error Occurred while accessing the database");
		return false;
	}
	*/

	// Was it a duplicate?
	//
	if (SP.GetIntField("Duplicate") == 1)
	{
		ShowDuplicateProfanityError(SP);
		return false;
	}
	else
	{
		// Show confirmation
		//
		AddProfanityInfoTag("ADDED_PROFANITY", SP.GetIntField("ProfanityId"), pProfanity, iProfanityRating, pProfanityReplacement, iGroupId, iSiteId);
		return true;
	}
}


/*********************************************************************************

	bool CProfanityAdmin::UpdateProfanity(const int iProfanityId, const TDVCHAR* pProfanity, 
									   const int iProfanityRating, const TDVCHAR* pProfanityReplacement)

	Author:		David van Zijl
	Created:	24/08/2004
	Inputs:		pProfanity - expresses the profane word
				iProfanityRating - action to take (see CProfanity)
				pProfanityReplacement - word to replace profanity with
	Outputs:	-
	Returns:	true on success
	Purpose:	Generates a new page, calls the appropriate stored procedure to add
				the profanity to the DB, obtains the list of all existing profanities
				including the new one and builds the page XML, adding it to the object

*********************************************************************************/

bool CProfanityAdmin::UpdateProfanity(const int iProfanityId, const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, 
								   const int iProfanityRating, const TDVCHAR* pProfanityReplacement)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (pProfanity == NULL || pProfanity[0] == 0 || iProfanityRating == 0)
	{
		SetDNALastError("ProfanityAdmin", "INPUTPARAMS", "Bad parameters for profanity / profanityrating passed");
		return false;
	}

	if (!SP.UpdateProfanity(iProfanityId, iGroupId, iSiteId, pProfanity, iProfanityRating, pProfanityReplacement))
	{
		SetDNALastError("ProfanityAdmin","DATABASE","An Error Occurred while accessing the database");
		return false;
	}

	// Was it a duplicate?
	//
	if (SP.GetIntField("Duplicate") == 1)
	{
		ShowDuplicateProfanityError(SP);
		return false;
	}
	else
	{
		// Show confirmation
		//
		AddProfanityInfoTag("UPDATED_PROFANITY", iProfanityId, pProfanity, iProfanityRating, pProfanityReplacement, iGroupId, iSiteId);
		return true;
	}
}


/*********************************************************************************

	bool CProfanityAdmin::DeleteProfanity(const int iProfID)

	Author:		Nick Stevenson, David van Zijl
	Created:	16/01/2004
	Inputs:		iProfID: int expressing an id associated with a profanity in the DB
	Outputs:	-
	Returns:	bool
	Purpose:	Creates new XML for page, calls the appropriate stored procedure for
				deleting the row specified by the id, obtains a list of all profanities
				in the DB and builds the page XML

*********************************************************************************/

bool CProfanityAdmin::DeleteProfanity(const int iProfanityId)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.DeleteProfanity(iProfanityId))
	{
		SetDNALastError("ProfanityAdmin","DATABASE","An Error Occurred while accessing the database");
		return false;
	}

	// Show confirmation
	//
	CTDVString sXML;

	InitialiseXMLBuilder(&sXML);
	OpenXMLTag("DELETED_PROFANITY");
	AddXMLIntTag("SUCCESS", 1);
	CloseXMLTag("DELETED_PROFANITY");

	AddInsideSelf(sXML);

	return true;
}


/*********************************************************************************

	bool CProfanityAdmin::AddProfanityInfoTag(const TDVCHAR* pContainerText, const int iProfanityId, 
				const TDVCHAR* pProfanity, const int iRating = 0, const TDVCHAR* pReplacement = NULL,
				const int iGroupId = -1, const int iSiteId = -1)

	Author:		David van Zijl
	Created:	24/08/2004
	Inputs:		pContainerText - text for container node eg "DUPLICATE_PROFANITY"
				iProfanityId - profanity information
				pProfanity - profanity information
				iRating - profanity information (can be left out)
				pReplacement - profanity information (can be left out)
				iGroupId - profanity information (can be left out)
				iSiteId - profanity information (can be left out)
	Outputs:	-
	Returns:	true on success
	Purpose:	Adds container tag inside main XML tree and creates a profanity object inside it

*********************************************************************************/

bool CProfanityAdmin::AddProfanityInfoTag(const TDVCHAR* pContainerText, const int iProfanityId, 
				const TDVCHAR* pProfanity, const int iRating, const TDVCHAR* pReplacement,
				const int iGroupId, const int iSiteId)
{
	CTDVString sContainerTagXML;
	sContainerTagXML << "<" << pContainerText << " />";
	AddInsideSelf(sContainerTagXML);

	CProfanity profanityInfo(m_InputContext);
	profanityInfo.SetId( iProfanityId );
	profanityInfo.SetName( pProfanity );
	if (iRating != 0)
	{
		profanityInfo.SetRating( iRating );
	}
	if (pReplacement != NULL && pReplacement[0] != 0)
	{
		profanityInfo.SetReplacement( pReplacement );
	}
	if (iGroupId != -1)
	{
		profanityInfo.SetGroupId( iGroupId );
	}
	if (iSiteId != -1)
	{
		profanityInfo.SetSiteId( iSiteId );
	}

	return AddInside(pContainerText, profanityInfo.GetAsXML());
}

/*********************************************************************************

	bool CProfanityAdmin::ShowGroupList()

	Author:		David van Zijl
	Created:	10/08/2004
	Inputs:		-
	Outputs:	-
	Returns:	true on success
	Purpose:	Show all groups along with list of sites for each one. The list 
				will be added to the PROFANITYADMIN node

*********************************************************************************/

bool CProfanityAdmin::ShowGroupList()
{
	CProfanityGroupList profanityGroupList(m_InputContext);
	profanityGroupList.PopulateList();

	AddInsideSelf(profanityGroupList.GetAsXML());
	return true;
}


/*********************************************************************************

	bool CProfanityAdmin::ShowGroupFilter(const int iGroupId)

	Author:		David van Zijl
	Created:	10/08/2004
	Inputs:		iGroupId - ID of profanity group
	Outputs:	-
	Returns:	true on success
	Purpose:	Show profanities for current group only

*********************************************************************************/

bool CProfanityAdmin::ShowGroupFilter(const int iGroupId)
{
	AddCurrentGroupDetails(iGroupId);

	// Get profanity list for group
	//
	CProfanityList profanityList(m_InputContext);
	//profanityList.PopulateListForGroup(iGroupId);

	//TODO:: DJW - Update with changes to profanity admin system.
	//AddInsideSelf(profanityList.GetAsXML());

	return true;
}

/*********************************************************************************

	bool CProfanityAdmin::ShowSiteFilter(const int iSiteId, const TDVCHAR* pSiteName)

	Author:		Nick Stevenson, David van Zijl
	Created:	16/01/2004
	Inputs:		-
	Outputs:	-
	Returns:	true on success
	Purpose:	Calls function to obtain list of profanities in the DB as an XML string.
				The XML string is added to the page.

*********************************************************************************/

bool CProfanityAdmin::ShowSiteFilter(const int iSiteId, const TDVCHAR* pSiteName)
{
	AddCurrentSiteDetails(iSiteId, pSiteName);

	// Add list of profanities relevant to this site
	// Will include global and group profanities
	//
	return AddSiteProfanityList(iSiteId);
}


/*********************************************************************************

	bool CProfanityAdmin::AddSiteProfanityList(const int iSiteId)

	Author:		Nick Stevenson, David van Zijl
	Created:	19/01/2004
	Inputs:		iSiteId - Site to get profanities for
	Outputs:	-
	Returns:	true always
	Purpose:	Empties the string ref is it isn't empty, makes a request to a stored
				procedure to obtain the complete profanity listing. The data is added to
				the string ref as XML.

*********************************************************************************/

bool CProfanityAdmin::AddSiteProfanityList(const int iSiteId)
{
	CProfanityList profanityList(m_InputContext);
	//profanityList.PopulateListForSite(iSiteId);

	//TODO:: DJW - Update with changes to profanity admin system.
	//AddInsideSelf(profanityList.GetAsXML());

	return true;
}


/*********************************************************************************

	bool CProfanityAdmin::AddGroupAndCompleteSiteList(const int iGroupId, const TDVCHAR* sGroupName, const TDVCHAR* sGroupSites)
	
	Author:		David van Zijl
	Created:	31/08/2004
	Inputs:		iGroupId - ID of profanity group we're editing or 0 for new
				sGroupName - Name of profanity group
				sGroupSites - CSV string of site ids in this group
	Outputs:	-
	Returns:	true on success
	Purpose:	Adds group information to the XML along with all DNA sites that
				aren't already in the group.

*********************************************************************************/

bool CProfanityAdmin::AddGroupAndCompleteSiteList(const int iGroupId, const TDVCHAR* pGroupName, const TDVCHAR* pGroupSites)
{
	// Generate a profanity group from params
	//
	CProfanityGroup profanityGroup(m_InputContext);
	profanityGroup.SetId(iGroupId);
	profanityGroup.SetName(pGroupName);

	// Generate list of all sites
	//
	CBasicSiteList basicSiteList(m_InputContext, "NONGROUPSITES");
	if (!basicSiteList.PopulateList())
	{
		CopyDNALastError("BasicSiteList", basicSiteList);
		return false;
	}

	// If we have sGroupSites then it means we are busy
	// adding or updating so these sites need to be removed
	// from the complete list and added to the group list
	//
	if (pGroupSites != NULL && pGroupSites[0] != 0)
	{
		std::vector<int> vGroupSites;
		std::vector<int>::iterator i;

		CXMLStringUtils::SplitCsvIntoInts(pGroupSites, vGroupSites);

		CSite movingSite;

		// Loop through sites that are supposed to be in the group
		//
		for (i = vGroupSites.begin(); i != vGroupSites.end(); i++)
		{
			if (basicSiteList.CutSite(*i, movingSite))
			{
				profanityGroup.AddSite(movingSite);
			}
		}
	}

	AddInsideSelf(profanityGroup.GetAsXML());
	AddInsideSelf(basicSiteList.GetAsXML());

	return true;
}


/*********************************************************************************

	bool CProfanityAdmin::AddCompleteSiteList(const TDVCHAR* pExcludeSites)
	
	Author:		David van Zijl
	Created:	19/08/2004
	Inputs:		pExcludeSites - CSV string of sites to exclude from list
	Outputs:	-
	Returns:	true on success
	Purpose:	Adds all DNA sites to the XML. If pExcludeSites is specified then 
				those sites will be left out. The idea is that this list is all 
				sites NOT in the current group

*********************************************************************************/

bool CProfanityAdmin::AddCompleteSiteList(const TDVCHAR* pExcludeSites)
{
	CTDVString sXML;

	// Generate list of all sites
	CBasicSiteList basicSiteList(m_InputContext, "NONGROUPSITES");
	basicSiteList.PopulateList();

	AddInsideSelf(basicSiteList.GetAsXML());

	return true;
}


/*********************************************************************************

	bool CProfanityAdmin::AddGroup(const TDVCHAR* pGroupName, const TDVCHAR* pGroupSites)

	Author:		David van Zijl
	Created:	15/08/2004
	Inputs:		pGroupName - name of new profanity group
				pGroupSites - CSV string of all all sites to be in this group
	Outputs:	-
	Returns:	true if group successfully added
	Purpose:	Adds new group to the DB. Also adds all sites that belong inside it

*********************************************************************************/

/*
bool CProfanityAdmin::AddGroup(const TDVCHAR* pGroupName, const TDVCHAR* pGroupSites)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	int iNewGroupId = 0;
	bool bAlreadyExists = false;

	if(pGroupName == NULL || pGroupName[0] == 0)
	{
		SetDNALastError("ProfanityAdmin", "INPUTPARAMS", "Please supply a group name");
		return false;
	}

	// Added 15/10/2004 when specifically requested:
	if(pGroupSites == NULL || pGroupSites[0] == 0)
	{
		SetDNALastError("ProfanityAdmin", "INPUTPARAMS", "The new group has to contain at least 1 site");
		return false;
	}

	if (!SP.CreateNewProfanityGroup(pGroupName))
	{
		SetDNALastError("ProfanityAdmin","DATABASE","Failure inside SP.AddNewProfanity");
		return false;
	}

	iNewGroupId = SP.GetIntField("GroupID");
	bAlreadyExists = SP.GetIntField("AlreadyExists") > 0 ? true : false;

	if (bAlreadyExists)
	{
		SetDNALastError("ProfanityAdmin","DUPLICATE","A group by that name already exists");
		return false;
	}
	if (iNewGroupId == 0)
	{
		// Eh? Insert succeeded but we don't have the new group id
		//
		SetDNALastError("ProfanityAdmin","DATABASE","Insert succeeded but we have 0 for new group id");
		return false;
	}

	// Add any sites for this group
	//
	CProfanityGroup profanityGroup(m_InputContext);
	profanityGroup.SetId(iNewGroupId);
	profanityGroup.SetName(pGroupName);

	SetSiteListForGroup(SP, profanityGroup, iNewGroupId, pGroupSites);

	// Refresh site list for profanity group from DB for a confirmation page
	// and add to XML
	//
	profanityGroup.PopulateList(iNewGroupId);

	AddInsideSelf("<ADDED_GROUP />");
	AddInside("ADDED_GROUP", profanityGroup.GetAsXML());

	return true;
}

*/


/*********************************************************************************

	bool CProfanityAdmin::SetSiteListForGroup(CStoredProcedure& SP, CProfanityGroup& profanityGroup, const int iGroupId, const TDVCHAR* pGroupSites)

	Author:		David van Zijl
	Created:	15/08/2004
	Inputs:		SP - Ref to existing CStoredProcedure object
				profanityGroup - reference to a profanity group (pre-populated with ID and sites)
				pGroupSites - CSV string of all all sites to be in this group
	Outputs:	-
	Returns:	true on success
	Purpose:	This ugly method will compare the new site list to the old one and
				add or delete sites as necessary.

*********************************************************************************/

/*
bool CProfanityAdmin::SetSiteListForGroup(CStoredProcedure& SP, CProfanityGroup& profanityGroup, const int iGroupId, const TDVCHAR* pGroupSites)
{
	bool bOk = true;

	// Because we need to do extra work each time a site is added to a
	// group, I'm comparing the new list to the current list instead of
	// just wiping the list and adding each one which would be simpler but
	// at the expense of doing a lot of work when somebody makes very small 
	// changes to a large site list

	// Make CGI param for new sites into a vector and check for errors
	//
	std::vector<int> intendedSites;
	std::vector<int>::iterator i;
	CXMLStringUtils::SplitCsvIntoInts(pGroupSites, intendedSites);

	for (i = intendedSites.begin(); i != intendedSites.end(); i++)
	{
		if (*i <= 0)
		{
			SetDNALastError("ProfanityAdmin", "INPUTPARAMS", "Could not complete operation - bad SiteId passed as param");
			return false;
		}
	}

	// Get map of all existing sites for this group
	// please note that profanityGroup should already be populated
	// before calling this method
	//
	std::map<int, bool> existingSites;
	std::map<int, bool>::iterator exists;
	profanityGroup.GetSiteListAsMap(existingSites);

	if (intendedSites.size() > 0)
	{
		// Loop through new sites in string and add if it is
		// not in the existing list of sites
		//
		std::vector<int>::iterator i;
		for (i = intendedSites.begin(); i != intendedSites.end(); i++)
		{
			exists = existingSites.find(*i);
			if (exists == existingSites.end())
			{
				// Doesn't exist
				//
				bOk = bOk && SP.AddSiteToProfanityGroup(iGroupId, *i);
			}
			else
			{
				// Already there, mark it so that it doesn't get deleted later
				//
				exists->second = false;
			}
		}
	}

	// Now go through all existing sites that weren't in the new list (will still be marked as 'true')
	//
	if (bOk)
	{
		for (exists = existingSites.begin(); exists != existingSites.end(); exists++)
		{
			if (exists->second == true)
			{
				bOk = bOk && SP.RemoveSiteFromProfanityGroup(exists->first);
				exists = existingSites.erase(exists);
			}
		}
	}

	return bOk;
}

*/

/*********************************************************************************

	bool CProfanityAdmin::UpdateGroup(const int iGroupId, const TDVCHAR* pGroupName, const TDVCHAR* pGroupSites)

	Author:		David van Zijl
	Created:	15/08/2004
	Inputs:		iGroupId - ID of group we are updating
				pGroupName - name of new profanity group
				pGroupSites - CSV string of all all sites to be in this group
	Outputs:	-
	Returns:	true on success
	Purpose:	Adds new group to the DB. Also adds all sites that belong inside it

*********************************************************************************/

/*
bool CProfanityAdmin::UpdateGroup(const int iGroupId, const TDVCHAR* pGroupName, const TDVCHAR* pGroupSites)
{
	if (iGroupId == 0)
	{
		SetDNALastError("CProfanityAdmin", "INPUTPARAMS", "0 GroupId passed as param. Cannot update global group!");
		return false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.UpdateProfanityGroup(iGroupId, pGroupName))
	{
		SetDNALastError("CProfanityAdmin", "DATABASE", "Failure inside SP.AddNewProfanity");
		return false;
	}

	if (SP.GetIntField("Duplicate") == 1)
	{
		// The new group name conflicts with another group
		//
		SetDNALastError("ProfanityAdmin", "DUPLICATE", "That name is already being used by another group");
		return false;
	}

	// Update this group's sites
	//
	CProfanityGroup profanityGroup(m_InputContext);
	profanityGroup.SetId(iGroupId);
	profanityGroup.SetName(pGroupName);
	profanityGroup.PopulateList(iGroupId);

	SetSiteListForGroup(SP, profanityGroup, iGroupId, pGroupSites);

	// Refresh site list for profanity group from DB for a confirmation page
	// and add to XML
	//
	profanityGroup.PopulateList(iGroupId);

	AddInsideSelf("<UPDATED_GROUP />");
	AddInside("UPDATED_GROUP", profanityGroup.GetAsXML());

	return true;
}

*/


/*********************************************************************************

	bool CProfanityAdmin::DeleteGroup(const int iGroupId)

	Author:		David van Zijl
	Created:	20/08/2004
	Inputs:		iGroupId - ID of group we are deleting
	Outputs:	-
	Returns:	true on success
	Purpose:	Deletes group to the DB. Also deletes all sites that belong inside it

*********************************************************************************/

/*
bool CProfanityAdmin::DeleteGroup(const int iGroupId)
{
	if (iGroupId <= 0)
	{
		SetDNALastError("ProfanityAdmin", "INPUTPARAMS", "Bad group id passed as param");
		return false;
	}

	// Get group details before we delete them
	// So the user can see what they have done
	//
	CProfanityGroup profanityGroup(m_InputContext);
	if (!profanityGroup.Populate(iGroupId))
	{
		CopyDNALastError("ProfanityGroup", profanityGroup);
		return false;
	}

	// Run SP
	//
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.DeleteProfanityGroup(iGroupId))
	{
		SetDNALastError("CProfanityAdmin","DATABASE","Failure inside SP.DeleteProfanityGroup");
		return false;
	}

	// Show confirmation
	//
	AddInsideSelf("<DELETED_GROUP />");
	AddInside("DELETED_GROUP", profanityGroup.GetAsXML());

	return true;
}
*/


/*********************************************************************************

	bool CProfanityAdmin::AddCurrentGroupDetails(const int iGroupId)

	Author:		David van Zijl
	Created:	20/08/2004
	Inputs:		iGroupId - ID of group we are busy with
	Outputs:	-
	Returns:	true on success
	Purpose:	Adds groups details to the object XML root node

*********************************************************************************/

bool CProfanityAdmin::AddCurrentGroupDetails(const int iGroupId)
{
	CTDVString sGroupName, sGroupSites;
	return AddCurrentGroupDetails(iGroupId, false, sGroupName, sGroupSites);
}


/*********************************************************************************

	bool CProfanityAdmin::AddCurrentGroupDetails(const int iGroupId, bool bReturnInfo, 
			CTDVString& sGroupName, CTDVString& sGroupSites)

	Author:		David van Zijl
	Created:	20/08/2004
	Inputs:		iGroupId - ID of group we are deleting
				bReturnInfo - true if values generated need to be passed back
	Outputs:	sGroupName (if bReturnInfo is true) - name of profanity group
				sGroupSites (if bReturnInfo is true) - CSV string of group sites
	Returns:	true on success
	Purpose:	Adds groups details to the object XML root node. Values for the 
				profanity group will be passed back if bReturnInfo is true

*********************************************************************************/

bool CProfanityAdmin::AddCurrentGroupDetails(const int iGroupId, bool bReturnInfo, CTDVString& sGroupName, CTDVString& sGroupSites)
{
	// Create new group and add it to the XML
	//
	CTDVString sXML;
	CProfanityGroup profanityGroup(m_InputContext);
	if (profanityGroup.Populate(iGroupId))
	{
		AddInsideSelf(profanityGroup.GetAsXML());
	}
	else
	{
		CopyDNALastError("ProfanityGroup", profanityGroup);
		return false;
	}

	// Do we need to send group details back?
	//
	if (bReturnInfo)
	{
		sGroupName = profanityGroup.GetName();
		profanityGroup.GetSiteListAsCsv(sGroupSites);
	}

	return true;
}

/*********************************************************************************

	bool CProfanityAdmin::AddCurrentSiteDetails(const int iSiteId, const TDVCHAR* pSiteName)

	Author:		David van Zijl
	Created:	20/08/2004
	Inputs:		iSiteId - ID of current site
				pSiteName - Name of current site
	Outputs:	-
	Returns:	true on success
	Purpose:	Adds current site details to the current object XML root node

*********************************************************************************/

bool CProfanityAdmin::AddCurrentSiteDetails(const int iSiteId, const TDVCHAR* pSiteName)
{
	if (iSiteId == 0 || pSiteName == NULL || pSiteName[0] == 0)
	{
		return false;
	}

	// Add current site details to XML
	//
	CTDVString sXML;
	CSite currentSite;
	currentSite.SetId(iSiteId);
	currentSite.SetName(pSiteName);

	AddInsideSelf(currentSite.GetAsXML());
	return true;
}


/*********************************************************************************
void CProfanityAdmin::ShowDuplicateProfanityError(CStoredProcedure& SP)
Author:		David van Zijl
Created:	12/10/2004
Inputs:		SP - reference to CStoredProcedure object
Outputs:	-
Returns:	-
Purpose:	Called when a duplicate profanity has occurred. Sets DNALastError
			to DUPLICATE and also adds a DUPLICATE_PROFANITY tag to the XML 
			with the conficting profanity inside it (from the SP)
*********************************************************************************/

void CProfanityAdmin::ShowDuplicateProfanityError(CStoredProcedure& SP)
{
	SetDNALastError("ProfanityAdmin", "DUPLICATE", "That word conflicts with another word in the system");

	// Add offending profanity inside a DUPLICATE_PROFANITY tag
	//
	int iDupProfanityId = SP.GetIntField("ProfanityID");
	int iDupProfanityRating = SP.GetIntField("Rating");
	int iDupGroupId = SP.GetIntField("GroupID");
	int iDupSiteId = SP.GetIntField("SiteID");

	CTDVString sDupProfanity, sDupProfanityReplacement;
	SP.GetField("Profanity", sDupProfanity);
	SP.GetField("ProfanityReplacement", sDupProfanityReplacement);

	AddProfanityInfoTag("DUPLICATE_PROFANITY", iDupProfanityId, sDupProfanity, iDupProfanityRating, sDupProfanityReplacement, iDupGroupId, iDupSiteId);
}
#endif

bool CProfanityAdmin::ProcessProfanities(void)
{
	CTDVString sAction;
	m_InputContext.GetParamString("action", sAction);

	if (sAction.CompareText("importprofanities"))
	{
		ImportProfanityList();
	}
	else if (sAction.CompareText("addprofanities"))
	{
		AddProfanities();
	}
	else if (sAction.CompareText("updateprofanities"))
	{
		int iProfanityCount = m_InputContext.GetParamCount("profanity");
		for (int i = 0; i < iProfanityCount; i++)
		{
			int iProfanityEdited = m_InputContext.GetParamInt("profanityedited", i);
			
			if (iProfanityEdited > 0)
			{
				CTDVString sProfanity;
				m_InputContext.GetParamString("profanity", sProfanity, i);
				CTDVString sDelete;
				m_InputContext.GetParamString("delete", sDelete, i);
				int iRefer = 0;
				CTDVString sRefer;
				m_InputContext.GetParamString("refer", sRefer, i);
				if (sRefer.CompareText("on"))
				{
					iRefer = 1;
				}
				int iProfanityId;
				iProfanityId = m_InputContext.GetParamInt("profanityid", i);
				int iModClassId;
				iModClassId = m_InputContext.GetParamInt("modclassid", i);
				if (sDelete.CompareText("on"))
				{
					m_profanityList.DeleteProfanity(iProfanityId);
				}
				else
				{
					m_profanityList.UpdateProfanity(iProfanityId, sProfanity, iModClassId, iRefer);
				}

			}
		}
	}

	Clear();
	Create("");
	return true;
}

bool CProfanityAdmin::AddProfanities(void)
{
	int iProfanityCount = m_InputContext.GetParamCount("profanity");

	for (int i = 0; i < iProfanityCount; i++)
	{
		CTDVString sProfanity;
		m_InputContext.GetParamString("profanity", sProfanity, i);
		//replace certain characters
		sProfanity.Replace("\t", "");
		sProfanity.Replace("\r", "");
		sProfanity.Replace("\n", "");
		if (sProfanity.CompareText(""))
		{
			continue;
		}
		
		int iRefer = 0;
		CTDVString sRefer;
		m_InputContext.GetParamString("refer", sRefer, i);
		if (sRefer.CompareText("on"))
		{
			iRefer = 1;
		}
		int iModClassId;
		iModClassId = m_InputContext.GetParamInt("modclassid", i);
		m_profanityList.AddProfanity(sProfanity, iModClassId, iRefer);
	}

	return true;
}

bool CProfanityAdmin::ImportProfanityList(void)
{
	CTDVString sProfanityList;
	m_InputContext.GetParamString("profanitylist", sProfanityList);
	int iModClassID = m_InputContext.GetParamInt("modclassid");

	std::vector<CTDVString> vecLines;
	CXMLStringUtils::Split(sProfanityList, "\n", vecLines);

	CTDVString sProfanity;
	int iRefer;

	for (int i = 0; i < (int)vecLines.size(); i++)
	{
		std::vector<CTDVString> vecLine;
		CXMLStringUtils::Split(vecLines[i], ",", vecLine);

		if (vecLine.size() == 2) 
		{
			sProfanity = vecLine[0];
			CTDVString sRefer = vecLine[1];
			//remove spaces
			sRefer.Replace(" ", "");
			sRefer.Replace("\r", "");
			sRefer.Replace("\n", "");
			iRefer = sRefer.CompareText("1")?1:0;		

			m_profanityList.AddProfanity(sProfanity, iModClassID, iRefer);
		}
	}	
	return true;
}