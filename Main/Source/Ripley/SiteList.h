// SiteList.h: interface for the CSiteList class.
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


#if !defined(AFX_SITELIST_H__0514AE0E_1E24_4971_A9AD_C105DDBF58F6__INCLUDED_)
#define AFX_SITELIST_H__0514AE0E_1E24_4971_A9AD_C105DDBF58F6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "SiteData.h"

class CSiteData;

#pragma warning(disable:4786)
#include <map>

using namespace std ;

typedef map<CTDVString, CSiteData*> SITENAMEMAP;
typedef map<int, CSiteData*> SITENUMMAP;

class CSiteList  
{
public:
	CSiteList();
	virtual ~CSiteList();

public:
	bool GetIsSiteUnmoderated(int iSiteID);
	bool GetNoAutoSwitch(int iSiteID);
	bool GetIsSitePassworded(int iSiteID);
	int  GetReviewForumID(int iSiteID, const TDVCHAR* pForumName);
	bool DoesSiteUseArticleGuestBookForums(int iSiteID);
	bool DoesArticleExist(int iSiteID, const TDVCHAR* pArticleName);
	bool AddReviewForum(int iSiteID, const TDVCHAR* pForumName, int iForumID);
	bool AddArticle(int iSiteID, const TDVCHAR* pArticleName);
	bool GetSkinUseFrames(int iSiteID, const TDVCHAR* pSkinName);
	bool GetAsXMLString(CTDVString* oXML, int iMode);
	bool GetSiteAsXMLString(int iSiteID, CTDVString& sXML, int iMode);
	bool GetNameOfSite(int iSiteID, CTDVString* oName);
	bool GetSSOService(int iSiteID, CTDVString* pSSOService);
	int  GetSiteID(const TDVCHAR* pSiteName);
	bool GetEmail(int iSiteID, int iEmailType, CTDVString& sEmail);
	bool GetShortName(int iSiteID, CTDVString& sShortName);
	int GetAutoMessageUserID(int iSiteID);
	
	bool GetSiteDetails(int iSiteID, CTDVString* oSiteName, bool* pbPreMod, 
						CTDVString* oSkin, bool* bNoAutoSwitch, 
						CTDVString* oDescription, CTDVString* oShortName, 
						CTDVString* psModeratorsEmail, CTDVString* psEditorsEmail,
						CTDVString* psFeedbackEmail,int *piAutoMessageUserID, bool* pbPassworded,
						bool* pbUnmoderated, bool* pbArticleGuestBookForums, CTDVString* psSiteConfig, int iThreadOrder,
						CTDVString* psEMailAlertSubject, int* piThreadEditTimeLimit, int* piEventAlertMessageUserID, int iAllowRemoveVote,
						int iIncludeCrumbtrail, int iAllowPostCodesInSearch, bool bSiteEmergencyClosed, CTDVString* pSSOService );

	bool GetSiteDetails(const TDVCHAR* pName, int* piSiteID, bool* pbPreModeration, 
						CTDVString* psDefaultSkin, bool* bNoAutoSwitch, 
						CTDVString* oDescription, CTDVString* oShortName,
						CTDVString* psModeratorsEmail, CTDVString* psEditorsEmail,
						CTDVString* psFeedbackEmail,int* piAutoMessageUserID, bool* pbPassworded,
						bool* pbUnmoderated, bool* pbArticleGuestBookForums, CTDVString* psSiteConfig, int *piThreadOrder,
						CTDVString* psEMailAlertSubject, int* piThreadEditTimeLimit, int* piEventAlertMessageUserID, int* piAllowRemoveVote, 
						int* piIncludeCrumbtrail, int* piAllowPostCodesInSearch, bool* pbQueuePostings, bool* pbSiteEmergencyClosed, CTDVString* pSSOService );
	bool Clear();

	bool SkinExistsInSite(int iSiteID, const TDVCHAR* pSkinName);
    bool GetSkinSet(int iSiteID, CTDVString* pSkinSet);

	bool AddSkinToSite(const TDVCHAR* pSiteName, const TDVCHAR* pSkinName, const TDVCHAR* pSkinDescription, bool bUseFrames);
	bool AddSiteDetails(const TDVCHAR* pName, int iSiteID, bool bPreModeration, 
						const TDVCHAR* pDefaultSkin, bool bNoAutoSwitch, 
						const TDVCHAR* pDescription, const TDVCHAR* pShortName,
						const TDVCHAR* psModeratorsEmail, const TDVCHAR* psEditorsEmail,
						const TDVCHAR* psFeedbackEmail,int iAutoMessageUserID, bool bPassworded,
						bool bUnmoderated, bool bArticleGuestBookForums,
						const TDVCHAR* psSiteConfig, int iThreadOrder,
						const TDVCHAR* psEMailAlertSubject,
						int iThreadEditTimeLimit, int iEventAlertMessageUserID, int iAllowRemoveVote, int iIncludeCrumbtrail, 
						int iAllowPostCodesInSearch, bool bQueuePostings, bool bSiteEmergencyClosed,
						int iMinAge, int iMaxAge, const TDVCHAR* pSSOService, bool bIsKidsSite, bool bUseIdentitySignIn,
						const TDVCHAR* pSkinSet, const TDVCHAR* psIdentityPolicy);
	const void Unlock();
	const void Lock();
	bool GetSiteEMailAlertSubject(int iSiteID, CTDVString& sEmailAlertSubject);
	bool GetEventAlertMessageUserID(int iSiteID, int& iUserID);

	bool GetTopicsXML(int iSiteID, CTDVString& sTopicsXML);
	bool SetTopicsXML(int iSiteID, const CTDVString& sTopicsXML);

	// Scheduling functions for sites
	bool AddSiteOpenCloseTime(int iSiteID, int iDayWeek, int iHour, int iMinute, int iClosed);
	bool GetSiteScheduleAsXMLString(int iSiteID, CTDVString& sXML);
	bool GetSiteScheduledClosed(int iSiteID, bool &bIsClosed);
	bool IsSiteEmergencyClosed(int iSiteID, bool &bIsClosed);
	bool SetSiteIsEmergencyClosed(int iSiteID, bool bEmergencyClosed);

	bool AddTopicForum(int iSiteId, int iForumID);
	bool IsForumATopic(int iSiteID, int iForumID);

	//CTDVString m_name;
	void SwapData(CSiteList& other);

	int GetSiteMinAge(int iSiteID);
	int GetSiteMaxAge(int iSiteID);

	void SetSiteMinMaxAge(int iSiteID, int minAge, int maxAge);

	void SetSiteUsesIdentitySignIn(int iSiteID, bool bUseIdentity);
	bool GetSiteUsesIdentitySignIn(int iSiteID);

	void SetSiteIdentityPolicy(int iSiteID, const TDVCHAR* psIdentityPolicy);
	CTDVString GetSiteIdentityPolicy(int iSiteID);

	void SetSiteIsKidsSite(int iSiteID, bool bIsKidsSite);
	bool GetSiteIsKidsSite(int iSiteID);

	int GetMaxSiteId();

	CTDVString GetSiteInfomationXML(int iSiteID, CGI* pCGI);

protected:
	//void Copy(CSiteList& other);

	SITENAMEMAP m_SiteMap;
	SITENUMMAP	m_SiteIDMap;
	CRITICAL_SECTION m_criticalsection;
	int m_MaxSiteId;
};

#endif // !defined(AFX_SITELIST_H__0514AE0E_1E24_4971_A9AD_C105DDBF58F6__INCLUDED_)
