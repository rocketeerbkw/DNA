#include "stdafx.h"
#include ".\tdvassert.h"
#include ".\mediaassetsearchphrasebuilder.h"
#include "User.h"
#include "MediaAssetSearchPhrase.h"


CMediaAssetSearchPhraseBuilder::CMediaAssetSearchPhraseBuilder( CInputContext& InputContext) : CXMLBuilder(InputContext)
{
}

CMediaAssetSearchPhraseBuilder::~CMediaAssetSearchPhraseBuilder(void)
{
}

bool CMediaAssetSearchPhraseBuilder::Build( CWholePage* pPage)
{
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CMediaAssetSearchPhrase SearchPhrase(m_InputContext,delimit);
	CUser* pUser = m_InputContext.GetCurrentUser();

	//Handle request to add new phrase(s)
	if ( m_InputContext.ParamExists("addphrase") && m_InputContext.ParamExists("assetid") )
	{
		if ( pUser && pUser->IsUserLoggedIn()  )
		{
			int iassetid = m_InputContext.GetParamInt("assetid");
			if ( iassetid > 0 )
			{
				//Add the new phrase to thread.
				for ( int i=0; i < m_InputContext.GetParamCount("addphrase"); ++i )
				{
					CTDVString skeyphrases;
					m_InputContext.GetParamString("addphrase",skeyphrases,i);
					SearchPhrase.ParsePhrases(skeyphrases,true);
				}
				bool bOk = SearchPhrase.AddKeyPhrases(iassetid);

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
				SetDNALastError("CMediaAssetSearchPhraseBuilder::Build","AddPhrase","Invalid assetid");
				pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			}
		}
		else
		{
			SetDNALastError("CMediaAssetSearchPhraseBuilder::Build","AddPhrase","Unable to add key phrase(s) - User not logged in.");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
	}

	//Set up Search Page XML
	if (!InitPage(pPage,"MEDIAASSETSEARCHPHRASE",false,true))
	{
		TDVASSERT(false,"CMediaAssetSearchPhraseBuilder - Failed to create Whole Page object!");
		return false;
	}

	//Get Search phrases.
	CTDVString sPhrases;
	if ( m_InputContext.ParamExists("phrase") )
	{
		CTDVString sPhraseParam;
		for (int i=0;m_InputContext.GetParamString("phrase",sPhraseParam,i);i++)
			SearchPhrase.ParsePhrases(sPhraseParam,true);
	}

	// Set up the page root node generate XML for current keyphrase search.
	if (!pPage->AddInside("H2G2","<MEDIAASSETSEARCHPHRASE/>"))
	{
		TDVASSERT(false,"CMediaAssetSearchPhraseBuilder - Failed to add SEARCHPHRASE node");
		return false;
	}
	pPage->AddInside("MEDIAASSETSEARCHPHRASE", SearchPhrase.GeneratePhraseListXML());

	//Get search filter.
	int ifilter = m_InputContext.GetParamInt("contenttype");

	// Get the assets associated with the current key phrase search
	int iNumResults = 0;
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");

	//Get Assets Sort by.
	CTDVString sAssetSortBy="";
	if ( m_InputContext.ParamExists("assetsortby") )
	{
		m_InputContext.GetParamString("assetsortby",sAssetSortBy);
	}

	SearchPhrase.GetMediaAssetsFromKeyPhrases(ifilter, iSkip, iShow == 0 ? 20 : iShow, sAssetSortBy, iNumResults);

	if (SearchPhrase.ErrorReported())
	{
		CopyDNALastError("CMediaAssetSearchPhraseBuilder", SearchPhrase);
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	pPage->AddInside("MEDIAASSETSEARCHPHRASE", &SearchPhrase);

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

	return true;
}
