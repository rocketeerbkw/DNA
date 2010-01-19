// ResearcherList.cpp: implementation of the CAuthorList class.
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
#include "User.h"
#include "AuthorList.h"


/*********************************************************************************
CAuthorList::CAuthorList(CInputContext& inputContext)
Author:		David van Zijl
Created:	25/05/2004
Purpose:	Constructor
*********************************************************************************/

CAuthorList::CAuthorList(CInputContext& inputContext) :
	CUserList(inputContext),
	m_ih2g2ID(0),
	m_iEditorID(0)
{
}


/*********************************************************************************
CAuthorList::~CAuthorList()
Author:		David van Zijl
Created:	25/05/2004
Purpose:	Destructor
*********************************************************************************/

CAuthorList::~CAuthorList()
{
	// make sure m_pSP is deleted safely
	if (m_pSP != NULL)
	{
		delete m_pSP;
		m_pSP = NULL;
	}
}


/*********************************************************************************

	bool CAuthorList::GenerateListForEditForm()

	Author:		Kim Harries
	Created:	04/01/2001
	Inputs:		iEntryID - ID of the entry whose researcher list we want
	Outputs:	-
	Returns:	true if successful, false if not.
	Purpose:	Creates a list of all the researchers for a particular Guide Entry.

*********************************************************************************/

bool CAuthorList::GenerateListForEditForm()
{
	int iEntryID = m_ih2g2ID / 10;

	// if entry ID is zero then create a blank list
	if (iEntryID == 0)
	{
		return CreateEmptyList("USER-LIST", "ENTRY-RESEARCHERS");
	}
	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if SP is still NULL then must fail
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Could not create SP in CAuthorList::CreateListFromEntryID");
		return false;
	}
	// do not want to use cache for this list as it needs to be up to date
	bool bSuccess = true;
	// now proceed with calling the appropriate stored procedure
	bSuccess = bSuccess && m_pSP->FetchEntriesResearchers(iEntryID, m_InputContext.GetSiteID());
	// use the generic helper method to create the actual list
	// use arbitrary very large number to ensure all researchers are fetched
	bSuccess = bSuccess && CreateList(100000, 0);
	// now set the list type attribute
	bSuccess = bSuccess && SetAttribute("USER-LIST", "TYPE", "ENTRY-RESEARCHERS");
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CAuthorList::AddResearcher(int iUserID)

	Author:		Kim Harries, David van Zijl
	Created:	05/01/2001
	Inputs:		iUserID - ID of the researcher to add
	Outputs:	-
	Returns:	true if successful
	Purpose:	Adds the given researcher to the internal list of researchers for
				this entry. Update in the database will only occur when the objects
				update method is called.

*********************************************************************************/

bool CAuthorList::AddResearcher(int iUserID)
{
	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}

	// create a SP to get the user data
	if (!m_InputContext.InitialiseStoredProcedureObject(m_pSP))
	{
		return false;
	}

	// first confirm the users existence and get the required details
	bool bSuccess = true;
	CTDVString sXML;

	// get this users details, if they exist
	if (m_pSP->GetUserFromUserID(iUserID, m_InputContext.GetSiteID()) && !m_pSP->IsEOF())
	{
		// Add user if not already in list
		if (!FindUserInList(iUserID))
		{
			GenerateSingleResearcher(sXML, iUserID);

			// now insert this data into the user list object representing the researchers
			bSuccess = bSuccess && AddInside("USER-LIST", sXML);
		}

		m_pSP->Release();
	}

	return bSuccess;
}

/*********************************************************************************

	bool CAuthorList::SetNewResearcherList(const TDVCHAR *pList)

	Author:		Jim Lynn
	Created:	02/07/2001
	Inputs:		pList - CSV string containing the researchers we want to add
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Takes a comma-separated string of user numbers and uses it
				to create a new list of researchers for an article. Will add
				a whole list to the current list, removing any existing ones,
				so the list passed in will be the definitive list of researchers.

*********************************************************************************/

bool CAuthorList::SetNewResearcherList(const TDVCHAR *pList)
{
	// Make sure we start with an empty list:
	ClearResearcherList();

	// Scan through the list and add each researcher in turn.
	int iPos = 0;
	int iEndPos = 0;
	TDVCHAR* pTerminator = (TDVCHAR*)pList + strlen(pList);
	
	// First strip off any trailing non-digits
	pList += strcspn(pList, "0123456789");
	while (pList[0] != 0)
	{
		CTDVString sNum;
		iEndPos = strspn(pList, "0123456789");
		sNum.AppendMid(pList, pTerminator - pList, 0, iEndPos);
		
		// Now we have the ID to append...
		
		int iUserID = atoi(sNum);
		AddResearcher(iUserID);
		pList += iEndPos;
		pList += strcspn(pList, "0123456789");
	}
	return true;
}

/*********************************************************************************

	bool CAuthorList::ClearResearcherList()

	Author:		David van Zijl
	Created:	25/05/2004
	Inputs:		-
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Clear the current user list so you will be left with XML that 
				reads like <USER-LIST></USER-LIST> for ArticleEditForm, and 
				<RESEARCHER></RESEARCHER> for normal articles.

*********************************************************************************/

bool CAuthorList::ClearResearcherList()
{
	Destroy();
	
	if (m_ArticleType == ARTICLE_EDITFORM)
	{
		CreateEmptyList(TAGNAME_EDITFORM_RESEARCHER_LIST, "ENTRY-RESEARCHERS");
	}
	else // ARTICLE
	{
		CreateEmptyList(TAGNAME_ARTICLE_RESEARCHER_LIST);
	}

	return true;
}

/*********************************************************************************

	bool CAuthorList::GenerateListForArticle(CUser* pAuthor)

	Author:		Jim Lynn (moved into a separate function from BuildTreeFromData() by Mark Neves)
	Created:	30/09/2003
	Inputs:		ih2g2ID = id of article in question
				pAuthor = ptr to the author of this article (can be NULL if not known)
				iEditorID = ID of the user that is the editor of the article (overridden if pAuthor if not NULL)
	Outputs:	sResearcherXML = a string that will be filled with a list of all the researchers associated with the article
				m_sEditorXML = a string that will be filled with the article's editor's info
	Returns:	true if OK
	Purpose:	Allows the page author XML to be extracted into two separate XML strings, one for the researchers list, 
				and one for the Editor's information
				
*********************************************************************************/

bool CAuthorList::GenerateListForArticle()
{
	bool bSuccess = true;

	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}

/*
	if (pAuthor != NULL)
	{
		bSuccess = bSuccess && pAuthor->GetUserID(&iEditorID);
	}
*/

	// Create empty list
	//
	if (IsEmpty())
	{
		CreateEmptyList(TAGNAME_ARTICLE_RESEARCHER_LIST);
	}
	else
	{
		ClearResearcherList();
	}

	bool bKeepLooking = false;
	if (m_ih2g2ID > 0)
	{
		bKeepLooking = m_pSP->GetResearchersFromH2G2id(m_ih2g2ID);
	}
	else
	{
		// if no h2g2id has been given, then just get the groups this user belongs to 
		// in the current site
		bKeepLooking = m_pSP->GetGroupsFromUserAndSite(m_iEditorID, m_InputContext.GetSiteID());
	}

	TDVASSERT(bSuccess, "Could not get editor ID or username in CGuideEntry::GetPageAuthorInfo(...)");

	int iResearcherID = 0;

	// Get user list, keep editor in it's own section
	//
	while (!m_pSP->IsEOF() && bSuccess)
	{
		iResearcherID = m_pSP->GetIntField("UserID");

		if (iResearcherID == m_iEditorID)
		{
			// Add to editor XML (separated from normal user list)
			//
			CTDVString sNewUserXML = "";
			bSuccess = bSuccess && GenerateSingleResearcher(sNewUserXML, iResearcherID);
			m_sEditorXML << "<EDITOR>" << sNewUserXML << "</EDITOR>";
		}
		else
		{
			CTDVString sResearcherXML;
			bSuccess = bSuccess && GenerateSingleResearcher(sResearcherXML, iResearcherID);
			bSuccess = bSuccess && AddInside(TAGNAME_ARTICLE_RESEARCHER_LIST, sResearcherXML);
		}
	}

	return bSuccess;
}

/*********************************************************************************

	bool CAuthorList::CommitChanges()

	Author:		David van Zijl
	Created:	25/05/2004
	Inputs:		-
	Outputs:	-
	Returns:	true if OK
	Purpose:	Commits changes made to the researcher list to the database
				For legacy reasons, all updates are done in a 2 stage process, 
				update XML list then make the actual change. Might be worth reviewing 
				this some time.
				
*********************************************************************************/

bool CAuthorList::CommitChanges()
{
	// if we have an SP then use it, else create a new one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}

	int*	piResearcherIDArray = NULL;
	int		iTotalResearchers = 0;
	bool bSuccess = true;

	// get the list of user IDs then use them to update the researcher list
	bSuccess = bSuccess && GetUserIDs(&piResearcherIDArray, &iTotalResearchers);
	bSuccess = bSuccess && m_pSP->UpdateEntryResearcherList(m_ih2g2ID / 10, m_iEditorID, piResearcherIDArray, iTotalResearchers);

	// now make sure the array is deleted
	if (piResearcherIDArray != NULL)
	{
		delete piResearcherIDArray;
		piResearcherIDArray = NULL;
	}

	m_pSP->Release();

	return bSuccess;
}

/*********************************************************************************

	void CAuthorList::GetListAsString(CTDVString& listAsString)

	Author:		David van Zijl
	Created:	25/05/2004
	Inputs:		-
	Outputs:	listAsString - List of researchers in one long XML string
	Returns:	-
	Purpose:	Entire researcher list is returned in a single string.
				For typed articles, returns researcher list and editor XML.
				
*********************************************************************************/

void CAuthorList::GetListAsString(CTDVString& listAsString)
{
	if (m_ArticleType == ARTICLE_EDITFORM)
	{
		// Return researcher list in one
		GetAsString(listAsString);
	}
	else if (m_ArticleType == ARTICLE)
	{
		// Researcher list excludes the editor, which is in it's own block (m_sEditorXML)
		GetAsString(listAsString);
		listAsString << m_sEditorXML;
	}
	else
	{
		TDVASSERT(false, "CAuthorList::GetListAsString - Bad value for m_ArticleType");
	}
}

/*********************************************************************************

	bool CAuthorList::GenerateSingleResearcher(CTDVString& sNewUserXML, int iResearcherID)

	Author:		David van Zijl
	Created:	25/05/2004
	Inputs:		iResearcherID - UserID of this researcher
	Outputs:	sNewUserXML - new XML is stored here
	Returns:	true on success
	Purpose:	Creates XML for a single user including all groups he belongs
				to.
				
*********************************************************************************/

bool CAuthorList::GenerateSingleResearcher(CTDVString& sNewUserXML, int iResearcherID)
{
	bool bSuccess = true;

	// Get username
	//
	CTDVString sResearcherName = "";
	m_pSP->GetField("UserName", sResearcherName);
	if (sResearcherName.GetLength() > 0)
	{
		EscapeXMLText(&sResearcherName);
	}
	else
	{
		sResearcherName << "Researcher " << iResearcherID;
	}

	// Initialise the XML Builder
	//
	InitialiseXMLBuilder(&sNewUserXML, m_pSP);

	bSuccess = bSuccess && OpenXMLTag("USER");
	bSuccess = bSuccess && AddXMLIntTag("USERID", iResearcherID);
	bSuccess = bSuccess && AddXMLTag("UserName", sResearcherName);
	bSuccess = bSuccess && AddDBXMLTag("Title",NULL,false);
	/*	
	bSuccess = bSuccess && OpenXMLTag("AREA");
	int nTaxonomyNode = 0;
	m_pSP->GetField("TaxonomyNode", nTaxonomyNode);
	if (nTaxonomyNode > 0)
	{
		bSuccess = bSuccess && AddDBXMLIntTag("TaxonomyNode","TAXONOMYNODE");	
	}
	bSuccess = bSuccess && CloseXMLTag("AREA");	
	*/ 
	bSuccess = bSuccess && AddDBXMLTag("Area",NULL,false);
	if ( bSuccess )
	{		
		int nTaxonomyNode = 0;
		if (m_pSP->FieldExists("TaxonomyNode"))
		{
			nTaxonomyNode = m_pSP->GetIntField("TaxonomyNode");

			if (nTaxonomyNode > 0)
			{		
				bSuccess = bSuccess && AddXMLIntTag("TAXONOMYNODE", nTaxonomyNode);
			}
		}
	}	
	bSuccess = bSuccess && AddDBXMLTag("FirstNames",NULL,false);
	bSuccess = bSuccess && AddDBXMLTag("LastName",NULL,false);
	bSuccess = bSuccess && AddDBXMLTag("SiteSuffix",NULL,false);
	bSuccess = bSuccess && AddDBXMLDoubleTag("Score", NULL, false);
	if (bSuccess)
	{
		// Add groups
		if (m_pSP->FieldExists("GroupName") && !m_pSP->IsNULL("GroupName"))
		{
			// There's at least one group - so create the groups section
			bool bGotGroup = true;
			bSuccess = bSuccess && OpenXMLTag("GROUPS");
			while (bGotGroup) 
			{
				bSuccess = bSuccess && OpenXMLTag("GROUP", true);
				bSuccess = bSuccess && AddDBXMLAttribute("GroupName", "NAME", false, false, true);
				bSuccess = bSuccess && CloseXMLTag("GROUP");

				// Move to next row and make sure we are still dealing with current user
				m_pSP->MoveNext();
				bGotGroup = !(m_pSP->IsEOF()) && !(m_pSP->IsNULL("GroupName")) && (m_pSP->GetIntField("UserID") == iResearcherID);
			}
			bSuccess = bSuccess && CloseXMLTag("GROUPS");
		}
		else
		{
			// NO group, so move to the next entry
			m_pSP->MoveNext();
		}
	}

	return bSuccess && CloseXMLTag("USER");
}

/*********************************************************************************

	bool CAuthorList::GenerateList()

	Author:		David van Zijl
	Created:	25/05/2004
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Calls relevant method to generate list of researchers.

*********************************************************************************/

bool CAuthorList::GenerateList()
{
	if (m_ArticleType == ARTICLE_EDITFORM)
	{
		return GenerateListForEditForm();
	}
	else // ARTICLE
	{
		return GenerateListForArticle();
	}
}
