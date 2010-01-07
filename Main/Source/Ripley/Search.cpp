// Search.cpp: implementation of the CSearch class.
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
#include "Search.h"
#include "tdvassert.h"
#include "StoredProcedure.h"
#include <vector>
#include ".\search.h"
#include "pollcontentrating.h"
#include "ExtraInfo.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSearch::CSearch(CInputContext& inputContext) : CXMLObject(inputContext)
{

}

CSearch::~CSearch()
{

}

/*********************************************************************************

	void CSearch::InitialiseArticleSearch

	Author:		Oscar Gillespie
	Created:	23/03/2000
	Modified:	09/03/2005 (jamesp) - ContentRating data
	Inputs:		
	const TDVCHAR* pcSearchString,				//Search string
					int iShowApproved,			//Filter on article status
					int iShowNormal,			//Filter on article status
					int iShowSubmitted,			//Filter on article status
					CTDVString* psUserGroups,	//Filter for author type.
					int iSkip,					//Articles to skip
					int iShow,					//Articles to show
					int iSiteID,				//SiteID 
					int iCategory,				//Filter on Category/Node
					int iSearcherID				//ID of user.
					int iShowContentRatingData	// When set to 1, will return content rating data as part of search results
	Outputs:	XML Search Results
	Returns:	true if results produced
	Purpose:	Conducts a search on articles
*********************************************************************************/
bool CSearch::InitialiseArticleSearch(const TDVCHAR* pcSearchString, int iShowApproved, int iShowNormal, int iShowSubmitted, const CTDVString* psUserGroups, int iSkip, int iShow, int iSiteID, int iCategory,int iSearcherID, int iShowContentRatingData, int iArticleType, int iArticleStatus)
{
	CTDVString			sSearch = pcSearchString;
	CTDVString			sCondition;
	CTDVString			sResults = "";
	CTDVString			sXMLForSearchResults;
	int					iActualKeywords = 0;
	bool				bResults = false;

	// SQL Server removes noise words itself, but we want to remove them
	// before constructing our query otherwise we may get odd results or
	// cause the query to not work properly
// no need to remove noise word here currently as they are removed whilst
// calculating the search condition
//	RemoveNoiseWords(&sSearch);
	// build the condition from the search terms - also needs the original, unmodified
	// search string that the user typed in

	sXMLForSearchResults << "<SEARCHRESULTS TYPE=\"ARTICLE\">";

	CTDVString sOriginalSearch = pcSearchString;
	EscapeXMLText(&sOriginalSearch);
	sXMLForSearchResults << "<SEARCHTERM>" << sOriginalSearch << "</SEARCHTERM>";

	CTDVString sEscapedTerm(sOriginalSearch);
	EscapeSearchTerm(&sEscapedTerm);
	sXMLForSearchResults << "<SAFESEARCHTERM>" << sEscapedTerm << "</SAFESEARCHTERM>";

	if (iCategory > 0)
	{
		sXMLForSearchResults << "<WITHINCATEGORY>" << iCategory << "</WITHINCATEGORY>";
	}

	if (iArticleType > 0)
	{
		sXMLForSearchResults << "<ARTICLETYPE>" << iArticleType << "</ARTICLETYPE>";
	}

	if (iArticleStatus > 0)
	{
		sXMLForSearchResults << "<ARTICLESTATUS>" << iArticleStatus << "</ARTICLESTATUS>";
	}

	//bool bSuccess = CalculateSearchCondition(pcSearchString, sSearch, &sCondition);
	bool bUseFreetext = m_InputContext.GetParamInt("s_searchusefreetext") == 1;
	if ( CalculateSearchCondition(pcSearchString, sSearch, &sCondition) && sSearch.GetLength() > 0)
	{
		CStoredProcedure	SP;
		
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			TDVASSERT(false, "Failed to create stored procedure in CSearch::Initialise()");
			// better to have tried and failed than to access a NULL pointer
			return false;
		}

// useful for debugging:
//sXMLForSearchResults << "<SEARCH-CONDITION>" << sCondition << "</SEARCH-CONDITION>";
		
		int		iBestEntryID = 0;
		double	dBestScore = 0.0;

		if (bUseFreetext)
		{
			bResults = SP.SearchArticlesFreetext(sCondition, iShowApproved, iShowNormal, iShowSubmitted, psUserGroups, sResults, &iBestEntryID, &dBestScore, iSkip, iShow, iSiteID, iCategory, iShowContentRatingData, iArticleType, iArticleStatus);
		}
		else if (UseFastSearch())
		{
			bResults = SP.SearchArticlesFast(sCondition, iShowApproved, iShowNormal, iShowSubmitted, psUserGroups, sResults, &iBestEntryID, &dBestScore, iSkip, iShow, iSiteID, iCategory, iShowContentRatingData, iArticleType);
		}
		else
		{
			bResults = SP.SearchArticles(sCondition, iShowApproved, iShowNormal, iShowSubmitted, psUserGroups, sResults, &iBestEntryID, &dBestScore, iSkip, iShow, iSiteID, iCategory, iShowContentRatingData, iArticleType, iArticleStatus);
		}
		if ( !bResults )
		{
			CTDVString error;
			int code;
			if ( SP.GetLastError(&error,code) )
			{
				TDVASSERT(false, error);
				SetDNALastError("CSearch::InitialiseArticleSearch", error, "Initialising Aricle Search" + sOriginalSearch);
			}
		}

		int iResultCount = 0;

		// Keep looping until we get EOF
		// generate XML for each matching user as we go
		CTDVString sResult;
		while (!SP.IsEOF() && iResultCount < iShow)
		{
			// start building up a section of xml for this chunk of information about a specific article
			sResult << "<ARTICLERESULT>";

			// get the status of the article
			int iStatus = SP.GetIntField("Status");
			sResult << "<STATUS>" << iStatus << "</STATUS>";

			int iArticleType = SP.GetIntField("Type");
			sResult << "<TYPE>" << iArticleType << "</TYPE>";
			
			// add the EntryID of the entry matching the search string
			int iEntryID = 0;
			iEntryID = SP.GetIntField("EntryID");

			sResult << "<ENTRYID>";
			sResult << iEntryID;
			sResult << "</ENTRYID>";
		
			// add the subject of the article
			CTDVString sArticleSubject = "";
			SP.GetField("Subject", sArticleSubject);

			// fix any sickness in the subject of the page
			CXMLObject::EscapeXMLText(&sArticleSubject);

			sResult << "<SUBJECT>";
			sResult << sArticleSubject;
			sResult << "</SUBJECT>";

			// add the h2g2ID of the article
			int ih2g2ID = 0;
			ih2g2ID = SP.GetIntField("h2g2ID");

			sResult << "<H2G2ID>" << ih2g2ID << "</H2G2ID>";

			//add the DateCreated column
			CTDVString  sDateCreated;
			CTDVDateTime dDateCreated = SP.GetDateField("DateCreated");
			dDateCreated.GetAsXML(sDateCreated, true);
			sResult << "<DATECREATED>";
			sResult << sDateCreated;
			sResult << "</DATECREATED>";

			//add the LastUpdated column
			CTDVString  sLastUpdated;
			CTDVDateTime dLastUpdated = SP.GetDateField("LastUpdated");
			dLastUpdated.GetAsXML(sLastUpdated, true);
			sResult << "<LASTUPDATED>";
			sResult << sLastUpdated;
			sResult << "</LASTUPDATED>";

			CTDVString sTemp;
			if (!SP.IsNULL("StartDate"))
			{
				sResult << "<DATERANGESTART>";
				SP.GetDateField("StartDate").GetAsXML(sTemp);
				sResult << sTemp;
				sResult << "</DATERANGESTART>";
			}
			
			if (!SP.IsNULL("EndDate"))
			{
				sResult << "<DATERANGEEND>";
				CTDVDateTime endDate = SP.GetDateField("EndDate");
				// Take a day from the end date as stored in the database for UI purposes. 
				// E.g. User submits a date range of 01/09/1980 to 02/09/1980. They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00. 
				// This gets stored in the database but for display purposes we subtract a day from the database end date to return the 
				// original dates submitted by the user inorder to match their expectations.
				COleDateTimeSpan dInterval(1, 0, 0, 0);
				endDate = endDate - dInterval; 
				endDate.GetAsXML(sTemp);
				sResult << sTemp;
				sResult << "</DATERANGEEND>";
			}

			if (!SP.IsNULL("TimeInterval"))
			{
				sResult << "<TIMEINTERVAL>";
				sResult << SP.GetIntField("TimeInterval");
				sResult << "</TIMEINTERVAL>";
			}
			
			// add the relevancy score for this article

			double dScore = 0.0;
			TDVCHAR cTemp[30];
			dScore = SP.GetDoubleField("Score");
			// turn score into a percentage and cut off the decimal point
			sprintf(cTemp, "%.0f", 100 * dScore);

			sResult << "<SCORE>"  << cTemp << "</SCORE>";

			int iArtSiteID = SP.GetIntField("SiteID");
			bool bPrimarySite = SP.GetBoolField("PrimarySite");
			sResult << "<SITEID>" << iArtSiteID << "</SITEID>";
			sResult << "<PRIMARYSITE>";
			if (bPrimarySite)
			{
				sResult << "1";
			}
			else
			{
				sResult << "0";
			}
			sResult << "</PRIMARYSITE>";

		
			CTDVString sExtra;
			SP.GetField("ExtraInfo", sExtra);

			//ExtraInfo includes <TYPE> XML - Fix it up to ensure it matches Article Type field.
			if ( !sExtra.IsEmpty() )
			{
				CExtraInfo xinfo;
				if ( xinfo.Create(iArticleType,sExtra) && xinfo.GetInfoAsXML(sExtra,false) )
					sResult << sExtra;
				else
				{
					TDVASSERT(false,"Unable to create extra info");
					SetDNALastError("CSearch::InitialiseArticleSearch","InitiaiseArticleSearch","Unable to create extra info");
				}
			}


			// Add content rating data
			if(iShowContentRatingData)
			{
				// Get content rating poll id.
				int nCRPollID = SP.GetIntField("CRPollID");

				// If nCRPollID is zero, article has no cr poll
				if(nCRPollID)
				{
					CPollContentRating Poll(m_InputContext, nCRPollID);

					// Set Stats
					Poll.SetContentRatingStatistics(SP.GetIntField("CRVoteCount"), SP.GetDoubleField("CRAverageRating"));

					// Generate XML without poll results, just stats
					if(!Poll.MakePollXML(CPoll::PollLink(nCRPollID, false), false))
					{
						TDVASSERT(false, "CStoredProcedure::SearchArticles() pPoll->MakePollXML failed");
					}
					else
					{
						// Add xml
						CTDVString sPollXML;
						if(!Poll.GetAsString(sPollXML))
						{
							TDVASSERT(false, "CStoredProcedure::SearchArticles() pPoll->GetAsString failed");
						}
						else
						{
							sResult << sPollXML;
						}
					}
				}
			}

			// finish building the block of info about the article
			sResult << "</ARTICLERESULT>";
		
			// increment the search result counter
			iResultCount++;
			// fetch the next row
			SP.MoveNext();
		}

		sResult << "<SKIP>";
		sResult << iSkip;
		sResult << "</SKIP>";
		sResult << "<COUNT>";
		sResult << iShow;
		sResult << "</COUNT>";
		sResult << "<MORE>";
		if (iResultCount < iShow)
		{
			// we didn't show a full quote of results so there are no more results
			sResult << "0";
		}
		else
		{
			// we got all we asked for so there's a good chance theres a few more there
			sResult << "1";
		}
		sResult << "</MORE>";
			
			// now record the search as a new search action, but only if the searchstring is
			// not completely empty and we are not skipping through an existing results set
//			if (bSuccess && strlen(pcSearchString) > 0 && iSkip == 0)
//			{
//				bool	bApprovedEntries = (iShowApproved == 1);
//				bool	bSubmittedEntries = (iShowSubmitted == 1);
//				bool	bNormalEntries = (iShowNormal == 1);
//				bool	bOK = true;
//
//				bOK = pSP->AddNewArticleSearchAction(pcSearchString, sSearchType, sCondition, iSearcherID,
//													bApprovedEntries, bSubmittedEntries, bNormalEntries,
//													iBestEntryID, dBestScore);
//				TDVASSERT(bOK, "AddNewArticleSearchAction failed in CSearch::Initialise(...)");
//			}
		sXMLForSearchResults << sResult;
	}

	sXMLForSearchResults << "</SEARCHRESULTS>";

	CreateFromXMLText( sXMLForSearchResults );
	return bResults;
}

/*********************************************************************************

	void CSearch::InitialiseForumSearch

	Author:		Oscar Gillespie
	Created:	23/03/2000
	Inputs:		const TDVCHAR* pcSearchString,	//Search string. 
				CTDVString* psUserGroups,		//Filter on author type guru, editor etc.
				int iSkip,						//Forums to skip
				int iShow,						//Forums to show
				int iSiteID,					//SiteID
				int iCategory,					//Filter on Category/Node.
				int iForumID,					//ForumID
				int iThreadID,					//ThreadID
				int iSearcherID					//ID of Viewer
	Outputs:	XML Search Results
	Returns:	true if results produced
	Purpose:	Conducts a search on forums
*********************************************************************************/
bool CSearch::InitialiseForumSearch(const TDVCHAR* pcSearchString, const CTDVString* psUserGroups, int iSkip, int iShow, int iSiteID, int iCategory, int iForumID, int iThreadID,int iSearcherID)
{
	CTDVString			sSearch = pcSearchString;
	CTDVString			sCondition;
	CTDVString			sResults = "";
	CTDVString			sXMLForSearchResults;
	int					iActualKeywords = 0;
	bool				bResults = false;

	// start building up the output XML
	sXMLForSearchResults << "<SEARCHRESULTS TYPE=\"FORUM\">";	

	CTDVString sOriginalSearch = pcSearchString;
	EscapeXMLText(&sOriginalSearch);

	sXMLForSearchResults << "<SEARCHTERM>" << sOriginalSearch << "</SEARCHTERM>";

	// useful for debugging:
	//sXMLForSearchResults << "<SEARCH-CONDITION>" << sCondition << "</SEARCH-CONDITION>";

	CTDVString sEscapedTerm(sOriginalSearch);
	sXMLForSearchResults << "<SAFESEARCHTERM>" << sEscapedTerm << "</SAFESEARCHTERM>";

	if (iCategory > 0)
	{
		sXMLForSearchResults << "<WITHINCATEGORY>" << iCategory << "</WITHINCATEGORY>";
	}

	// The Search service removes noise words itself, but we want to remove them
	// before constructing our query otherwise we may get odd results or
	// cause the query to not work properly
	// no need to remove noise word here currently as they are removed whilst
	// calculating the search condition
	//	RemoveNoiseWords(&sSearch);
	// build the condition from the search terms - also needs the original, unmodified
	// search string that the user typed in
	if ( CalculateSearchCondition(pcSearchString, sSearch, &sCondition) && sSearch.GetLength() > 0)
	{
		CStoredProcedure	SP;
		
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			TDVASSERT(false, "Failed to create stored procedure in CSearch::Initialise()");
			// better to have tried and failed than to access a NULL pointer
			return false;
		}

		int		iBestPostID = 0;
		double	dBestScore = 0.0;


		bResults = SP.SearchForums(sCondition, sResults, psUserGroups, iSkip, iShow, iSiteID, iForumID, iThreadID, &iBestPostID, &dBestScore);
		if ( !bResults )
		{
			CTDVString error;
			int code;
			if ( SP.GetLastError(&error,code) )
			{
				TDVASSERT(false, error);
				SetDNALastError("CSearch::InitialiseForumSearch",error,"Initialising Forum Search" + sOriginalSearch);
			}
		}

		// now record the search as a new search action, but only if the searchstring is
		// not completely empty and we are not skipping through an existing results set
//			if (bSuccess && strlen(pcSearchString) > 0 && iSkip == 0)
//			{
//				bool	bOK = true;
//
//				bOK = pSP->AddNewForumSearchAction(pcSearchString, sSearchType, sCondition, iSearcherID,
//													iBestPostID, dBestScore);
//				TDVASSERT(bOK, "AddNewForumSearchAction failed in CSearch::Initialise(...)");
//			}

				sXMLForSearchResults << sResults;
	}

	sXMLForSearchResults << "</SEARCHRESULTS>";

	//Not returning error in search.
	CreateFromXMLText( sXMLForSearchResults );
	return bResults;
}

/*********************************************************************************

	void CSearch::InitialiseNameOrEmailSearch

	Author:		Oscar Gillespie
	Created:	23/03/2000
	Inputs:		const TDVCHAR* pUserNameOrEmail, int iSkip, int iShow, int iSearcherID, bool bAllowEmailSearch, int iSiteID
	Outputs:	XML Search REsults
	Returns:	true if results produced
	Purpose:	Conducts a search on name / email
*********************************************************************************/
bool CSearch::InitialiseNameOrEmailSearch(const TDVCHAR* pUserNameOrEmail, int iSkip, int iShow, int iSearcherID, bool bAllowEmailSearch, int iSiteID)
{
	CTDVString sXMLForSearchResults = "";

	sXMLForSearchResults << "<SEARCHRESULTS TYPE=\"USER\">";

	CTDVString sOriginalSearch = pUserNameOrEmail;
	EscapeXMLText(&sOriginalSearch);
	
	sXMLForSearchResults << "<SEARCHTERM>";
	sXMLForSearchResults << sOriginalSearch;
	sXMLForSearchResults << "</SEARCHTERM>";

	CTDVString sEscapedTerm = sOriginalSearch;
	EscapeSearchTerm(&sEscapedTerm);

	sXMLForSearchResults << "<SAFESEARCHTERM>" << sEscapedTerm << "</SAFESEARCHTERM>";

	CTDVString sResults = "";
	
	// Create our stored procedure object
	CStoredProcedure SP;
	bool bGotSP = m_InputContext.InitialiseStoredProcedureObject(&SP);
	TDVASSERT(bGotSP, "Failed to create stored procedure in CSearch::InitialiseEmailSearch()");

	int		iBestUserID = 0;
	double	dBestScore = 0.0;
	
	bool bResults = SP.SearchUsers(pUserNameOrEmail, bAllowEmailSearch, sResults, iSkip, iShow, &iBestUserID, &dBestScore, iSiteID);
	if ( !bResults )
	{
		CTDVString error;
		int code;
		if ( SP.GetLastError(&error,code) )
		{
			TDVASSERT(false, error);
			SetDNALastError("CSearch::InitialisingNameEmailSearch",error,"Initialising Name/Email Search" + sOriginalSearch);
		}
	}

	// only store the search if it is a new one, not if it is skipping through
	// an existing result set
//	if (bSuccess && strlen(pUserNameOrEmail) > 0 && iSkip == 0)
//	{
//		// no special search condition currently for user searches so pass an empty string
//		bool	bOK = pSP->AddNewUserSearchAction(pUserNameOrEmail, "user", "", iSearcherID, iBestUserID, dBestScore);
//		TDVASSERT(bOK, "AddNewUserSearchAction failed in CSearch::InitialiseNameOrEmailSearch(...)");
//	}
	
	sXMLForSearchResults << sResults;
	sXMLForSearchResults << "</SEARCHRESULTS>";

	CreateFromXMLText( sXMLForSearchResults );
	return bResults;
}

/*********************************************************************************

	void CSearch::RemoveNoiseWords(CTDVString* pString)

	Author:		Kim Harries
	Created:	15/09/2000
	Inputs:		pString - the string from which noise words are to be removed
	Outputs:	pString - the string from which noise words have been removed
	Returns:	-
	Purpose:	Goes through the given string and removes all the words that are
				considered 'noise' words - i.e. words that are not useful to
				search on because e.g. they are so common place.

	Note:		Currently this method is not used as noise words are removed by
				using IsNoiseWord after being extracted from the string by
				CalculateSearchCondition, which is a more reliable method.

*********************************************************************************/

void CSearch::RemoveNoiseWords(CTDVString* pString)
{
	// if string not passed or is empty return without doing anything
	if (pString == NULL || pString->IsEmpty())
	{
		return;
	}
	// put whitespace at beggining and end of string for easier search
	// and replaces
	*pString = " " + (*pString) + " ";

	// remove "noise" words... will remove noise words _only_ if they aren't next to a " (bug)
	pString->Replace(" about "," ");
	pString->Replace(" 1 "," ");
	pString->Replace(" after "," ");
	pString->Replace(" 2 "," ");
	pString->Replace(" all "," ");
	pString->Replace(" also "," ");
	pString->Replace(" 3 "," ");
	pString->Replace(" an "," ");
	pString->Replace(" 4 "," ");
	pString->Replace(" and "," ");
	pString->Replace(" 5 "," ");
	pString->Replace(" another "," ");
	pString->Replace(" 6 "," ");
	pString->Replace(" any "," ");
	pString->Replace(" 7 "," ");
	pString->Replace(" are "," ");
	pString->Replace(" 8 "," ");
	pString->Replace(" as "," ");
	pString->Replace(" 9 "," ");
	pString->Replace(" at "," ");
	pString->Replace(" 0 "," ");

	pString->Replace(" be "," ");
	pString->Replace(" because "," ");
	pString->Replace(" been "," ");
	pString->Replace(" before "," ");
	pString->Replace(" being "," ");
	pString->Replace(" between "," ");
	pString->Replace(" both "," ");
	pString->Replace(" but "," ");
	pString->Replace(" by "," ");

	pString->Replace(" came "," ");
	pString->Replace(" can "," ");
	pString->Replace(" come "," ");
	pString->Replace(" could "," ");

	pString->Replace(" did "," ");
	pString->Replace(" do "," ");

	pString->Replace(" each "," ");

	pString->Replace(" for "," ");
	pString->Replace(" from "," ");

	pString->Replace(" get "," ");
	pString->Replace(" got "," ");
	
	pString->Replace(" has "," ");
	pString->Replace(" had "," ");
	pString->Replace(" he "," ");
	pString->Replace(" have "," ");
	pString->Replace(" her "," ");	
	pString->Replace(" here "," ");
	pString->Replace(" him "," ");
	pString->Replace(" himself "," ");
	pString->Replace(" his "," ");
	pString->Replace(" how "," ");

	pString->Replace(" if "," ");	
	pString->Replace(" in "," ");
	pString->Replace(" into "," ");
	pString->Replace(" is "," ");
	pString->Replace(" it "," ");

	pString->Replace(" like "," ");

	pString->Replace(" make "," ");
	pString->Replace(" many "," ");
	pString->Replace(" me "," ");
	pString->Replace(" might "," ");	
	pString->Replace(" more "," ");
	pString->Replace(" most "," ");	
	pString->Replace(" much "," ");
	pString->Replace(" must "," ");	
	pString->Replace(" my "," ");	

	pString->Replace(" never "," ");	
	pString->Replace(" now "," ");

	pString->Replace(" of "," ");
	pString->Replace(" on "," ");
	pString->Replace(" only "," ");
	pString->Replace(" or "," ");
	pString->Replace(" other "," ");
	pString->Replace(" our "," ");
	pString->Replace(" out "," ");
	pString->Replace(" over "," ");

	pString->Replace(" said "," ");
	pString->Replace(" same "," ");	
	pString->Replace(" see "," ");
	pString->Replace(" should "," ");
	pString->Replace(" since "," ");	
	pString->Replace(" some "," ");
	pString->Replace(" still "," ");
	pString->Replace(" such "," ");

	pString->Replace(" take "," ");	
	pString->Replace(" than "," ");	
	pString->Replace(" that "," ");
	pString->Replace(" the "," ");
	pString->Replace(" their "," ");
	pString->Replace(" them "," ");
	pString->Replace(" then "," ");	
	pString->Replace(" there "," ");
	pString->Replace(" these "," ");
	pString->Replace(" they "," ");
	pString->Replace(" this "," ");
	pString->Replace(" those "," ");
	pString->Replace(" through "," ");
	pString->Replace(" to "," ");
	pString->Replace(" too "," ");

	pString->Replace(" under "," ");
	pString->Replace(" up "," ");

	pString->Replace(" very "," ");

	pString->Replace(" was "," ");
	pString->Replace(" way "," ");
	pString->Replace(" we "," ");
	pString->Replace(" well "," ");
	pString->Replace(" were "," ");
	pString->Replace(" what "," ");	
	pString->Replace(" where "," ");
	pString->Replace(" which "," ");
	pString->Replace(" while "," ");	
	pString->Replace(" who "," ");
	pString->Replace(" with "," ");
	pString->Replace(" would "," ");	

	pString->Replace(" you "," ");
	pString->Replace(" your "," ");
	
	pString->Replace(" a "," ");
	pString->Replace(" b "," ");
	pString->Replace(" c "," ");
	pString->Replace(" d "," ");
	pString->Replace(" e "," ");
	pString->Replace(" f "," ");
	pString->Replace(" g "," ");
	pString->Replace(" h "," ");
	pString->Replace(" i "," ");	
	pString->Replace(" j "," ");		
	pString->Replace(" k "," ");
	pString->Replace(" l "," ");	
	pString->Replace(" m "," ");	
	pString->Replace(" n "," ");	
	pString->Replace(" o "," ");	
	pString->Replace(" p "," ");	
	pString->Replace(" q "," ");	
	pString->Replace(" r "," ");
	pString->Replace(" s "," ");	
	pString->Replace(" t "," ");
	pString->Replace(" u "," ");
	pString->Replace(" v "," ");
	pString->Replace(" w "," ");
	pString->Replace(" x "," ");
	pString->Replace(" y "," ");
	pString->Replace(" z "," ");

	// remove the space chars we added to the beginning and end
	if (pString->GetLength() > 0 && pString->GetAt(0) == ' ')
	{
		pString->RemoveLeftChars(1);
	}
	pString->RemoveTrailingChar(' ');
}

/*********************************************************************************

	bool CSearch::CalculateSearchCondition(const TDVCHAR* pUnmodifiedSearch, const TDVCHAR* pModifiedSearch, CTDVString* psCondition)

	Author:		Kim Harries
	Created:	15/09/2000
	Inputs:		pUnmodifiedSearch - the search string entered by the user, unmodified
				pModifiedSearch - the search string entered by the user, after having
					noise words removed and other adjustements
	Outputs:	psCondition - a string in which to out the search condition calculated
					from the users query that will be passed ot the stored procedure
	Returns:	true if successful, false if not.
	Purpose:	Processes the users search query and calculates from it a search
				condition suitable for being passed to the stored procedures for
				searching articles or forums.

	Note:		Due to weirdness on the part of SQL Server, despite the fact that
				it is supposed to ignore noise words a condition constructed using
				them seems to choke the SP. Hence it is important that they are
				removed by us before building the search condition.

*********************************************************************************/

bool CSearch::CalculateSearchCondition(const TDVCHAR* pUnmodifiedSearch, const TDVCHAR* pModifiedSearch, CTDVString* psCondition)
{
	bool bUseFreetext = false;		// use freetext search. If true, overrides all other options
	bool bIncludeNear = false;		// include 'near' predicate
	bool bIncludeFormsOf = true;	// Include inflectional terms
	bool bIncludeWholeSearch = true;// 
	bool bIncludeSingleTerms = true;// search for each term

	// Now override these defaults if the URL contains overrides
	if (m_InputContext.ParamExists("s_searchusefreetext"))
	{
		bUseFreetext = m_InputContext.GetParamInt("s_searchusefreetext") == 1;
	}
	if (m_InputContext.ParamExists("s_searchusenear"))
	{
		bIncludeNear = m_InputContext.GetParamInt("s_searchusenear") == 1;
	}
	if (m_InputContext.ParamExists("s_searchuseformsof"))
	{
		bIncludeFormsOf = m_InputContext.GetParamInt("s_searchuseformsof") == 1;
	}
	if (m_InputContext.ParamExists("s_searchusewhole"))
	{
		bIncludeWholeSearch = m_InputContext.GetParamInt("s_searchusewhole") == 1;
	}
	if (m_InputContext.ParamExists("s_searchusesingleterms"))
	{
		bIncludeSingleTerms = m_InputContext.GetParamInt("s_searchusesingleterms") == 1;
	}

	TDVASSERT(psCondition != NULL, "NULL psCondition in CSearch::CalculateSearchCondition(...)");
	// fail if no output parameter provided
	if (psCondition == NULL)
	{
		return false;
	}

	std::vector<CTDVString>	SearchTerms;
	CTDVString			sOriginalSearch = pUnmodifiedSearch;
	CTDVString			sSearch = pModifiedSearch;
	CTDVString			sTerm;
	unsigned char		cChar;
	TDVCHAR				cQuote = '?';
	int					iPos = 0;
	bool				bInsideSimpleTerm = false;
	bool				bInsideQuotedTerm = false;

	// go through search string character at a time and extract both
	// simple terms and quoted terms
	iPos = 0;
	while (iPos < sSearch.GetLength())
	{
		cChar = sSearch[iPos];
		// if a whitespace char
		if (isspace(cChar))
		{
			if (bInsideQuotedTerm)
			{
				// maintain whitespace inside quotes
				sTerm += cChar;
			}
			else if (bInsideSimpleTerm)
			{
				// whitespace indicates end of a simple term
				bInsideSimpleTerm = false;
				// only add the word to the list if it is not a noise word
				if (!IsNoiseWord(sTerm))
				{
					// surround all terms in quotes so apostraphes are not a problem
					sTerm = "\"" + sTerm + "\"";
					SearchTerms.insert(SearchTerms.end(), sTerm);
				}
				sTerm = "";
			}
			// all other whitespace discarded
		}
		else // if not a whitespace
		{
			// deal with quote characters
			// single quotes with no whitespace either side of them, and not at beginning or end
			// of string are assumed to be apostraphes
			if (cChar == '\'' && iPos > 0 && iPos + 1 < sSearch.GetLength() && !isspace(unsigned char(sSearch[iPos - 1])) && !isspace(unsigned char(sSearch[iPos + 1])))
			{
				sTerm += cChar;
			}
			else if (cChar == '\"' || cChar == '\'')
			{
				// if single quote is not being used as an apostraphe, then assume it
				// is used as a quote and convert it to a double quote char
				cChar = '\"';
				// if currently in a quoted term
				if (bInsideQuotedTerm)
				{
					// always add the quotes in
					sTerm += cChar;
					// if the end of this quoted term then finish it
					// and add it to the list
					if (cChar == cQuote)
					{
						bInsideQuotedTerm = false;
						// only add the phrase if it isn't just a noise word
						if (!IsNoiseWord(sTerm))
						{
							SearchTerms.insert(SearchTerms.end(), sTerm);
						}
						sTerm = "";
						cQuote = '?';
					}
				}
				else
				{
					// if currently in a simple term then end it first
					if (bInsideSimpleTerm)
					{
						bInsideSimpleTerm = false;
						// only add the word if not a noise word
						if (!IsNoiseWord(sTerm))
						{
							// surround all terms in quotes so apostraphes are not a problem
							sTerm = "\"" + sTerm + "\"";
							SearchTerms.insert(SearchTerms.end(), sTerm);
						}
						sTerm = "";
					}
					// start of a new quoted term
					bInsideQuotedTerm = true;
					sTerm += cChar;
					cQuote = cChar;
				}
			}
			else if (bInsideSimpleTerm || bInsideQuotedTerm)
			{
				// if doing either type of term then all non-quote,
				// non-whitespace chars are added to the term
				sTerm += cChar;
			}
			else
			{
				// if not already inside a search term this is a new
				// simple term
				bInsideSimpleTerm = true;
				sTerm += cChar;
			}
		}
		// move on to next char
		iPos++;
	}
	// at end if we were still in the middle of a term then end it
	if (bInsideQuotedTerm)
	{
		bInsideQuotedTerm = false;
		// only add the phrase if it is not just a noise word
		if (!IsNoiseWord(sTerm))
		{
			SearchTerms.insert(SearchTerms.end(), sTerm);
		}
	}
	else if (bInsideSimpleTerm)
	{
		bInsideSimpleTerm = false;
		// only add the word if it is not a noise word
		if (!IsNoiseWord(sTerm))
		{
			// surround all terms in quotes so apostraphes are not a problem
			sTerm = "\"" + sTerm + "\"";
			SearchTerms.insert(SearchTerms.end(), sTerm);
		}
	}

	// now we have all the search terms extracted we can build our search
	// condition from them
	const CTDVString	sSimpleWeight = "0.5";
	const CTDVString	sFormsOfWeight = "0.25";
	const CTDVString	sProximityWeight = "0.5";
	const CTDVString	sAllTogetherWeight = "1.0";
	int					iTotalSearchTerms = SearchTerms.size();
	int					i = 0;

	if (bUseFreetext)
	{
		*psCondition = "";
		for (i=0; i < iTotalSearchTerms; i++)
		{
			CTDVString sTerm = SearchTerms[i].Mid(1, SearchTerms[i].GetLength()-2);

				*psCondition << sTerm << " ";
		}
	}
	else if (UseFastSearch())
	{
		*psCondition = "";
		for (i=0; i < iTotalSearchTerms; i++)
		{
			*psCondition << SearchTerms[i];
			if (i < (iTotalSearchTerms-1))
			{
				*psCondition << " AND ";
			}
		}
	}
	else
	{
		CTDVString comma = " ";
		*psCondition = "isabout(";
		// first add each term in its simplist form
		if (bIncludeSingleTerms)
		{
			for (i = 0; i < iTotalSearchTerms; i++)
			{
				*psCondition << comma << SearchTerms[i] << " weight(" << sSimpleWeight << ")";
				comma = ",";
			}
		}
		// then add the inflectional forms of each term
		if (bIncludeFormsOf)
		{
			for (i = 0; i < iTotalSearchTerms; i++)
			{
				*psCondition << comma << "formsof(inflectional, " << SearchTerms[i] << ") weight(" << sFormsOfWeight << ")";
				comma = ",";
			}
		}
		// now do a proximity check on all terms if there is more than one

		if (bIncludeNear && iTotalSearchTerms > 1)
		{
			*psCondition << comma;
			for (i = 0; i < iTotalSearchTerms; i++)
			{
				*psCondition << SearchTerms[i] << " near ";
			}
			// remove the last ' near ' added
			*psCondition = psCondition->Left(psCondition->GetLength() - 6);
			*psCondition << " weight(" << sProximityWeight << ")";
			comma = ",";
		}

		// finally do a check for the exact search term as entered by the
		// user, but need to turn any double quotes into double double quotes
		// first, else it will choke the stored procedure
		if (bIncludeWholeSearch)
		{
			sOriginalSearch.Replace("\"", "\"\"");
			*psCondition << comma << "\"" << sOriginalSearch << "\" weight(" << sAllTogetherWeight << ")";
		}
		// close the final brackets on a well built query condition
		*psCondition << ")";
	}
	// return success
	return true;
}

/*********************************************************************************

	bool CSearch::EscapeSearchTerm(CTDVString&)

	Author:		Martin Robb
	Created:	19/11/2004
	Inputs:		String to escape
	Outputs:	-
	Returns:	NA
	Purpose:	Escapes non alphanumeric characters ( _-~  are acceptable too )

*********************************************************************************/
void CSearch::EscapeSearchTerm(CTDVString* psEscapedTerm)
{
	if ( !psEscapedTerm )
	{
		return;
	}

	//Take a copy of text to escape and clear output.
	CTDVString sOriginal(*psEscapedTerm);
	psEscapedTerm->Empty();

	int iPos = 0;
	int iLen = sOriginal.GetLength();
	while (iPos < iLen)
	{
		unsigned char ch = sOriginal.GetAt(iPos);
		if (ch == ' ')
		{
			*psEscapedTerm << "+";
		}
		else if ( isalnum(ch) || (strchr("_-~",ch) != NULL) )
		{
			*psEscapedTerm += ch;
		}
		else
		{
			char hextemp[20];
			sprintf(hextemp, "%%%2X", ch);
			*psEscapedTerm += hextemp;
		}
		iPos++;
	}
}

/*********************************************************************************

	bool CSearch::IsNoiseWord(const TDVCHAR* pWord)

	Author:		Kim Harries
	Created:	15/09/2000
	Inputs:		pWord - the string to check if it is a noise word
	Outputs:	-
	Returns:	true if it is a noise word, false if not
	Purpose:	Checks the given string to see if it matches any of the words we
				consider noise words.

*********************************************************************************/

bool CSearch::IsNoiseWord(const TDVCHAR* pWord)
{
	// create a string with all the noise words in it seperated by whitespace
	// includes a double space at the start so that the empty word will also match
	// string is the same for all calls to this method, so can be static
	static const CTDVString sNoiseWords = "  1 2 3 4 5 6 7 8 9 0 a b c d e f g h i j k l m n o p q r s t u v w x y z about after all also an and another any are as at be because been before being between both but by came can come could did do each for from get got has had he have her here him himself his how if in into is it like make many me might more most much must my never now of on only or other our out over said same see should since some still such take than that the their them then there these they this those through to too under up very was way we well were what where which while who with would you your ";
	CTDVString sWord = pWord;

	// empty string counts as noise - we don't want to try to search on it
	if (sWord.IsEmpty())
	{
		return true;
	}

	// we want to ignore any leading or trailing whitespace and quote chars
	int iStartChar = 0;
	int iEndChar = sWord.GetLength() - 1;

	// find the starting point for the actual word
	while (iStartChar < sWord.GetLength() && (sWord.GetAt(iStartChar) == ' ' ||
											  sWord.GetAt(iStartChar) == '\t' ||
											  sWord.GetAt(iStartChar) == '\n' ||
											  sWord.GetAt(iStartChar) == '"' ||
											  sWord.GetAt(iStartChar) == '\''))
	{
		iStartChar++;
	}
	// find the end point of the actual word
	while (iEndChar > 0 && (sWord.GetAt(iEndChar) == ' ' ||
							sWord.GetAt(iEndChar) == '\t' ||
							sWord.GetAt(iEndChar) == '\n' ||
							sWord.GetAt(iEndChar) == '"' ||
							sWord.GetAt(iEndChar) == '\''))
	{
		iEndChar--;
	}
	// if start is beyond end, string contains nothing useful
	if (iStartChar > iEndChar)
	{
		sWord = "";
	}
	else
	{
		// chop out the surrounding stuff, leaving the word in the middle
		sWord = sWord.Mid(iStartChar, 1 + iEndChar - iStartChar);
	}

	// put spaces on the end of the word and see if it is in the string
	// of noise words
	sWord = " " + sWord + " ";
	// do a case-insensitive search
	if (sNoiseWords.FindText(sWord) >= 0)
	{
		// if in the string, it is a noise word
		return true;
	}
	else
	{
		// otherwise it is not a noise word
		return false;
	}
}

/*********************************************************************************

	bool CSearch::InitialiseHierarchySearch(const TDVCHAR *pSearchString, int iSiteID,
											int iSkip, int iShow, const TDVCHAR *psBaseTag)

	Author:		Mark Howitt
	Created:	05/11/2003
	Inputs:		pSearchString - The string you want to search for.
				iSiteID - The ID of the site you want to look in
				iSkip - The Number of results you want to skip before processing the XML
				iShow - The number of results you want to put into the XML
				psBaseTag - A Pointer to a string that gives you the option of adding extra
					base tags. This is NULL by default, which means do not insert any new tags.
	Outputs:	-
	Returns:	true if results produced
	Purpose:	Searchs the Hierarchy for Nodes which contain the searchstring in
				their susbject. It also returns the ancestry for the nodes found.
				The psBaseTag string is an optional parameter which enables you to
				put the resultant XML into extra base tags if required.

*********************************************************************************/

bool CSearch::InitialiseHierarchySearch(const TDVCHAR *pSearchString, int iSiteID, int iSkip, int iShow)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	
	CTDVString sXML;
	sXML << "<SEARCHRESULTS TYPE='HIERARCHY'>\n";
	CTDVString sOriginalSearch = pSearchString;
	EscapeXMLText(&sOriginalSearch);

	sXML << "<SEARCHTERM>" << sOriginalSearch << "</SEARCHTERM>";
	
	CTDVString sEscapedTerm = sOriginalSearch;
	EscapeSearchTerm(&sEscapedTerm);
	sXML << "<SAFESEARCHTERM>" << sEscapedTerm << "</SAFESEARCHTERM>";

	CTDVString sCondition;
	CalculateSearchCondition(pSearchString, pSearchString, &sCondition);

	if ( !SP.SearchHierarchy(sCondition, iSiteID) )
	{
		CTDVString error;
		int code;
		if ( SP.GetLastError(&error,code) )
		{
			TDVASSERT(false, error);
			SetDNALastError("CSearch::InitialiseHierarchySearch",error,"Initialising Hierarchy Search" + sOriginalSearch);
		}
	}

	if (iShow > 200)
	{
		iShow = 200;
	}

	//Rely on ordering here - want to skip to the start of a hierarchy 
	//which will be immediately after a keynode match.
	//The skip refers to the number of hierarchies to skip not individual items.
	if(iSkip)
	{
		int iSkipCount = 0;
		while ( !SP.IsEOF() && iSkip > iSkipCount )
		{
			int iNodeID = SP.GetIntField("NodeID");
			int iKeyNodeID = SP.GetIntField("KEY");

			if ( ( iNodeID == iKeyNodeID ) )
			{
				++iSkipCount;
			}
			SP.MoveNext();
		}
	}

	// In order to return a complete ancestry, we return all ancestors as well as the matching nodes. 
	// We return them in level order, oldest ancestors first. 
	int iResultCount = 0;
	CTDVString sDisplayName;
	bool bGotResultStart = false;
	while (!SP.IsEOF() && (iResultCount < iShow) )
	{
		if (!bGotResultStart)
		{
			sXML << "<HIERARCHYRESULT>\n";
			bGotResultStart = true;
		}
		int iNodeID = SP.GetIntField("NodeID");
		int iKeyNodeID = SP.GetIntField("KEY");
		int iResultSiteID = SP.GetIntField("SiteID");
		int iNodeType = SP.GetIntField("Type");
		SP.GetField("DisplayName", sDisplayName);
		int iNodeCount =  SP.GetIntField("NodeMembers");
		int iRedirectNodeID = 0;
		CTDVString sRedirectNodeName = "";
		if (SP.FieldExists("RedirectNodeID") && !SP.IsNULL("RedirectNodeID"))
		{
			iRedirectNodeID = SP.GetIntField("RedirectNodeID");
			SP.GetField("RedirectNodeName",sRedirectNodeName);
		}

		EscapeXMLText(&sDisplayName);
		if (iNodeID == iKeyNodeID)
		{
			sXML << "<NODEID USERADD='" << SP.GetIntField("UserAdd") << "'>";
			sXML << iNodeID << "</NODEID>\n<SITEID>" << iResultSiteID << "</SITEID>\n";
			sXML << "<DISPLAYNAME>" << sDisplayName << "</DISPLAYNAME>";
			sXML << "<TYPE>" << iNodeType << "</TYPE>";
			sXML << "<NODECOUNT>" << iNodeCount << "</NODECOUNT>";
			if (iRedirectNodeID > 0)
			{
				sXML << "<REDIRECTNODE ID='" << iRedirectNodeID << "'>" << sRedirectNodeName << "</REDIRECTNODE>";
			}
			sXML << "</HIERARCHYRESULT>\n";
			iResultCount++;
			bGotResultStart = false;
		}
		else
		{
			sXML << "<ANCESTOR NODEID='" << iNodeID << "'";
			if (iRedirectNodeID > 0)
			{
				sXML << " REDIRECTNODEID='" << iRedirectNodeID << "'";
			}
			sXML << ">" << sDisplayName << "</ANCESTOR>";
		}

		SP.MoveNext();
	}

	sXML << "<SKIP>" << iSkip << "</SKIP>\n";
	sXML << "<COUNT>" << iShow << "</COUNT>\n";
	sXML << "<MORE>";
	if (!SP.IsEOF())
	{
		sXML << "1";
	}
	else
	{
		sXML << "0";
	}
	sXML << "</MORE>\n";
	sXML << "</SEARCHRESULTS>";

	CreateFromXMLText(sXML);

	//return true if results found
	return (iResultCount > 0); 
}

/*********************************************************************************

	bool CSearch::InitialiseNewSearch(const TDVCHAR* pSearchWords, bool bShowApproved, bool bShowNormal, bool bShowSubmitted, int iSiteID, bool bUseANDSearch, bool bPhraseSearch, int iShow, int iSkip, int iCategory)

		Author:		Mark Howitt
        Created:	13/09/2004
        Inputs:		pSearchWords - The Words to search for.
					bShowApproved - A flag that states whether or not to include approved articles.
					bShowNormal - A flag that states whether or not to include normal articles.
					bShowSubmitted - A flag that states whether or not to include submitted articles.
					iSiteID - The main site the articles must belong to.
					bUseANDSearch - A flag to state whether or not to use the AND search or the OR type
					bPhaseSearch - A flag that states whether the search should be a phrase search instead of search for all words.
					iShow - The number of results to show at one time.
					iSkip - The number of results to skip before showing.
					iCategory - If not 0, then search for articles that belong to the given category or children.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	NEW search procedure that uses AND searching. Also includes phrase searching.

*********************************************************************************/
bool CSearch::InitialiseNewSearch(const TDVCHAR* pSearchWords, bool bShowApproved, bool bShowNormal, bool bShowSubmittable, int iSiteID, bool bUseANDSearch, bool bPhraseSearch, int iShow, int iSkip, int iMaxResults, int iCategory)
{
	// Setup some local variables
	CStoredProcedure SP;
	bool bOk = m_InputContext.InitialiseStoredProcedureObject(&SP);
	
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	int iResults = 0;
	
	// Start by adding the XML
	bOk = OpenXMLTag("SEARCHRESULTS",true);
	bOk = bOk && AddXMLAttribute("TYPE","ARTICLES",true);
	
	// Make the seach safe
	CTDVString sSafeSearch = pSearchWords;
	if (!bPhraseSearch)
	{
		RemoveNoiseWords(&sSafeSearch);
	}

	CTDVString sSafeSearchEscaped = sSafeSearch;
	EscapeXMLText(&sSafeSearchEscaped);
	bOk = bOk && AddXMLTag("SEARCHTERM",sSafeSearch);
	bOk = bOk && AddXMLTag("SAFESEARCHTERM",sSafeSearchEscaped);
	if (!bPhraseSearch)
	{
		// We want to find articles which contain these words
		sSafeSearch.Replace(" ",",");
	}
	if (iCategory > 0)
	{
		AddXMLIntTag("WITHINCATEGORY",iCategory);
	}

	// Now call the search and get the results.
	if ( !SP.SearchArticlesNew(sSafeSearch,bShowApproved,bShowNormal,bShowSubmittable,bUseANDSearch,iSiteID,iCategory,iMaxResults) )
	{
		CTDVString error;
		int code;
		if ( SP.GetLastError(&error,code) )
		{
			TDVASSERT(false, error);
			SetDNALastError("CSearch::InitialiseNewSearch",error,"Initialising New Search" + sSafeSearch);
			bOk = false;
		}
	}
	
	// See if we need to skip any results
	bOk = bOk && SP.MoveNext(iSkip);

	// Now go through the results adding them to the xml
	while (bOk && !SP.IsEOF() && iResults <= iShow)
	{
		// Add each article in turn
		bOk = bOk && OpenXMLTag("ARTICLERESULT");
		bOk = bOk && AddDBXMLIntTag("STATUS");
		bOk = bOk && AddDBXMLIntTag("ENTRYID");
		bOk = bOk && AddDBXMLTag("SUBJECT");
		bOk = bOk && AddDBXMLIntTag("H2G2ID");
		bOk = bOk && AddDBXMLDateTag("DATECREATED");
		bOk = bOk && AddDBXMLDateTag("LASTUPDATED");
		bOk = bOk && AddDBXMLDoubleTag("SCORE");
		bOk = bOk && AddDBXMLIntTag("SITEID");
		bOk = bOk && AddDBXMLIntTag("PRIMARYSITE");
		bOk = bOk && AddDBXMLTag("EXTRAINFO",NULL,false);
		bOk = bOk && CloseXMLTag("ARTICLERESULT");
		SP.MoveNext();
		iResults++;
	}

	// Insert the skip, show and more tags
	bOk = bOk && AddXMLIntTag("COUNT",iShow);
	bOk = bOk && AddXMLIntTag("SKIP",iSkip);
	if (iResults < iShow)
	{
		bOk = bOk && AddXMLIntTag("MORE",0);
	}
	else
	{
		bOk = bOk && AddXMLIntTag("MORE",1);
	}

	// Now close and then create the XML
	CloseXMLTag("SEARCHRESULTS");
	return bOk && CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool CSearch::UseFastSearch()

		Author:		Mark Neves
		Created:	12/06/2007
		Inputs:		-
		Outputs:	-
		Returns:	true if the system should use the fast free text search
		Purpose:	Centralises the logic that determines if DNA should use the fast
					free text search for the current request

*********************************************************************************/

bool CSearch::UseFastSearch()
{
	// if usefastsearch is on the URL, use it's value to override the site option setting

	if (m_InputContext.ParamExists("usefastsearch"))
    {
		return m_InputContext.GetParamInt("usefastsearch") == 1;
    }
    else
    {
		return m_InputContext.DoesCurrentSiteHaveSiteOptionSet("ArticleSearch","FastFreetextSearch");
    }
}

