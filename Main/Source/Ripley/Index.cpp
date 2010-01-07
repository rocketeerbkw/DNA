// Index.cpp: implementation of the CIndex class.
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
#include "Index.h"
#include "tdvassert.h"
#include "StoredProcedure.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CIndex::CIndex(CInputContext& inputContext) : CXMLObject(inputContext)
{

}

CIndex::~CIndex()
{

}

/*********************************************************************************

	CIndex::Initialise()

	Author:		Oscar Gillespie
	Created:	14/03/2000
	Modified:	17/03/2000
	Inputs:		const TDVCHAR* sLetter - the letter the user is interested in (first letter of entries)
				bool bShowApproved - show approved entries?
				bool bShowSubmitted - show submitted entries?
				bool bShowUnapproved - show unapproved entries?
				CTDVString& sGroupFilter - Group name to filter on
				const int iTypesCount - Number of type values to filter against
				int* pTypesList - A list of types to filter on
				int iOrderBy - A Variable to determine the ordering of the results.
					0 (Default)	= Sort By Subject
					1			= Sort by date created
					2			= Sort by last updated
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Initialises the CIndex with XML listing all articles in the index
				(subject to stingyness).
				
*********************************************************************************/

bool CIndex::Initialise(const TDVCHAR* sLetter, int iSiteID, bool bShowApproved, bool bShowSubmitted,
						bool bShowUnapproved, int iShow, int iSkip, CTDVString& sGroupFilter,
						const int iTypesCount, int* pTypesList, const TDVCHAR* psOrderBy)
{
	if (iShow == 0)
	{
		iShow = 50;
	}

	// string holding the XML for the page showing the list of online users
	CTDVString sXMLText;

	// create a stored procedure to access the database
	CStoredProcedure SP;
	bool bGotSP = m_InputContext.InitialiseStoredProcedureObject(&SP);

	TDVASSERT(bGotSP, "m_InputContext.CreateStoredProcedureObject() returned null :(");

	//	sOrderBy - A Variable to determine the ordering of the results.
	//	(Empty)		= Sort By Subject		= 0
	//	datecreated	= Sort by date created	= 1
	//	lastupdated	= Sort by last updated	= 2
	int iOrderBy = 0;
	CTDVString sOrderBy = psOrderBy;
	if (sOrderBy.CompareText("datecreated"))
	{
		iOrderBy = 1;
	}
	else if (sOrderBy.CompareText("lastupdated"))
	{
		iOrderBy = 2;
	}

	// attempt to query the database through the stored procedure
	// asking for Index XML
	CTDVString sIndexEntries = "";
	int iTotalCount = 0;
	bool bSuccess = SP.FetchIndexEntries(sLetter, iSiteID, sIndexEntries, bShowApproved, bShowSubmitted, bShowUnapproved, sGroupFilter, iTypesCount, pTypesList, iOrderBy);

	if (bSuccess)
	{
		// Skip over however many we need to skip
		if (iSkip > 0)
		{
			SP.MoveNext(iSkip);
		}
	
		// Get the total number of entries
		iTotalCount = SP.GetIntField("Count");
		
		// start building the XML to return
		sIndexEntries << "<INDEX";
		sIndexEntries << " LETTER='" << sLetter << "'";
		if (bShowApproved)
		{
			sIndexEntries << " APPROVED='on'";
		}
		if (bShowUnapproved)
		{
			sIndexEntries << " UNAPPROVED='on'";
		}
		if (bShowSubmitted)
		{
			sIndexEntries << " SUBMITTED='on'";
		}
		sIndexEntries << " COUNT='" << iShow << "'";
		sIndexEntries << " SKIP='" << iSkip << "'";
		sIndexEntries << " TOTAL='" << iTotalCount << "'";

		if (!sGroupFilter.IsEmpty())
		{
			EscapeEverything(&sGroupFilter);
			sIndexEntries << " GROUP='" << sGroupFilter << "'";
		}

		// Put the order by info into the xml
		if (iOrderBy > 0)
		{
			sIndexEntries << " ORDERBY='" << sOrderBy << "'";
		}

		// Now close the index tag correclty!
		sIndexEntries << ">";

		// Now add all the types we're looking for
		if (iTypesCount > 0)
		{
			sIndexEntries << "<SEARCHTYPES>";
			for (int i = 0; i < iTypesCount; i++)
			{
				sIndexEntries << "<TYPE>" << pTypesList[i] << "</TYPE>";
			}
			sIndexEntries << "</SEARCHTYPES>";
		}
		
		// Keep looping until we get EOF
		// generate XML for each online user as we go
		while (!SP.IsEOF() && bSuccess == true && iShow > 0)
		{

			int iStatus = SP.GetIntField("Status");
			// find out what status the current article has
			
			// if A) they want to show approved articles and the current article is marked as approved
			// or B) they want to show submitted articles and the current article is marked as submitted
			// or C) they want to show unapproved articles and the current article is marked as unapproved

			// List of status meanings (taken from llama/GuideEntryObject.pm 17/03/2000
			//
			//	"No status",                           0
			//	"Official Guide Entry",                1
			//	"User entry, private",                 2
			//	"User entry, public",                  3
			//	"Submitted Article",                   4
			//	"Locked by editor",                    5
			//	"Awaiting Approval",                   6
			//	"Cancelled",                           7
			//	"User entry, staff-locked",            8
			//	"Guide Key Article",                   9
			//	"Guide General Page",				   10
			//	"Awaiting Rejection",                  11
			//	"Unsure: Awaiting Editorial Decision", 12
			//	"Waiting to go Official"               13

			CTDVString sStatus = "";

			if (iStatus == 1)
			{
				sStatus = "APPROVED";
			}
			else if (iStatus > 3 && iStatus < 14 && iStatus != 7 && iStatus != 9 && iStatus != 10)
			{
				sStatus = "SUBMITTED";
			}
			else if (iStatus == 3)
			{
				sStatus = "UNAPPROVED";
			}
			else
			{
				sStatus = "SHAGGED";
			}

			// start building up a section of xml for this chunk of information about a specific article
			sIndexEntries << "<INDEXENTRY>";
			
			// add the h2g2ID of the entry
			int ih2g2ID = 0;
			ih2g2ID = SP.GetIntField("h2g2ID");

			sIndexEntries << "<H2G2ID>" << ih2g2ID << "</H2G2ID>";

			// add the subject of the entry
			CTDVString sEntrySubject = "";
			SP.GetField("Subject", sEntrySubject);

			// fix any sickness in the subject of the page
			EscapeXMLText(&sEntrySubject);

			sIndexEntries << "<SUBJECT>";
			
			sIndexEntries << sEntrySubject;

			sIndexEntries << "</SUBJECT>";

			// iStatus is worked out earlier in the code... add the status of the article
			sIndexEntries << "<STATUSNUMBER>" << iStatus << "</STATUSNUMBER>";

			// and the string explaining the status
			sIndexEntries << "<STATUS>" << sStatus << "</STATUS>";

			// Now add the extrainfo for the article if we've got any
			if (!SP.IsNULL("ExtraInfo"))
			{
				CTDVString sExtraInfo;
				SP.GetField("ExtraInfo",sExtraInfo);
				sIndexEntries << sExtraInfo;
			}

			CTDVDateTime dDate = SP.GetDateField("DateCreated");
			CTDVString sDate = "";
			dDate.GetAsXML(sDate);

			sIndexEntries << "<DATECREATED>" << sDate << "</DATECREATED>\n";

			// finish building the block of info about the article
			sIndexEntries << "</INDEXENTRY>";

			// fetch the next row
			SP.MoveNext();
			iShow--;
		}
		
		// finish building the xml representing the query
		sIndexEntries << "</INDEX>";

		sXMLText << sIndexEntries;
		
		bSuccess = CreateFromXMLText(sXMLText);
		
		// see if there's any left...
		if (bSuccess && !SP.IsEOF())
		{
			CXMLTree* pFNode = m_pTree->FindFirstTagName("INDEX");
			TDVASSERT(pFNode != NULL, "NULL node returned - couldn't find INDEX element");

			if (pFNode != NULL)
			{
				pFNode->SetAttribute("MORE","1");
			}
		}
	}

	// express whether the stuff we've made will parse into an XML Object happily or not
	if (bSuccess)
	{
		return true;
	}
	else
	{
		return CXMLObject::CreateFromXMLText("<INDEX><INDEXERROR>Failed to find the Index entries you wanted. Sorry.</INDEXERROR></INDEX>");
	}
}