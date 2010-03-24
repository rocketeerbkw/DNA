#include "stdafx.h"
#include "User.h"
#include "MediaAsset.h"
#include ".\mediaassetsearchphrase.h"

CMediaAssetSearchPhrase::CMediaAssetSearchPhrase(CInputContext& InputContext, CTDVString sToken) : CSearchPhraseBase(InputContext, sToken)
{
}

/*********************************************************************************

	CMediaAssetSearchPhrase::AddKeyhrases()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- threadId, sPhrases to add
        Outputs:	- 
        Returns:	- false on error.
        Purpose:	- Adds/Associates the given space separated list of phrases to the asset.

*********************************************************************************/
bool CMediaAssetSearchPhrase::AddKeyPhrases( int iAssetID  )
{
	//Destroy();
	//m_lPhraseList.clear();
	//ParsePhrases(sPhrases);
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	CUser * pViewer = m_InputContext.GetCurrentUser();
	if ( !pViewer )
	{
		SetDNALastError("CMediaAssetSearchPhrase::AddKeyPhrases","AddKeyPhrases","Failed to add phrase(s) - User not signed in.");
		return false;
	}

	CTDVString sPhraseList;
	CTDVString sFailedPhrases;
	
	//Create a comma delimited phrase list
	SEARCHPHRASELIST::iterator iter;
	for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
	{
		sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
	}

	if ( ! SP.AddKeyPhrasesToMediaAsset( iAssetID, sPhraseList ) )
	{
		SetDNALastError("CMediaAssetSearchPhrase::AddKeyPhrases", "AddKeyPhrases", "Failed to add phrase(s)");
		return false;
	}


	if ( !sFailedPhrases.IsEmpty() )
	{
		//Report phrases that failed validation.
		SetDNALastError("CMediaAssetSearchPhrase::AddKeyPhrases", "AddKeyPhrases", CTDVString("Failed to add phrase(s) - Insufficent Permissions ") << sFailedPhrases);
		return false;
	}

	return true;
}

/*********************************************************************************

	CMediaAssetSearchPhrase::GetMediaAssetsFromKeyPhrases()

		Author:		Martin Robb
        Created:	24/10/2005
        Inputs:		- token that delimits phrase elements
					- Content Type - type of asset to search through
					- skip and show parameters
					- sSortBy - How the returned list is ordered
        Outputs:	- 
        Returns:	-
        Purpose:	- Feches Assets for the current key phrases
*********************************************************************************/
bool CMediaAssetSearchPhrase::GetMediaAssetsFromKeyPhrases( int iContentType, int iSkip, int iShow, CTDVString sSortBy, int& iNumResults )
{
	//Clean Up previous XML.
	Destroy();

	//Create a comma delimited phrase list
	CTDVString sPhrases = "";
	for (SEARCHPHRASELIST::iterator iter = m_lPhraseList.begin();iter != m_lPhraseList.end(); iter++)
	{
		sPhrases << (sPhrases.IsEmpty() ? "" : "|") << iter->m_Phrase;
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMediaAssetSearchPhrase::GetMediaAssetsFromKeyPhrases", "FailedToInitialiseStoredProcedure", "Failed To Initialise Stored Procedure");
	}

	// Now call the procedure
	if (!SP.GetMediaAssetsWithKeyPhrases(sPhrases, iContentType, iSkip, iShow, sSortBy ))
	{
		CTDVString sSPError;
		int sSPErrorCode;
		SP.GetLastError(&sSPError, sSPErrorCode);
		return SetDNALastError("CMediaAssetSearchPhrase::GetMediaAssetsFromKeyPhrases", "GetMediaAssetsFromKeyPhrases", "Getting media assets with key phrases failed" + sSPError);
	}

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);

	OpenXMLTag("ASSETSEARCH",true);
	//if ( iContentType > 0 )
	AddXMLIntAttribute("ContentType",iContentType);
	AddXMLAttribute("SORTBY", sSortBy, false);
	AddXMLIntAttribute("SKIPTO",iSkip);
	AddXMLIntAttribute("COUNT", iShow);
	
	int iTotal = 0;
	if (!SP.IsEOF())
	{
		iTotal = SP.GetIntField("total");
	}

	AddXMLIntAttribute("TOTAL", iTotal, true );

	while( !SP.IsEOF() )
	{
		int iOwnerID = 0;
		CTDVString sUserXMLBlock;
		CTDVString sFTPPath;

		OpenXMLTag("ASSET",true);
		int iAssetID = SP.GetIntField("AssetID");
		AddXMLIntAttribute("ASSETID",iAssetID);
		AddDBXMLIntAttribute("CONTENTTYPE", "Contenttype", false, true);

		CMediaAsset::GenerateFTPDirectoryString(iAssetID, sFTPPath);
		AddXMLTag("FTPPATH", sFTPPath);

		AddDBXMLTag("Caption", "SUBJECT");

		iOwnerID = SP.GetIntField("OWNERID");
		CUser oOwner(m_InputContext);
		oOwner.CreateFromID(iOwnerID);
		oOwner.GetAsString(sUserXMLBlock);

		AddXMLTag("OWNER", sUserXMLBlock);
		AddDBXMLTag("Mimetype", "MIMETYPE");

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

		//Create XML for the phrases associated with each asset.
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CMediaAssetSearchPhrase asp(m_InputContext,delimit);
		SEARCHPHRASELIST phraselist;
		do 
		{
			if ( !SP.IsNULL("Phrase") )
			{
				CTDVString sPhrase;
				CTDVString sNamespace = "";

				SP.GetField("Phrase", sPhrase);
				if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
				{
					SP.GetField("Namespace", sNamespace);
				}
				
				PHRASE phrase(sNamespace, sPhrase);

				phraselist.push_back(phrase);
			}
		} while ( SP.MoveNext() && !SP.IsEOF() && (iAssetID == SP.GetIntField("AssetId"))  ) ;
		asp.SetPhraseList(phraselist);
		sXML << asp.GeneratePhraseListXML();

		CloseXMLTag("ASSET");
	}
	CloseXMLTag("ASSETSEARCH");

	return CreateFromXMLText(sXML);
}

bool CMediaAssetSearchPhrase::GetKeyPhraseHotList( int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType, bool bCache)
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

		//Try to get a cached copy.
		CTDVDateTime dExpires(60*10);		// expire after 10 minutes
		if ( CacheGetItem("mediaassetkeyphrase", cachename, &dExpires, &sXML) )
			return CreateFromXMLText(sXML);
	}

	
	SP.GetKeyPhraseMediaAssetHotList( m_InputContext.GetSiteID(), sPhraseList, iSkip, iShow, sSortBy, iMediaAssetType );
	if ( !SP.IsEOF() )
	{
		//Might get integarated into top-fives
		OpenXMLTag("HOT-PHRASES", true);
		AddXMLIntAttribute("ASSETCONTENTTYPE", iMediaAssetType);
		AddXMLIntAttribute("SKIP", iSkip);
		AddXMLIntAttribute("SHOW", iShow);
		AddDBXMLIntAttribute("COUNT", "Count", false, false);
		AddXMLIntAttribute("MORE", SP.GetIntField("COUNT") > iSkip+iShow, true);
		while ( !SP.IsEOF() )
		{
			CTDVString sPhrase;
			OpenXMLTag("HOT-PHRASE");
			SP.GetField("phrase", sPhrase);

			//If phrase contains token then quote.
			CTDVString sURLPhrase = sPhrase;
			if ( sPhrase.Find(' ') != -1 ) 
			{
				sURLPhrase = '"';
				sURLPhrase += sPhrase;
				sURLPhrase += '"';
			}

			EscapeAllXML(&sPhrase);
			AddXMLTag("NAME", sPhrase);

			EscapePhraseForURL(&sURLPhrase);
			AddXMLTag("TERM", sURLPhrase);

			AddDBXMLDoubleTag("Rank");
			CloseXMLTag("HOT-PHRASE");
			SP.MoveNext();
		}
		CloseXMLTag("HOT-PHRASES");

		if ( bCache && !cachename.IsEmpty() ) 
		{
			CachePutItem("mediaassetkeyphrase", cachename, sXML);
		}
	}
	else 
	{
		// No result set so return an empty HOT-PHRASES element. 
		sXML << "<HOT-PHRASES/>";
	}

	CreateFromXMLText(sXML);

	return true;
}

/*********************************************************************************

	CSearchPhrase::GetKeyPhrasesFromAsset()

		Author:		Martin Robb
        Created:	27/10/2005
        Inputs:		- assetId
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Finds the key phrases associated with given discussion/threadId
*********************************************************************************/
bool CMediaAssetSearchPhrase::GetKeyPhrasesFromAsset( int iAssetID )
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.GetKeyPhrasesFromMediaAsset(iAssetID) )
	{
		SetDNALastError("CMediaAssetSearchPhrase::GetKeyPhrasesFromAsset", "GetKeyPhrasesFromAsset", "Failed to get key phrases for media asset.");	
		return false;
	}

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML, &SP);
	
	if ( !SP.IsEOF() )
	{
		SEARCHPHRASELIST lPhraseList;

		CTDVString sPhrases;
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CMediaAssetSearchPhrase asp(m_InputContext,delimit);
		while ( !SP.IsEOF() )
		{
			CTDVString sPhrase;
			CTDVString Namespace = "";

			SP.GetField("Phrase", sPhrase);
			if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
			{
				SP.GetField("Namespace", Namespace);
			}
			
			PHRASE phrase(Namespace, sPhrase);

			lPhraseList.push_back(phrase);

			sPhrases << " " << sPhrase;
			SP.MoveNext();
		}
		SetPhraseList(lPhraseList);
		sXML << GeneratePhraseListXML();
	}
	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	CMediaAssetSearchPhrase::RemoveKeyPhrasesFromAsset()

		Author:		Steven Francis
        Created:	27/01/2006
        Inputs:		- iMediaAssetID, Phrases
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Removes the given key phrases associated with given mediaasset
*********************************************************************************/
bool CMediaAssetSearchPhrase::RemoveKeyPhrasesFromAsset( int iMediaAssetID, CTDVString& sPhrases )
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.RemoveKeyPhrasesFromAssets( iMediaAssetID, sPhrases ) )
	{
		SetDNALastError("CMediaAssetSearchPhrase::RemoveKeyPhrasesFromAsset","RemoveKeyPhrasesFromAsset","Failed to remove key phrases from the Asset.");	
		return false;
	}
	return true;
}

/*********************************************************************************

	CMediaAssetSearchPhrase::RemoveAllKeyPhrasesFromAsset()

		Author:		Steven Francis
        Created:	19/06/2006
        Inputs:		- iMediaAssetID
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Removes all the key phrases associated with given mediaasset
*********************************************************************************/
bool CMediaAssetSearchPhrase::RemoveAllKeyPhrasesFromAsset( int iMediaAssetID)
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.RemoveAllKeyPhrases(iMediaAssetID, CStoredProcedure::ASSET) )
	{
		SetDNALastError("CMediaAssetSearchPhrase::RemoveAllKeyPhrasesFromAsset","RemoveAllKeyPhrasesFromAsset","Failed to remove key phrases from the Asset.");	
		return false;
	}
	return true;
}

/*********************************************************************************

	CMediaAssetSearchPhrase::CreatePreviewPhrases()

		Author:		Steven Francis
        Created:	20/12/2005
        Inputs:		- sPhrases to add to xml
        Outputs:	- 
        Returns:	- false on error.
        Purpose:	- Generates the xml for the given space separated list of phrases.

*********************************************************************************/
bool CMediaAssetSearchPhrase::CreatePreviewPhrases( const CTDVString& sPhrases )
{
	CTDVString sXML;

	Destroy();
	m_lPhraseList.clear();
	ParsePhrases(sPhrases);
	
	sXML << GeneratePhraseListXML();
	return CreateFromXMLText(sXML);
}
