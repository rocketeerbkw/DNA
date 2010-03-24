// SearchBuilder.cpp: implementation of the CSearchBuilder class.
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
#include "PageUI.h"
#include "SearchBuilder.h"
#include "Search.h"
#include "tdvassert.h"
#include "RecentSearch.h"
#include "Groups.h"

#include "postcodeparser.h"
#include "Notice.h"
#include "profanityfilter.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


/*********************************************************************************

	CWholePage* CSearchBuilder::CSearchBuilder

	Author:		Oscar Gillespie
	Created:	23/3/00
	Inputs:		CInputContext*
	Outputs:	CInputContext*
	Returns:	NA
	Purpose:	Construction
*********************************************************************************/
CSearchBuilder::CSearchBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}


/*********************************************************************************

	CSearchBuilder::~CSearchBuilder

	Author:		Oscar Gillespie
	Created:	23/3/00
	Inputs:		NA
	Outputs:	NA
	Returns:	NA
	Purpose:	Destruction
*********************************************************************************/
CSearchBuilder::~CSearchBuilder()
{

}

/*********************************************************************************

	CWholePage* CSearchBuilder::Build()

	Author:		Oscar Gillespie
	Created:	23/3/00
	Modified:	08/03/05 (Jamesp)
	Inputs:		CWholePage*
	Outputs:	CWholePage*
	Returns:	true on success, false on error
	Purpose:	Creates Search Page.
				Uses CSearch to create the search results xml.
				Adds a search functionality xml block to describe search options available.
				UserGroups parameter(s) ( Optional ) - restricts search to authors which are members of the specified groups.
				Category parameter ( Optional ) - restricts search to provided category/node and ancestors.
				ShowContentRatingData ( Optional ) - When set to 1, will return content rating data for article
*********************************************************************************/
bool CSearchBuilder::Build(CWholePage* pPageXML)
{
	CUser*			pViewer = NULL; // the viewing user and his/her xml representation
	int				iViewerID = 0;
	const int		iSiteID = m_InputContext.GetSiteID();

	pViewer = m_InputContext.GetCurrentUser(); // get this and don't delete it in this function
	
	if ( pViewer )
	{
		iViewerID = pViewer->GetUserID();
	}

	bool bSuccess = true; // success tracking variable

	bSuccess = InitPage(pPageXML, "SEARCH",true);

	CTDVString sSiteXML;
	m_InputContext.GetSiteListAsXML(&sSiteXML);
	bSuccess = bSuccess && pPageXML->AddInside("H2G2", sSiteXML);

	bSuccess = bSuccess && pPageXML->AddInside("H2G2","<SEARCH></SEARCH>");

	//Unable to initialise - abort.
	if ( !bSuccess )
	{
		return false;
	}

	CTDVString sSearchType = "";
	bool bShowApproved = (m_InputContext.GetParamInt("showapproved") == 1);
	bool bShowSubmitted = (m_InputContext.GetParamInt("showsubmitted") == 1);
	bool bShowNormal = (m_InputContext.GetParamInt("shownormal") == 1);
	bool bShowContentRatingData = (m_InputContext.GetParamInt("showcontentratingdata") == 1);

	int iForumID = 0;
	int iThreadID = 0;

	int iCategory = m_InputContext.GetParamInt("category");
	
	if (!bShowApproved && !bShowSubmitted && !bShowNormal)
	{
		// if no types of article are specified default to whole guide
		bShowApproved = true;
		bShowSubmitted = true;
		bShowNormal = true;
	}


	//Process Author Type Filter
	// Read each group name passed as a parameter and create comma sparated list.
	CTDVString	sUserGroups;
	CTDVString* psUserGroups = NULL;
	int			iParams = m_InputContext.GetParamCount("UserGroups");
	for (int i = 0; i < iParams; i++)
	{
		if ( i != 0 )
		{
			sUserGroups << ",";
		}
		int ID = m_InputContext.GetParamInt("UserGroups",i);
		sUserGroups << ID;
	}
	if ( !sUserGroups.IsEmpty() )
	{
		psUserGroups = &sUserGroups;
	}


	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	if (iShow == 0)
	{
		// default case... show 20 search results at a time
		iShow = 20;
	}

	CTDVString sSearchString = "";
	bool bGotSearchString = m_InputContext.GetParamString("searchstring", sSearchString);
	CProfanityFilter profanityFilter(m_InputContext);
	CProfanityFilter::FilterState filterState = profanityFilter.CheckForProfanities(sSearchString);
	if (filterState == CProfanityFilter::FailBlock && !pViewer->GetIsEditor())
	{
		bGotSearchString = false;
	}

	m_InputContext.GetParamString("searchtype", sSearchType);

	//detect postcode searches
	if ( m_InputContext.GetAllowPostCodesInSearch() > 0  )
	{
		//detect if string is a postcode
		CPostCodeParser oPostCodeParser ;		
		if (oPostCodeParser.IsPostCode(sSearchString))
		{			
			CTDVString sActualPostCode ="";
			CTDVString sActualPostCodeXML = "";
			int iNode=0;
			CNotice oNotice(m_InputContext);

			int nRes =  oNotice.GetDetailsForPostCodeArea(sSearchString, iSiteID, iNode, sActualPostCode, sActualPostCodeXML);
			if (nRes == CNotice::PR_REQUESTOK)
			{
				if (iNode)
				{
					CTDVString sCatgeory(iNode);
					sCatgeory = "C" + sCatgeory;
					pPageXML->Redirect(sCatgeory);
					return true;
				}
			}
			else if ( nRes == CNotice::PR_POSTCODENOTFOUND)
			{
				SetDNALastError("CSearchBuilder::Build", "PostcodeNotFound", sSearchString + " could not be found");
				pPageXML->AddInside("H2G2",GetLastErrorAsXMLString());
				return true;
			}
			else if (nRes == CNotice::PR_REQUESTTIMEOUT)
			{
				SetDNALastError("CSearchBuilder::Build", "RequestTimedOut", "Request timed out");
				pPageXML->AddInside("H2G2",GetLastErrorAsXMLString());
				return true;
			}
		}
		else if ( oPostCodeParser.IsCloseMatch(sSearchString) )
		{
			SetDNALastError("CSearchBuilder::Build", "PostCodeError", sSearchString + " looks like a post code, but it is invalid");
			pPageXML->AddInside("H2G2",GetLastErrorAsXMLString());
			return true;
		}
	}
	

	// process goosearchs to determine what kind of search they really are
	if (sSearchType.CompareText("GOOSEARCH"))
	{
		// if they contain an @ symbol then do a user search
		// otherwise do an article serch
		if (sSearchString.Find('@') >= 0)
		{
			sSearchType = "USER";
		}
		else
		{
			sSearchType = "ARTICLE";
		}
	}

	CRecentSearch RecentSearch(m_InputContext);
	RecentSearch.Initialise();
	pPageXML->AddInside("H2G2/SEARCH",&RecentSearch);


	//Require a search string or a search type to indicate that a search has been initiated.
	if ( bGotSearchString || m_InputContext.ParamExists("searchtype") )
	{
		if (sSearchType.CompareText("USER") || m_InputContext.GetParamInt("USER") == 1 )
		{
			// if this is an explicit search for a user from the Power Search page
			// or they're searching from a 
			bool bAllowEmailSearch = (pViewer != NULL) && (pViewer->GetIsEditor());

			// Check to see if we're looking for user on this site or all sites
			int iSearchSiteID = 0;
			if (m_InputContext.GetParamInt("thissite") == 1)
			{
				iSearchSiteID = iSiteID;
			}

			CSearch Search(m_InputContext);
			bool bResults = Search.InitialiseNameOrEmailSearch(sSearchString, iSkip, iShow, iViewerID, bAllowEmailSearch, iSearchSiteID);
			
			//If new search ( not using skip and show ) then record.
			if ( bResults && !m_InputContext.ParamExists("Skip") )
			{
				RecentSearch.AddSearchTerm(sSearchString,CRecentSearch::USER);
			}

			//Add Search results to page.
			bSuccess = bSuccess && pPageXML->AddInside("H2G2/SEARCH", &Search);
		
		}
		
		if (sSearchType.CompareText("NEW") || m_InputContext.GetParamInt("NEW") == 1 )
		{
			// Mark Howitt
			// New Search Procedure being tested
			bool bANDSearch = m_InputContext.ParamExists("ANDSearch");
			bool bPhraseSearch = m_InputContext.ParamExists("PhraseSearch");

			CSearch Search(m_InputContext);
			Search.InitialiseNewSearch(sSearchString,bShowApproved,bShowNormal,bShowSubmitted,iSiteID,bANDSearch,bPhraseSearch,iShow,iSkip,500,iCategory);
		
			//Add Search results to page.
			bSuccess = bSuccess && pPageXML->AddInside("H2G2/SEARCH", &Search);
		}
		
		if ( sSearchType.CompareText("HIERARCHY") || m_InputContext.GetParamInt("HIERARCHY") == 1 )
		{

			CSearch Search(m_InputContext);
			bool bResults = Search.InitialiseHierarchySearch(sSearchString,iSiteID,iSkip,iShow);

			//If new search ( not using skip and show ) then record.
			if ( bResults && !m_InputContext.ParamExists("Skip") )
			{
				RecentSearch.AddSearchTerm(sSearchString,CRecentSearch::HIERARCHY);
			}

			//Add Search results to page.
			bSuccess = bSuccess && pPageXML->AddInside("H2G2/SEARCH", &Search);
		}
		
		if ( sSearchType.CompareText("FORUM") || m_InputContext.GetParamInt("FORUM") == 1 )
		{
			iForumID = m_InputContext.GetParamInt("forumId");
			iThreadID = m_InputContext.GetParamInt("threadId");

			CSearch Search(m_InputContext);
			bool bResults = Search.InitialiseForumSearch( sSearchString, psUserGroups, iSkip, iShow, iSiteID, m_InputContext.GetParamInt("category"), iForumID, iThreadID,iViewerID );
			
			//If new search ( not using skip and show ) then record.
			if ( bResults && !m_InputContext.ParamExists("Skip") )
			{
				RecentSearch.AddSearchTerm(sSearchString,CRecentSearch::FORUM);
			}

			//Add Search results to page.
			bSuccess = bSuccess && pPageXML->AddInside("H2G2/SEARCH", &Search);
		}
		
		if ( sSearchType.CompareText("ARTICLE") || m_InputContext.GetParamInt("ARTICLE") == 1 || (sSearchType.IsEmpty() && !m_InputContext.ParamExists("ARTICLE") && !m_InputContext.ParamExists("NEW") && !m_InputContext.ParamExists("FORUM") && !m_InputContext.ParamExists("USER") ))
		{
			//Default Search Type - Article Search.
			CSearch Search(m_InputContext);
			int iArticleType = m_InputContext.GetParamInt("ArticleType");
			int iArticleStatus = m_InputContext.GetParamInt("ArticleStatus");
			bool bResults = Search.InitialiseArticleSearch(sSearchString, bShowApproved, bShowNormal, bShowSubmitted, psUserGroups, iSkip, iShow, iSiteID,m_InputContext.GetParamInt("category"),iViewerID,bShowContentRatingData, iArticleType, iArticleStatus);
			
			//If new search ( not using skip and show ) then record.
			if ( bResults && !m_InputContext.ParamExists("Skip") )
			{
				RecentSearch.AddSearchTerm(sSearchString,CRecentSearch::ARTICLE);
			}

			//Add Search results to page.
			bSuccess = bSuccess && pPageXML->AddInside("H2G2/SEARCH", &Search);
		}
	}

	//Add XML Specifying Available User Groups - used to filter on author type.
	CGroups Groups(m_InputContext);
	bSuccess = bSuccess && Groups.GetGroups();
	bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Groups);



	// Add the XML specifying the functionality of each search type.
	CDBXMLBuilder functionality;
	CTDVString sFunctionality;
	functionality.Initialise(&sFunctionality);
	functionality.OpenTag("FUNCTIONALITY");

	//Article Search Functionality
	bool bArticleSearch = sSearchType.CompareText("ARTICLE") || (sSearchType.GetLength() == 0);
	functionality.OpenTag("SEARCHARTICLES",bArticleSearch);
	if ( bArticleSearch )
	{
		functionality.AddIntAttribute("SELECTED",1,true);
	}
	functionality.AddIntTag("SHOWAPPROVED",bShowApproved);
	functionality.AddIntTag("SHOWNORMAL",bShowNormal);
	functionality.AddIntTag("SHOWSUBMITTED",bShowSubmitted);
	functionality.CloseTag("SEARCHARTICLES");

	//Forum Search Functionality
	bool bForumSearch = sSearchType.CompareText("FORUM");
	functionality.OpenTag("SEARCHFORUMS",bForumSearch);
	if ( bForumSearch ) 
	{
		functionality.AddIntAttribute("SELECTED",1,true);
	}
	if (iForumID > 0) 
	{
		functionality.AddIntTag("FORUM",iForumID);
	}
	if (iThreadID > 0) 
	{
		functionality.AddIntTag("THREAD",iThreadID);
	}
	functionality.CloseTag("SEARCHFORUMS");

	//User Search Functionality
	bool bUserSearch = sSearchType.CompareText("USER");
	functionality.OpenTag("SEARCHUSERS",bUserSearch);
	if ( bUserSearch ) 
	{
		functionality.AddIntAttribute("SELECTED",1,true);
	}
	functionality.CloseTag("SEARCHUSERS");
	functionality.CloseTag("FUNCTIONALITY");

	//Add XML search functionality to page.
	bSuccess = bSuccess && pPageXML->AddInside("H2G2/SEARCH", sFunctionality);

	// need to put the XML for the category hierarchy in so that the
	// stylesheet can display it. This may change hence must go in the XML
	// => this is a bodge
	// TODO: do this properly!
	CTDVString sCategoryXML = "";
	sCategoryXML << "<CATEGORISATION>"
		<< "<CATEGORY>"
		<< "<NAME>Life</NAME>"
		<< "<CATID>72</CATID>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Sex</NAME>"
		<< "<CATID>31</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Food &amp; Drink</NAME>"
		<< "<CATID>69</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Human Behaviour</NAME>"
		<< "<CATID>122</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Humour</NAME>"
		<< "<CATID>120</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Music</NAME>"
		<< "<CATID>90</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Sports &amp; Recreation</NAME>"
		<< "<CATID>71</CATID>"
		<< "</SUBCATEGORY>"
		<< "</CATEGORY>"
		<< "<CATEGORY>"
		<< "<NAME>The Universe</NAME>"
		<< "<CATID>73</CATID>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Australasia</NAME>"
		<< "<CATID>50</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Asia</NAME>"
		<< "<CATID>48</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Africa</NAME>"
		<< "<CATID>44</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>North America</NAME>"
		<< "<CATID>46</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Europe</NAME>"
		<< "<CATID>45</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Travel</NAME>"
		<< "<CATID>83</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Transport</NAME>"
		<< "<CATID>52</CATID>"
		<< "</SUBCATEGORY>"
		<< "</CATEGORY>"
		<< "<CATEGORY>"
		<< "<NAME>Everything</NAME>"
		<< "<CATID>74</CATID>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Languages</NAME>"
		<< "<CATID>37</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Science &amp; Technology</NAME>"
		<< "<CATID>6</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>History &amp; Politics</NAME>"
		<< "<CATID>4</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>Mythology &amp; Folklore</NAME>"
		<< "<CATID>26</CATID>"
		<< "</SUBCATEGORY>"
		<< "<SUBCATEGORY>"
		<< "<NAME>How to use h2g2</NAME>"
		<< "<CATID>550</CATID>"
		<< "</SUBCATEGORY>"
		<< "</CATEGORY>"
		<< "</CATEGORISATION>";
	bSuccess = bSuccess && pPageXML->AddInside("H2G2", sCategoryXML);

	return bSuccess;
}