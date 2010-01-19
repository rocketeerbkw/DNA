// ArticleMember.h: interface for the CArticleMember class.
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


#ifndef _ARTICLEMEMBER_H_INCLUDED_
#define _ARTICLEMEMBER_H_INCLUDED_

#include "TDVString.h"
#include "TDVDateTime.h"
#include "ExtraInfo.h"
#include "XMLObject.h"
#include "threadsearchphrase.h"

class CArticleMember : public CXMLObject
{
public:
	CArticleMember(CInputContext& inputContext);
	virtual ~CArticleMember();

	void Clear();

	//
	// Accessor functions:
	//
	void SetH2g2Id(const int iH2g2Id);
	void SetName(const CTDVString& sName);
	void SetIncludeStrippedName(bool bIncludeStrippedName);

	void SetEditor(const CTDVString& sEditor, const CTDVString& sEditorName, 
		const CTDVString& sFirstNames, 
		const CTDVString& sLastName, 
		const CTDVString& sArea, 
		int nStatus, 
		int nTaxonomyNode,
		int nJournal,
		int nActive,
		const CTDVString& sSiteSuffix,
		const CTDVString& sTitle);

	void SetExtraInfo(const CTDVString& sExtraInfo);
	void SetExtraInfo(const CTDVString& sExtraInfo, const int iType);
	void SetStatus(const int iStatus);
	void SetDateCreated(const CTDVDateTime& dateCreated);
	void SetLastUpdated(const CTDVDateTime& lastUpdated);
	void SetCrumbTrail();
	void SetLocal();
	void SetContentRatingStatistics(int nPollID, int nVoteCount, double dblAverageRating);

	void SetMediaAssetInfo(int iMediaAssetID,
							int iContentType,
							const CTDVString& sCaption,
							int iMimeType,
							int iOwnerID,
							const CTDVString& sExtraElementXML,
							int iHidden,
							const CTDVString& sExternalLinkURL);

	void SetPhraseList(const SEARCHPHRASELIST& Phrases);

	//
	// Output:
	//
	bool GetAsXML(CTDVString& sXML);

private:
	int m_iH2g2Id, m_iStatus;
	CTDVString m_sName, m_sEditor, m_sExtraInfo;
	CTDVString m_sEditorName;
	CTDVDateTime m_dateCreated, m_lastUpdated;
	bool m_bIncludeStrippedName;
	
	// Content rating stats
	int m_nCRPollID;
	int m_nCRVoteCount;
	double m_dblCRAverageRating;
	bool m_bArticleIsLocal;

	CExtraInfo m_cExtraInfo;
	CTDVString m_sCrumbTrail;

	// Additional editor fields
	CTDVString m_sFirstNames;
	CTDVString m_sLastName;
	CTDVString m_sArea;
	int m_nStatus;
	int m_nTaxonomyNode;
	int m_nJournal;
	int m_nActive;
	CTDVString m_sSiteSuffix;
	CTDVString m_sTitle;

	int m_iMediaAssetID;
	int m_iContentType;
	CTDVString m_sCaption;
	int m_iMimeType;
	int m_iOwnerID;
	CTDVString m_sExtraElementXML;
	int m_iHidden;
	CTDVString m_sExternalLinkURL;

	SEARCHPHRASELIST m_splPhraseList;

};


/*********************************************************************************
	inline void CArticleMember::SetH2g2Id(const int iH2g2Id)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CArticleMember::SetH2g2Id(const int iH2g2Id)
{
	m_iH2g2Id = iH2g2Id;
}


/*********************************************************************************
	inline void CArticleMember::SetName(const CTDVString& sName)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CArticleMember::SetName(const CTDVString& sName)
{
	m_sName = sName;
}


/*********************************************************************************
	inline void CArticleMember::SetIncludeStrippedName(bool bIncludeStrippedName)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CArticleMember::SetIncludeStrippedName(bool bIncludeStrippedName)
{
	m_bIncludeStrippedName = bIncludeStrippedName;
}


/*********************************************************************************
	inline void CArticleMember::SetEditor(const CTDVString& sEditor)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
	Updated:	13/04/04 - jamesp - Added new fields (sFirstNames...sTitle)
*********************************************************************************/

inline void CArticleMember::SetEditor(const CTDVString& sEditor, const CTDVString& sEditorName, 
		const CTDVString& sFirstNames, 
		const CTDVString& sLastName, 
		const CTDVString& sArea, 
		int nStatus, 
		int nTaxonomyNode,
		int nJournal,
		int nActive,
		const CTDVString& sSiteSuffix,
		const CTDVString& sTitle)
{
	m_sEditor = sEditor;
	m_sEditorName = sEditorName;

	m_sFirstNames = sFirstNames;
	m_sLastName = sLastName;
	m_sArea = sArea;
	m_nStatus = nStatus;
	m_nTaxonomyNode = nTaxonomyNode;
	m_nJournal = nJournal;
	m_nActive = nActive;
	m_sSiteSuffix = sSiteSuffix;
	m_sTitle = sTitle;
}


/*********************************************************************************
	inline void CArticleMember::SetExtraInfo(const CTDVString& sExtraInfo, const int iType)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CArticleMember::SetExtraInfo(const CTDVString& sExtraInfo, const int iType)
{
	m_cExtraInfo.Create(iType, sExtraInfo);
	m_cExtraInfo.GetInfoAsXML(m_sExtraInfo);
}


/*********************************************************************************
	inline void CArticleMember::SetExtraInfo(const CTDVString& sExtraInfo)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CArticleMember::SetExtraInfo(const CTDVString& sExtraInfo)
{
	m_sExtraInfo = sExtraInfo;
}

/*********************************************************************************
	inline void CArticleMember::SetStatus(const int iStatus)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CArticleMember::SetStatus(const int iStatus)
{
	m_iStatus = iStatus;
}


/*********************************************************************************
	inline void CArticleMember::SetDateCreated(const CTDVDateTime& dateCreated)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CArticleMember::SetDateCreated(const CTDVDateTime& dateCreated)
{
	m_dateCreated = dateCreated;
}


/*********************************************************************************
	inline void CArticleMember::SetLastUpdated(const CTDVDateTime& lastUpdated)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CArticleMember::SetLastUpdated(const CTDVDateTime& lastUpdated)
{
	m_lastUpdated = lastUpdated;
}

/*********************************************************************************

	inline void CArticleMember::SetContentRatingStatistics(int nPollID, int nVoteCount, double dblAverageRating)

		Author:		James Pullicino
        Created:	10/03/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Call to inlcude content rating data in articlemember

*********************************************************************************/

inline void CArticleMember::SetContentRatingStatistics(int nPollID, int nVoteCount, double dblAverageRating)
{
	m_nCRPollID = nPollID;
	m_nCRVoteCount = nVoteCount;
	m_dblCRAverageRating = dblAverageRating;
}

/*********************************************************************************

	inline void CArticleMember::SetMediaAssetInfo(int iMediaAssetID)

		Author:		Steve Francis
        Created:	16/08/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Call to include media asset info data in articlemember

*********************************************************************************/

inline void CArticleMember::SetMediaAssetInfo(int iMediaAssetID,
												int iContentType,
												const CTDVString& sCaption,
												int iMimeType,
												int iOwnerID,
												const CTDVString& sExtraElementXML,
												int iHidden,
												const CTDVString& sExternalLinkURL)
{
	m_iMediaAssetID = iMediaAssetID;
	m_iContentType = iContentType;
	m_sCaption = sCaption;
	m_iMimeType = iMimeType;
	m_iOwnerID = iOwnerID;
	m_sExtraElementXML = sExtraElementXML;
	m_iHidden = iHidden;
	m_sExternalLinkURL = sExternalLinkURL;
}

/*********************************************************************************

	inline void CArticleMember::SetMediaAssetInfo(const SEARCHPHRASELIST& Phrases)

		Author:		Steve Francis
        Created:	04/05/2007
        Inputs:		const SEARCHPHRASELIST& Phrases - the phrases
        Outputs:	-
        Returns:	-
        Purpose:	Call to set the key phrase info data in articlemember

*********************************************************************************/

inline void CArticleMember::SetPhraseList(const SEARCHPHRASELIST& Phrases)
{
	m_splPhraseList = Phrases;
}

#endif
