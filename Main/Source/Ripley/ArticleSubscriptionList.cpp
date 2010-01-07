// ArticleList.cpp: implementation of the CArticleList class.
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
#include "ArticleSubscriptionList.h"
#include "TDVAssert.h"
#include "ArticleSearchPhrase.h"
#include "MediaAsset.h"
#include "pollcontentrating.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CArticleSubscriptionList::CArticleSubscriptionList(CInputContext& inputContext)

	Author:		James Conway
	Created:	10/09/2007
	Inputs:		inputContext - input context
	Outputs:	-
	Returns:	-
	Purpose:	Construct a CArticleSubscriptionList object and provide its member variables with
				suitable default values.

*********************************************************************************/

CArticleSubscriptionList::CArticleSubscriptionList(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_pSP(NULL)
{
	// no other construction
}

/*********************************************************************************

	CArticleSubscriptionList::~CArticleSubscriptionList()

	Author:		James Conway
	Created:	10/09/2007
	Inputs:		inputContext - input context
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources specifically allocated by this subclass.

*********************************************************************************/

CArticleSubscriptionList::~CArticleSubscriptionList()
{
	// make sure SP is deleted safely
	delete m_pSP;
	m_pSP = NULL;
}

bool CArticleSubscriptionList::GetRecentArticles(int iUserID, int iSiteID)
{
	TDVASSERT(iUserID > 0, "Non-positive user id in CArticleSubscriptionList::GetRecentArticles.");
	TDVASSERT(m_pTree == NULL, "CArticleSubscriptionList::GetRecentArticles called with non-NULL tree");
	TDVASSERT(iSiteID > 0, "CArticleSubscriptionList::GetRecentArticles called with invalid SiteID");

	// Set up the cache file name based on the parameters.
	CTDVString cachename = "articlesubscriptionlist";
	cachename << iUserID << "-" << iSiteID;
	cachename << ".xml";
	
	CTDVString sXML;

	//Try to get a cached copy.
	CTDVDateTime dExpires(60 * 10);		// expire after 10 minutes
	if ( CacheGetItem("articlesubscriptionlist", cachename, &dExpires, &sXML) )
		return CreateFromXMLText(sXML);

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CArticleSubscriptionList::GetRecentArticles", "FailedToInitialiseStoredProcedure", "Failed To Initialise Stored Procedure");
	}

	// Now call the procedure
	if (!SP.GetRecentArticlesOfSubscribedToUsers(iUserID, iSiteID))
	{
		return SetDNALastError("CArticleSubscriptionList::GetRecentArticles", "GetRecentArticlesOfSubscribedToUsers Failed", "Getting recent articles of subscribed to users failed.");
	}
	
	InitialiseXMLBuilder(&sXML,&SP);

	OpenXMLTag("ARTICLESUBSCRIPTIONLIST");
	OpenXMLTag("ARTICLES");
	while( !SP.IsEOF() )
	{
		typedef std::map<int, SEARCHPHRASELIST> ArticleKeyPhrases;
		ArticleKeyPhrases articleKeyPhrasesMap; 
		SEARCHPHRASELIST phraselist;
		int ih2g2ID = 0;

		int ipreviousH2G2ID = 0;

		// process first results set: the Article Key phrase results set
		do
		{
			ih2g2ID = SP.GetIntField("H2G2ID"); 

			if (ih2g2ID != ipreviousH2G2ID)
			{
				//New now have a new article so clean up the last one
				if (ipreviousH2G2ID != 0)
				{
					articleKeyPhrasesMap[ipreviousH2G2ID] = phraselist;
					phraselist.clear(); 
				}
			}

			//set the previous h2g2id to this one
			ipreviousH2G2ID = ih2g2ID;

			if ( !SP.IsNULL("Phrase") )
			{
				CTDVString sPhrase;
				CTDVString sNamespace = "";

				SP.GetField("Phrase",sPhrase);
				if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
				{
					SP.GetField("Namespace", sNamespace);
				}
				
				PHRASE phrase(sNamespace, sPhrase);
				phraselist.push_back(phrase);
			}
		} while (SP.MoveNext() && !SP.IsEOF());

		articleKeyPhrasesMap[ih2g2ID] = phraselist;

		do // Move to next results set
		{
			int iEditor = 0;

			OpenXMLTag("ARTICLE",true);
			int iH2G2ID = SP.GetIntField("H2G2ID");
			AddXMLIntAttribute("H2G2ID", iH2G2ID, true);
		        
			AddDBXMLTag("SUBJECT", 0, false);
			
			iEditor = SP.GetIntField("editor");
			if (iEditor > 0)
			{
				CDBXMLBuilder XML;
				XML.Initialise(&sXML,&SP);
				XML.OpenTag("EDITOR");
				XML.OpenTag("USER");
				XML.AddIntTag("USERID", iEditor);
				XML.DBAddTag("USERNAME",NULL,false);
				XML.DBAddTag("POSTCODE",NULL,false);
				XML.DBAddTag("REGION",NULL,false);
				XML.DBAddIntTag("USER-MODE");
				XML.DBAddIntTag("STATUS");
				XML.DBAddTag("AREA",NULL,false);
				XML.DBAddTag("TITLE",NULL,false);
				XML.DBAddTag("FIRSTNAMES",NULL,false);
				XML.DBAddTag("LASTNAME",NULL,false);
				XML.DBAddTag("SITESUFFIX",NULL,false);
				XML.DBAddIntTag("TEAMID");
				XML.DBAddIntTag("UNREADPUBLICMESSAGECOUNT");
				XML.DBAddIntTag("UNREADPRIVATEMESSAGECOUNT");
				XML.DBAddIntTag("TAXONOMYNODE",NULL,false);
				XML.DBAddIntTag("HIDELOCATION");
				XML.DBAddIntTag("HIDEUSERNAME");

				CTDVString sEditorGroupsXMLBlock;
				m_InputContext.GetUserGroups(sEditorGroupsXMLBlock, iEditor, m_InputContext.GetSiteID());
				AddXMLTag("", sEditorGroupsXMLBlock);

				XML.CloseTag("USER");
				XML.CloseTag("EDITOR");
			}

			AddDBXMLTag("EXTRAINFO","",false,false);

			//AddXMLTag("EDITOR", sEditorXMLBlock);
			AddDBXMLDateTag("DATECREATED", 0, false, true);
			AddDBXMLDateTag("LASTUPDATED", 0, false, true);


			//***********************************************************************
			// Media Asset Info
			int iOwnerID = 0;
			CTDVString sFTPPath;
			int iMediaAssetID = SP.GetIntField("MediaAssetID");

			if (iMediaAssetID != 0)
			{
				OpenXMLTag("MEDIAASSET",true);
				AddXMLIntAttribute("MEDIAASSETID", iMediaAssetID);
				AddDBXMLIntAttribute("CONTENTTYPE", "ContentType", false, true);

				CMediaAsset::GenerateFTPDirectoryString(iMediaAssetID, sFTPPath);
				AddXMLTag("FTPPATH", sFTPPath);

				AddDBXMLTag("Caption");

				iOwnerID = SP.GetIntField("OWNERID");
				if (iOwnerID > 0)
				{
					CDBXMLBuilder XML;
					XML.Initialise(&sXML,&SP);
					XML.OpenTag("OWNER");
					XML.OpenTag("USER");
					XML.AddIntTag("USERID", iOwnerID);
					XML.DBAddTag("USERNAME",NULL,false);
					XML.DBAddTag("POSTCODE",NULL,false);
					XML.DBAddTag("REGION",NULL,false);
					XML.DBAddIntTag("USER-MODE");
					XML.DBAddIntTag("STATUS");
					XML.DBAddTag("AREA",NULL,false);
					XML.DBAddTag("TITLE",NULL,false);
					XML.DBAddTag("FIRSTNAMES",NULL,false);
					XML.DBAddTag("LASTNAME",NULL,false);
					XML.DBAddTag("SITESUFFIX",NULL,false);
					XML.DBAddIntTag("TEAMID");
					XML.DBAddIntTag("UNREADPUBLICMESSAGECOUNT");
					XML.DBAddIntTag("UNREADPRIVATEMESSAGECOUNT");
					XML.DBAddIntTag("TAXONOMYNODE",NULL,false);
					XML.DBAddIntTag("HIDELOCATION");
					XML.DBAddIntTag("HIDEUSERNAME");

					CTDVString sOwnersGroupsXMLBlock;
					m_InputContext.GetUserGroups(sOwnersGroupsXMLBlock, iOwnerID, m_InputContext.GetSiteID());
					AddXMLTag("", sOwnersGroupsXMLBlock);

					XML.CloseTag("USER");
					XML.CloseTag("OWNER");
				}
				AddDBXMLTag("Mimetype","MIMETYPE");

				//Extra extendedable element stuff removed for time being
				AddDBXMLTag("EXTRAELEMENTXML", NULL, false, false);

				AddDBXMLIntTag("HIDDEN", NULL, false);

				CTDVString sExternalLinkURL="";
				CTDVString sExternalLinkID="";
				CTDVString sExternalLinkType="";

				CTDVString sFlickrFarmPath=""; 
				CTDVString sFlickrServer=""; 
				CTDVString sFlickrID=""; 
				CTDVString sFlickrSecret=""; 
				CTDVString sFlickrSize="";


				SP.GetField("EXTERNALLINKURL", sExternalLinkURL);
				CMediaAsset::GetIDFromLink(sExternalLinkURL, 
											sExternalLinkID, 
											sExternalLinkType, 
											sFlickrFarmPath, 
											sFlickrServer, 
											sFlickrID, 
											sFlickrSecret, 
											sFlickrSize);
					
				AddXMLTag("EXTERNALLINKTYPE", sExternalLinkType);
				AddDBXMLTag("EXTERNALLINKURL", NULL, false, true);
				AddXMLTag("EXTERNALLINKID", sExternalLinkID);

				OpenXMLTag("FLICKR", false);
				AddXMLTag("FARMPATH", sFlickrFarmPath);
				AddXMLTag("SERVER", sFlickrServer);
				AddXMLTag("ID", sFlickrID);
				AddXMLTag("SECRET", sFlickrSecret);
				AddXMLTag("SIZE", sFlickrSize);
				CloseXMLTag("FLICKR");

				CloseXMLTag("MEDIAASSET");
			}

			// Get Content rating data
			int nCRPollID = SP.GetIntField("CRPollID");

			// Add Content rating
			if(nCRPollID)
			{
				CPollContentRating Poll(m_InputContext, nCRPollID);

				Poll.SetContentRatingStatistics(SP.GetIntField("CRVoteCount"), 
				SP.GetDoubleField("CRAverageRating"));
					
				// Generate XML without poll results, just stats
				if(!Poll.MakePollXML(CPoll::PollLink(nCRPollID, false), false))
				{
					TDVASSERT(false, "CArticleSearchPhrase::GetArticlesFromKeyPhrases pPoll->MakePollXML failed");
				}
				else 
				{
					CTDVString sPollXML;
					if(!Poll.GetAsString(sPollXML))
					{
						TDVASSERT(false, "CArticleSearchPhrase::GetArticlesFromKeyPhrases Poll.GetAsString failed");
					}
					else
					{
						sXML << sPollXML;
					}
				}
			}
			//***********************************************************************

			//Create XML for the phrases associated with each article.
			CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
			CArticleSearchPhrase asp(m_InputContext,delimit);
			asp.SetPhraseList(articleKeyPhrasesMap[iH2G2ID]);
			sXML << asp.GeneratePhraseListXML();

			CloseXMLTag("ARTICLE");
		} while (SP.MoveNext() && !SP.IsEOF());
	}
	CloseXMLTag("ARTICLES");
	CloseXMLTag("ARTICLESUBSCRIPTIONLIST");

	if ( !cachename.IsEmpty() ) 
	{
		CachePutItem("articlesubscriptionlist", cachename, sXML);
	}

	return CreateFromXMLText(sXML);
}
