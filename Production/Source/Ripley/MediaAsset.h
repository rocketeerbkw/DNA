//////////////////////////////////////////////////////////////////////
// MediaAsset.h: interface for the CMediaAsset class.
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


#if !defined(AFX_MEDIAASSET_H__6F82D0DF_8226_4781_8D4F_3A86E04C1E74__INCLUDED_)
#define AFX_MEDIAASSET_H__6F82D0DF_8226_4781_8D4F_3A86E04C1E74__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#include "xmlobject.h"

/*********************************************************************************
class:	CMediaAsset

This class handles the creating, updating and retrieval of media assets

		Author:		Steve Francis
        Created:	12/10/2005
        Inputs:		Input Context
        Purpose:	Class to perform core Media Asset functions. 
*********************************************************************************/

class CMediaAsset :	public CXMLObject
{
public:
	CMediaAsset(CInputContext& inputContext);
	virtual ~CMediaAsset(void);

	virtual bool ProcessAction();

	bool ExternalCreateMediaAsset(int& iMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType,
									const TDVCHAR* pMultiElementsXML, int iOwnerID, 
									const TDVCHAR* pMediaAssetKeyPhrases, const TDVCHAR* pDescription,
									bool bAddToLibrary, 
									bool bManualUpload, const char *pFileBuffer, int iFileLength, bool bSkipModeration,
									const TDVCHAR* pExternalLinkURL, CTDVString& sReturnedXML);
	
	bool ExternalPreviewMediaAsset(int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType,
									const TDVCHAR* pMultiElementsXML, int iOwnerID, 
									const TDVCHAR* pMediaAssetKeyPhrases, const TDVCHAR* pDescription,
									bool bAddToLibrary, CTDVString& sReturnedXML);

	bool ExternalGetLinkedArticleAsset(int iH2G2ID, int iSiteID);
	bool ExternalRemoveLinkedArticleAsset(int iH2G2ID);

	bool ViewMediaAsset(int iMediaAssetID, int iSiteID);

	static bool GenerateFTPDirectoryString(int iMediaAssetID, CTDVString& sFTPDirectory);
	static bool IsMimeTypeSupported(CTDVString sMimeType, int &iContentType);
	static int GetMAXFileSize();
	static bool GetImageFormat(CTDVString sMimeType, CTDVString& sFileSuffix);
	static bool GetAudioSuffix(CTDVString sMimeType, CTDVString& sFileSuffix);
	static bool GetVideoSuffix(CTDVString sMimeType, CTDVString& sFileSuffix);

	static bool GetIDFromLink(CTDVString sInLink, 
								CTDVString& sOutID, 
								CTDVString& sOutType, 
								CTDVString& sOutFlickrFarmPath, 
								CTDVString& sOutFlickrServer, 
								CTDVString& sOutFlickrID, 
								CTDVString& sOutFlickrSecret, 
								CTDVString& sOutFlickrSize);

	bool GetArticlesAssets(int iH2G2ID, int &iMediaAssetID, CTDVString& sMimeType, int& iHidden );

private:

	bool ProcessView();

	bool ProcessCreateUpdate(int iMediaAssetID, bool bAddToLibrary, int iH2G2ID = 0);

	bool CreateUpdateMediaAsset(int& iMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
								const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType, 
								const TDVCHAR* pMultiElementsXML, int iOwnerID, 
								const TDVCHAR* pMediaAssetKeyPhrases, const TDVCHAR* pDescription,
								bool bAddToLibrary, int iFileLength, 
								const TDVCHAR* pIPAddress, bool bSkipModeration, 
								int iHidden, int iH2G2ID, const TDVCHAR* pExternalLinkURL,
								CTDVString& sReturnedXML);


	bool GetMediaAsset(int iMediaAssetID, int iSiteID, CTDVString &sCaption,
									CTDVString &sFilename, CTDVString &sMimeType, int *piContentType, 
									CTDVString &sMultiElementsXML, int *piOwnerID, 
									CTDVString &sMediaAssetKeyPhrasesAsString,
									CTDVString &sDescription, int *piHidden,
									CTDVString &sExternalURLLink);

	bool CreateMediaAssetXML(int iMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
							const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType, 
							const TDVCHAR* pMultiElementsXML, int iOwnerID,
							const TDVCHAR* pDescription, bool bAddToLibrary,
							CTDVDateTime &dtDateCreated, CTDVDateTime &dtLastUpdated,
							CTDVString& sReturnedXML, bool bPreviewMode = false, 
							const TDVCHAR* pPreviewKeyPhrases = NULL, int iHidden = 3,
							const TDVCHAR* pExternalURLLink = NULL);

	bool AddMediaAssetKeyPhrases(int iMediaAssetID, const TDVCHAR* sMediaAssetKeyPhrases);
	bool GetMediaAssetKeyPhrases(int iMediaAssetID, CTDVString &sMediaAssetKeyPhrases, bool bAsString = false);

	bool UploadMediaAsset(int iMediaAssetID, const char *pFileBuffer, int iLength, bool bAddToLibrary, bool bSkipModeration);

	bool GetFileDetails(int &iContentType, CTDVString &sMimeType, int &iLength);
	bool RemoveLinkedArticlesAssets(int iH2G2ID);

	bool ViewUsersMediaAssets(int iUserID, int iContentType, bool bOwner, CTDVString sSortBy);
	bool ProcessShowUsersMediaAssets();

	bool ViewUsersArticlesWithMediaAssets(int iUserID, int iContentType, bool bOwner, CTDVString sSortBy);
	bool ProcessShowUsersArticlesWithMediaAssets();

	bool QueueMediaAssetForModeration(int iMediaAssetID, int iSiteID);

	bool CheckUsersFileUploadLimit(int iFileLength, int iCurrentUserID, int &iTotalUploadSize, bool &bWithinLimit, CTDVDateTime &dtNextLimitStartDate);
	bool ExceedsUploadLimitErrorInfo(int iFileLength, int &iTotalUploadSize, CTDVDateTime &dtNextLimitStartDate);

	bool ProcessShowFTPUploadQueue();
	bool ProcessReprocessFailedUploads(int iMediaAssetID = 0);

	bool FixMimeType(CTDVString sInMimeType, CTDVString& sFixedMimeType);

	bool RemoveArticleAndMediaAssetKeyPhrases(int iMediaAssetID, int iH2G2ID);
	bool AddArticleMediaAssetKeyPhrases(int iH2G2ID, const TDVCHAR* pMediaAssetKeyPhrases);

	static bool GetExternalIDFromLink(CTDVString sInLink, 
										CTDVString sInPreFix, 
										CTDVString& sOutExternalID);

	static bool TryGetExternalFlickrIDFromLink(CTDVString sInLink, 
												 CTDVString& sOutFlickrFarmPath, 
												 CTDVString& sOutFlickrServer, 
												 CTDVString& sOutFlickrID, 
												 CTDVString& sOutFlickrSecret, 
												 CTDVString& sOutFlickrSize);

private:

	bool m_bManualUpload;
	bool m_bExternalLink;

	bool m_bUpdate;
	bool m_bUpdateDataLoaded;
};
#endif // !defined(AFX_MEDIAASSET_H__6F82D0DF_8226_4781_8D4F_3A86E04C1E74__INCLUDED_)
