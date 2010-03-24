// ArticleList.cpp: implementation of the CArticleList class.
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
#include "ArticleList.h"
#include "TDVAssert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CArticleList::CArticleList(CInputContext& inputContext)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		inputContext - input context
	Outputs:	-
	Returns:	-
	Purpose:	Construct a CArticleList object and provide its member variables with
				suitable default values.

*********************************************************************************/

CArticleList::CArticleList(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_pSP(NULL)
{
	// no other construction
}

/*********************************************************************************

	CArticleList::~CArticleList()

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		inputContext - input context
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources specifically allocated by this subclass.

*********************************************************************************/

CArticleList::~CArticleList()
{
	// make sure SP is deleted safely
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	bool CArticleList::CreateRecentArticlesList(int iUserID, int iMaxNumber)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		iUserID - the ID of the user whose recent articles we want
				iMaxNumber - the max number of articles to get. Defaults to ten.
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Fills the current object with the xml representing the specified
				users most recent guide entries, up to a maximum of iMaxNumber.

*********************************************************************************/

bool CArticleList::CreateRecentArticlesList(int iUserID, int iMaxNumber, int iSkip, int iSiteID, int iGuideType)
{
	return CreateMostRecentList(iUserID, iMaxNumber, iSkip, ARTICLELISTTYPE_NORMAL, iSiteID, iGuideType);
}

/*********************************************************************************

	bool CArticleList::CreateRecentApprovedArticlesList(int iUserID, int iMaxNumber)

	Author:		Kim Harries
	Created:	08/03/2000
	Inputs:		iUserID - the ID of the user whose recent articles we want
				iMaxNumber - the max number of articles to get. Defaults to ten.
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Fills the current object with the xml representing the specified
				users most recent approved guide entries, up to a maximum of
				iMaxNumber.

*********************************************************************************/

bool CArticleList::CreateRecentApprovedArticlesList(int iUserID, int iMaxNumber, int iSkip, int iGuideType)
{
	return CreateMostRecentList(iUserID, iMaxNumber, iSkip, ARTICLELISTTYPE_APPROVED, 0, iGuideType);
}

bool CArticleList::CreateCancelledArticlesList(int iUserID, int iMaxNumber, int iSkip, int iGuideType)
{
	return CreateMostRecentList(iUserID, iMaxNumber, iSkip, ARTICLELISTTYPE_CANCELLED, 0, iGuideType);
}

bool CArticleList::CreateRecentNormalAndApprovedArticlesList(int iUserID, int iMaxNumber, int iSkip, int iGuideType)
{
	return CreateMostRecentList(iUserID, iMaxNumber, iSkip, ARTICLELISTTYPE_NORMALANDAPPROVED, 0, iGuideType);
}

bool CArticleList::CreateMostRecentList(int iUserID, int iMaxNumber, int iSkip, int iWhichType, int iSiteID, int iGuideType)
{
	TDVASSERT(iUserID > 0, "Non-positive user id in CArticleList::CreateMostRecentList(...)");
	TDVASSERT(m_pTree == NULL, "CArticleList::CreateMostRecentList() called with non-NULL tree");
	TDVASSERT(iMaxNumber > 0, "CArticleList::CreateMostRecentList(...) called with non-positive max number of articles");

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CArticleList::CreateMostRecentList");
		return false;
	}

	// Set up the cache file name based on the parameters.
	CTDVString cachename = "AL";
	cachename << iUserID << "-" << iMaxNumber << "-" << iSkip << "-" << iWhichType << "-" << iSiteID;
	// If we have a guidetype then add this as well. Leave it out when 0 will reuse older existing cached files.
	if (iGuideType > 0)
	{
		cachename << "-" << iGuideType;
	}
	cachename << ".xml";
	
	CTDVDateTime dLastDate;	// cache for five minutes
	m_pSP->CacheGetArticleListDate(iUserID, iSiteID, &dLastDate);
	bool bGotCache = false;

	CTDVString sList;
	bGotCache = CacheGetItem("articlelist", cachename, &dLastDate, &sList);
	if (bGotCache)
	{
		CreateFromXMLText(sList);
		UpdateRelativeDates();
		return true;
	}
	
	bool bSuccess = true;
	
	
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->GetUsersMostRecentEntries(iUserID, iWhichType, iSiteID, iGuideType);
	// use the generic helper method to create the actual list
	bSuccess = bSuccess && CreateList(iMaxNumber, iSkip);
	// now set the list type attribute
	switch (iWhichType)
	{
		case ARTICLELISTTYPE_APPROVED:			bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "USER-RECENT-APPROVED"); break;
		case ARTICLELISTTYPE_NORMAL:			bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "USER-RECENT-ENTRIES"); break;
		case ARTICLELISTTYPE_CANCELLED:			bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "USER-RECENT-CANCELLED"); break;
		case ARTICLELISTTYPE_NORMALANDAPPROVED:	bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "USER-RECENT-NORMALANDAPPROVED"); break;
		default:bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "USER-RECENT-ENTRIES"); break;
	}
	// return success value
	CTDVString StringToCache;
	GetAsString(StringToCache);
	CachePutItem("articlelist", cachename, StringToCache);
	return bSuccess;
}

/*********************************************************************************

	bool CArticleList::CreateUndecidedRecommendationsList(int iMaxNumber, int iSkip)

	Author:		Kim Harries
	Created:	16/11/2000
	Inputs:		iMaxNumber - the max number of entries to include in the list
				iSkip - the number of entries to skip before starting inclusions
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates a list of articles representing the articles currently in
				the recommended entries list.

*********************************************************************************/

bool CArticleList::CreateUndecidedRecommendationsList(int iMaxNumber, int iSkip)
{
	TDVASSERT(iMaxNumber > 0, "CArticleList::CreateUndecidedRecommendationsList(...) called with non-positive max number of articles");

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CArticleList::CreateUndecidedRecommendationsList");
		return false;
	}

	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchUndecidedRecommendations();
	// use the generic helper method to create the actual list
	bSuccess = bSuccess && CreateList(iMaxNumber, iSkip);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "UNDECIDED-RECOMMENDATIONS");
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CArticleList::CreateUnallocatedRecommendationsList(int iMaxNumber, int iSkip)

	Author:		Kim Harries
	Created:	20/11/2000
	Inputs:		iMaxNumber - the max number of entries to include in the list
				iSkip - the number of entries to skip before starting inclusions
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates a list of articles representing the articles currently in
				the accepted recommendations list that have not yet been allocated.

*********************************************************************************/

bool CArticleList::CreateUnallocatedRecommendationsList(int iMaxNumber, int iSkip)
{
	TDVASSERT(iMaxNumber > 0, "CArticleList::CreateUnallocatedRecommendationsList(...) called with non-positive max number of articles");

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CArticleList::CreateUnallocatedRecommendationsList");
		return false;
	}

	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchUnallocatedAcceptedRecommendations();
	// use the generic helper method to create the actual list
	bSuccess = bSuccess && CreateList(iMaxNumber, iSkip);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "UNALLOCATED-RECOMMENDATIONS");
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CArticleList::CreateAllocatedRecommendationsList(int iMaxNumber, int iSkip)

	Author:		Kim Harries
	Created:	20/11/2000
	Inputs:		iMaxNumber - the max number of entries to include in the list
				iSkip - the number of entries to skip before starting inclusions
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates a list of articles representing the recommendations that
				have been allocated to a sub but not yet returned.

*********************************************************************************/

bool CArticleList::CreateAllocatedRecommendationsList(int iMaxNumber, int iSkip)
{
	TDVASSERT(iMaxNumber > 0, "CArticleList::CreateAllocatedRecommendationsList(...) called with non-positive max number of articles");

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CArticleList::CreateAllocatedRecommendationsList");
		return false;
	}

	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchAllocatedUnreturnedRecommendations();
	// use the generic helper method to create the actual list
	bSuccess = bSuccess && CreateList(iMaxNumber, iSkip);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "ALLOCATED-RECOMMENDATIONS");
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CArticleList::CreateScoutRecommendationsList(int iScoutID, const TDVCHAR* pcUnitType, int iNumberOfUnits)

	Author:		Kim Harries
	Created:	02/03/2001
	Inputs:		iScoutID - id of scout
				pcTimeUnit
				iNumberOfUnits
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates a list of articles representing the recommendations made
				by this particular scout.

*********************************************************************************/

bool CArticleList::CreateScoutRecommendationsList(int iScoutID, const TDVCHAR* pcUnitType, int iNumberOfUnits)
{
	TDVASSERT(pcUnitType != NULL, "CArticleList::CreateScoutRecommendationsList(...) called with NULL pcUnitType");

	CTDVString	sUnitType = pcUnitType;
	sUnitType.MakeLower();

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CArticleList::CreateScoutRecommendationsList");
		return false;
	}

	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchScoutRecommendationsList(iScoutID, sUnitType, iNumberOfUnits);
	// use the generic helper method to create the actual list
	bSuccess = bSuccess && CreateList(100000, 0);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "SCOUT-RECOMMENDATIONS");
	bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "UNIT-TYPE", sUnitType);
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CArticleList::CreateSubsEditorsAllocationsList(int iSubID, const TDVCHAR* pcUnitType, int iNumberOfUnits)

	Author:		Kim Harries
	Created:	02/03/2001
	Inputs:		iSubID
				pcTimeUnit
				iNumberOfUnits
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Creates a list of articles representing the entries allocated to this particular
				sub editor in the time period specified.

*********************************************************************************/

bool CArticleList::CreateSubsEditorsAllocationsList(int iSubID, const TDVCHAR* pcUnitType, int iNumberOfUnits)
{
	TDVASSERT(pcUnitType != NULL, "CArticleList::CreateSubsEditorsAllocationsList(...) called with NULL pcUnitType");

	CTDVString	sUnitType = pcUnitType;
	sUnitType.MakeLower();

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CArticleList::CreateSubsEditorsAllocationsList");
		return false;
	}

	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchSubEditorsAllocationsList(iSubID, sUnitType, iNumberOfUnits);
	// use the generic helper method to create the actual list
	bSuccess = bSuccess && CreateList(100000, 0);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "TYPE", "SUB-ALLOCATIONS");
	bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "UNIT-TYPE", sUnitType);
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CArticleList::CreateList(int iMaxNumber = 10, int iSkip = 0)

	Author:		Kim Harries
	Created:	17/11/2000
	Inputs:		iMaxNumber - the max number of entries to include in the list
				iSkip - the number of entries to skip before starting inclusions
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Helper method to create the list after a specific stored procedure
				has been called to return an appropriate results set.

*********************************************************************************/

bool CArticleList::CreateList(int iMaxNumber, int iSkip)
{
	TDVASSERT(iMaxNumber > 0, "CArticleList::CreateList(...) called with non-positive max number of articles");

	// if tree isn't empty then delete it and start anew
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// if SP is NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "NULL SP in CArticleList::CreateList(...)");
		return false;
	}

	CTDVString	sXML = "";
	bool		bSuccess = true;
	// also make sure the list has the correct type attribute, and count and skip attributes
	sXML = "<ARTICLE-LIST";
	sXML << " COUNT='" << iMaxNumber << "' SKIPTO='" << iSkip << "'>";
	sXML << "</ARTICLE-LIST>";
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
		bSuccess = bSuccess && AddCurrentArticleToList();
		m_pSP->MoveNext();
		iMaxNumber--;
	}
	// if there are more articles in list then set the MORE attribute
	if (bSuccess && !m_pSP->IsEOF())
	{
		bSuccess = bSuccess && SetAttribute("ARTICLE-LIST", "MORE", "1");
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

	bool CArticleList::CreateUserBlock(CTDVString & sXML, CTDVString sUserType)

		Author:		James Pullicino
        Created:	06/04/2005

        Inputs:		sUserType can be one of (case insensitive): 
					"EDITOR" "AUTHOR" "ACCEPTOR" "ALLOCATOR" "SCOUT" "SUBEDITOR"

					sXML must be empty string

					m_SP must be valid

        Outputs:	On success, sXML will contain user block xml
        Returns:	true on success 
        Purpose:	Creates user block xml inside element for editor, author etc..

*********************************************************************************/

bool CArticleList::CreateUserBlock(CTDVString & sXML, CTDVString sUserType)
{
	// This is for safety
	if(!sXML.IsEmpty())
	{
		TDVASSERT(false, "CArticleList::CreateUserBlock() sXML parameter must be empty string");
		return false;
	}

	// Field names
	CTDVString fldUserID, fldUserName, fldFirstNames, fldLastName, fldArea, fldStatus, fldTaxonomyNode, fldJournal, fldActive, fldSitesuffix, fldTitle;

	// Figure out field names
	// (There must be a more efficient way to do this, but leave like this
	// for now since it offers better flexibility and clarity)
	sUserType.MakeUpper();
	if(sUserType.CompareText("EDITOR"))			// EDITOR
	{
		fldUserID = "Editor";
		fldUserName = "EditorName";
		fldFirstNames = "EditorFirstNames";
		fldLastName = "EditorLastName";
		fldArea = "EditorArea";
		fldStatus = "EditorStatus";
		fldTaxonomyNode = "EditorTaxonomyNode";
		fldJournal = "EditorJournal";
		fldActive = "EditorActive";
		fldSitesuffix = "EditorSiteSuffix";
		fldTitle = "EditorTitle";
	}
	else if(sUserType.CompareText("AUTHOR"))	// AUTHOR
	{
		fldUserID = "AuthorID";
		fldUserName = "AuthorName";
		fldFirstNames = "AuthorFirstNames";
		fldLastName = "AuthorLastName";
		fldArea = "AuthorArea";
		fldStatus = "AuthorStatus";
		fldTaxonomyNode = "AuthorTaxonomyNode";
		fldJournal = "AuthorJournal";
		fldActive = "AuthorActive";
		fldSitesuffix = "AuthorSiteSuffix";
		fldTitle = "AuthorTitle";
	}
	else if(sUserType.CompareText("ACCEPTOR"))	// ACCEPTOR
	{
		fldUserID = "AcceptorID";
		fldUserName = "AcceptorName";
		fldFirstNames = "AcceptorFirstNames";
		fldLastName = "AcceptorLastName";
		fldArea = "AcceptorArea";
		fldStatus = "AcceptorStatus";
		fldTaxonomyNode = "AcceptorTaxonomyNode";
		fldJournal = "AcceptorJournal";
		fldActive = "AcceptorActive";
		fldSitesuffix = "AcceptorSiteSuffix";
		fldTitle = "AcceptorTitle";
	}
	else if(sUserType.CompareText("ALLOCATOR"))	// ALLOCATOR
	{
		fldUserID = "AllocatorID";
		fldUserName = "AllocatorName";
		fldFirstNames = "AllocatorFirstNames";
		fldLastName = "AllocatorLastName";
		fldArea = "AllocatorArea";
		fldStatus = "AllocatorStatus";
		fldTaxonomyNode = "AllocatorTaxonomyNode";
		fldJournal = "AllocatorJournal";
		fldActive = "AllocatorActive";
		fldSitesuffix = "AllocatorSiteSuffix";
		fldTitle = "AllocatorTitle";
	}
	else if(sUserType.CompareText("SCOUT"))		// SCOUT
	{
		fldUserID = "ScoutID";
		fldUserName = "ScoutName";
		fldFirstNames = "ScoutFirstNames";
		fldLastName = "ScoutLastName";
		fldArea = "ScoutArea";
		fldStatus = "ScoutStatus";
		fldTaxonomyNode = "ScoutTaxonomyNode";
		fldJournal = "ScoutJournal";
		fldActive = "ScoutActive";
		fldSitesuffix = "ScoutSiteSuffix";
		fldTitle = "ScoutTitle";
	}
	else if(sUserType.CompareText("SUBEDITOR"))	// SUBEDITOR
	{
		fldUserID = "SubEditorID";
		fldUserName = "SubEditorName";
		fldFirstNames = "SubEditorFirstNames";
		fldLastName = "SubEditorLastName";
		fldArea = "SubEditorArea";
		fldStatus = "SubEditorStatus";
		fldTaxonomyNode = "SubEditorTaxonomyNode";
		fldJournal = "SubEditorJournal";
		fldActive = "SubEditorActive";
		fldSitesuffix = "SubEditorSiteSuffix";
		fldTitle = "SubEditorTitle";
	}
	else										// UKNOWN
	{
		TDVASSERT(false, "CArticleList::CreateUserBlock() Uknown user type parameter passed");
		return false;
	}

	// Build user block xml
	sXML << "<" << sUserType << "><USER>";		// Open <USERTYPE><USER>

	// <USERID>
	int iUserID = 0;
	if (m_pSP->FieldExists(fldUserID))
	{
		iUserID = m_pSP->GetIntField(fldUserID);
		sXML << "<USERID>" << iUserID << "</USERID>";
	}

	// <USERNAME>
	if (m_pSP->FieldExists(fldUserName))
	{
		CTDVString sFieldVal;
		if(m_pSP->GetField(fldUserName, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<USERNAME>" << sFieldVal << "</USERNAME>";
		}
	}
	
	// <FIRSTNAMES>
	if (m_pSP->FieldExists(fldFirstNames))
	{
		CTDVString sFieldVal;
		if(m_pSP->GetField(fldFirstNames, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<FIRSTNAMES>" << sFieldVal << "</FIRSTNAMES>";
		}
	}

	// <LASTNAME>
	if (m_pSP->FieldExists(fldLastName))
	{
		CTDVString sFieldVal;
		if(m_pSP->GetField(fldLastName, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<LASTNAME>" << sFieldVal << "</LASTNAME>";
		}
	}

	// <AREA>
	if (m_pSP->FieldExists(fldArea))
	{
		CTDVString sFieldVal;
		if(m_pSP->GetField(fldArea, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<AREA>" << sFieldVal << "</AREA>";
		}
	}

	// <STATUS>
	if (m_pSP->FieldExists(fldStatus))
	{
		sXML << "<STATUS>" << m_pSP->GetIntField(fldStatus) << "</STATUS>";
	}

	// <TAXONOMYNODE>
	if (m_pSP->FieldExists(fldTaxonomyNode))
	{
		sXML << "<TAXONOMYNODE>" << m_pSP->GetIntField(fldTaxonomyNode) << "</TAXONOMYNODE>";
	}

	// <JOURNAL>
	if (m_pSP->FieldExists(fldJournal))
	{
		sXML << "<JOURNAL>" << m_pSP->GetIntField(fldJournal) << "</JOURNAL>";
	}

	// <ACTIVE>
	if (m_pSP->FieldExists(fldActive))
	{
		sXML << "<ACTIVE>" << m_pSP->GetIntField(fldActive) << "</ACTIVE>";
	}

	// <SITESUFFIX>
	if (m_pSP->FieldExists(fldSitesuffix))
	{
		CTDVString sFieldVal;
		if(m_pSP->GetField(fldSitesuffix, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<SITESUFFIX>" << sFieldVal << "</SITESUFFIX>";
		}
	}

	// <TITLE>
	if (m_pSP->FieldExists(fldTitle))
	{
		CTDVString sFieldVal;
		if(m_pSP->GetField(fldTitle, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<TITLE>" << sFieldVal << "</TITLE>";
		}
	}

	// <GROUPS>
	CTDVString sGroupsXML;
	if(!m_InputContext.GetUserGroups(sGroupsXML, iUserID))
	{
		TDVASSERT(false, "CArticleList::CreateUserBlock() m_InputContext.GetUserGroups failed");
		// Don't fail. User tag will simply have no groups tag.
	}
	else
	{
		// Append
		sXML += sGroupsXML;
	}
	

	sXML << "</USER></" << sUserType << ">";	// Close </USER></USERTYPE>

	return true;
}


/*********************************************************************************

	bool CArticleList::AddCurrentArticleToList()

	Author:		Kim Harries
	Created:	17/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not.
	Purpose:	Adds the details for the article represented by the current row
				in the data member stored procedures results set as a new article
				in the article list. Only adds those fields which are present in
				the results set to the XML.

*********************************************************************************/

bool CArticleList::AddCurrentArticleToList()
{
	TDVASSERT(m_pSP != NULL, "m_pSP is NULL in CArticleList::AddCurrentArticleToList()");

	// must fail if no SP
	if (m_pSP == NULL)
	{
		return false;
	}

	// otherwise try to read the fields into variables
	CTDVString		sArticleXML;
	CTDVString		sEditorName;
	CTDVString		sAuthorName;
	CTDVString		sScoutName;
	CTDVString		sSubEditorName;
	CTDVString		sAcceptorName;
	CTDVString		sAllocatorName;
	int				iEntryID = 0;
	int				ih2g2ID = 0;
	int				iSiteID = 0;
	int				iRecommendationID = 0;
	int				iEditorID = 0;
	int				iAuthorID = 0;
	int				iScoutID = 0;
	int				iSubEditorID = 0;
	int				iAcceptorID = 0;
	int				iAllocatorID = 0;
	int				iStatus = 0;
	int				iRecommendationStatus = 0;
	int				iSubbingStatus = 0;
	int				iStyle = 0;
	int				iNotificationSent = 0;
	CTDVString		sSubject;
	CTDVDateTime	dtDateCreated;
	CTDVString		sDateCreated;
	CTDVDateTime	dtLastUpdated;
	CTDVString		sLastUpdated;
	CTDVDateTime	dtDateRecommended;
	CTDVString		sDateRecommended;
	CTDVDateTime	dtDateAllocated;
	CTDVString		sDateAllocated;
	CTDVDateTime	dtDateReturned;
	CTDVString		sDateReturned;
	CTDVDateTime	dtRecommendationDecisionDate;
	CTDVString		sRecommendationDecisionDate;
	bool			bSuccess = true;

	// if no object yet then create one
	if (IsEmpty())
	{
		bSuccess = bSuccess && CreateFromXMLText("<ARTICLE-LIST></ARTICLE-LIST>");
	}
	// build the XML for this article in a string
	// get each field at a time, only adding XML for it if it exists
	if (bSuccess)
	{
		sArticleXML = "<ARTICLE>";
		if (m_pSP->FieldExists("EntryID"))
		{
			iEntryID = m_pSP->GetIntField("EntryID");
			sArticleXML << "<ENTRY-ID>" << iEntryID << "</ENTRY-ID>";
		}
		if (m_pSP->FieldExists("h2g2ID"))
		{
			ih2g2ID = m_pSP->GetIntField("h2g2ID");
			sArticleXML << "<H2G2-ID>" << ih2g2ID << "</H2G2-ID>";
		}
		if (m_pSP->FieldExists("SiteID"))
		{
			iSiteID = m_pSP->GetIntField("SiteID");
			sArticleXML << "<SITEID>" << iSiteID << "</SITEID>";
		}
		if (m_pSP->FieldExists("RecommendationID"))
		{
			iRecommendationID = m_pSP->GetIntField("RecommendationID");
			sArticleXML << "<RECOMMENDATION-ID>" << iRecommendationID << "</RECOMMENDATION-ID>";
		}
		if (m_pSP->FieldExists("NotificationSent"))
		{
			iNotificationSent = m_pSP->GetIntField("NotificationSent");
			sArticleXML << "<NOTIFIED>" << iNotificationSent << "</NOTIFIED>";
		}
		// place all user details within a USER tag and structure them appropriately
		// editro info
		if (m_pSP->FieldExists("Editor") || m_pSP->FieldExists("EditorName"))
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "EDITOR"))
			{
				TDVASSERT(false, "CreateUserBlock for EDITOR failed");
			}
			else
			{
				sArticleXML += sUserXML;
			}
		}

		// author info
		if (m_pSP->FieldExists("AuthorID") || m_pSP->FieldExists("AuthorName"))
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "AUTHOR"))
			{
				TDVASSERT(false, "CreateUserBlock for AUTHOR failed");
			}
			else
			{
				sArticleXML += sUserXML;
			}
		}

		// acceptor info (user that accepted a recommendation)
		if (m_pSP->FieldExists("AcceptorID") || m_pSP->FieldExists("AcceptorName"))
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "ACCEPTOR"))
			{
				TDVASSERT(false, "CreateUserBlock for ACCEPTOR failed");
			}
			else
			{
				sArticleXML += sUserXML;
			}
		}

		// allocator info (user that allocated a recommendation to a sub)
		if (m_pSP->FieldExists("AllocatorID") || m_pSP->FieldExists("AllocatorName"))
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "ALLOCATOR"))
			{
				TDVASSERT(false, "CreateUserBlock for ALLOCATOR failed");
			}
			else
			{
				sArticleXML += sUserXML;
			}
		}

		// scout info
		if (m_pSP->FieldExists("ScoutID") || m_pSP->FieldExists("ScoutName"))
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "SCOUT"))
			{
				TDVASSERT(false, "CreateUserBlock for SCOUT failed");
			}
			else
			{
				sArticleXML += sUserXML;
			}
		}

		// sub editor info
		if (m_pSP->FieldExists("SubEditorID") || m_pSP->FieldExists("SubEditorName"))
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "SUBEDITOR"))
			{
				TDVASSERT(false, "CreateUserBlock for SUBEDITOR failed");
			}
			else
			{
				sArticleXML += sUserXML;
			}
		}

		if (m_pSP->FieldExists("Status"))
		{
			iStatus = m_pSP->GetIntField("Status");
			sArticleXML << "<STATUS>" << iStatus << "</STATUS>";
		}
		if (m_pSP->FieldExists("RecommendationStatus"))
		{
			iRecommendationStatus = m_pSP->GetIntField("RecommendationStatus");
			sArticleXML << "<RECOMMENDATION-STATUS>" << iRecommendationStatus << "</RECOMMENDATION-STATUS>";
		}
		if (m_pSP->FieldExists("SubbingStatus"))
		{
			iSubbingStatus = m_pSP->GetIntField("SubbingStatus");
			sArticleXML << "<SUBBING-STATUS>" << iSubbingStatus << "</SUBBING-STATUS>";
		}
		if (m_pSP->FieldExists("Style"))
		{
			iStyle = m_pSP->GetIntField("Style");
			sArticleXML << "<STYLE>" << iStyle << "</STYLE>";
		}
		if (m_pSP->FieldExists("Subject"))
		{
			m_pSP->GetField("Subject", sSubject);
			EscapeXMLText(&sSubject);
			sArticleXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
		}
		if (m_pSP->FieldExists("DateCreated"))
		{
			dtDateCreated = m_pSP->GetDateField("DateCreated");
			// get relative dates too
			dtDateCreated.GetAsXML(sDateCreated, true);
			sArticleXML << "<DATE-CREATED>" << sDateCreated << "</DATE-CREATED>";
		}
		if (m_pSP->FieldExists("LastUpdated"))
		{
			dtLastUpdated = m_pSP->GetDateField("LastUpdated");
			// get relative dates too
			dtLastUpdated.GetAsXML(sLastUpdated, true);
			sArticleXML << "<LASTUPDATED>" << sLastUpdated << "</LASTUPDATED>";
		}
		if (m_pSP->FieldExists("DateRecommended") && !m_pSP->IsNULL("DateRecommended"))
		{
			dtDateRecommended = m_pSP->GetDateField("DateRecommended");
			// get relative dates too
			dtDateRecommended.GetAsXML(sDateRecommended, true);
			sArticleXML << "<DATE-RECOMMENDED>" << sDateRecommended << "</DATE-RECOMMENDED>";
		}
		if (m_pSP->FieldExists("DecisionDate") && !m_pSP->IsNULL("DecisionDate"))
		{
			dtRecommendationDecisionDate = m_pSP->GetDateField("DecisionDate");
			// get relative dates too
			dtRecommendationDecisionDate.GetAsXML(sRecommendationDecisionDate, true);
			sArticleXML << "<RECOMMENDATION-DECISION-DATE>" << sRecommendationDecisionDate << "</RECOMMENDATION-DECISION-DATE>";
		}
		if (m_pSP->FieldExists("DateAllocated") && !m_pSP->IsNULL("DateAllocated"))
		{
			dtDateAllocated = m_pSP->GetDateField("DateAllocated");
			// get relative dates too
			dtDateAllocated.GetAsXML(sDateAllocated, true);
			sArticleXML << "<DATE-ALLOCATED>" << sDateAllocated << "</DATE-ALLOCATED>";
		}
		if (m_pSP->FieldExists("DateReturned") && !m_pSP->IsNULL("DateReturned"))
		{
			dtDateReturned = m_pSP->GetDateField("DateReturned");
			// get relative dates too
			dtDateReturned.GetAsXML(sDateReturned, true);
			sArticleXML << "<DATE-RETURNED>" << sDateReturned << "</DATE-RETURNED>";
		}
		if (m_pSP->FieldExists("ExtraInfo"))
		{
			CTDVString sExtraInfo;
			m_pSP->GetField("ExtraInfo",sExtraInfo);
			sArticleXML << sExtraInfo;
		}

		if (m_pSP->FieldExists("ForumPostCount"))
		{
			int iForumPostCount= m_pSP->GetIntField("ForumPostCount");
			sArticleXML << "<FORUMPOSTCOUNT>" << iForumPostCount << "</FORUMPOSTCOUNT>";			
			sArticleXML << "<FORUMPOSTLIMIT>" << m_InputContext.GetCurrentSiteOptionInt("Forum", "PostLimit") << "</FORUMPOSTLIMIT>";
		}

		CTDVString sTemp;
		if (m_pSP->FieldExists("StartDate") && !m_pSP->IsNULL("StartDate"))
		{
			sArticleXML << "<DATERANGESTART>";
			m_pSP->GetDateField("StartDate").GetAsXML(sTemp);
			sArticleXML << sTemp;
			sArticleXML << "</DATERANGESTART>";
		}
		
		if (m_pSP->FieldExists("EndDate") && !m_pSP->IsNULL("EndDate"))
		{
			sArticleXML << "<DATERANGEEND>";
			CTDVDateTime endDate = m_pSP->GetDateField("EndDate");
			// Take a day from the end date as stored in the database for UI purposes. 
			// E.g. User submits a date range of 01/09/1980 to 02/09/1980. They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00. 
			// This gets stored in the database but for display purposes we subtract a day from the database end date to return the 
			// original dates submitted by the user inorder to match their expectations.
			COleDateTimeSpan dInterval(1, 0, 0, 0);
			endDate = endDate - dInterval; 
			endDate.GetAsXML(sTemp);
			sArticleXML << sTemp;
			sArticleXML << "</DATERANGEEND>";
		}

		if (m_pSP->FieldExists("TimeInterval") && !m_pSP->IsNULL("TimeInterval"))
		{
			sArticleXML << "<TIMEINTERVAL>";
			sArticleXML << m_pSP->GetIntField("TimeInterval");
			sArticleXML << "</TIMEINTERVAL>";
		}

		sArticleXML << "</ARTICLE>";
		// add the article XML inside the ARTICLE-LIST element
		bSuccess = bSuccess && AddInside("ARTICLE-LIST", sArticleXML);
	}	
	// return the success value
	return bSuccess;
}

