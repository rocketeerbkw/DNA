// RandomArticle.cpp: implementation of the CRandomArticle class.
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
#include "RandomArticle.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "TDVString.h"
#include "TDVDateTime.h"
#include "TDVAssert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CRandomArticle::CRandomArticle(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_pSP(NULL),
	m_ih2g2ID(0),
	m_iSiteID(1)
{
	// no further construction required
}

CRandomArticle::~CRandomArticle()
{
	// make sure SP is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	bool CRandomArticle::CreateRandomNormalEntry()

	Author:		Kim Harries
	Created:	29/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Selects a random entry for all the user entries, i.e. status = 3.

*********************************************************************************/

bool CRandomArticle::CreateRandomNormalEntry()
{
	return CreateRandomArticleSelection(3);
}

/*********************************************************************************

	bool CRandomArticle::CreateRandomRecommendedEntry()

	Author:		Kim Harries
	Created:	29/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Selects a random entry for all the user entries, i.e. status = 3.

*********************************************************************************/

bool CRandomArticle::CreateRandomRecommendedEntry()
{
	return CreateRandomArticleSelection(4);
}

/*********************************************************************************

	bool CRandomArticle::CreateRandomEditedEntry()

	Author:		Kim Harries
	Created:	29/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Selects a random entry for all the user entries, i.e. status = 3.

*********************************************************************************/

bool CRandomArticle::CreateRandomEditedEntry()
{
	return CreateRandomArticleSelection(1);
}

/*********************************************************************************

	bool CRandomArticle::CreateRandomAnyEntry()

	Author:		Kim Harries
	Created:	29/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Selects a random entry from any edited, recommended, or normal entry.

*********************************************************************************/

bool CRandomArticle::CreateRandomAnyEntry()
{
	return CreateRandomArticleSelection(1, 3, 4);
}

/*********************************************************************************

	int CRandomArticle::Geth2g2ID()

	Author:		Kim Harries
	Created:	30/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	the h2g2 ID of the randomnly selected article
	Purpose:	Gets the h2g2 ID of this article.

*********************************************************************************/

int CRandomArticle::Geth2g2ID()
{
	return m_ih2g2ID;
}

/*********************************************************************************

	bool CreateRandomArticleSelection(int iStatus1, int iStatus2 = -1, int iStatus3 = -1, int iStatus4 = -1, int iStatus5 = -1);

	Author:		Kim Harries
	Created:	29/11/2000
	Inputs:		iTargetStatus - the status of guide entry that we want to
					select randomly from
	Outputs:	-
	Returns:	true if successful
	Purpose:	Selects an entry at random from all those with the given status
				and builds an XML representation summarising it.

*********************************************************************************/

bool CRandomArticle::CreateRandomArticleSelection(int iStatus1, int iStatus2, int iStatus3, int iStatus4, int iStatus5)
{
	// create and SP if we don't already have one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if still no sp then must fail
	if (m_pSP == NULL)
	{
		return false;
	}
	CTDVString		sXML;
	int				iEntryID = 0;
	int				ih2g2ID = 0;
	int				iEditorID = 0;
	CTDVString		sSubject;
	CTDVString		sEditorName;
	CTDVDateTime	dtDateCreated;
	CTDVString		sDateCreated;
	bool			bSuccess = true;

	CTDVString		sEditorFirstNames, sEditorLastName, sEditorArea, sEditorSiteSuffix, sEditorTitle;
	int				nEditorStatus(0), nEditorTaxonomyNode(0), nEditorJournal(0), nEditorActive(0);

	// now call the fetch random article SP
	bSuccess = bSuccess && m_pSP->FetchRandomArticle(m_iSiteID, iStatus1, iStatus2, iStatus3, iStatus4, iStatus5);
	// if okay then lets create some XML
	if (bSuccess)
	{
		// create some XML for this selection
		sXML = "<RANDOM-ARTICLE>";
		iEntryID = m_pSP->GetIntField("EntryID");
		ih2g2ID = m_pSP->GetIntField("h2g2ID");

		// Get edior data
		iEditorID = m_pSP->GetIntField("Editor");
		nEditorStatus = m_pSP->GetIntField("EditorStatus");
		nEditorTaxonomyNode = m_pSP->GetIntField("EditorTaxonomyNode");
		nEditorJournal = m_pSP->GetIntField("EditorJournal");
		nEditorActive = m_pSP->GetIntField("EditorActive");
		m_pSP->GetField("EditorName", sEditorName);
		EscapeAllXML(&sEditorName);
		m_pSP->GetField("EditorFirstNames", sEditorFirstNames);
		EscapeAllXML(&sEditorFirstNames);
		m_pSP->GetField("EditorLastName", sEditorLastName);
		EscapeAllXML(&sEditorLastName);
		m_pSP->GetField("EditorArea", sEditorArea);
		EscapeAllXML(&sEditorArea);
		m_pSP->GetField("EditorSiteSuffix", sEditorSiteSuffix);
		EscapeAllXML(&sEditorSiteSuffix);
		m_pSP->GetField("EditorTitle", sEditorTitle);
		EscapeAllXML(&sEditorTitle);
		
		dtDateCreated = m_pSP->GetDateField("DateCreated");
		dtDateCreated.GetAsXML(sDateCreated, true);
		sXML << "<ENTRY-ID>" << iEntryID << "</ENTRY-ID>";
		sXML << "<H2G2-ID>" << ih2g2ID << "</H2G2-ID>";
		
		// Get Editor groups
		CTDVString sEditorGroups;
		if(!m_InputContext.GetUserGroups(sEditorGroups, iEditorID))
		{
			TDVASSERT(false, "Failed to get user groups for editor");
		}

		sXML << "<EDITOR><USER>" 
			 << "<USERID>"			<< iEditorID			<< "</USERID>"
			 << "<USERNAME>"		<< sEditorName			<< "</USERNAME>"
			 << "<FIRSTNAMES>"		<< sEditorFirstNames	<< "</FIRSTNAMES>"
			 << "<LASTNAME>"		<< sEditorLastName		<< "</LASTNAME>"
			 << "<AREA>"			<< sEditorArea			<< "</AREA>"
			 << "<STATUS>"			<< nEditorStatus		<< "</STATUS>"
			 << "<TAXONOMYNODE>"	<< nEditorTaxonomyNode	<< "</TAXONOMYNODE>"
			 << "<JOURNAL>"			<< nEditorJournal		<< "</JOURNAL>"
			 << "<ACTIVE>"			<< nEditorActive		<< "</ACTIVE>"
			 << "<SITESUFFIX>"		<< sEditorSiteSuffix	<< "</SITESUFFIX>"
			 << "<TITLE>"			<< sEditorTitle			<< "</TITLE>"
			 << sEditorGroups
			 << "</USER></EDITOR>";

		sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
		sXML << "<DATE-CREATED>" << sDateCreated << "</DATE-CREATED>";
		sXML << "</RANDOM-ARTICLE>";
		bSuccess = bSuccess && CreateFromXMLText(sXML);
	}
	// if all worked then set member variables as well
	if (bSuccess)
	{
		m_ih2g2ID = ih2g2ID;
	}
	// return the success value
	return bSuccess;
}

bool CRandomArticle::SetCurrentSite(int iSiteID)
{
	m_iSiteID = iSiteID;
	return true;
}