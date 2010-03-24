#include "stdafx.h"
#include ".\groups.h"
#include ".\tdvassert.h"
#include "StoredProcedure.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

CGroups::CGroups(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CGroups::~CGroups(void)
{
}

/*********************************************************************************

	bool CGroups::GetGroupMembers(const TDVCHAR* psGroupName, int iSiteID, bool bCheckCache = true)

		Author:		Mark Howitt
        Created:	14/07/2004
        Inputs:		psGroupName - The Name of the group you want to get the members for
					iSiteID - The Site you want to get the members from.
					bCheckCache - An optional flag to state whether or nbot to use the cache!
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets all the members IDs for a given group and site.

		Notes:		This function could be updated to include user details such
					as UserName, FirstName, LastNAme... by adding an extra flag to the function
					and updating the stored procedurte to join with the users table.

*********************************************************************************/
bool CGroups::GetGroupMembers(const TDVCHAR* psGroupName, int iSiteID, bool bCheckCache)
{
	// Check to see if we've been given a valid groupname.
	if (psGroupName == "")
	{
		return SetDNALastError("CGroups::GetGroupMembers","NoGroupNameGiven","No Group Name Given");
	}

	// Check to see if we've got a cached version for this request
	if (bCheckCache && CheckAndCreateFromCachedPage(iSiteID,psGroupName))
	{
		// Ok, we've got a cached version and alls well! return ok!
		return true;
	}

	// Set up the XML String and the Storedprocedure object
	CTDVString sXML;
	CStoredProcedure SP;
	InitialiseXMLBuilder(&sXML,&SP);

	// Now create and call the storedprocedure
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetGroupMembersForGroup(psGroupName,iSiteID))
	{
		return SetDNALastError("CGroups::GetGroupMembers","FailedToFindMembers","Failed to find members of group");
	}

	// Check to see if we've got any members!
	if (SP.IsEOF())
	{
		// No problem, nothing to do but return!
		return true;
	}

	// Now create the container tag
	OpenXMLTag("GROUP",true);

	// Setup the Attributes for the tag, GroupID and Name.
	bool bOk = AddDBXMLIntAttribute("GroupID","ID");
	bOk = bOk && AddDBXMLAttribute("Name",NULL,true,true,true);
	
	// Now add all the members
	while (!SP.IsEOF() && bOk)
	{
		// Just get the userids for now
		bOk = bOk && OpenXMLTag("MEMBER");
		bOk = bOk && AddDBXMLIntTag("UserID","ID",true);
		bOk = bOk && AddDBXMLTag("UserName");
		bOk = bOk && AddDBXMLTag("FirstNames",NULL,false);
		bOk = bOk && AddDBXMLTag("LastName",NULL,false);
		bOk = bOk && AddDBXMLTag("Title",NULL,false);
		bOk = bOk && AddDBXMLTag("SiteSuffix",NULL,false);
		bOk = bOk && AddDBXMLTag("Area",NULL,false);
		bOk = bOk && AddDBXMLIntTag("TaxonomyNode",NULL,false);
		bOk = bOk && CloseXMLTag("MEMBER");
		SP.MoveNext();
	}

	// Now close the Container XML Tag
	bOk = bOk && CloseXMLTag("GROUP");

	// Check to see if everything went ok?
	if (!bOk)
	{
		return SetDNALastError("CGroups::GetGroupMembers","FailedGettingMemberInfo","Failed to get group member information");
	}

	// Now create the XML Tree
	if (!CreateFromXMLText(sXML,NULL,true))
	{
		return SetDNALastError("CGroups::GetGroupMembers","FailedToCreateXMLTree","Failed to create XML tree");
	}

	// Make sure we put this into the cache!
	return CreateNewCachePage(iSiteID,psGroupName);
}

/*********************************************************************************

	bool CGroups::CreateNewCachePage(int iSiteID, const TDVCHAR* psGroupName)

		Author:		Mark Howitt
        Created:	15/07/2004
        Inputs:		iSiteID - The ID of the site you want to cache the file for.
					iGroupID - The ID of the group you want to cache
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Creates a new cache file for the group info for the given site

*********************************************************************************/
bool CGroups::CreateNewCachePage(int iSiteID, const TDVCHAR* psGroupName)
{
	// Setup the local variables
	CTDVString sStringToCache;
	CTDVString sCacheName = "Groups";
	sCacheName << "-" << iSiteID << psGroupName << ".txt";

	// Get the tree as a string
	if (GetAsString(sStringToCache))
	{
		// Now put the string into the cache file
		if (CachePutItem("Groups", sCacheName, sStringToCache))
		{
			return true;
		}
	}

	// Problems!
	return SetDNALastError("CGroups::GetGroupMembers","FailedToCreateXMLTree","Failed to create XML tree");
}

/*********************************************************************************

	bool CGroups::CheckAndCreateFromCachedPage(int iSiteID, const TDVCHAR* psGroupName)

		Author:		Mark Howitt
        Created:	15/07/2004
        Inputs:		iSiteID - The Id of the site you want to get the group info for.
					iGourpID - the Id of the group you want to get the cached info for.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the cached file for the given group on the requested site.

*********************************************************************************/
bool CGroups::CheckAndCreateFromCachedPage(int iSiteID, const TDVCHAR* psGroupName)
{
	// Setup the cache file name
	CTDVString sXML;
	CTDVString sCacheName = "Groups";
	sCacheName << "-" << iSiteID << psGroupName << ".txt";

	// Setup the in range date. We want cached file to live for a hour only.
	CTDVDateTime dVD;
	dVD = dVD.GetCurrentTime();
	CTDVDateTime dValidRange(dVD.GetYear(),dVD.GetMonth(),dVD.GetDay(),dVD.GetHour() - 1,dVD.GetMinute(),0);
	CTDVString sRes;
	dValidRange.GetAsXML(sRes);

	// Check to see if we can use the cache!
	bool bGotCache = CacheGetItem("Groups", sCacheName, &dValidRange, &sXML);

	// If we got a cached version, use it
	if (bGotCache)
	{
		bGotCache = CreateFromXMLText(sXML,NULL,true);
		TDVASSERT(bGotCache,"Failed to create Groups tree form XML!");
	}

	// Return the verdict
	return bGotCache;
}

/*********************************************************************************

	bool CGroups::GetGroups()

		Author:		Martin Robb
        Created:	10/01/2005
        Inputs:		NA.
        Outputs:	NA
        Returns:	true on success
        Purpose:	Gets a list of all Groups and creates XML.

*********************************************************************************/
bool CGroups::GetGroups()
{
	CTDVString sXML;

	CTDVString sCacheName = "Groups";
	CTDVDateTime dExpires(60*60*24);		// expire once a day.

	//Add XML Specifying Groups - used to filter search on author type - Put in Group Object.
	if ( !CacheGetItem(sCacheName,"Groups.txt",&dExpires,&sXML) )
	{
		CStoredProcedure	SP;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			TDVASSERT(false, "Failed to create stored procedure in CSearch::Initialise()");
			return false;
		}
		InitialiseXMLBuilder(&sXML,&SP);

		SP.FetchUserGroupsList();
		OpenXMLTag("GROUPS-LIST",false);
		while (!SP.IsEOF())
		{
			CTDVString	sGroupName;
			SP.GetField("Name", sGroupName);
			OpenXMLTag("GROUP");
			AddXMLTag("NAME",sGroupName);
			AddXMLIntTag("ID",SP.GetIntField("GroupId"));
			CloseXMLTag("GROUP");
			SP.MoveNext();
		}
		CloseXMLTag("GROUPS-LIST");
	}

	bool bSuccess = CreateFromXMLText(sXML);
	CachePutItem(sCacheName,"Groups",sXML);
	return bSuccess;
}