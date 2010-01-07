#pragma once
#include ".\frontpageelement.h"
#include ".\frontpageelement.h"

#include <vector>

class CMessageBoardPromo :	public CFrontPageElement
{
public:
	CMessageBoardPromo(CInputContext& inputContext);
	virtual ~CMessageBoardPromo(void);

public:
	bool CreateNewBoardPromo(int iSiteID, int iEditorID, int& iPromoID, CTDVString* pEditKey = NULL);
	bool DeleteBoardPromo(int iPromoID,int iUserID);
	
	bool GetBoardPromosForSite(int iSiteID, eElementStatus ElementStatus, int iActivePromoID = 0);
	bool GetBoardPromoDetails(int iPromoID);

	bool GetBoardPromosForPhrase( int iSiteId, const SEARCHPHRASELIST& phrases, eElementStatus ElementStatus );

	bool SetTemplateType(int iPromoID, int iType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetTitle(int iPromoID, const TDVCHAR* psTitle, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetText(int iPromoID, const TDVCHAR* psText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetImageName(int iPromoID, const TDVCHAR* psImageName, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetBoardPromoType(int iPromoID, int iBoxType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetImageWidth(int iPromoID, int iImageWidth, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetImageHeight(int iPromoID, int iImageHeight, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetImageAltText(int iPromoID, const TDVCHAR* psImageAltText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);

	bool SetKeyPhrases( int iPromoID, const SEARCHPHRASELIST& phrases, bool bDefaultPromo);

	bool GetBoardPromoTitle(CTDVString& sTitle, int iElementID = 0);
	bool GetBoardPromoText(CTDVString& sText, int iElementID = 0);
	bool GetBoardPromoImageName(CTDVString& sImageName, int iElementID = 0);
	bool GetBoardPromoImageWidth(int& iImageWidth, int iElementID = 0);
	bool GetBoardPromoImageHeight(int& iImageHeight, int iElementID = 0);
	bool GetBoardPromoImageAltText(CTDVString& sImageAltText, int iElementID = 0);

	bool CommitBoardPromoChanges(int iUserID, const TDVCHAR* psEditKey,CTDVString* psNewEditKey=NULL);
	bool MakePreviewBoardPromosActive(int iSiteID, int iEditorID, int iPromoID = 0);
	bool GetNumberOfBoardPromosForSiteID(int iSiteID, int& iNumberOfPromos, eElementStatus ElementStatus = ES_PREVIEW);
	bool SetBoardPromoLocations(int iBoardPromoID, CDNAIntArray& Locations, const TDVCHAR* psEditKey, int iUserID);
	bool SetDefaultBoardPromoForTopics(int iSiteID, int iBoardPromoID, int iUserID);
	bool SetBoardPromoName(int iPromoID, const TDVCHAR* psPromoName, const TDVCHAR* psEditKey, CTDVString* psNewEditKey = NULL);
protected:
	virtual bool CreateInternalXMLForElement(CDBXMLBuilder& XML);
	virtual bool GetElementDetailsFromDatabase(CStoredProcedure& SP);
private:
	CTDVString m_sBoardPromoName;
};
