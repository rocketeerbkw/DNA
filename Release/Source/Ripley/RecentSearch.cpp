// RecentSearch.cpp: implementation of the CSearch class.
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
#include "RecentSearch.h"
#include "tdvassert.h"
#include "StoredProcedure.h"
#include "ProfanityFilter.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CRecentSearch::CRecentSearch(CInputContext& inputContext) : CXMLObject(inputContext)
{

}

CRecentSearch::~CRecentSearch()
{

}

/*********************************************************************************

	bool		CRecentSearch::Initialise()

	Author:		Martin Robb
	Created:	8/12/04
	Inputs:		bRefresh parameter - true, forces a refresh of cache
	Outputs:	NA
	Returns:	true on success, false on error
	Purpose:	Creates recent Search XML
*********************************************************************************/
bool CRecentSearch::Initialise( bool bRefresh )
{	
	CTDVString sXML;

	CTDVDateTime dExpires(60*5);		// expire after 5 minutes
	CTDVString cachename;
	cachename << "recentsearch-" << m_InputContext.GetSiteID() << ".xml";
		
	// Unless refresh is set, try to get from cache
	bool bCached = !bRefresh && CacheGetItem("recentsearch", cachename, &dExpires, &sXML);
	if ( !bCached )
	{
		//Get Recent Searches for this site from DB
		CStoredProcedure recentsearches;
		m_InputContext.InitialiseStoredProcedureObject(recentsearches);
		recentsearches.GetRecentSearches(m_InputContext.GetSiteID());

		InitialiseXMLBuilder(&sXML,&recentsearches);

		CTDVString sQueryText;
		int PrevType = -1;
		bool bCloseTag = false;

		//Create XML 
		OpenXMLTag("RECENTSEARCHES",false);
		while ( !recentsearches.IsEOF() )
		{
			OpenXMLTag("SEARCHTERM",false);
			
			//Add Name attribute
			recentsearches.GetField("TERM",sQueryText);
			EscapeXMLText(&sQueryText);
			AddXMLTag("NAME",sQueryText);

			//Add Type Element
			int Type = recentsearches.GetIntField("TYPE");
			switch ( Type )
			{
			case ARTICLE:
				AddXMLTag("Type","ARTICLE");
				break;
			case FORUM:
				AddXMLTag("Type","FORUM");
				break;
			case USER:
				AddXMLTag("Type","USER");
				break;
			case HIERARCHY:
				AddXMLTag("Type","HIERARCHY");
				break;
			case KEYPHRASE:
				AddXMLTag("Type","KEYPHRASE");
				break;
			default:
				//Error - Unknown type.
				TDVASSERT(false, "Unknown Type");
				SetDNALastError("CRecentSearch::Initialise", "Unkown Search Type", "Initialising Recent Search");
				return false;
			}

			//Add time stamp.
			CTDVDateTime stamp = recentsearches.GetDateField("STAMP");
			CTDVString sStamp;
			if ( stamp.GetAsString(sStamp) )
			{
				AddXMLTag("TIMESTAMP",sStamp);
			}

			AddDBXMLIntTag("COUNT");

			CloseXMLTag("SEARCHTERM");
			recentsearches.MoveNext();
		}
		CloseXMLTag("RECENTSEARCHES");

		CachePutItem("recentsearch", cachename, sXML);
	}

	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool		CRecentSearch::AddSearchTerm()
	Author:		Martin Robb
	Created:	8/12/04
	Inputs:		Search term and search type.
	Outputs:	NA
	Returns:	true on success
	Purpose:	Adds a new search term to the database
*********************************************************************************/
bool CRecentSearch::AddSearchTerm(const CTDVString& sSearch, SEARCHTYPE Type)
{
	//Scan Search Term
	CProfanityFilter ProfanityFilter(m_InputContext);
	CProfanityFilter::FilterState fs = ProfanityFilter.CheckForProfanities(sSearch);
	bool bSuccess = false;
	if ( fs != CProfanityFilter::FailBlock )
	{
		CStoredProcedure RecentSearch;
		m_InputContext.InitialiseStoredProcedureObject(&RecentSearch);
		bool bSuccess = RecentSearch.UpdateRecentSearch(m_InputContext.GetSiteID(),int(Type),sSearch);
	}

	return bSuccess;
}


