#pragma once
#include "FrontPageElement.h"

class CFrontPageTopicElement : public CFrontPageElement
{
public:
	CFrontPageTopicElement(CInputContext& inputContext);
	virtual ~CFrontPageTopicElement(void);

public:	
	bool CreateTopicFrontPageElement(int& iElementID, int iSiteID, int iUserID, CFrontPageElement::eElementStatus ElementStatus,  int iElementLinkID, int iTopicID, const bool bUseNoOfPost, const TDVCHAR* psText, const TDVCHAR* psImageName, int iTemplate, const TDVCHAR* psTitle, const TDVCHAR* psImageAltText); 
	bool EditTopicFrontPageElement(int iElementID,  int iUserID, CFrontPageElement::eElementStatus ElementStatus, const bool bUseNoOfPost, const TDVCHAR* psText, const TDVCHAR* psImageName, int iTemplate, const TDVCHAR* psEditKey, const TDVCHAR* psTitle, const TDVCHAR* psImageAltText, bool bCommitChanges = true);
	bool DeleteTopicFrontPageElement(int iElementID, int iUserID);
	bool GetTopicFrontPageElementsForSiteID(int iSiteID, eElementStatus ElementStatus, int iActivePromoID = 0);	
	bool GetTopicFrontPageElementDetails(int iElementID);
	bool MakePreviewTopicFrontPageElementsActive(int iSiteID, int iEditorID, int iElementID = 0);

	bool SetTopicFrontPageElementTemplateType(int iElementID, int iType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey, bool bApplyTemplateToAllInSite = true);
	bool SetTopicFrontPageElementTitle(int iElementID, const TDVCHAR* psTitle, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetTopicFrontPageElementText(int iElementID, const TDVCHAR* psText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetTopicFrontPageElementPosition(int iElementID, int iPosition, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetTopicFrontPageElementImageName(int iElementID, const TDVCHAR* psImageName, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetTopicFrontPageElementImageAltText(int iElementID, const TDVCHAR* psImageAltText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
//	bool SetTopicFrontPageElementUseNoOfPost(int iElementID, int bUseNoOfPost,  bool bCommitChanges, const TDVCHAR* psEditKey); // No longer used

	bool CommitTopicFrontPageElementChanges(int iUserID, const TDVCHAR* psEditKey);

	bool GetTopicFrontPageElementTitle(CTDVString& sTitle, int iElementID);
	bool GetTopicFrontPageElementText(CTDVString& sText, int iElementID);
	bool GetTopicFrontPageElementImageName(CTDVString& sImageName, int iElementID);
	bool GetTopicFrontPageElementTopicID(int& iTopicID, int iElementID);
	bool GetTopicFrontPageElementTemplateType(int& iTemplateType, int iElementID);
	bool GetTopicFrontPageElementImageAltText(CTDVString& sImageAltText, int iElementID);
//	bool GetTopicFrontPageElementUseNoOfPosts(int& iUseNoOfPosts, int iElementID); // No longer used.
	bool GetNumberOfFrontPageTopicElementsForSiteID(int iSiteID, int& iNumTopicElements, eElementStatus ElementStatus = ES_PREVIEW);
};

