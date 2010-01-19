// UserList.cpp: implementation of the CUserList class.
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
#include "TDVAssert.h"
#include "XMLObject.h"
#include "UserList.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CUserList::CUserList(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_pSP(NULL)
{
	// no other construction
}

CUserList::~CUserList()
{
	// make sure SP is deleted safely
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	bool CUserList::CreateNewUsersList(int iNumberOfUnits, int iMaxNumber, int iSkip, 
										const TDVCHAR* pUnitType, bool bFilterUsers, 
										const TDVCHAR * pFilterType, int iSiteID, 
										int iShowUpdatingUsers)

	
	Author:		Kim Harries
	Created:	01/09/2000
	Modified:	20/11/2000
	Inputs:		iNumberOfUnits - the number of time units since registration to
					use as a definition of being a new user for this list.
				iMaxNumber - the maximum number of users to include in the list
				iSkip - the number of users to skip before starting the list
				pUnitType - the type of time unit to use. Default is day, but other
					valid values include hour, month, week, year, etc.
				bFilterUsers - true if only want subset of users
				sFilterType - filter type name to filter users. Should be not 
							NULL if bFilterUsers is true. could be
	Outputs:	-
	Returns:	true if successful, false if not.
	Purpose:	Creates a list of all the users that registered within the given
				number of time units.

*********************************************************************************/

bool CUserList::CreateNewUsersList(int iNumberOfUnits, int iMaxNumber, int iSkip, 
								   const TDVCHAR* pUnitType, bool bFilterUsers, 
								   const TDVCHAR * pFilterType, int iSiteID, 
								   int iShowUpdatingUsers)
{
	TDVASSERT(iNumberOfUnits > 0, "non-positive iNumberOfUnits in CUserList::CreateNewUsersList(...)");
	TDVASSERT(iMaxNumber > 0, "iMaxNumber <= 0 in CUserList::CreateNewUsersList(...)");
	TDVASSERT(iSkip >= 0, "iSkip < 0 in CUserList::CreateNewUsersList(...)");

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CUserList::CreateNewUsersList");
		return false;
	}
	// attempt to get a cached version if one available
	// this is best done here as different list types return different data
	// calculate the cachename for this particular object
	CTDVString cachename = "NU";
	cachename << iNumberOfUnits << "-" << pUnitType << "-" << iSkip << "-" 
		<< (iSkip + iMaxNumber - 1) << "-" << pFilterType << "-" << iSiteID 
		<< "-" << iShowUpdatingUsers << ".txt"; 

	CTDVString		sXML;
	CTDVDateTime	dExpires(60*5);		// Make it expire after 5 minutes
	// get the cached version if we can
	if (CacheGetItem("NewUsers", cachename, &dExpires, &sXML))
	{
		// make sure object was successfully created from cached text
		if (CreateFromCacheText(sXML))
		{
			UpdateRelativeDates();
			return true;
		}
	}
	// if we haven't got a recent enough cache then go get the data from the DB
	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchNewUsers(iNumberOfUnits, pUnitType, 
		bFilterUsers, pFilterType, iSiteID, iShowUpdatingUsers);
	// use the generic helper method to create the actual list
 	bSuccess = bSuccess && CreateList(iMaxNumber, iSkip);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("USER-LIST", "TYPE", "NEW-USERS");
	// if successful then cache this new objects data
	if (bSuccess)
	{
		CTDVString StringToCache;
		CreateCacheText(&StringToCache);
		CachePutItem("NewUsers", cachename, StringToCache);
	}
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CUserList::CreateSubEditorsList(int iMaxNumber, int iSkip)

	Author:		Kim Harries
	Created:	20/11/2000
	Inputs:		iMaxNumber - the maximum number of users to include in the list
				iSkip - the number of users to skip before starting the list
	Outputs:	-
	Returns:	true if successful, false if not.
	Purpose:	Creates a list of all the sub editors, containing info about their
				quota and current workload.

*********************************************************************************/

bool CUserList::CreateSubEditorsList(int iMaxNumber, int iSkip)
{
	TDVASSERT(iMaxNumber > 0, "iMaxNumber <= 0 in CUserList::CreateSubEditorsList(...)");
	TDVASSERT(iSkip >= 0, "iSkip < 0 in CUserList::CreateSubEditorsList(...)");

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CUserList::CreateSubEditorsList");
		return false;
	}
	// do not want to use cache for this list as it needs to be up to date
	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchSubEditorsDetails();
	// use the generic helper method to create the actual list
	bSuccess = bSuccess && CreateList(iMaxNumber, iSkip);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("USER-LIST", "TYPE", "SUB-EDITORS");
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CUserList::CreateGroupMembershipList(const TDVCHAR* pcGroupName, int iMaxNumber = 100000, int iSkip = 0)

	Author:		Kim Harries
	Created:	03/03/2001
	Inputs:		pcGroupName
				iMaxNumber
				iSkip
	Outputs:	-
	Returns:	true if successful, false if not.
	Purpose:	Creates a list of all the users who are members of the specified group

*********************************************************************************/

bool CUserList::CreateGroupMembershipList(const TDVCHAR* pcGroupName, int iSiteID, int iSystem, int iMaxNumber, int iSkip)
{
	TDVASSERT(pcGroupName != NULL, "CUserList::CreateGroupMembershipList(...) called with NULL pcGroupName");

	CTDVString	sGroupName = pcGroupName;
	sGroupName.MakeUpper();
	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CUserList::CreateGroupMembershipList");
		return false;
	}
	// do not want to use cache for this list as it needs to be up to date
	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchGroupMembershipList(sGroupName, iSiteID, iSystem);	// System 0
	// use the generic helper method to create the actual list
	// use arbitrary very large number to ensure all researchers are fetched
	bSuccess = bSuccess && CreateList(iMaxNumber, iSkip);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("USER-LIST", "TYPE", "GROUP-MEMBERSHIP");
	// and add an attribute for the name of the group
	bSuccess = bSuccess && SetAttribute("USER-LIST", "GROUP-NAME", sGroupName);
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CUserList::GetUserIDs(int** piIDArray, int* piTotalIDs)

	Author:		Kim Harries
	Created:	28/11/2000
	Inputs:		-
	Outputs:	ppiIDArray - ptr to an array of ints containing the user IDs of all
					the users in the list
				piTotalIDs - the total number of IDs, i.e. the size of the array
	Returns:	true if successful, false if not.
	Purpose:	Creates and returns an array containing all the user IDs of the
				users in the list.

*********************************************************************************/

bool CUserList::GetUserIDs(int** ppiIDArray, int* piTotalIDs)
{
	TDVASSERT(m_pTree != NULL, "NULL m_pTree in CUserList::GetUserIDs(...)");
	TDVASSERT(ppiIDArray != NULL, "NULL ppiIDArray in CUserList::GetUserIDs(...)");
	TDVASSERT(piTotalIDs != NULL, "NULL piTotalIDs in CUserList::GetUserIDs(...)");

	// if no object or parameters NULL then return false
	if (m_pTree == NULL || ppiIDArray == NULL || piTotalIDs == NULL)
	{
		return false;
	}

	// put everything in a try block just in case dynamic allocation fails
	try
	{
		// otherwise go through the tree finding all the user IDs and add them to the array
		CXMLTree*	pNode = NULL;
		CXMLTree*	pText = NULL;
		int			iArraySize = 100;
		int			iPos = 0;

		// first delete the array, if any, then allocate some memory
		delete [] *ppiIDArray;
		*ppiIDArray = NULL;
		*ppiIDArray = new int[iArraySize];

		pNode = m_pTree->FindFirstTagName("USERID", 0, false);
		// keep looping so long as we have more user IDs
		while (pNode != NULL)
		{
			// first check we haven't exceed the size of the array
			if (iPos >= iArraySize)
			{
				// create a temporary array of twice the size
				int* piTemp = new int[iArraySize * 2];
				// copy the contents over
				for (int i = 0; i < iArraySize; i++)
				{
					piTemp[i] = (*ppiIDArray)[i];
				}
				// delete the old array
				delete [] (*ppiIDArray);
				// make the ID array ptr point to the new array
				(*ppiIDArray) = piTemp;
				// set the array size to twice what it was
				iArraySize *= 2;
			}
			// find the first child of the node, i.e. the text contents
			pText = pNode->GetFirstChild();
			if (pText == NULL)
			{
				// if no child then use a zero value
				(*ppiIDArray)[iPos] = 0;
			}
			else
			{
				// set the next index in the array to the integer value of the USERID tag
				(*ppiIDArray)[iPos] = atoi(pText->GetText());
			}
			// increment the index position
			iPos++;
			// increment the count of the total IDs
			(*piTotalIDs)++;
			// see if we can find another USERID tag
			pNode = pNode->FindNextTagNode("USERID");
		}
	}
	catch (...)
	{
		// only exceptions likely are if dynamica allocation fails, so
		// log an error, try to tidy up, then return failure
		TDVASSERT(false, "Unknown exception caught in CUserList::GetUserIDs(...)");
		delete [] (*ppiIDArray);
		(*ppiIDArray) = NULL;
		return false;
	}
	// all okay if we reach here
	return true;
}

/*********************************************************************************

	bool CUserList::RemoveUser(int iUserID)

	Author:		Kim Harries
	Created:	05/01/2001
	Inputs:		iUserID - user to be removed from list
	Outputs:	-
	Returns:	true if successful, false if not.
	Purpose:	Returns the user with this ID from the list.

*********************************************************************************/

bool CUserList::RemoveUser(int iUserID)
{
	TDVASSERT(!IsEmpty(), "CUserList::RemoveUser(...) called on empty user list");
	TDVASSERT(iUserID > 0, "CUserList::RemoveUser(...) called with non-positive user ID");

	// can't remove anything from an empty list
	if (IsEmpty() || iUserID <= 0)
	{
		return false;
	}

	// must find the node for this user and detach and delete it
	CXMLTree* pNode = NULL;
	if (FindUserInList(iUserID, true, &pNode))
	{
		// want to delete the parent of the USERID tag (i.e. the USER tag)
		// and all it's contents
		pNode = pNode->GetParent();
		pNode->DetachNodeTree();
		delete pNode;
		pNode = NULL;
		// return success
		return true;
	}
	else
	{
		// if node not found the return failure
		return false;
	}
}

/*********************************************************************************

	bool CUserList::CreateList(int iMaxNumber, int iSkip)

	Author:		Kim Harries
	Created:	20/11/2000
	Inputs:		iMaxNumber - the maximum number of users to go in the list
				iSkip - the number of users to skip before starting the list
	Outputs:	-
	Returns:	true if successful, false if not.
	Purpose:	Helper method to create the list after a specific stored procedure
				has been called to return an appropriate results set.

*********************************************************************************/

bool CUserList::CreateList(int iMaxNumber, int iSkip)
{
	TDVASSERT(iMaxNumber > 0, "CUserList::CreateList(...) called with non-positive max number of articles");

	// if tree isn't empty then delete it and start anew
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// if SP is NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "NULL SP in CUserList::CreateList(...)");
		return false;
	}

	CTDVString	sXML = "";
	bool		bSuccess = true;
	// also make sure the list has the correct type attribute, and count and skip attributes
	sXML = "<USER-LIST";
	sXML << " COUNT='" << iMaxNumber << "' SKIPTO='" << iSkip << "'>";
	sXML << "</USER-LIST>";
	// create an empty list then add articles to it
	bSuccess = bSuccess && CreateFromXMLText(sXML);
	// skip the appropriate number of rows
	if (iSkip > 0 && !m_pSP->IsEOF())
	{
		m_pSP->MoveNext(iSkip);
	}
	// go through each row in the results set and add it to the list
	while (bSuccess && !m_pSP->IsEOF() && iMaxNumber > 0)
	{
		// use helper method to extract the relevant fields and add the article
		bSuccess = bSuccess && AddCurrentUserToList();
		m_pSP->MoveNext();
		iMaxNumber--;
	}
	// if there are more articles in list then set the MORE attribute
	if (bSuccess && !m_pSP->IsEOF())
	{
		bSuccess = bSuccess && SetAttribute("USER-LIST", "MORE", "1");
	}
	// if something went wrong then delete the tree
	if (!bSuccess)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// delete the SP regardless
	delete m_pSP;
	m_pSP = NULL;
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CUserList::AddCurrentUserToList()

	Author:		Kim Harries
	Created:	20/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Adds the details for the user represented by the current row
				in the data member stored procedures results set as a new user
				in the user list. Only adds those fields which are present in
				the results set to the XML.

*********************************************************************************/

bool CUserList::AddCurrentUserToList()
{
	TDVASSERT(m_pSP != NULL, "m_pSP is NULL in CUserList::AddCurrentUserToList()");

	// must fail if no SP
	if (m_pSP == NULL)
	{
		return false;
	}

	// otherwise try to read the fields into variables
	CTDVString		sUserXML;
	CTDVString		sUsername;
	CTDVString		sArea;
	CTDVString		sTitle;
	CTDVString		sSiteSuffix;
	CTDVString		sFirstNames;
	CTDVString		sLastName;
	CTDVString		sEmail;
	CTDVDateTime	dtDateJoined;
	CTDVString		sDateJoined;
	CTDVDateTime	dtDateLastNotified;
	CTDVString		sDateLastNotified;
	int				iUserID = 0;
	int				iMasthead = 0;
	int				iForumID = 0;
	int				iForumPostedTo = 0;
	int				iActive = 0;
	int				iStatus = 0;
	int				iJournal = 0;
	int				iSinBin = 0;
	int				iAllocations = 0;
	int				iSubQuota = 0;
	bool			bSuccess = true;
	int				iTaxonomyNode = 0;

	// if no object yet then create one
	if (IsEmpty())
	{
		bSuccess = bSuccess && CreateEmptyList("USER-LIST");
	}
	// build the XML for this article in a string
	// get each field at a time, only adding XML for it if it exists
	if (bSuccess)
	{
/*
		// TODO - this would clean up the lines below 
		// a bit but DBXMLBuilder currently has no FieldExists()
		// checking.
		InitialiseXMLBuilder(&sUserXML, m_pSP);
		bSuccess = bSuccess && OpenXMLTag("USER");
		bSuccess = bSuccess && AddDBXMLTag("UserID",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Masthead",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("ForumID",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("ForumPostedTo","FORUM-POSTED-TO",false);
		bSuccess = bSuccess && AddDBXMLTag("Active",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("SinBin",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Allocations",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("SubQuota","SUB-QUOTA",false);
		bSuccess = bSuccess && AddDBXMLTag("DateLastNotified","DATE-LAST-NOTIFIED",false);
		bSuccess = bSuccess && AddDBXMLTag("Status",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Journal",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Username",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Area",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Title",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("SiteSuffix",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Email",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("FirstNames",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Lastname",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("DateJoined","DATE-JOINED",false);
		bSuccess = bSuccess && CloseXMLTag("USER");
*/

		sUserXML = "<USER>";
		if (m_pSP->FieldExists("UserID"))
		{
			iUserID = m_pSP->GetIntField("UserID");
			sUserXML << "<USERID>" << iUserID << "</USERID>";
		}
		if (m_pSP->FieldExists("Masthead"))
		{
			iMasthead = m_pSP->GetIntField("Masthead");
			sUserXML << "<MASTHEAD>" << iMasthead << "</MASTHEAD>";
		}
		if (m_pSP->FieldExists("ForumID"))
		{
			iForumID = m_pSP->GetIntField("ForumID");
			sUserXML << "<FORUMID>" << iForumID << "</FORUMID>";
		}
		if (m_pSP->FieldExists("ForumPostedTo"))
		{
			iForumPostedTo = m_pSP->GetIntField("ForumPostedTo");
			sUserXML << "<FORUM-POSTED-TO>" << iForumPostedTo << "</FORUM-POSTED-TO>";
		}
		if (m_pSP->FieldExists("Active"))
		{
			iActive = m_pSP->GetIntField("Active");
			sUserXML << "<ACTIVE>" << iActive << "</ACTIVE>";
		}
		if (m_pSP->FieldExists("SinBin"))
		{
			iSinBin = m_pSP->GetIntField("SinBin");
			sUserXML << "<SINBIN>" << iSinBin << "</SINBIN>";
		}
		if (m_pSP->FieldExists("Allocations"))
		{
			iAllocations = m_pSP->GetIntField("Allocations");
			sUserXML << "<ALLOCATIONS>" << iAllocations << "</ALLOCATIONS>";
		}
		if (m_pSP->FieldExists("SubQuota"))
		{
			iSubQuota = m_pSP->GetIntField("SubQuota");
			sUserXML << "<SUB-QUOTA>" << iSubQuota << "</SUB-QUOTA>";
		}
		if (m_pSP->FieldExists("DateLastNotified") && !m_pSP->IsNULL("DateLastNotified"))
		{
			dtDateLastNotified = m_pSP->GetDateField("DateLastNotified");
			// get relative dates too
			dtDateLastNotified.GetAsXML(sDateLastNotified, true);
			sUserXML << "<DATE-LAST-NOTIFIED>" << sDateLastNotified << "</DATE-LAST-NOTIFIED>";
		}
		if (m_pSP->FieldExists("Status"))
		{
			iStatus = m_pSP->GetIntField("Status");
			sUserXML << "<STATUS>" << iStatus << "</STATUS>";
		}
		if (m_pSP->FieldExists("Journal"))
		{
			iJournal = m_pSP->GetIntField("Journal");
			sUserXML << "<JOURNAL>" << iJournal << "</JOURNAL>";
		}
		if (m_pSP->FieldExists("Username"))
		{
			m_pSP->GetField("Username", sUsername);
			EscapeXMLText(&sUsername);
			sUserXML << "<USERNAME>" << sUsername << "</USERNAME>";
		}
		if (m_pSP->FieldExists("Area") && !m_pSP->IsNULL("Area"))
		{
			m_pSP->GetField("Area", sArea);
			EscapeXMLText(&sArea);
			sUserXML << "<AREA>" << sArea << "</AREA>";
		}
		if (m_pSP->FieldExists("Title") && !m_pSP->IsNULL("Title"))
		{
			m_pSP->GetField("title", sTitle);
			EscapeXMLText(&sTitle);
			sUserXML << "<TITLE>" << sTitle << "</TITLE>";
		}
		if (m_pSP->FieldExists("SiteSuffix") && !m_pSP->IsNULL("SiteSuffix"))
		{
			m_pSP->GetField("SiteSuffix", sSiteSuffix);
			EscapeXMLText(&sSiteSuffix);
			sUserXML << "<SITESUFFIX>" << sSiteSuffix << "</SITESUFFIX>";
		}
		if (m_pSP->FieldExists("Email"))
		{
			m_pSP->GetField("Email", sEmail);
			EscapeXMLText(&sEmail);
			sUserXML << "<EMAIL>" << sEmail << "</EMAIL>";
		}
		if (m_pSP->FieldExists("FirstNames"))
		{
			m_pSP->GetField("FirstNames", sFirstNames);
			EscapeXMLText(&sFirstNames);
			sUserXML << "<FIRSTNAMES>" << sFirstNames << "</FIRSTNAMES>";
		}
		if (m_pSP->FieldExists("LastName"))
		{
			m_pSP->GetField("LastName", sLastName);
			EscapeXMLText(&sLastName);
			sUserXML << "<LASTNAME>" << sLastName << "</LASTNAME>";
		}
		if (m_pSP->FieldExists("DateJoined"))
		{
			dtDateJoined = m_pSP->GetDateField("DateJoined");
			// get relative dates too
			dtDateJoined.GetAsXML(sDateJoined, true);
			sUserXML << "<DATE-JOINED>" << sDateJoined << "</DATE-JOINED>";
		}
		if (m_pSP->FieldExists("TaxonomyNode"))
		{
			iTaxonomyNode = m_pSP->GetIntField("TaxonomyNode");
			sUserXML << "<TAXONOMYNODE>" << iTaxonomyNode << "</TAXONOMYNODE>";
		}

		//get the groups to which this user belongs to 		
		CTDVString sGroupXML;		
		bSuccess = bSuccess && m_InputContext.GetUserGroups(sGroupXML, iUserID);
		sUserXML = sUserXML + sGroupXML;

		sUserXML << "</USER>";

		// add the article XML inside the USER-LIST element
		bSuccess = bSuccess && AddInside("USER-LIST", sUserXML);
	}	
	// return the success value
	return bSuccess;
}

/*********************************************************************************

	bool CUserList::FindUserInList(int iUserID, bool bReturnRef, CXMLTree** pUserNode)

	Author:		David van Zijl
	Created:	21/05/2004
	Inputs:		iUserID - User id to check
	Outputs:	-
	Returns:	true if user is in list, false if not.
	Purpose:	TODO

*********************************************************************************/

bool CUserList::FindUserInList(int iUserID, bool bReturnRef, CXMLTree** pUserNode)
{
	// can't find anything in an empty list
	if (IsEmpty() || iUserID <= 0)
	{
		return false;
	}

	// UserID of current node we're looking at
	CXMLTree* pNode = m_pTree->FindFirstTagName("USERID", 0, false);
	int iID = 0;

	while (pNode != NULL)
	{
		// get the id value for this user
		if (pNode->GetFirstChild() == NULL)
		{
			iID = 0;
		}
		else
		{
			iID = atoi(pNode->GetFirstChild()->GetText());
		}
		// if this is the user we are looking for do the remove
		if (iID == iUserID)
		{
			// Found it!
			if (bReturnRef)
			{
				*pUserNode = pNode;
			}
			return true;
		}
		// find the next userid
		pNode = pNode->FindNextTagNode("USERID");
	}
	// if node not found the return failure
	return false;
}

/*********************************************************************************

	bool CUserList::CreateEmptyList(const TDVCHAR* pcTagName, const TDVCHAR* pcListType)

	Author:		David van Zijl
	Created:	21/05/2004
	Inputs:		pcTagName - Name of main user list tag, this is often USER-LIST
				pcListType (optional) - Type of list (for USER-LIST 'TYPE' attribute)
	Outputs:	-
	Returns:	true if list created
	Purpose:	TODO

*********************************************************************************/

bool CUserList::CreateEmptyList(const TDVCHAR* pcTagName, const TDVCHAR* pcListType)
{
	CTDVString sNewListXML;
	sNewListXML << "<" << pcTagName;
	if (pcListType != NULL)
	{
		sNewListXML << " TYPE='" << pcListType << "'";
	}
	sNewListXML << "/>";
	return CreateFromXMLText(sNewListXML);
}

/*********************************************************************************

	bool CUserList::CreateNewUsersForSite(int iSiteID, const TDVCHAR* pTimeUnit, int iNoOfUnits, int iShow, int iSkip)

		Author:		Mark Howitt
		Created:	20/09/2006
		Inputs:		iSiteID - The id of the site that you want to check for new users.
					pTimeUnit - The time unit you want to search across.
						Currently one of the following...
							Day
							Week
							Month
							Year
					iNoOfUnits - The number of time units to search across.
						Currently Max value = 1 Year in any time unit.
					iShow - The number of entries to show.
					iSkin - The number of entries to skip before showing.
		Outputs:	-
		Returns:	True if ok, false if not
		Purpose:	Gets all the users who have joined in the last date range for a given site.

*********************************************************************************/
bool CUserList::CreateNewUsersForSite(int iSiteID, const TDVCHAR* pTimeUnit, int iNoOfUnits, int iShow, int iSkip)
{
	// Get the cached version if we have one
	CTDVString cachename = "NewUsersForSite";
	cachename << iNoOfUnits << "-" << pTimeUnit << "-" << iSkip << "-" << iShow << "-" << iSiteID << ".txt";
	CTDVString		sXML = "";
	CTDVDateTime	dExpires(60*5);		// Make it expire after 5 minutes

	// Get the cached version if we can
	if (CacheGetItem("NewUsers", cachename, &dExpires, &sXML))
	{
		// make sure object was successfully created from cached text
		if (CreateFromCacheText(sXML))
		{
			UpdateRelativeDates();
			return true;
		}
	}

	// No cache, lets create the list from the database
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		// Problems getting a database connection
		return SetDNALastError("CUserList::CreateNewUsersForSite","FailedToCreateStoredProcedure","Failed to create a stored procedure!!!");
	}

	// Now call the stored procedure to get the info
	int iTotal = 0;
	if (!SP.GetNewUserForSite(iSiteID,pTimeUnit,iNoOfUnits,&iTotal))
	{
		// Problems getting a database connection
		return SetDNALastError("CUserList::CreateNewUsersForSite","FailedToGetNewUsers","Failed to get new users for site!!!");
	}
	
	// Create the list of users
	sXML = "";
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);

	// Open the base XML tag and add the search criteria
	XML.OpenTag("USER-LIST",true);
	bool bOk = XML.AddIntAttribute("skipto",iSkip);
	bOk = bOk && XML.AddIntAttribute("show",iShow);
	bOk = bOk && XML.AddAttribute("type","NEW-USERS",true);

	// Start by skipping the required amaount of entries.
	int iToSkip = iSkip;
	while (!SP.IsEOF() && iSkip > 0)
	{
		// Get the next Entry
		SP.MoveNext();
		iSkip--;
	}

	// Now cycle through the results getting each users details.
	int iToShow = iShow;
	while (!SP.IsEOF() && bOk && iToShow > 0)
	{
		// Start by openning the User tag
		bOk = bOk && XML.OpenTag("USER");
		bOk = bOk && XML.DBAddIntTag("USERID");
		bOk = bOk && XML.DBAddTag("USERNAME");
		bOk = bOk && XML.DBAddDateTag("DATEJOINED","DATE-JOINED",true,true);
		bOk = bOk && XML.CloseTag("USER");

		// Get the next entry
		SP.MoveNext();
		iToShow--;
	}

	// Finish off by closing the user-list
	bOk = bOk && XML.CloseTag("USER-LIST");

	// Make sure we've run through all the results, so that the output param 'total' can be found
	while (!SP.IsEOF())
	{
		SP.MoveNext();
	}

	// Now create the objects xml tree ready for insertion, checking to make sure that we're ok first
	if (!bOk || !CreateFromXMLText(sXML,NULL,true) || !SetAttribute("USER-LIST","COUNT",CTDVString(iTotal)))
	{
		// Problems creating the xml object
		return SetDNALastError("CUserList::CreateNewUsersForSite","FailedToCreateXML","Failed to create XML!!!");
	}

	// Create the cached version for this request
	CTDVString StringToCache;
	CreateCacheText(&StringToCache);
	CachePutItem("NewUsers", cachename, StringToCache);

	// return ok
	return true;
}
