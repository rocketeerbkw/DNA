// TypedArticleBuilder.h: interface for the CTypedArticleBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TYPEDARTICLEBUILDER_H__364302F1_EE1B_4DCB_9D82_853687F560B7__INCLUDED_)
#define AFX_TYPEDARTICLEBUILDER_H__364302F1_EE1B_4DCB_9D82_853687F560B7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CGuideEntry;
class CMultiStep;
class CArticleDateRange;
class CDateRangeValidation;

#include "XMLBuilder.h"
#include "ArticleEditForm.h"
#include "poll.h"
#include <vector>

class CTypedArticleBuilder  : public CXMLBuilder
{
public:
	CTypedArticleBuilder(CInputContext& inputContext);
	virtual ~CTypedArticleBuilder();

	virtual bool Build(CWholePage* pPage);

protected:
	bool ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg);
	bool CreateTypedArticle();
	bool PreviewTypedArticle(int iH2G2ID = 0);
	bool UpdateTypedArticle(int iH2G2ID, bool bForceNoUpdate = false, bool bUseCachedArticle = true);
	bool EditTypedArticle(int iH2G2ID, bool bProfanityTriggered = false );
	bool DeleteTypedArticle(int iH2G2ID);
	bool UnDeleteTypedArticle(int iH2G2ID);
	bool SetResearchers(int iH2G2ID);
	bool PerformSetResearchers(CArticleEditForm& editForm, int iH2G2ID);

	bool InitialiseMultiStepFromGuideEntry(CMultiStep& Multi, CGuideEntry& GuideEntry );
	
	bool GetMultiStepInput(CMultiStep& Multi, 
						   CTDVString& sTitle,
						   CTDVString& sNewBodyXML,
						   CExtraInfo& ExtraInfo, 
						   int& iSubmittable,
						   int& iType, 
						   int& iStatus, 
						   int& iHideArticle, 
						   bool& bArchive, 
						   CTDVString& sWhoCanEdit,
						   int& bArticleForumStyle,
						   int& iLinkClub,
						   CTDVString& sLinkClubRelationship,
						   bool& bUpdateDateCreated,
						   std::vector< POLLDATA >* pvecPollTypes = NULL ,
						   bool bHasAsset = false,
						   bool bManualUpload = false,
						   bool bHasKeyPhrases = false,
						   bool bExternalLink = false,
						   CTDVString *pCaption = 0,
						   CTDVString *pFilename = 0, 
						   CTDVString *pMimeType = 0, 
						   int *iContentType = 0,
						   CTDVString *pMultiElementsXML = 0,
						   CTDVString *pMediaAssetKeyPhrases = 0, 
						   CTDVString *pFileDescription = 0,
						   const char **pFileBuffer = 0, 
						   int *iFileLength = 0,
						   CTDVString *pExternalLinkURL = 0,
						   CTDVString *pNamespacedKeyPhrases = 0,
						   CTDVString *pNamespaces =0
						   );

	bool GetEditFormDataFromGuideEntry(CGuideEntry& GuideEntry,CTDVString& sSubject, 
							  CTDVString& sEditFormData);
	bool ModerateArticle(CGuideEntry& GuideEntry, bool bProfanitiesFound = false, bool bHasAssets = false, CTDVString sProfanity = "");

	bool CanSetStatus();
	bool CheckIsChangingPermissionsIllegally(bool bCanChangePermissions, 
						const TDVCHAR* pNewWhoCanEdit, const TDVCHAR* pOldWhoCanEdit);

	void ProcessExtraInfoActions(CMultiStep& Multi,CExtraInfo& ExtraInfo);
	void ProcessExtraInfoAction(CExtraInfo& ExtraInfo,int nAction,const TDVCHAR* pName,const TDVCHAR* pValue);

	void ProcessDerivedKeyPhraseActions( CMultiStep& Multi, CTDVString& sKeyPhrases );
	void ProcessNamespacedKeyPhrases(CMultiStep& Multi, CTDVString& sKeyPhrases, CTDVString& sNamespaces);

	bool UpdateDerivedKeyPhrases( int iH2G2ID, CMultiStep& Multi, CMultiStep& EditedMulti );

	bool LinkToClub(int iArticleID, int iClubID, const TDVCHAR* pRelationship);
	
	bool LinkArticleAndMediaAsset(int ih2g2ID, int iMediaAssetID);
	bool CheckIsUserBanned(int iArticleSiteID);

	bool GetDateRangeFromMultiStep(CMultiStep& Multi, CDateRangeValidation& dateRangeVal);
	void SetArticleDateRangeFromMultiStep(CStoredProcedure& SP,int iH2G2ID, CDateRangeValidation& dateRangeVal);
	
protected:
	CWholePage* m_pPage;
	CUser*		m_pViewer;

	CDateRangeValidation* m_pDateRangeVal;

public:
	bool CheckAndInsertTagNodes(CDNAIntArray& NodeArray);
};

#endif // !defined(AFX_TYPEDARTICLEBUILDER_H__364302F1_EE1B_4DCB_9D82_853687F560B7__INCLUDED_)
