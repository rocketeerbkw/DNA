// ReviewForum.h: interface for the CReviewForum class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_REVIEWFORUM_H__2DF3610F_A84A_11D5_87C1_00A024998768__INCLUDED_)
#define AFX_REVIEWFORUM_H__2DF3610F_A84A_11D5_87C1_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "xmlobject.h"
class CStoredProcedure;


class CReviewForum  : public CXMLObject
{
public:

	static enum OrderBy {DATEENTERED = 1,LASTPOSTED,AUTHORID,AUTHORNAME,H2G2ID,SUBJECT};

	CReviewForum(CInputContext& inputContext);
	virtual ~CReviewForum();
	bool InitialiseViaReviewForumID(int iReviewForumID,bool bAlwaysFromDB=false);
	bool InitialiseViaH2G2ID(int iH2G2ID,bool bAlwaysFromDB=false);
	bool InitialiseFromData(int iReviewForumID,const TDVCHAR* sForumName, const TDVCHAR* sURLFriendlyName, int iIncubateTime, bool bRecommend,int iH2G2ID, int iSiteID);
	bool GetReviewForumThreadList(int iNumThreads, int iNumSkipped, OrderBy eOrderBy, bool bAscending);	
	int GetSiteID() const;
	int GetH2G2ID() const;
	int GetReviewForumID() const;
	int GetIncubateTime() const;
	bool IsRecommendable() const;
	bool IsInitialised() const;
	const CTDVString& GetReviewForumName() const;
	const CTDVString& GetURLFriendlyName() const;
	bool CReviewForum::GetAsXMLString(CTDVString& sResult) const;
	const CTDVString& GetError();
	bool Update(const TDVCHAR* sName,const TDVCHAR* sURL,bool bRecommendable, int iIncubateTime);
	bool CreateAndInitialiseNewReviewForum(const TDVCHAR* sForumName, const TDVCHAR* sURLFriendlyName, int iIncubateTime, bool bRecommend,int iSiteID, int iUserID);
	bool AreNamesUniqueWithinSite(const TDVCHAR* sName,const TDVCHAR* sURL,int iSiteID,bool* bUnique);

protected:
	bool Initialise(int iID,bool bIDIsReviewForumID, bool bAlwaysFromDB=false);
	
	bool GetReviewForumThreadsFromDatabase(CStoredProcedure& mSP,int iReviewForumID,OrderBy eOrderBy, bool bAscending);
	bool GracefulError(const TDVCHAR* pOuterTag,const TDVCHAR* pErrorType,const TDVCHAR* pErrorText = NULL,
										   const TDVCHAR* pLinkHref = NULL,const TDVCHAR* pLinkBody = NULL);

	void SetError(const TDVCHAR* pErrorText);

protected:

	bool m_bInitialised;
	bool m_bRecommend;
	int m_iReviewForumID;
	int m_iH2G2ID;
	int m_iSiteID;
	int m_iIncubateTime;
	CTDVString m_sReviewForumName;
	CTDVString m_sURLFriendlyName;
	CTDVString m_sErrorText;


};

#endif // !defined(AFX_REVIEWFORUM_H__2DF3610F_A84A_11D5_87C1_00A024998768__INCLUDED_)
