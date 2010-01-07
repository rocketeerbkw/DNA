// Notice.h: interface for the CNotice class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_NOTICE_H__E5F8F5F4_2325_469C_8D8B_9B67EBC6949C__INCLUDED_)
#define AFX_NOTICE_H__E5F8F5F4_2325_469C_8D8B_9B67EBC6949C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "User.h"

class CNotice : public CXMLObject  
{
public:
	CNotice(CInputContext& inputContext);
	virtual ~CNotice();

	enum
	{
		PR_REQUESTOK,
		PR_REQUESTTIMEOUT,
		PR_POSTCODENOTFOUND
	};

public:
	bool GetVoteIDForNotice(int iThreadID, int& iVoteID);
	bool GetNoticeBoardForNode(int iNodeID, int iSiteID, bool bIncludeNotices = true);
	bool GetLocalNoticeBoardForPostCode(CTDVString& sPostCodeToFind, int iSiteID, CTDVString &sXML, CTDVString& sPostCoderXML);
	bool GetLocalNoticeBoardForUser(CUser* pUser, int iSiteID, bool bUsersPostsOnly, CTDVString& sXML);
	bool CreateNewCachePage(int iNodeID, int iSiteID, CTDVString& sXML);
	bool CheckAndCreateFromCachedPage(int iNodeID, int iForumID, int iSiteID, CTDVString& sXML);
	int  GetDetailsForPostCodeArea(CTDVString &sPlace, int iSiteID, int& iNodeID, CTDVString& sPostCode, CTDVString& sPostCodeXML);
	bool GetFutureEventsForNode(int iNodeID, int iForumID, int iSiteID, CTDVString& sXML, int iPostForUserID = 0);
	bool GetForumDetailsForNodeID(int iNodeID, int iSiteID, int &iForumID, CTDVString* pForumName = NULL);
	
	bool GetNoticeBoardPosts(int iForumID, int iSiteID, CTDVString& sXML, int iPostForUserID = 0);

	bool GetNodeIDFromThreadID(int iThreadID, int iSiteID, int& iNodeID);
	bool CreateNewNotice(int iNodeID, int iSiteID, CUser* pUser, CTDVString& sType, CTDVString& sTitle, CTDVString& sBody, CTDVString& sEventDate, CDNAIntArray& TagNodeArray, int& iThreadID, bool* pbProfanityFound = NULL, bool* pbNonAllowedURLsFound = NULL, bool* pbEmailAddressFound = NULL );
	bool EditNotice(int iPostID, int iTHreadId, int iForumId, CTDVString sType,  CUser* pUser, CTDVString &sTitle, CTDVString &sBody, CTDVString& sEventDate, bool& bProfanityFound, bool& bNonAllowedURLsFound, bool& bEmailAddressFound );

	bool GetNumberOfSupportersForNotice(int iThreadID,int& iVoteID,int& iVisible, int& iHidden);
	bool GetNoticeFromThreadID(int iThreadID, int iForumID, CTDVString& sXML);

	void GetNoticeThreadID(int& iThreadID)						{ iThreadID = m_iThreadID; }
	void GetNoticePostID( int& iPostID)							{ iPostID = m_iPostID; }
	void GetNoticeType(CTDVString& sType)						{ sType = m_sType; }
	void GetNoticeUserID(int& iUserID)							{ iUserID = m_iUserID; }
	void GetNoticeTitle(CTDVString& sTitle)						{ sTitle = m_sTitle; }
	void GetNoticeBodyText(CTDVString& sBody)					{ sBody = m_sBody; }
	void GetNoticePostedDate(CTDVDateTime& tPostedDate)			{ tPostedDate = m_tPostedDate; }
	void GetNoticeEventDate(CTDVDateTime& tEventDate)			{ tEventDate = m_tEventDate; }
	void GetNoticeHiddenSupportsCount(int& iHiddenSupporters)	{ iHiddenSupporters = m_iHiddenSupporters; }
	void GetNoticeVisibleSupportsCount(int& iVisibleSupporters) { iVisibleSupporters = m_iVisibleSupporters; }
	void GetNoticeVoteID(int& iVoteID)							{ m_iVoteID = m_iVoteID; }

	bool Initialise( CStoredProcedure& SP, CTDVString& sXML);

protected:
	int m_iThreadID;
	CTDVString m_sType;
	int m_iUserID;
	CTDVString m_sTitle;
	CTDVString m_sBody;
	CTDVDateTime m_tPostedDate;
	CTDVDateTime m_tEventDate;
	int m_iHiddenSupporters;
	int m_iVisibleSupporters;
	int m_iVoteID;
	int m_iPostID;
	int m_iUserTaxNode;
	int m_iForumID;
	CTDVString m_sTaxNodeName;
	CTDVString m_sUsersPostCode;
	CTDVString m_sUserName;

private:
	bool CreateActionXML(CTDVString sAction, int iThreadID, int iForumID, const TDVCHAR* psNoticeType);
};

#endif // !defined(AFX_NOTICE_H__E5F8F5F4_2325_469C_8D8B_9B67EBC6949C__INCLUDED_)
