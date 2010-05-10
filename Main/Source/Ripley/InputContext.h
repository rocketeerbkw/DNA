// InputContext.h: interface for the CInputContext class.
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


#if !defined(AFX_INPUTCONTEXT_H__98589424_E605_11D3_89EB_00104BF83D2F__INCLUDED_)
#define AFX_INPUTCONTEXT_H__98589424_E605_11D3_89EB_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"

class CUser;
class CGI;
class CProfileConnection;
class CTDVDateTime;
class CStoredProcedure;
class CStoredProcedureBase;
class CRipleyStatistics;
class CSiteOptions;

class CInputContext
{
	public:
		CInputContext();
		virtual ~CInputContext();
		void SetCgi(CGI* pCGI);
		bool Initialised() { return m_pCGI != NULL; }

		bool GetNamedSectionMetadata(const char* pName, int& iLength, CTDVString& sMime);
		bool IsUserAllowedInPasswordedSite(int* pReason = NULL);
		void LogTimerEvent(const TDVCHAR* pMessage);
        void WriteInputLog( CTDVString type, CTDVString message);
		bool IsSitePassworded(int iSiteID);
		bool IsSiteUnmoderated(int iSiteID = 0);
		bool IsCurrentSiteMessageboard();
		bool IsCurrentSiteEmailAddressFiltered();
		bool IsSystemMessagesOn(int ipSiteID);
		bool DoesSiteUseArticleGuestBookForums(int iSiteID);
		bool DoesSiteHaveDistressMsgUserId( int iSiteId, int& iUserId );
		int GetDefaultShow( int iSiteId );
		bool IncludeUsersGuideEntryInPersonalSpace();
		bool IncludeUsersGuideEntryForumInPersonalSpace();
		bool IncludeJournalInPersonalSpace();
		bool IncludeRecentPostsInPersonalSpace();
		bool IncludeRecentGuideEntriesInPersonalSpace();
		bool IncludeUploadsInPersonalSpace();
		bool IncludeWatchInfoInPersonalSpace();
		bool IncludeClubsInPersonalSpace();
		bool IncludePrivateForumsInPersonalSpace();
		bool IncludeLinksInPersonalSpace();
		bool IncludeTaggedNodesInPersonalSpace();
		bool IncludePostcoderInPersonalSpace();
		bool IncludeNoticeboardInPersonalSpace();
		bool IncludeSiteOptionsInPersonalSpace();
		bool IncludeRecentCommentsInPersonalSpace();
		bool IncludeRecentArticlesOfSubscribedToUsersInPersonalSpace();

		bool CanUserMoveToSite(int iCurrentSiteID, int iNewSiteID);
		bool GetUserName(CTDVString* oName);
		int GetAutoMessageUserID(int iSiteID = -1);
		int GetReviewForumID(int iSiteID, const TDVCHAR* pForumName);
		bool DoesKeyArticleExist(int iSiteID, const TDVCHAR* pArticleName);
		bool DoesSkinExistInSite(int iSiteID, const TDVCHAR* pSkinName);
		bool DoesCurrentSkinUseFrames();
		bool SaveUploadedSkin(const TDVCHAR* pSkinName, const TDVCHAR* pFileName, const TDVCHAR* pParamName, bool bCreateNew, CTDVString* oErrors);
		bool SetSkin(const TDVCHAR* pSkin);
		bool Signal(const TDVCHAR* pURL);
		void SiteDataUpdated();
		void GroupDataUpdated();
		void UserGroupDataUpdated(int iUserID);
		bool MakeCUDRequest(const TDVCHAR* pRequest, CTDVString* oResponse);
		bool GetSiteListAsXML(CTDVString *oXML, int iMode = 1);
		CTDVString GetSiteAsXML(int iSiteID, int iMode = 1);
		bool GetNameOfSite(int iSiteID, CTDVString* oName);
		CTDVString GetNameOfCurrentSite();
		bool GetNoAutoSwitch();
		int GetSiteID();
		int GetModClassID();
		int GetSiteID(const TDVCHAR* pName);
		int GetThreadOrder();
		int GetAllowRemoveVote();
		int GetAllowPostCodesInSearch();
		int GetIncludeCrumbtrail();
		bool IsSiteClosed(int iSiteID, bool &bEmergencyClosed);
		bool SetSiteIsEmergencyClosed(int iSiteID, bool bEmergencyClosed);
		bool IsSiteEmergencyClosed(int iSiteID, bool &bEmergencyClosed);
		bool IsForumATopic(int m_SiteID, int iForumID);
		bool GetSiteScheduleAsXMLString(int iSiteID, CTDVString& sXML);
		int GetThreadEditTimeLimit();
		void GetSiteConfig(CTDVString& sSiteConfig);
		void SetSiteConfig(const TDVCHAR* pSiteConfig);
		void GetTopics(CTDVString& sTopics);
		bool ChangeSite(int iSiteID);
		bool GetPreModerationState();
		bool GetSkin(CTDVString* oSkinName);
        bool GetSkinSet(CTDVString* pSkinSet);
		bool SendMail(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks = false);
		bool SendMailOrSystemMessage(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks = false, int piUserID = 0, int piSiteID = 0);
		bool SendDNASystemMessage(int piUserID, int piSiteID, const TDVCHAR* pBody);
		bool GetSiteRootURL(int iSiteID, CTDVString& sSiteRootURL);
		bool GetParsingErrors(const TDVCHAR *pText, CTDVString *pErrorString, CTDVString *pErrorLine, int *piLineNo, int *piCharNo);
		bool GetDomainName(CTDVString& sResult);
		bool GetStylesheetHomePath(CTDVString& sResult);
		bool GetHomePath(CTDVString& sResult);
		bool GetRipleyServerPath(CTDVString& sResult);
		bool GetCommand(CTDVString& sResult);
		bool GetDefaultSkin(CTDVString& sSkinName);	
		bool GetShortName(CTDVString& sShortName, int iSiteID = -1);
		bool GetEmail(int iEmailType, CTDVString& sEmail, int iSiteID = -1);
		bool GetParamString(const TDVCHAR* pName, CTDVString& sResult, int iIndex = 0, bool bPrefix = false, CTDVString* pParamName = NULL);
		int GetParamInt(const TDVCHAR* pName, int iIndex = 0);
		bool GetParamFile(const TDVCHAR* pName, int iAvailableLength, 
			char* pBuffer, int& iLength, CTDVString& sMime);
		bool ParamExists(const TDVCHAR* pName, int iIndex = 0);
		int GetParamCount(const TDVCHAR* pName = NULL);
		CUser* GetCurrentUser();
		CUser* GetSignedinUser(); 
		bool GetClientAddr(CTDVString& result);
		CProfileConnection* GetProfileConnection();
		bool GetCookieByName(const TDVCHAR* pCookieName, CTDVString& sCookieValue);
		static const char* GetMimeExtension(const char* pMime);
		// Is In Fast Builder Mode Function.
		bool GetIsInFastBuilderMode();

		// Is in preview mode?
		bool GetIsInPreviewMode();
		bool GetTimeTransform();
		bool RefreshProfanityList();
		bool GetBBCUIDFromCookie(CTDVString& sBBCUID);
		CTDVString GetBBCUIDFromCookie();
		bool PostcoderPlaceRequest(const TDVCHAR *pPlaceName, CTDVString &oResult);
		bool PostcoderPlaceCookieRequest(const TDVCHAR *pPlaceName, CTDVString &oResult);
		bool ConvertPlainText(CTDVString* oResult, int MaxSmileyCount = 0);
		bool CachePutItem(const TDVCHAR* pCacheName, const TDVCHAR* pItemName, const TDVCHAR* pText);
		bool CacheGetItem(const TDVCHAR* pCacheName, const TDVCHAR* pItemName, CTDVDateTime* pdExpires, CTDVString* oXMLText);
		CStoredProcedure* CreateStoredProcedureObject();
		bool InitialiseStoredProcedureObject(CStoredProcedure* pSP);
		bool InitialiseStoredProcedureObject(CStoredProcedureBase& sp);
		bool GetParamsAsString(CTDVString& sResult, const TDVCHAR* pPrefix = NULL);
		bool GetParamsAsXML(CTDVString* pResult,const TDVCHAR* pPrefix);
		void GetQueryHash(CTDVString& sHash);
		bool IsUsersEMailVerified(bool& bVerified);
		bool GetSitesEMailAlertSubject(int iSiteID, CTDVString& sEmailSubject);
		bool GetEventAlertMessageUserID(int iSiteID, int& iUserID);

		bool RefreshTopicLists(int iSiteID);

		bool GetUserGroups(CTDVString &sXML, int nUserID, int nSiteID = 0);
		bool GetDynamicLists(CTDVString &sXML, int nSiteID);
		void CInputContext::DynamicListsDataUpdated();

		CTDVString GetRipleyServerInfoXML();
		CRipleyStatistics* GetStatistics();

		bool GetParamFilePointer(const TDVCHAR* pName,	const char** pBuffer, int& iLength, CTDVString& sMime, CTDVString *sFilename=NULL);
		CTDVString GetIPAddress();

		bool GetFeedsCacheName(CTDVString& sFeedsCacheName, CTDVString& sFeedsCacheItemName);
		bool GetRequestFeedCacheFolderName(CTDVString& sFeedsCacheFolderName);
		bool GetRequestFeedCacheFileSuffix(CTDVString& sFeedsCacheFileSuffix);
		bool IsRequestForCachedFeed();
		bool IsRequestForRssFeed();
		bool IsRequestForSsiFeed();

		bool IsRequestSecure( );

		CSiteOptions* GetSiteOptions();

		CTDVString GetServerName(CTDVString* oServerName);

		bool IsCurrentSiteURLFiltered();
		bool RefreshAllowedURLList();
		bool const GetAllowedURLList(int iSiteID, CTDVString& AllowedURLList);

		bool DoesCurrentSiteAllowedMAExternalLinks();

		bool DoesSiteUsePreModPosting(int piSiteID);

		bool IsModerationSite(int iSiteID);

		bool DoesCurrentSiteAllowOwnerHiding();
		bool DoesSiteAllowOwnerHiding(int iSiteID);

		bool DoesCurrentSiteHaveSiteOptionSet(const TDVCHAR* pSection, const TDVCHAR* pName);
		CTDVString GetCurrentSiteOptionString(const TDVCHAR* pSection, const TDVCHAR* pName);
		int GetCurrentSiteOptionInt(const TDVCHAR* pSection, const TDVCHAR* pName);

		int GetSiteMinAge(int iSiteID);
		int GetSiteMaxAge(int iSiteID);

		bool IsDateRangeInclusive(int iSiteID);

protected:
		CGI* m_pCGI;

public:
	//theConfig functions wrapper

	const char* GetMediaAssetFtpServer() const ;
	const char* GetMediaAssetFtpUser() const ;
	const char* GetMediaAssetFtpPassword() const ;
	const char* GetMediaAssetFtpHomeDirectory() const ;
	const char* GetMediaAssetUploadQueueLocalDir() const ;
	const char* GetMediaAssetUploadQueueTmpLocalDir() const ;

	const char* GetPostcoderCookieName() const ;
	const char* GetPostcoderCookiePostcodeKey() const ;

	const char* GetImageLibraryPreviewImage() const ;
	int GetImageLibraryMaxUploadBytes() const ; 
	const char* GetImageLibraryFtpServer() const ; 
	const char* GetImageLibraryFtpUser() const ; 
	const char* GetImageLibraryFtpPassword() const ; 
	const char* GetImageLibraryFtpRaw() const ;
	const char* GetImageLibraryFtpPublic() const ;
	const char* GetImageLibraryAwaitingModeration() const; 
	const char* GetImageLibraryFailedModeration() const ;
	const char* GetImageLibraryTmpLocalDir() const ;
	const char* GetImageLibraryPublicUrlBase() const ; 
	const char* GetImageLibraryRawUrlBase() const ;
	const char* GetSiteRoot() const ; 

	bool GetSiteUsesIdentitySignIn(int iSiteID);
};

#endif // !defined(AFX_INPUTCONTEXT_H__98589424_E605_11D3_89EB_00104BF83D2F__INCLUDED_)
