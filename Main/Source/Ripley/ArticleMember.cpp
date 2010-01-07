// ArticleMember.cpp: implementation of the CArticleMember class.
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
#include "ArticleMember.h"
#include "XMLStringUtils.h"
#include "TDVAssert.h"
#include "category.h"
#include "pollcontentrating.h"
#include "MediaAsset.h"
#include "User.h"

/*********************************************************************************
	CArticleMember::CArticleMember()

	Author:		David van Zijl
	Created:	20/07/2004
	Inputs:		-
	Purpose:	Constructor
*********************************************************************************/

CArticleMember::CArticleMember(CInputContext& inputContext)
	: CXMLObject(inputContext)
{
	Clear();
}


/*********************************************************************************
	CArticleMember::~CArticleMember()

	Author:		David van Zijl
	Created:	20/07/2004
	Inputs:		-
	Purpose:	Destructor
*********************************************************************************/

CArticleMember::~CArticleMember()
{
}


/*********************************************************************************
	void CArticleMember::Clear()

	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Clears all internal fields
*********************************************************************************/

void CArticleMember::Clear()
{
	m_iH2g2Id = 0;
	m_iStatus = 0;
	m_bIncludeStrippedName = false;
	m_sName.Empty();
	m_sEditor.Empty();
	m_sEditorName.Empty();
	m_sExtraInfo.Empty();
	m_dateCreated.SetStatus( COleDateTime::null );
	m_lastUpdated.SetStatus( COleDateTime::null );
	
	m_nCRPollID = 0;
	m_dblCRAverageRating = 0;
	m_nCRVoteCount = 0;

	m_bArticleIsLocal = false;

	m_sFirstNames.Empty();
	m_sLastName.Empty();
	m_sArea.Empty();
	m_nStatus = 0;
	m_nTaxonomyNode = 0;
	m_nJournal = 0;
	m_nActive = 0;
	m_sSiteSuffix.Empty();
	m_sTitle.Empty();

	m_iMediaAssetID = 0;

	m_splPhraseList.clear();
}


/*********************************************************************************
	bool CArticleMember::GetAsXML(CTDVString& sXML)

	Author:		David van Zijl
	Created:	20/07/2004
	Inputs:		sXML - destination for generated XML
	Outputs:	1) CXMLObject is populated with XML for current article member
				2) XML for current article member is appended to sXML
	Returns:	true on success
	Purpose:	Builds ARTICLEMEMBER xml from internal values
	
	Changes:	- 28/02/2005: Since class now derives from CXMLObject, CreateFromXMLText is called.
				- 28/02/2005: Adds Content Rating data to xml
				- 16/08/2006: Adds Media Asset data to xml if Site Option set

*********************************************************************************/

bool CArticleMember::GetAsXML(CTDVString& sXML)
{
	CTDVString sArticleMemberXML;

	// Require h2g2id as a minimum
	if (m_iH2g2Id == 0)
	{
		return false;
	}

	sArticleMemberXML << "<ARTICLEMEMBER>";
	sArticleMemberXML << "<H2G2ID>" << m_iH2g2Id << "</H2G2ID>";
	sArticleMemberXML << "<NAME>" << m_sName << "</NAME>"; // Can be blank
	if (m_bIncludeStrippedName)
	{
		CXMLStringUtils::AddStrippedNameXML(m_sName, sArticleMemberXML);
	}

	if (!m_sEditor.IsEmpty())
	{
		// Get groups for user
		CTDVString sGroups;
		if(!m_InputContext.GetUserGroups(sGroups, atoi(m_sEditor)))
		{
			TDVASSERT(false, "CArticleMember::GetAsXML() m_InputContext.GetUserGroups failed");
		}

		sArticleMemberXML << "<EDITOR>" << m_sEditor 
			<< "<USER>"
			<< "<USERID>"		<< m_sEditor		<< "</USERID>"
			<< "<USERNAME>"		<< m_sEditorName	<< "</USERNAME>"
			<< "<FIRSTNAMES>"	<< m_sFirstNames	<< "</FIRSTNAMES>"
			<< "<LASTNAME>"		<< m_sLastName		<< "</LASTNAME>"
			<< "<AREA>"			<< m_sArea			<< "</AREA>"
			<< "<STATUS>"		<< m_nStatus		<< "</STATUS>"
			<< "<TAXONOMYNODE>"	<< m_nTaxonomyNode	<< "</TAXONOMYNODE>"
			<< "<JOURNAL>"		<< m_nJournal		<< "</JOURNAL>"
			<< "<ACTIVE>"		<< m_nActive		<< "</ACTIVE>"
			<< "<SITESUFFIX>"	<< m_sSiteSuffix	<< "</SITESUFFIX>"
			<< "<TITLE>"		<< m_sTitle			<< "</TITLE>"
			<< sGroups
			<< "</USER>"
			<< "</EDITOR>";
	}
	if (m_iStatus != 0)
	{
		CXMLStringUtils::AppendStatusTag(m_iStatus, sArticleMemberXML);
	}
	if (!m_sExtraInfo.IsEmpty())
	{
		sArticleMemberXML << m_sExtraInfo;
	}

	// Add dates if they have been provided
	//
	if (m_dateCreated.GetStatus())
	{
		CTDVString sDateCreatedXML;
		m_dateCreated.GetAsXML(sDateCreatedXML);

		sArticleMemberXML << "<DATECREATED>" << sDateCreatedXML << "</DATECREATED>";
	}
	if (m_lastUpdated.GetStatus())
	{
		CTDVString sLastUpdatedXML;
		m_lastUpdated.GetAsXML(sLastUpdatedXML);

		sArticleMemberXML << "<LASTUPDATED>" << sLastUpdatedXML << "</LASTUPDATED>";
	}
	if (m_bArticleIsLocal)
	{
		sArticleMemberXML << "<LOCAL>1</LOCAL>";
	}

	sArticleMemberXML << "</ARTICLEMEMBER>";

	// Parse XML, init CXMLObject
	if(!CreateFromXMLText(sArticleMemberXML, 0, true))
	{
		return false;
	}

	// Add Content Rating data if we have a cr poll for this article
	if(m_nCRPollID)
	{
		// Set Stats
		CPollContentRating Poll(m_InputContext, m_nCRPollID);
		Poll.SetContentRatingStatistics(m_nCRVoteCount, m_dblCRAverageRating);

		// Generate XML without poll results, just stats
		if(Poll.MakePollXML(CPoll::PollLink(m_nCRPollID, false), false))
		{
			// Add to article member
			AddInside("ARTICLEMEMBER", &Poll);
		}
		else
		{
			TDVASSERT(false, "CArticleMember::GetAsXML() Poll.MakePollXML failed");
		}
	}

	CTDVString sArticleMemberMediaAssetXML;
	if (m_InputContext.DoesCurrentSiteHaveSiteOptionSet("MediaAsset", "ReturnInCategoryList"))
	{
		if(m_iMediaAssetID > 0)
		{
			CTDVString sFTPPath;
			CTDVString sUserXMLBlock;
			CTDVString sExternalLinkID="";
			CTDVString sExternalLinkType="";

			CTDVString sFlickrFarmPath=""; 
			CTDVString sFlickrServer=""; 
			CTDVString sFlickrID=""; 
			CTDVString sFlickrSecret=""; 
			CTDVString sFlickrSize="";

			CMediaAsset::GenerateFTPDirectoryString(m_iMediaAssetID, sFTPPath);
			CMediaAsset::GetIDFromLink(m_sExternalLinkURL, 
										sExternalLinkID, 
										sExternalLinkType, 
										sFlickrFarmPath, 
										sFlickrServer, 
										sFlickrID, 
										sFlickrSecret, 
										sFlickrSize);

			CUser oOwner(m_InputContext);
			oOwner.CreateFromID(m_iOwnerID);
			oOwner.GetAsString(sUserXMLBlock);

			sArticleMemberMediaAssetXML << "<MEDIAASSET "
				<< "MEDIAASSETID='" << m_iMediaAssetID << "' CONTENTTYPE='" << m_iContentType	<< "' >"
				<< "<FTPPATH>" << sFTPPath << "</FTPPATH>"
				<< "<CAPTION>" << m_sCaption << "</CAPTION>"
				<< "<OWNER>" << sUserXMLBlock << "</OWNER>"
				<< "<MIMETYPE>" << m_iMimeType << "</MIMETYPE>"
				<< "<EXTRAELEMENTXML>" << m_sExtraElementXML << "</EXTRAELEMENTXML>";
				if (m_iHidden > 0)
				{
					sArticleMemberMediaAssetXML << "<HIDDEN>" << m_iHidden << "</HIDDEN>";
				}
				sArticleMemberMediaAssetXML << "<EXTERNALLINKTYPE>" << sExternalLinkType << "</EXTERNALLINKTYPE>"
				<< "<EXTERNALLINKURL>" << m_sExternalLinkURL << "</EXTERNALLINKURL>"
				<< "<EXTERNALLINKID>" << sExternalLinkID << "</EXTERNALLINKID>";

				if(sExternalLinkType == "Flickr")
				{
					sArticleMemberMediaAssetXML << "<FLICKR>"
					<<	"<FARMPATH>" << sFlickrFarmPath << "</FARMPATH>"
					<<	"<SERVER>" << sFlickrServer << "</SERVER>"
					<<	"<ID>" << sFlickrID << "</ID>"
					<<	"<SECRET>" << sFlickrSecret << "</SECRET>"
					<<	"<SIZE>" << sFlickrSize << "</SIZE>"
					<<  "</FLICKR>";
				}

				sArticleMemberMediaAssetXML << "</MEDIAASSET>";


			// Add to article member
			AddInside("ARTICLEMEMBER", sArticleMemberMediaAssetXML);
		}
	}

	bool bIncludeKeyPhraseData = m_InputContext.DoesCurrentSiteHaveSiteOptionSet("KeyPhrases", "ReturnInCategoryList");
	if (bIncludeKeyPhraseData)
	{
		CTDVString sArticleMemberPhraseXML;

		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CSearchPhraseBase spb(m_InputContext,delimit);
		spb.SetPhraseList(m_splPhraseList);
		sArticleMemberPhraseXML = spb.GeneratePhraseListXML();
		
		// Add to article member
		AddInside("ARTICLEMEMBER", sArticleMemberPhraseXML);
	}

	// Make sure XML is latest 
	sArticleMemberXML.Empty();
	if(!GetAsString(sArticleMemberXML))
	{
		TDVASSERT(false, "CArticleMember::GetAsXML() GetAsString failed");
		return false;
	}

	// Append
	sXML += sArticleMemberXML;
    
	return true;
}

void CArticleMember::SetCrumbTrail()
{
	CCategory Cat(m_InputContext);
	Cat.GetArticleCrumbTrail(m_iH2g2Id);
	Cat.GetAsString(m_sCrumbTrail);
}

void CArticleMember::SetLocal()
{
	m_bArticleIsLocal = true;
}