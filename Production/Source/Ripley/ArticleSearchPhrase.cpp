// ArticleSearchPhrase.cpp: implementation of the CArticleSearchPhrase class.
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
#include "StoredProcedure.h"
#include "User.h"
#include "ArticleSearchPhrase.h"
#include "MediaAsset.h"
#include "pollcontentrating.h"

CArticleSearchPhrase::CArticleSearchPhrase(CInputContext& InputContext, CTDVString sToken) : CSearchPhraseBase(InputContext, sToken)
{
}

/*********************************************************************************

	CArticleSearchPhrase::AddKeyhrases()

		Author:		Steven Francis
        Created:	15/12/2005
        Inputs:		- iH2G2ID, sPhrases to add
        Outputs:	- 
        Returns:	- false on error.
        Purpose:	- based on Martin Robb AddKeyPhrases 
					  Adds/Associates the given space separated list of phrases to the article.

*********************************************************************************/
bool CArticleSearchPhrase::AddKeyPhrases( int iH2G2ID )
{
	//Destroy();
	//m_lPhraseList.clear();
	//ParsePhrases(sPhrases);

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	CUser * pViewer = m_InputContext.GetCurrentUser();
	if ( !pViewer )
	{
		SetDNALastError("CArticleSearchPhrase::AddKeyPhrases", "AddKeyPhrases","Failed to add phrase(s) - User not signed in.");
		return false;
	}

	CTDVString sPhraseList;
	CTDVString sNamespaceList;
	CTDVString sFailedPhrases;
	
	//Create a comma delimited phrase list
	SEARCHPHRASELIST::iterator iter;
	for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
	{
		sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
		sNamespaceList << (sNamespaceList.IsEmpty() ? "" : "|") << iter->m_NameSpace;
	}

	/*
	if ( ! SP.AddKeyPhrasesToArticle( iH2G2ID, sPhraseList ) )
	{
		SetDNALastError("CArticleSearchPhrase::AddKeyPhrases", "AddKeyPhrases", "Failed to add phrase(s)");
		return false;
	}
	*/

	if ( ! SP.AddKeyPhrasesToArticleWithNamespaces( iH2G2ID, sPhraseList, sNamespaceList ) )
	{
		SetDNALastError("CArticleSearchPhrase::AddKeyPhrases", "AddKeyPhrases", "Failed to add phrase(s)");
		return false;
	}


	if ( !sFailedPhrases.IsEmpty() )
	{
		//Report phrases that failed validation.
		SetDNALastError("CArticleSearchPhrase::AddKeyPhrases", "AddKeyPhrases", CTDVString("Failed to add phrase(s) - Insufficent Permissions ") << sFailedPhrases);
		return false;
	}

	return true;
}

/*********************************************************************************

	CArticleSearchPhrase::GetArticlesFromKeyPhrases()

		Author:		Martin Robb
        Created:	24/10/2005
        Inputs:		- token that delimits phrase elements
					- Content Type - type of article (with/or without(-1) asset) to search through
					- skip and show parameters
					- sSortBy - How the returned list is ordered
					- bCache - Whether to use XML caching
        Outputs:	- iNumResults
        Returns:	-
        Purpose:	- Fetches Articles for the current key phrases
*********************************************************************************/
bool CArticleSearchPhrase::GetArticlesFromKeyPhrases( int iContentType, int iSkip, int iShow, CTDVString sSortBy, bool bCache, int& iNumResults )
{
	//Clean Up previous XML.
	Destroy();

	CTDVString sXML;

	//Create a comma delimited phrase list
	CTDVString sPhrases = "";
	for (SEARCHPHRASELIST::iterator iter = m_lPhraseList.begin();iter != m_lPhraseList.end(); iter++)
	{
		sPhrases << (sPhrases.IsEmpty() ? "" : "|") << iter->m_Phrase;
	}

	CTDVString cachename;
	if ( bCache ) 
	{
		//Create a cache name including the site, keyphrases, skip and show params.
		cachename << "articlesearchphrase-" << m_InputContext.GetSiteID();
		if (iContentType != 0) 
		{
			cachename << "-type" << iContentType;
		}
		cachename << (sPhrases.IsEmpty() ? "" : "-") 
			<< sPhrases << "-" << iSkip << "-" << iShow << (sSortBy.IsEmpty() ? "" : "-") << sSortBy << ".xml";

		cachename.MakeFilenameSafe(); 

		int iCacheTime = m_InputContext.GetCurrentSiteOptionInt("ArticleSearch", "CacheTime");
		if( iCacheTime < 10 )
		{
			iCacheTime = 10;
		}
		//Try to get a cached copy.
		CTDVDateTime dExpires(60 * iCacheTime);		// expire after 10 minutes
		if ( CacheGetItem("articlesearchphrase", cachename, &dExpires, &sXML) )
			return CreateFromXMLText(sXML);
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CArticleSearchPhrase::GetArticlesFromKeyPhrases", "FailedToInitialiseStoredProcedure", "Failed To Initialise Stored Procedure");
	}

	// Now call the procedure
	if (!SP.GetArticlesWithKeyPhrases(sPhrases, iContentType, iSkip, iShow, sSortBy ))
	{
		return SetDNALastError("CArticleSearchPhrase::GetArticlesWithKeyPhrases", "GetArticlesWithKeyPhrases Failed", "Getting articles with key phrases failed");
	}

	InitialiseXMLBuilder(&sXML,&SP);

	OpenXMLTag("ARTICLESEARCH",true);

	AddXMLIntAttribute("ContentType", iContentType);
	AddXMLAttribute("SORTBY", sSortBy, false);
	AddXMLIntAttribute("SKIPTO", iSkip);
	AddXMLIntAttribute("COUNT", iShow);

	if(SP.IsEOF())
	{
		AddXMLIntAttribute("TOTAL", 0, true ); // no results so 0
	}
	else
	{
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

			AddXMLIntAttribute("TOTAL", SP.IsEOF() ? 0 : SP.GetIntField("TOTAL"), true ); // add in total for search which is part of second results set.

			do // Move to next results set
			{
				int iEditor = 0;

				OpenXMLTag("ARTICLE",true);
				int iH2G2ID = SP.GetIntField("H2G2ID");
				AddXMLIntAttribute("H2G2ID", iH2G2ID, true);
		        
				AddDBXMLTag("SUBJECT", 0, false);
				AddDBXMLTag("EXTRAINFO","",false,false);

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

				//AddXMLTag("EDITOR", sEditorXMLBlock);
				AddDBXMLDateTag("DATECREATED", 0, false);
				AddDBXMLDateTag("LASTUPDATED", 0, false);

				AddDBXMLIntTag("ForumPostCount", "NUMBEROFPOSTS", false);
				AddDBXMLDateTag("LASTPOSTED", "FORUMLASTPOSTED", false);

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
	}
	CloseXMLTag("ARTICLESEARCH");

	if ( bCache && !cachename.IsEmpty() ) 
	{
		cachename.MakeFilenameSafe(); 
		CachePutItem("articlesearchphrase", cachename, sXML);
	}

	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	CArticleSearchPhrase::GetKeyPhraseHotList()

		Author:		Steven Francis
        Created:	15/12/2005
        Inputs:		- iSkip, iShow, sSortBy, iMediaAssetType, bCache 
        Outputs:	- 
        Returns:	- false on error.
        Purpose:	- based on Martin Robb GetKeyPhraseHotList 
					  Gets the key phrase hotlist for the article.

*********************************************************************************/
bool CArticleSearchPhrase::GetKeyPhraseHotList( int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType, bool bCache)
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);

	//Create a comma delimited phrase list from the current key phrases
	CTDVString sPhraseList;
	SEARCHPHRASELIST::iterator iter;
	for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
	{
		sPhraseList << (iter == m_lPhraseList.begin() ? "" : "|") << iter->m_Phrase;
	}

	CTDVString cachename;
	if ( bCache ) 
	{
		//Create a cache name including the site, keyphrases, skip and show params.
		cachename << "hotkeyphrases-" << m_InputContext.GetSiteID();
		if (iMediaAssetType != 0) 
		{
			cachename << "-type" << iMediaAssetType;
		}
		cachename << (sPhraseList.IsEmpty() ? "" : "-") 
			<< sPhraseList << "-" << iSkip << "-" << iShow << (sSortBy.IsEmpty() ? "" : "-") << sSortBy << ".xml";

		cachename.MakeFilenameSafe(); 

		//Try to get a cached copy.
		CTDVDateTime dExpires(60*10);		// expire after 10 minutes
		if ( CacheGetItem("articlekeyphrase", cachename, &dExpires, &sXML) )
			return CreateFromXMLText(sXML);
	}

	
	SP.GetKeyPhraseArticleHotList( m_InputContext.GetSiteID(), sPhraseList, iSkip, iShow, sSortBy, iMediaAssetType );
	if ( !SP.IsEOF() )
	{
		//Might get integarated into top-fives
		OpenXMLTag("ARTICLEHOT-PHRASES", true);
		AddXMLIntAttribute("ASSETCONTENTTYPE", iMediaAssetType);
		AddXMLIntAttribute("SKIP", iSkip);
		AddXMLIntAttribute("SHOW", iShow);
		AddDBXMLIntAttribute("COUNT", "Count", false, false);
		AddXMLIntAttribute("MORE", SP.GetIntField("COUNT") > iSkip+iShow, true);
		while ( !SP.IsEOF() )
		{
			CTDVString sPhrase;
			OpenXMLTag("ARTICLEHOT-PHRASE");
			SP.GetField("phrase",sPhrase);

			//If phrase contains token then quote.
			CTDVString sURLPhrase = sPhrase;
			if ( sPhrase.Find(' ') != -1 ) 
			{
				sURLPhrase = '"';
				sURLPhrase += sPhrase;
				sURLPhrase += '"';
			}

			EscapeAllXML(&sPhrase);
			AddXMLTag("NAME",sPhrase);

			EscapePhraseForURL(&sURLPhrase);
			AddXMLTag("TERM",sURLPhrase);

			AddDBXMLDoubleTag("Rank");
			CloseXMLTag("ARTICLEHOT-PHRASE");
			SP.MoveNext();
		}
		CloseXMLTag("ARTICLEHOT-PHRASES");

		if ( bCache && !cachename.IsEmpty() ) 
		{
			cachename.MakeFilenameSafe(); 

			CachePutItem("articlekeyphrase", cachename, sXML);
		}
	}
	else 
	{
		// No result set so return an empty HOT-PHRASES element. 
		sXML << "<ARTICLEHOT-PHRASES/>";
	}

	CreateFromXMLText(sXML);

	return true;
}

/*********************************************************************************

	CArticleSearchPhrase::GetKeyPhrasesFromArticle()

		Author:		Steven Francis
        Created:	16/12/2005
        Inputs:		- iH2G2ID
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Finds the key phrases associated with given article
*********************************************************************************/
bool CArticleSearchPhrase::GetKeyPhrasesFromArticle( int iH2G2ID )
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.GetKeyPhrasesFromArticle(iH2G2ID) )
	{
		SetDNALastError("CArticleSearchPhrase::GetKeyPhrasesFromArticle","GetKeyPhrasesFromArticle","Failed to get key phrases for an Article.");	
		return false;
	}

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	
	if ( !SP.IsEOF() )
	{
		SEARCHPHRASELIST lPhraseList;

		CTDVString sPhrases;
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CArticleSearchPhrase asp(m_InputContext,delimit);
		while ( !SP.IsEOF() )
		{
			CTDVString sPhrase;
			CTDVString sNamespace = "";
			int phrasenamespaceid = 0;

			SP.GetField("Phrase", sPhrase);
			if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
			{
				SP.GetField("Namespace", sNamespace);
			}
			
			if ( SP.FieldExists("PhrasenameSpaceId") )
			{
				phrasenamespaceid = SP.GetIntField("phrasenamespaceid");
			}
			
			PHRASE phrase(sNamespace, sPhrase, phrasenamespaceid );

			lPhraseList.push_back(phrase);
			SP.MoveNext();
		}
		SetPhraseList(lPhraseList);
	}
	sXML << GeneratePhraseListXML();

	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	CArticleSearchPhrase::RemoveKeyPhrasesFromArticle()

		Author:		Steven Francis
        Created:	27/01/2006
        Inputs:		- iH2G2ID, Phrases - Phrasese must be comma separated.
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Removes the given key phrases associated with given article
*********************************************************************************/
bool CArticleSearchPhrase::RemoveKeyPhrasesFromArticle( int iH2G2ID, std::vector<int> phrasenamespaceids )
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.RemoveKeyPhrasesFromArticle(iH2G2ID, phrasenamespaceids ) )
	{
		SetDNALastError("CArticleSearchPhrase::RemoveKeyPhrasesFromArticle","RemoveKeyPhrasesFromArticle","Failed to remove key phrases from the Article.");	
		return false;
	}

	//Record the Key Phrases removed.
	SEARCHPHRASELIST removed;
	while ( !SP.IsEOF() )
	{
		CTDVString sNameSpace;
		CTDVString sPhrase;
		SP.GetField("NameSpace",sNameSpace);
		SP.GetField("Phrase", sPhrase);
		int iPhraseNameSpaceId = SP.GetIntField("PhraseNameSpaceId");
		PHRASE phrase(sNameSpace, sPhrase, iPhraseNameSpaceId);
		removed.push_back(phrase);
		SP.MoveNext();
	}
	SetPhraseList(removed);

	return true;
}


/*********************************************************************************

	CMediaAssetSearchPhrase::RemoveAllKeyPhrasesFromArticle()

		Author:		Steven Francis
        Created:	19/06/2006
        Inputs:		- iH2G2ID
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Removes all the key phrases associated with given article
*********************************************************************************/
bool CArticleSearchPhrase::RemoveAllKeyPhrasesFromArticle( int iH2G2ID )
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.RemoveAllKeyPhrases(iH2G2ID, CStoredProcedure::ARTICLE) )
	{
		SetDNALastError("CArticleSearchPhrase::RemoveAllKeyPhrasesFromArticle","RemoveAllKeyPhrasesFromArticle","Failed to remove key phrases from the Article.");	
		return false;
	}
	return true;
}
