// FrontPageBuilder.cpp: implementation of the CFrontPageBuilder class.
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
#include "FrontPageBuilder.h"
#include "PageBody.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVDateTime.h"
#include "TopFives.h"
#include "RecentSearch.h"
#include "Postcoder.h"
#include "tdvassert.h"
#include "Notice.h"
#include "Postcoder.h"
#include "TextBoxElement.h"
#include "FrontPageTopicElement.h"
#include "Topic.h"
#include "FrontPageLayout.h"
#include "MediaAssetSearchPhrase.h"
#include "ArticleSearchPhrase.h"
#include ".\SiteOptions.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CFrontPageBuilder::CFrontPageBuilder(CInputContext& inputContext)
																			 
	Author:		Oscar Gillespie
	Created:	28/02/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for our fun plain text and somesuch class

*********************************************************************************/

CFrontPageBuilder::CFrontPageBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext), m_bInPreview(false)
{

}

/*********************************************************************************

	CFrontPageBuilder::~CFrontPageBuilder()

	Author:		Oscar Gillespie
	Created:	28/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CFrontPageBuilder class. Functionality when we start allocating memory

*********************************************************************************/

CFrontPageBuilder::~CFrontPageBuilder()
{

}

/*********************************************************************************

	CWholePage* CFrontPageBuilder::Build()

	Author:		Oscar Gillespie
	Created:	29/02/2000
	Modified:	10/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	Makes a whole XML page (the one that's needed to send to the transformer)
				and puts inside it an XML PageBody object which represents the text/XML
				body part of a page.

*********************************************************************************/


bool CFrontPageBuilder::Build(CWholePage* pPageXML)
{
	// XML object subclasses representing various parts of the front page
	CUser*		pUser = NULL;
	int			iUserID = 0;

	CTopFives	TopFives(m_InputContext);
	CPageUI		PageUI(m_InputContext);

	// class that can give us an XML representation of the current time
	CTDVDateTime dDateTime = CTDVDateTime::GetCurrentTime();	
	
	// Are we in preview mode?
	if(m_InputContext.GetIsInPreviewMode())
	{
		m_bInPreview = true;
	}

	// boolean that tracks success of operations through the work we do in Build()
	bool bSuccess = InitPage(pPageXML, "FRONTPAGE",true,false);
	int iSiteID = m_InputContext.GetSiteID();
	TDVASSERT(bSuccess, "Failed to initialise PageXML");

	if (bSuccess)
	{
		// get a User object from the GCI input context (the real world)
		pUser = m_InputContext.GetCurrentUser();
		if (pUser != NULL)
		{
			// tell the user to make his/her ID, name and email visible and shove him/her the page xml
			pUser->SetIDNameVisible();
			pUser->SetIDNameEmailVisible();
			bSuccess = pPageXML->AddInside("VIEWING-USER", pUser);
			iUserID = pUser->GetUserID();
			TDVASSERT(bSuccess, "Failed to AddInside pUser");
		}
	}

	if (bSuccess)
	{
		// add the article xml inside the H2G2 tag
		CFrontPageLayout FPL(m_InputContext);
		if (FPL.InitialisePageBody(iSiteID,m_bInPreview))
		{
			FPL.CreateFromPageLayout();
			bSuccess = pPageXML->AddInside("H2G2", &FPL);
			TDVASSERT(bSuccess, "Failed to AddInside pBody");
		}
		else
		{
			// Get the error from the object
			pPageXML->AddInside("H2G2",FPL.GetLastErrorAsXMLString());
		}
	}

	if (bSuccess)
	{
		// Do the TopFive thing
		TopFives.Initialise(m_InputContext.GetSiteID());
		bSuccess = pPageXML->AddInside("H2G2", &TopFives);
		TDVASSERT(bSuccess, "Failed to AddInside TopFives");
	}

	if ( bSuccess )
	{
		// Add Recent Search Items
		CRecentSearch RecentSearches(m_InputContext);
		RecentSearches.Initialise();
		bSuccess = pPageXML->AddInside("H2G2",&RecentSearches);
	}

/*
	Mark Howitt 11/8/05 - Removing the civic data and noticeboards from the front page as it is nolonger used by any sites.
						  THis will help reduce the amount of work the page has to do as well
						  The only place civic data is used now is on the postcoder page.


	if (bSuccess)
	{
		// Now try to get the local noticeboard info.
		// First check to see if there is a postcode in the URL
		CTDVString sNoticeXML;
		bool bFoundLocalInfo = false;
		CTDVString sPostCodeToFind, sPostCodeXML;
		if (m_InputContext.ParamExists("postcode"))
		{
			// Get the postcode and use this to display the noticeboard
			m_InputContext.GetParamString("postcode",sPostCodeToFind);
			CNotice Notice(m_InputContext);
			bFoundLocalInfo = Notice.GetLocalNoticeBoardForPostCode(sPostCodeToFind,iSiteID,sNoticeXML,sPostCodeXML);
		}

		// If we didn't find a valid postcode in the URL, try the viewing user
		if (!bFoundLocalInfo)
		{
			// No postcode given, try to get the viewing users postcode if we have one.
			if (pUser != NULL)
			{
				// Insert the notice board information!
				CNotice Notice(m_InputContext);
				if (!Notice.GetLocalNoticeBoardForUser(pUser,iSiteID,false,sNoticeXML))
				{
					sNoticeXML << "<NOTICEBOARD><ERROR>FailedToFindLocalNoticeBoard</ERROR></NOTICEBOARD>";
				}
			}
			else
			{
				sNoticeXML << "<NOTICEBOARD><ERROR>UserNotLoggedIn</ERROR></NOTICEBOARD>";
			}
		}

		// Now insert the noticeboard xml
		bSuccess = pPageXML->AddInside("H2G2",sNoticeXML);

		// If all's well, insert the postcoder xml
		if (bSuccess)
		{
			// If we we're given a valid postcode in the URL, then use the PostCoderXML from the
			// noticeboard as it will be different to the users details.
			if (bFoundLocalInfo && !sPostCodeXML.IsEmpty())
			{
				CTDVString sXML = "<CIVICDATA POSTCODE='";
				sXML << sPostCodeToFind << "'/>";
				pPageXML->AddInside("H2G2", sXML);
				bSuccess = pPageXML->AddInside("CIVICDATA",sPostCodeXML);
			}
			// If we have a valid user, use their postcode details.
			else if (pUser != NULL)
			{
				CTDVString sPostCode;
				pUser->GetPostcode(sPostCode);
				if (!sPostCode.IsEmpty())
				{
					bool bHitPostcode = false;
					CPostcoder cPostcoder(m_InputContext);
					cPostcoder.MakePlaceRequest(sPostCode,bHitPostcode);
					if (bHitPostcode)
					{
						CTDVString sXML = "<CIVICDATA POSTCODE='";
						sXML << sPostCode << "'/>";
						pPageXML->AddInside("H2G2", sXML);
						bSuccess = pPageXML->AddInside("CIVICDATA",&cPostcoder);
					}
				}
			}
		}
	}
*/

	if(bSuccess)
	{
		
		CTextBoxElement::eElementStatus eTextBoxStatus				= CTextBoxElement::ES_LIVE;
		CFrontPageTopicElement::eElementStatus eTopicElementStatus	= CFrontPageElement::ES_LIVE;
		//CTopic::eTopicStatus eTopicStatus							= CTopic::TS_LIVE;
		if(m_bInPreview)
		{
			eTextBoxStatus		= CTextBoxElement::ES_PREVIEW;
			eTopicElementStatus = CFrontPageElement::ES_PREVIEW;
			//eTopicStatus		= CTopic::TS_PREVIEW;
		}
		
		CTextBoxElement TextBElem(m_InputContext);
		CFrontPageTopicElement TopicElem(m_InputContext);
		//CTopic Topic(m_InputContext);

		bSuccess = TextBElem.GetTextBoxesForSiteID(iSiteID, eTextBoxStatus);
		bSuccess = bSuccess && TopicElem.GetTopicFrontPageElementsForSiteID(iSiteID, eTopicElementStatus);
		//bSuccess = bSuccess && Topic.GetTopicsForSiteID(iSiteID, eTopicStatus);
		
		if (bSuccess)
		{
			pPageXML->AddInside("H2G2", &TextBElem);
			pPageXML->AddInside("H2G2", &TopicElem);
			//pPageXML->AddInside("H2G2", &Topic);
		}
	}

	// Add <DYNAMIC-LISTS>
	if(bSuccess)
	{
		// Create and add <dynamic-lists> to page
		CTDVString sDyanmicListsXml;
		if(!m_InputContext.GetDynamicLists(sDyanmicListsXml, m_InputContext.GetSiteID()))
		{
			TDVASSERT(false, "CFrontPageBuilder::Build() m_InputContext.GetDynamicLists failed");
		}
		else
		{
			if(!pPageXML->AddInside("H2G2", sDyanmicListsXml))
			{
				TDVASSERT(false, "CFrontPageBuilder::Build() pPageXML->AddInside failed");
			}
		}
	}

	if (bSuccess)
	{	
		// ask the datetime object for an xml representation of the current date and
		// put that in the front page xml
	//	CTDVString sXMLDate = "";
	//	dDateTime.GetAsXML(sXMLDate);
	//	bSuccess = pPageXML->AddInside("H2G2", sXMLDate);
		
		//TDVASSERT(bSuccess, "Failed to AddInside date"); 
	}

	CTDVString sSiteName;
	m_InputContext.GetNameOfSite(m_InputContext.GetSiteID(), &sSiteName); 
	if ( sSiteName.CompareText("comedysoup") )
	{
		if ( bSuccess )
		{
			// Add Media Asset key phrase hot list
			CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
			CMediaAssetSearchPhrase MediaAssetKeyPhrase(m_InputContext,delimit);
			
			CTDVString sSortBy;
			m_InputContext.GetParamString("sortby",sSortBy);
			int iSkipPhrases = m_InputContext.GetParamInt("skipphrases");
			int iShowPhrases = m_InputContext.GetParamInt("showphrases");
			int iassettype = m_InputContext.GetParamInt("contenttype");
			
			MediaAssetKeyPhrase.GetKeyPhraseHotList(iSkipPhrases, iShowPhrases == 0 ? 100 : iShowPhrases, sSortBy, iassettype); //(0, 100, "Phrase", iassettype);
			bSuccess = pPageXML->AddInside("H2G2",&MediaAssetKeyPhrase);
		}

		if ( bSuccess )
		{
			// Add Article key phrase hot list
			CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
			CArticleSearchPhrase ArticleKeyPhrase(m_InputContext,delimit);
			
			CTDVString sSortBy;
			m_InputContext.GetParamString("sortby", sSortBy);
			int iSkipPhrases = m_InputContext.GetParamInt("skipphrases");
			int iShowPhrases = m_InputContext.GetParamInt("showphrases");
			int iassettype = m_InputContext.GetParamInt("contenttype");
			
			ArticleKeyPhrase.GetKeyPhraseHotList(iSkipPhrases, iShowPhrases == 0 ? 100 : iShowPhrases, sSortBy, iassettype); //(0, 100, "Phrase", iassettype);
			bSuccess = pPageXML->AddInside("H2G2", &ArticleKeyPhrase);
		}
	}

	if (bSuccess)
	{
		// tell the page XML what kind of page it is (it would have a hard time working it out otherwise)
		pPageXML->SetPageType("FRONTPAGE");
	}

	// Check to see if we're ok and if we are given a redirect?
	if (bSuccess)
	{
		// Call the redirect function
		if (CheckAndUseRedirectIfGiven(pPageXML))
		{
			// we've had a valid redirect! return
			return true;
		}
	}

	return bSuccess;
}

/********************************************************************************

	bool CFrontPageBuilder::IsRequestHTMLCacheable()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if the current request can be cached
        Purpose:	Determines if the HTML for this request can be cached.
					Basically it boils down to "Is this request read-only?".

*********************************************************************************/

bool CFrontPageBuilder::IsRequestHTMLCacheable()
{
	return true;
}

/*********************************************************************************

	CTDVString CFrontPageBuilder::GetRequestHTMLCacheFolderName()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Returns the path, under the ripleycache folder, where HTML cache files 
					should be stored for this builder

*********************************************************************************/

CTDVString CFrontPageBuilder::GetRequestHTMLCacheFolderName()
{
	return CTDVString("html\\frontpage");
}

/*********************************************************************************

	CTDVString CFrontPageBuilder::GetRequestHTMLCacheFileName()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Creates the HTML cache file name that uniquely identifies this request.

*********************************************************************************/

CTDVString CFrontPageBuilder::GetRequestHTMLCacheFileName()
{ 
	CTDVString sHash;
	m_InputContext.GetQueryHash(sHash);

	CTDVString sCacheName;
	sCacheName << "FP-" << m_InputContext.GetNameOfCurrentSite() << "-" << sHash << ".html";

	return sCacheName;
}
