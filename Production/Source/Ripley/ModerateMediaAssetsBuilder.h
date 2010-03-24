#pragma once
#include "XMLBuilder.h"

class CModerateMediaAssetsBuilder :
	public CXMLBuilder
{
public:
	CModerateMediaAssetsBuilder( CInputContext& InputContext);
	~CModerateMediaAssetsBuilder(void);

	bool Build( CWholePage*);
private:
	bool Process(CWholePage* pPage, CUser* pViewer);
	bool SendEmail( int iModID, int iAssetID, int iStatus, int iSiteID, CTDVString sNotes, CTDVString sCustomText, CTDVString sEmailType, CTDVString sAuthorsEmail, CTDVString sComplainantsEmail );
	bool SendMailOrSystemMessage( int iModID, int iAssetID, int iStatus, int iSiteID, CTDVString sNotes, CTDVString sCustomText, CTDVString sEmailType, CTDVString sAuthorsEmail, CTDVString sComplainantsEmail, int iAuthorID = 0, int iComplainantID = 0  );
};

class CModerateMediaAssets : public CXMLObject
{
public:
	CModerateMediaAssets( CInputContext& InputContext ) : CXMLObject(InputContext) {}
	bool GetAssets( int iUserID, bool bAlerts, bool bReferrals, bool bLocked, bool bHeld, int iShow );
	bool Update(int iModID, int iSiteID, int iUserID, int iStatus, int iReferTo, 
				const CTDVString& sNotes, CTDVString& sAuthorsEmail, CTDVString& sComplainantsEmail, int& iAuthorID, int& iComplainantID);
	bool UpdateOnArticleModID(int iArticleModID, int iUserID, int iStatus, int iReferTo,
		const CTDVString& sNotes, CTDVString& sAuthorsEmail, CTDVString& sComplainantsEmail);

};
