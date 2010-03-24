// ComingUpBuilder.cpp: implementation of the CComingUpBuilder class.
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
#include "ripleyserver.h"
#include "ComingUpBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CComingUpBuilder::CComingUpBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{

}

CComingUpBuilder::~CComingUpBuilder()
{

}

bool CComingUpBuilder::Build(CWholePage* pPage)
{
	InitPage(pPage, "COMING-UP", true);
	CTDVString sXML;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	int iSiteID = m_InputContext.GetSiteID();
	SP.GetAcceptedEntries(iSiteID);

	// just output the raw XML here - possibly paged...
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	if (iShow <= 0)
	{
		iShow = 40;
	}
	if (iSkip < 0)
	{
		iSkip = 0;
	}

	if (iSkip > 0)
	{
		SP.MoveNext(iSkip);
	}

	sXML << "<RECOMMENDATIONS COUNT='" << iShow << "' SKIPTO='" << iSkip << "'>";
	
	while (!SP.IsEOF())
	{
		sXML << "<RECOMMENDATION>";
		CTDVString sSubject;
		CTDVString sSubName;
		CTDVString sScoutName;
		SP.GetField("SubEditorName", sSubName);
		SP.GetField("ScoutName", sScoutName);
		SP.GetField("Subject", sSubject);
		CXMLObject::EscapeXMLText(&sSubject);
		CXMLObject::EscapeXMLText(&sSubName);
		CXMLObject::EscapeXMLText(&sScoutName);

		int iGuideStatus = SP.GetIntField("GuideStatus");
		int iAcceptedStatus = SP.GetIntField("AcceptedStatus");
		int iOriginalEntryID = SP.GetIntField("OriginalEntryID");
		int iOriginalh2g2ID = SP.GetIntField("Originalh2g2ID");
		int iNewEntryID = SP.GetIntField("EntryID");
		int iNewh2g2ID = SP.GetIntField("h2g2ID");
		int iSubEditorID = SP.GetIntField("SubEditorID");
		int iScoutID = SP.GetIntField("ScoutID");
		CTDVDateTime dDateAllocated;
		CTDVDateTime dDateReturned;
		bool bDateAllocated = !SP.IsNULL("DateAllocated");
		bool bDateReturned = !SP.IsNULL("DateReturned");
		if (bDateAllocated)
		{
			dDateAllocated = SP.GetDateField("DateAllocated");
		}
		if (bDateReturned)
		{
			dDateReturned = SP.GetDateField("DateReturned");
		}

		sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
		sXML << "<ACCEPTEDSTATUS>" << iAcceptedStatus << "</ACCEPTEDSTATUS>";
		sXML << "<GUIDESTATUS>" << iGuideStatus << "</GUIDESTATUS>";
		sXML << "<ORIGINAL><ENTRYID>" << iOriginalEntryID << "</ENTRYID>";
		sXML << "<H2G2ID>" << iOriginalh2g2ID << "</H2G2ID></ORIGINAL>";
		sXML << "<EDITED><ENTRYID>" << iNewEntryID << "</ENTRYID>";
		sXML << "<H2G2ID>" << iNewh2g2ID << "</H2G2ID></EDITED>";
		
		// Get scrout groups
		CTDVString sScoutGroups;
		if(!m_InputContext.GetUserGroups(sScoutGroups, iScoutID))
		{
			TDVASSERT(false, "Failed to get User Groups");
		}

		// Get additional user fields
		CTDVString sScoutFirstNames, sScoutLastName, sScoutArea, sScoutSiteSuffix, sScoutSiteTitle;
		int nScoutTaxonomyNode(0), nScoutJournal(0), nScoutActive(0), nScoutStatus(0);
		
		SP.GetField("ScoutFirstNames", sScoutFirstNames);
		CXMLObject::EscapeXMLText(&sScoutFirstNames);

		SP.GetField("ScoutLastName", sScoutLastName);
		CXMLObject::EscapeXMLText(&sScoutLastName);

		SP.GetField("ScoutArea", sScoutArea);
		CXMLObject::EscapeXMLText(&sScoutArea);

		SP.GetField("ScoutSiteSuffix", sScoutSiteSuffix);
		CXMLObject::EscapeXMLText(&sScoutSiteSuffix);

		SP.GetField("ScoutTitle", sScoutSiteTitle);
		CXMLObject::EscapeXMLText(&sScoutSiteTitle);

		nScoutStatus = SP.GetIntField("ScoutStatus");
		nScoutTaxonomyNode = SP.GetIntField("ScoutTaxonomyNode");
		nScoutJournal = SP.GetIntField("ScoutJournal");
		nScoutActive = SP.GetIntField("ScoutActive");

		sXML << "<SCOUT><USER>"
			 << "<USERNAME>"	<< sScoutName		<< "</USERNAME>"
			 << "<USERID>"		<< iScoutID			<< "</USERID>"
			 << "<FIRSTNAMES>"	<< sScoutFirstNames	<< "</FIRSTNAMES>"
			 << "<LASTNAME>"	<< sScoutLastName	<< "</LASTNAME>"
			 << "<AREA>"		<< sScoutArea		<< "</AREA>"
			 << "<SITESUFFIX>"	<< sScoutSiteSuffix	<< "</SITESUFFIX>"
			 << "<TITLE>"		<< sScoutSiteTitle	<< "</TITLE>"
			 << "<STATUS>"		<< nScoutStatus		<< "</STATUS>"
			 << "<TAXONOMYNODE>" << nScoutTaxonomyNode << "</TAXONOMYNODE>"
			 << "<JOURNAL>"		<< nScoutJournal	<< "</JOURNAL>"
			 << "<ACTIVE>"		<< nScoutActive		<< "</ACTIVE>"
			 << sScoutGroups
			 << "</USER></SCOUT>";

		// Get Sub Editor groups
		CTDVString sSubEditorGroups;
		if(!m_InputContext.GetUserGroups(sSubEditorGroups, iSubEditorID))
		{
			TDVASSERT(false, "Failed to get User Groups");
		}

		// Get additional user fields
		CTDVString sSubEditorFirstNames, sSubEditorLastName, sSubEditorArea, sSubEditorSiteSuffix, sSubEditorSiteTitle;
		int nSubEditorTaxonomyNode(0), nSubEditorJournal(0), nSubEditorActive(0), nSubEditorStatus(0);
		
		SP.GetField("SubEditorFirstNames", sSubEditorFirstNames);
		CXMLObject::EscapeXMLText(&sSubEditorFirstNames);

		SP.GetField("SubEditorLastName", sSubEditorLastName);
		CXMLObject::EscapeXMLText(&sSubEditorLastName);

		SP.GetField("SubEditorArea", sSubEditorArea);
		CXMLObject::EscapeXMLText(&sSubEditorArea);

		SP.GetField("SubEditorSiteSuffix", sSubEditorSiteSuffix);
		CXMLObject::EscapeXMLText(&sSubEditorSiteSuffix);

		SP.GetField("SubEditorTitle", sSubEditorSiteTitle);
		CXMLObject::EscapeXMLText(&sSubEditorSiteTitle);

		nSubEditorStatus = SP.GetIntField("SubEditorStatus");
		nSubEditorTaxonomyNode = SP.GetIntField("SubEditorTaxonomyNode");
		nSubEditorJournal = SP.GetIntField("SubEditorJournal");
		nSubEditorActive = SP.GetIntField("SubEditorActive");

		sXML << "<SUBEDITOR><USER>"
			 << "<USERNAME>"	<< sSubName				<< "</USERNAME>"
			 << "<USERID>"		<< iSubEditorID			<< "</USERID>"
			 << "<FIRSTNAMES>"	<< sSubEditorFirstNames	<< "</FIRSTNAMES>"
			 << "<LASTNAME>"	<< sSubEditorLastName	<< "</LASTNAME>"
			 << "<AREA>"		<< sSubEditorArea		<< "</AREA>"
			 << "<SITESUFFIX>"	<< sSubEditorSiteSuffix	<< "</SITESUFFIX>"
			 << "<TITLE>"		<< sSubEditorSiteTitle	<< "</TITLE>"
			 << "<STATUS>"		<< nSubEditorStatus		<< "</STATUS>"
			 << "<TAXONOMYNODE>"<< nSubEditorTaxonomyNode << "</TAXONOMYNODE>"
			 << "<JOURNAL>"		<< nSubEditorJournal	<< "</JOURNAL>"
			 << "<ACTIVE>"		<< nSubEditorActive		<< "</ACTIVE>"
			 << sSubEditorGroups
			 << "</USER></SUBEDITOR>";

		CTDVString sDate;
		
		if (bDateAllocated)
		{
			dDateAllocated.GetAsXML(sDate, true);
			sXML << "<DATEALLOCATED>" << sDate << "</DATEALLOCATED>";
			sDate.Empty();
		}
		if (bDateReturned)
		{
			dDateReturned.GetAsXML(sDate, true);
			sXML << "<DATERETURNED>" << sDate << "</DATERETURNED>";
			sDate.Empty();
		}
		sXML << "</RECOMMENDATION>";

		SP.MoveNext();
	}

	sXML << "</RECOMMENDATIONS>";
	if (!SP.IsEOF())
	{
		// More rows so display the More flag
		sXML.Replace("<RECOMMEDNATIONS", "<RECOMMENDATIONS MORE='1'");
	}

	pPage->AddInside("H2G2", sXML);
	return true;
}
