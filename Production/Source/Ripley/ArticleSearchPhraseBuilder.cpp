// ArticleSearchPhraseBuilder.cpp: implementation of the CArticleSearchPhraseBuilder class.
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
#include "tdvassert.h"
#include "PageUI.h"
#include "ArticleSearchPhraseBuilder.h"
#include "ArticleSearchPhrase.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CArticleSearchPhraseBuilder::CArticleSearchPhraseBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CArticleSearchPhraseBuilder::~CArticleSearchPhraseBuilder(void)
{
}

/*********************************************************************************

	CWholePage* CArticleSearchPhraseBuilder::Build()

	Author:		Steven Francis
	Created:	16/12/2005
	Inputs:		-
	Outputs:	-
	Returns:	CWholePage containing the page the output.
	Purpose:	

				ARTICLE Page Type

				The XML output can look like this:
				<H2G2>
				...
					<ARTICLEBUILDER>
						<ARTICLESEARCHPHRASE>
						</ARTICLESEARCHPHRASE>
					</ARTICLEBUILDER>
				...
				</H2G2>

*********************************************************************************/
bool CArticleSearchPhraseBuilder::Build( CWholePage* pPage)
{
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CArticleSearchPhrase SearchPhrase(m_InputContext,delimit);
	CUser* pUser = m_InputContext.GetCurrentUser();

	//Handle request to add new phrase(s)
	if ( m_InputContext.ParamExists("addphrase") && m_InputContext.ParamExists("H2G2ID") )
	{
		if ( pUser && pUser->IsUserLoggedIn()  )
		{
			int iH2G2ID = m_InputContext.GetParamInt("H2G2ID");
			if ( iH2G2ID > 0 )
			{
				//Add the new phrase to thread.
				for ( int i=0; i < m_InputContext.GetParamCount("addphrase"); ++i )
				{
					CTDVString keyphrases;
					m_InputContext.GetParamString("addphrase", keyphrases);
					SearchPhrase.ParsePhrases(keyphrases,true);
				}
				bool bOk = SearchPhrase.AddKeyPhrases(iH2G2ID);

				//Handle rediect.
				if ( bOk && CheckAndUseRedirectIfGiven(pPage) )
				{
					return true;
				}
				else
				{
					pPage->AddInside("H2G2", SearchPhrase.GetLastErrorAsXMLString());
				}
			}
			else
			{
				SetDNALastError("CArticleSearchPhraseBuilder::Build","AddPhrase","Invalid H2G2ID");
				pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			}
		}
		else
		{
			SetDNALastError("CArticleSearchPhraseBuilder::Build","AddPhrase","Unable to add key phrase(s) - User not logged in.");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
	}

	//Set up Search Page XML
	if (!InitPage(pPage,"ARTICLESEARCHPHRASE",false,true))
	{
		TDVASSERT(false,"CArticleSearchPhraseBuilder - Failed to create Whole Page object!");
		return false;
	}

	//Get Search phrases.
	if ( m_InputContext.ParamExists("phrase") )
	{
		CTDVString sPhraseParam;
		for (int i=0;m_InputContext.GetParamString("phrase",sPhraseParam,i);i++)
			SearchPhrase.ParsePhrases(sPhraseParam,true);
	}

	// Set up the page root node generate XML for current keyphrase search.
	if (!pPage->AddInside("H2G2","<ARTICLESEARCHPHRASE/>"))
	{
		TDVASSERT(false,"CArticleSearchPhraseBuilder - Failed to add SEARCHPHRASE node");
		return false;
	}
	pPage->AddInside("H2G2/ARTICLESEARCHPHRASE",SearchPhrase.GeneratePhraseListXML());

	//Get search filter.
	int ifilter = m_InputContext.GetParamInt("contenttype");

	// Get the articles associated with the current key phrase search
	int iNumResults = 0;
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");

	//Get Article Sort by.
	CTDVString sArticleSortBy="";
	if ( m_InputContext.ParamExists("articlesortby") )
	{
		m_InputContext.GetParamString("articlesortby", sArticleSortBy);
	}

	SearchPhrase.GetArticlesFromKeyPhrases(ifilter, iSkip, iShow == 0 ? 20 : iShow, sArticleSortBy, true, iNumResults);

	if (SearchPhrase.ErrorReported())
	{
		CopyDNALastError("CArticlePhraseBuilder",SearchPhrase);
	}

	pPage->AddInside("H2G2/ARTICLESEARCHPHRASE",&SearchPhrase);
            
	
	bool bGenerateHotlist = m_InputContext.DoesCurrentSiteHaveSiteOptionSet("ArticleSearch", "GenerateHotlist");
	if (bGenerateHotlist)
	{
		//Add Hot Phrases.
		CTDVString sSortBy;
		m_InputContext.GetParamString("sortby",sSortBy);
		int iSkipPhrases = m_InputContext.GetParamInt("skipphrases");
		int iShowPhrases = m_InputContext.GetParamInt("showphrases");
		int iMediaAssetType = m_InputContext.GetParamInt("contenttype"); 

		if ( !SearchPhrase.GetKeyPhraseHotList(iSkipPhrases, iShowPhrases == 0 ? 100 : iShowPhrases, sSortBy, iMediaAssetType) )
		{
			pPage->AddInside("H2G2",SearchPhrase.GetLastErrorAsXMLString());
			return true;
		}
		pPage->AddInside("H2G2",&SearchPhrase);
	}

	return true;
}

/********************************************************************************

	bool CArticleSearchPhraseBuilder::IsRequestHTMLCacheable()

		Author:		Steven Francis
        Created:	22/08/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if the current request can be cached
        Purpose:	Determines if the HTML for this request can be cached.
					Basically it boils down to "Is this request read-only?".

*********************************************************************************/

bool CArticleSearchPhraseBuilder::IsRequestHTMLCacheable()
{
	if (m_InputContext.ParamExists("addphrase"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	CTDVString CArticleSearchPhraseBuilder::GetRequestHTMLCacheFolderName()

		Author:		Steven Francis
        Created:	22/08/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Returns the path, under the ripleycache folder, where HTML cache files 
					should be stored for this builder

*********************************************************************************/

CTDVString CArticleSearchPhraseBuilder::GetRequestHTMLCacheFolderName()
{
	return CTDVString("html\\articlesearchphrase");
}

/*********************************************************************************

	CTDVString CArticleSearchPhraseBuilder::GetRequestHTMLCacheFileName()

		Author:		Steven Francis
        Created:	22/08/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Creates the HTML cache file name that uniquely identifies this request.

*********************************************************************************/

CTDVString CArticleSearchPhraseBuilder::GetRequestHTMLCacheFileName()
{ 
	CTDVString sHash;
	m_InputContext.GetQueryHash(sHash);

	// We add these params to the name to make it human-readable.  The hash alone isn't!
	int iContentType = m_InputContext.GetParamInt("contenttype");

	CTDVString sCacheName;
	sCacheName << "ASP-" << m_InputContext.GetNameOfCurrentSite() << "-" << iContentType << "-" << sHash << ".html";

	return sCacheName;
}
