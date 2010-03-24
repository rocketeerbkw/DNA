// SiteData.h: interface for the CSiteData class.
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


#if !defined(AFX_SITEDATA_H__DEAD0152_AE4D_4FA7_A855_C723BA870914__INCLUDED_)
#define AFX_SITEDATA_H__DEAD0152_AE4D_4FA7_A855_C723BA870914__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "SkinDetails.h"
#include "SiteOpenCloseTime.h"
#include "TDVDateTime.h"
#include "CGI.h"

#pragma warning(disable:4786)
#include <map>
#include <vector>

using namespace std ;
typedef map<CTDVString, CSkinDetails*> SKINMAP;
typedef map<CTDVString, int> FORUMMAP;
typedef map<CTDVString, int> ARTICLEMAP;

typedef vector<CSiteOpenCloseTime> OPENCLOSETIMES;
typedef vector<int> TOPICFORUMS;

#define EMAIL_MODERATORS	0
#define EMAIL_EDITORS		1
#define EMAIL_FEEDBACK		2

class CSiteData  
{
public:
	bool IsSiteUnmoderated();
	bool IsSitePassworded();
	bool DoesSiteUseArticleGuestBookForums();
	int GetAutoMessageUserID() const;
	bool DoesArticleExist(const TDVCHAR* pName);
	int GetReviewForumID(const TDVCHAR* pName);
	bool AddReviewForum(const TDVCHAR* pForumName, int iForumID);
	bool AddArticle(const TDVCHAR* pName);
	bool GetSkinUseFrames(const TDVCHAR* pSkinName);
	bool GetShortName(CTDVString* oName);
	bool GetDescription(CTDVString* oDescription);
	bool GetAsXMLString(CTDVString* oXML, int iMode = 1);

	bool GetNoAutoSwitch();
	bool GetSiteName( CTDVString* pName );
	bool GetSSOService( CTDVString* pSSOService );

	bool SkinExists(const TDVCHAR* pSkinName);

	bool AddSkin(const TDVCHAR* pSkinName, const TDVCHAR* pSkinDescription, bool bUseFrames);
	bool GetDefaultSkin(CTDVString* oName);
	bool GetPreModeration();
	bool GetEmail(int iEmailType, CTDVString& pEmail) const;
	void GetSiteDetails( int* piSiteID, CTDVString* psSiteName, bool *pbPreMod, 
						CTDVString* psSkin, bool* pbNoAutoSwitch, 
						CTDVString* psDescription, CTDVString* psShortName, 
						CTDVString* psModeratorsEmail,
						CTDVString* psEditorsEmail, CTDVString* psFeedbackEmail,
						int* piAutoMessageUserID, bool* pbPassworded, bool *pbUnmoderated, bool* pbArticleGuestBookForums,
						CTDVString* psSiteConfig, int* piThreadOrder, CTDVString* psEMailAlertSubject, int* piThreadEditTimeLimit,
						int* piEventAlertMessageUserID, int* piAllowRemoveVote, int* piIncludeCrumbtrails, int* piAllowPostCodesInSearch,
						bool* pbQueuePostings, bool* pbSiteEmergencyClosed, CTDVString* psSSOService );

	int GetSiteID();
	int GetAllowRemoveVote();
	int GetIncludeCrumbtrail();
	int GetAllowPostCodesInSearch();
	int GetThreadOrder();
	int GetThreadEditTimeLimit();
	bool GetSiteConfig(CTDVString* psSiteConfig);
	CSiteData(const TDVCHAR* pSiteName, int iSiteID, int iThreadOrder, bool bPreModeration, 
		const TDVCHAR* pDefaultSkin, bool bNoAutoSwitch, const TDVCHAR* pDescription, 
		const TDVCHAR* pShortName, const TDVCHAR* pModeratorsEmail,
		const TDVCHAR* pEditorsEmail, const TDVCHAR* pFeedbackEmail,int iAutoMessageUserID,
		bool bPassworded, bool bUnmoderated, bool bArticleGuestBookForums, const TDVCHAR* pSiteConfig, const TDVCHAR* psEMailAlertSubject,
		int iThreadEditTimeLimit, int iEventAlertMessageUserID, int iAllowRemoveVote, int iIncludeCrumbtrail, int iAllowPostCodeInSearch,
		bool bQueuePostings, bool bSiteEmergencyClosed, int iMinAge, int iMaxAge, const TDVCHAR* pSSOService,
		bool bIsKidsSite, bool bUseIdentitySignIn, const TDVCHAR* pSkinSet, const TDVCHAR* psIdentityPolicy );
	virtual ~CSiteData();
	const CSiteData& operator=(const CSiteData& Other);
	CSiteData(const CSiteData& Other);
	bool GetEMailAlertSubject(CTDVString& sEmailAlertSubject);
	int GetEventAlertMessageUserID();

	bool GetTopicsXML(CTDVString* psSource) const;
	bool SetTopicsXML(const CTDVString* psTopicsXML);

	bool GetQueuePostings();

	// Site open / closed schedule fucntions
	bool AddSiteOpenCloseTime(int iDayWeek, int iHour, int iMinute, int iClosed);
	bool GetSiteScheduledClosed(CTDVDateTime dDate);
	bool GetSiteScheduleAsXMLString(CTDVString& sXML);
	bool IsSiteEmergencyClosed();
	void SetSiteEmergencyClosed(bool bEmergencyClosed);

	bool AddTopicForum(int iForumID);
	bool IsForumATopic(int iForumID);

	int GetMinAge();
	int GetMaxAge();
	void SetMinMaxAge(int minAge, int maxAge);

	bool GetIsKidsSite();
	void SetIsKidsSite(bool bIsKidsSite);

	bool GetUseIdentitySignIn();
	void SetUseIdentitySignIn(bool bUseIdentity);

	void SetSiteIdentityPolicy(const TDVCHAR* psIdentityPolicy);
	CTDVString GetSiteIdentityPolicy();

	bool GetSkinSet(CTDVString* pSkinSet);

	CTDVString GetSiteInfomationXML(CGI* pCGI);

protected:
	CTDVString m_SiteName;
	CTDVString m_SSOService;
	int m_SiteID;
	int m_ThreadOrder;
	int m_AllowRemoveVote;
	int m_IncludeCrumbtrail; 
	int m_AllowPostCodesInSearch;
	int m_ThreadEditTimeLimit;
	bool m_bPreModeration;
	CTDVString m_DefaultSkin;
	SKINMAP m_SkinMap;
	FORUMMAP m_ForumMap;
	ARTICLEMAP m_ArticleMap;
	OPENCLOSETIMES m_OpenCloseTimes;
	TOPICFORUMS m_TopicForums; 
	bool m_bNoAutoSwitch;
	CTDVString m_Description;
	CTDVString m_ShortName;
	CTDVString m_EditorsEmail;
	CTDVString m_ModeratorsEmail;
	CTDVString m_FeedbackEmail;
	int m_AutoMessageUserID;
	bool m_bPassworded;
	bool m_bUnmoderated;
	bool m_bArticleGuestBookForums;
	CTDVString m_sSiteConfig;
	CTDVString m_sEMailAlertSubject;
	int m_iEventAlertMessageUserID;
	bool m_bQueuePostings;
	bool m_bSiteEmergencyClosed;
	int m_iMinAge;
	int m_iMaxAge;
	bool m_bIsKidsSite;
	bool m_bUseIdentitySignIn;
	CTDVString m_sIdentityPolicy;
	CTDVString m_SkinSet;
	CTDVString	m_sTopicsXML;
};

#endif // !defined(AFX_SITEDATA_H__DEAD0152_AE4D_4FA7_A855_C723BA870914__INCLUDED_)
