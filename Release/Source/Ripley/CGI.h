// CGI.h: interface for the CGI class.
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


#if !defined(AFX_CGI_H__03E3D46A_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
#define AFX_CGI_H__03E3D46A_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_

#include "TDVString.h"
#include "XMLTree.h"
#include "InputContext.h"	// Added by ClassView
#include "OutputContext.h"
#include "StoredProcedure.h"
#include "User.h"
#include "SmileyTranslator.h"
#include "SmileyList.h"
#include "SiteList.h"	// Added by ClassView
#include "ProfileConnectionPool.h"
#include "ProfileConnection.h"
#include "UserGroups.h"
#include "RipleyStatistics.h"
#include "Config.h"
#include "SkinSelector.h"

class CStoredProcedureBase;
class CDynamicLists;
class CSiteOptions;

#pragma warning(disable:4786)
#include <map>
#include <vector>
#include <utility>

#include "XMLCookie.h"

#include "httpext.h"

using namespace std ;

class CMimeExt;



typedef map<CTDVString, CTDVString> VARIABLEMAP;
typedef vector<CTDVString> STRINGVECTOR;

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/*
	class CGI  
	
	Author:		Jim Lynn
	Created:	18/02/2000
	Inherits:	none
	Purpose:	Hides the platform-specific IO provided by the server. From this
				object you can get either an Input context or an output context
				object, which you use to read from and write to the server. This
				lets us specialise both the input and output without each needing
				to know how.

*/

class CGI  
{
	friend class CStoredProcedureBase;

public:
	CGI();
	CGI(const CGI& other);
	virtual ~CGI();

	bool Initialise(EXTENSION_CONTROL_BLOCK* pECB, const TDVCHAR* pszQuery, LPTSTR pszCommand);
	bool InitUser();  // Call after Initialise()

public:
	bool IsUserAllowedInPasswordedSite(int* pReason = NULL);
	bool RefreshProfanityList();
	bool RefreshProfanityList(CSiteList* pSiteList);
	bool RefreshTopics();
	bool RefreshTopics(CSiteList* pSiteList);
	bool GetBBCUIDFromCookie(CTDVString& sBBCUID);
	CTDVString GetBBCUIDFromCookie();
	bool DecryptAndValidateBBCUID(CTDVString& sCookie, CTDVString& sUID);
	void SwitchTimers(bool bNewState);
	bool LogTimerEvent(const TDVCHAR* pMessage);
	bool CanUserMoveToSite(int iCurrentSiteID, int iNewSiteID);
	static bool ConvertPlainText(CTDVString* oResult, int MaxSmileyCount = 0);
	bool GetSiteListAsXML(CTDVString* oXML, int iMode = 1);
	CTDVString GetSiteAsXML(int iSiteID, int iMode = 1);
	bool GetNameOfSite(int iSiteID, CTDVString* oName);
	bool GetSiteSSOService(int iSiteID, CTDVString* psSSOService);
	CTDVString GetNameOfCurrentSite();
	bool GetNoAutoSwitch();
	int GetSiteID();
	int GetSiteID(const TDVCHAR* pName);
	int GetThreadOrder();
	int GetAllowRemoveVote();
	int GetIncludeCrumbtrail();
	int GetAllowPostCodesInSearch();
	bool IsForumATopic(int iSiteID, int iForumID);
	int GetThreadEditTimeLimit();
	int GetModClassID();
	bool ChangeSite(int iSiteID);
	bool GetPreModerationState();
	bool TestSetServerVariable(const TDVCHAR* pName, const TDVCHAR* pValue);
	bool GetSkin(CTDVString* oSkinName);
    bool GetSkinSet(CTDVString* pSkinSet);
	bool InitialiseFromDatabase(bool bCreateNewSiteList = true);
	bool StartInputLog();
	bool SendMail(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks = false);
	bool SendMailOrSystemMessage(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks = false, int piUserID = 0, int piSiteID = 0);
	bool SendDNASystemMessage(int piSendToUserID, int piSiteID, const TDVCHAR* psMessageBody);
	virtual bool InitialiseStoredProcedureObject(CStoredProcedure* pSP);
	bool InitialiseStoredProcedureObject(CStoredProcedureBase& sp);
	static bool LoadSmileyList(const TDVCHAR* sSmileyListFile);
	static CSmileyList* GetSmileyList();

	bool GetParamsAsXML(CTDVString* oResult,const TDVCHAR* pPrefix);
	bool GetParamsAsString(CTDVString& sResult, const TDVCHAR* pPrefix = NULL);
	void GetQueryHash(CTDVString& sHash);
	bool GetSiteRootURL(int iSiteID, CTDVString& sSiteRootURL);
	void SetHeader(const TDVCHAR* pHeader);
	bool GetServerName(CTDVString* oServerName);
	bool CachePutItem(const TDVCHAR* pCacheName, const TDVCHAR* pItemName, const TDVCHAR* pText);
	bool CacheGetItem(const TDVCHAR* pCacheName, const TDVCHAR* pItemName, CTDVDateTime* pdExpires, CTDVString* oXMLText, bool bIncInStats = true);
	bool GetParsingErrors(const TDVCHAR *pText, CTDVString *pErrorString, CTDVString *pErrorLine, int *piLineNo, int *piCharNo);
	bool SendRedirect(const TDVCHAR* pLocation);
	bool SendAbsoluteRedirect(const TDVCHAR* pLocation);
	bool SendRedirectWithCookies(const TDVCHAR* pLocation, CXMLCookie::CXMLCookieList oCookieList);
	void ClearCookie();
	void SetCookie(const TDVCHAR* pCookie, bool bMemoryCookie = false, const TDVCHAR* pCookieName = NULL, const TDVCHAR* pCookieDomain = NULL);	
	void UnEscapeString(CTDVString* pString);
	void SetMimeType(const TDVCHAR* pType);
	bool GetStylesheetHomePath(CTDVString& sResult);
	bool GetHomePath(CTDVString& sResult);
	bool GetRipleyServerPath(CTDVString& sResult);
	bool GetDomainName(CTDVString& sResult);
	bool GetClientAddr(CTDVString& sResult);
	bool GetDefaultSkin(CTDVString& sSkinName);
	bool GetShortName(CTDVString& sShortName, int iSiteID = -1);
	int GetAutoMessageUserID(int iSiteID = -1);
	bool GetEmail(int iEmailType, CTDVString& sEmail, int iSiteID = -1);
	bool InitialiseWithConfig();
	bool GetCommand(CTDVString& sResult);
	virtual CStoredProcedure* CreateStoredProcedureObject();
	COutputContext* GetOutputContext();
	CInputContext& GetInputContext();
	CProfileConnection* GetProfileConnection();
	CUser* GetCurrentUser();
	CUser* GetCurrentLoggedInUser();
	bool CreateCurrentUser();
	bool GetParamString(const TDVCHAR* pName, CTDVString& sResult, int iIndex = 0, bool bPrefix = false, CTDVString* pParamName = NULL);
	int GetParamInt(const TDVCHAR* pName, int iIndex = 0);
	bool GetParamFile(const TDVCHAR* pName, int iAvailableLength, 
		char* pBuffer, int& iLength, CTDVString& sMime);
	bool ParamExists(const TDVCHAR* pName, int iIndex = 0);
	int GetParamCount(const TDVCHAR* pName = NULL);
	void SendOutput(const TDVCHAR *pString);
	bool SendPicture(const TDVCHAR* sServerName, const TDVCHAR* sPath, const TDVCHAR* sMimeType);
	void WriteInputLog(const TDVCHAR* pString);
	//static const TDVCHAR* const GetProfanties() { return m_sProfanities; }
	static bool const GetProfanities(int iModClassID, std::pair<CTDVString, CTDVString>& profanityLists);
	bool GetCookieByName(const TDVCHAR* pCookieName, CTDVString& sCookieValue);
	CTDVString GetIPAddress();
	bool IsDatabaseInitialised();

	bool GetParamFilePointer(const TDVCHAR* pName,	const char** pBuffer, int& iLength, CTDVString& sMime, CTDVString *sFilename=NULL);

	bool GetFeedsCacheName(CTDVString& sFeedsCacheFolderName, CTDVString& sFeedsCacheItemName);
	bool GetRequestFeedCacheFolderName(CTDVString& sFeedsCacheFolderName);
	bool GetRequestFeedCacheFileSuffix(CTDVString& sFeedsCacheFileSuffix);
	void AddRssCacheHit();
	void AddRssCacheMiss(); 
	void AddSsiCacheHit();
	void AddSsiCacheMiss(); 
	void AddHTMLCacheHit();
	void AddHTMLCacheMiss(); 
	void AddLoggedOutRequest();
	void AddIdentityCallDuration(long ttaken);
	bool InitialiseSiteList(CSiteList* pSiteList);

    bool TestFileExists(const CTDVString& sFile);

	CSiteOptions* GetSiteOptions() { return m_pSiteOptions; }

	bool GetCookie(CTDVString& sResult);
	bool HasSSOCookie();

	
public:
	//theConfig functions wrapper
	const char* GetMediaAssetFtpServer() const { return theConfig.GetMediaAssetFtpServer(); }
	const char* GetMediaAssetFtpUser() const {	return theConfig.GetMediaAssetFtpUser(); }
	const char* GetMediaAssetFtpPassword() const {	return theConfig.GetMediaAssetFtpPassword();}
	const char* GetMediaAssetFtpHomeDirectory() const { return theConfig.GetMediaAssetFtpHomeDirectory();}
	const char* GetMediaAssetUploadQueueLocalDir() const {	return theConfig.GetMediaAssetUploadQueueLocalDir();}
	const char* GetMediaAssetUploadQueueTmpLocalDir() const { return theConfig.GetMediaAssetUploadQueueTmpLocalDir();}

	const char* GetPostcoderCookieName() const { return theConfig.GetPostcoderCookieName();}
	const char* GetPostcoderCookiePostcodeKey() const { return theConfig.GetPostcoderCookiePostcodeKey();}

	const char* GetImageLibraryPreviewImage() const { return theConfig.GetImageLibraryPreviewImage(); }
	int GetImageLibraryMaxUploadBytes() const { return theConfig.GetImageLibraryMaxUploadBytes(); } 
	const char* GetImageLibraryFtpServer() const { return theConfig.GetImageLibraryFtpServer(); } 
	const char* GetImageLibraryFtpUser() const { return theConfig.GetImageLibraryFtpUser(); } 
	const char* GetImageLibraryFtpPassword() const { return theConfig.GetImageLibraryFtpPassword(); } 
	const char* GetImageLibraryFtpRaw() const { return theConfig.GetImageLibraryFtpRaw(); } 
	const char* GetImageLibraryFtpPublic() const { return theConfig.GetImageLibraryFtpPublic(); } 
	const char* GetImageLibraryAwaitingModeration() const { return theConfig.GetImageLibraryAwaitingModeration(); } 
	const char* GetImageLibraryFailedModeration() const { return theConfig.GetImageLibraryFailedModeration(); } 
	const char* GetImageLibraryTmpLocalDir() const { return theConfig.GetImageLibraryTmpLocalDir(); } 
	const char* GetImageLibraryPublicUrlBase() const { return theConfig.GetImageLibraryPublicUrlBase(); } 
	const char* GetImageLibraryRawUrlBase() const { return theConfig.GetImageLibraryRawUrlBase(); } 
	const char* GetSiteRoot() const { return theConfig.GetSiteRoot(); } 

	// Site Open / Closing and Emergency stopping functions.
	bool IsSiteClosed(int iSiteID, bool &bIsClosed);
	bool IsSiteEmergencyClosed(int iSiteID, bool &bEmergencyClosed);
	bool SetSiteIsEmergencyClosed(int iSiteID, bool bEmergencyClosed);
	bool GetSiteScheduleAsXMLString(int iSiteID, CTDVString& sXML);

	CTDVString FormatLastErrorMessage();

protected:

	void DeleteInitDatabaseObjects();

	CSiteList* m_pSiteList;
	CSiteOptions* m_pSiteOptions;
	CProfileConnectionPool* m_pProfilePool;
	static CSmileyList m_Smilies;
	static CSmileyTranslator m_Translator;

	static LONG m_ReqCount;
	LONG m_ThisRequest;

	//static CTDVString m_sProfanities;
	
	static std::map<int, std::pair<CTDVString, CTDVString> > m_ProfanitiesMap;
	static std::map<int, int> m_SiteModClassMap;

	CTDVString m_ServerName;
	const TDVCHAR* m_pActualQuery;
	CTDVString m_sBoundary;
	int m_ContentLength;

	// This is no longer necessary
	CTDVString m_DefaultSkinPreference;
	bool GetServerVariable(const TDVCHAR* pName, CTDVString& sResult);

	CTDVString m_DomainName;

	CTDVString ExtractFileExceptionInfo(CFileException* theException);

	bool m_bIsSecureRequest;

#ifdef __MYSQL__
	CMySQLConnection m_Connection;
#else
	CDBConnection m_Connection;
	CDBConnection m_WriteConnection;
#endif
	CProfileConnection m_ProfileConnection;
	
public:
    bool IsRequestForCachedFeed();
	bool IsRequestForRssFeed(); 
	bool IsRequestForSsiFeed();

	bool IsRequestSecure(){ return m_bIsSecureRequest; };

	bool MakeURLRequest(const TDVCHAR* pHost, const TDVCHAR* pReqType, const TDVCHAR* pProxy, const TDVCHAR* pRequest, const TDVCHAR* pPostData, CTDVString& oResult, CTDVString& oHeader, bool bFastTimeout = false);
	bool PostcoderPlaceRequest(const TDVCHAR* pPlaceName, CTDVString& oResult);
	bool PostcoderPlaceCookieRequest( const TDVCHAR *pPostCode, CTDVString &oResult);
	bool IsSiteUnmoderated(int iSiteID = 0);
	bool IsSitePassworded(int iSiteID);
	bool IsCurrentSiteMessageboard();
	bool IsCurrentSiteEmailAddressFiltered();
	bool DoesSiteHaveDistressMsgUserId( int iSiteId, int& iUserId );
	int GetDefaultShow( int iSiteId );
	bool DoesCurrentSiteCacheHTML();
	int  GetCurrentSiteHTMLCacheExpiry();
	bool IsSystemMessagesOn(int piSiteID);
	bool DoesSiteUseArticleGuestBookForums(int iSiteID);
	bool GetUserName(CTDVString* oName);
	void SendAuthRequired();
	bool ReplaceQueryString(const TDVCHAR* pNewParams);
	int GetReviewForumID(int iSiteID, const TDVCHAR* pForumName);
	bool DoesKeyArticleExist(int iSiteID, const TDVCHAR* pArticleName);
	bool DoesSkinExistInSite(int iSiteID, const TDVCHAR* pSkinName);
	bool DoesCurrentSkinUseFrames();
	bool SaveUploadedSkin(const TDVCHAR* pSkinName, const TDVCHAR* pFileName, const TDVCHAR* pParamName, bool bCreateNew, CTDVString* oError);
	bool FindDataSection(const char**iPos, CTDVString* oName, int* oLength, 
		CTDVString* oMimeType, CTDVString* oFileName=NULL);
	bool FindNamedDataSection(const TDVCHAR* pName, const char** iPos, int* oLength, CTDVString* oMimeType, CTDVString* oFileName = NULL);
	bool GetNamedSectionMetadata(const char* pName, int& iLength, CTDVString& sMime);
	bool SetSkin(const TDVCHAR* pSkin);
	bool Signal(const TDVCHAR* pURL);
	void SiteDataUpdated();
	void GroupDataUpdated();
	void UserGroupDataUpdated(int iUserID);
	void DynamicListDataUpdated();
	void GetSiteConfig(CTDVString& sSiteConfig);
	void SetSiteConfig(const TDVCHAR* pSiteConfig);
	void GetTopics(CTDVString& sTopics);
	bool MakeCUDRequest(const TDVCHAR* pRequest, CTDVString* oResponse);
	CDBConnection* GetDBConnection();
	CDBConnection* GetWriteDBConnection();
	static void EscapeTextForURL(CTDVString& sString);
	bool GetIsInFastBuilderMode() { return m_bFastBuilderMode; }

	// Fetches the UserAgent from the web server and returns the string representing it.
	bool GetUserAgent(CTDVString& oAgentString);
	bool IsUsersEMailVerified(bool& bVerified);
	bool GetSitesEMailAlertSubject(int iSiteID, CTDVString& sEmailAlertSubject);
	bool GetEventAlertMessageUserID(int iSiteID, int& iUserID);

	static const char* GetMimeExtension(const char* pMime);

	void StartDatabaseWatchdog();

	bool GetIsInPreviewMode() { return m_bPreviewMode; }
	bool GetTimeTransform() { return m_bTimeTransform; }
	
	static CTDVString GetPreviewModeURLParam();

	CTDVString GetRipleyServerInfoXML();
	void	   SetRipleyServerInfoXML(const TDVCHAR* pXML);

	CRipleyStatistics* GetStatistics() { return m_pStatistics; }

	bool IsCurrentSiteURLFiltered();
	static bool const GetAllowedURLList(int iSiteID, CTDVString& AllowedURLList);
	bool RefreshAllowedURLList();
	bool RefreshAllowedURLList(CSiteList* pSiteList);

	bool DoesSiteUsePreModPosting(int piSiteID);
	
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


	bool DoesCurrentSiteAllowedMAExternalLinks();
	bool IsModerationSite(int iSiteID);
	bool DoesCurrentSiteAllowOwnerHiding();
	bool DoesSiteAllowOwnerHiding(int iSiteID);

	bool DoesCurrentSiteHaveSiteOptionSet(const TDVCHAR* pSection, const TDVCHAR* pName);
	CTDVString GetCurrentSiteOptionString(const TDVCHAR* pSection, const TDVCHAR* pName);
	int GetCurrentSiteOptionInt(const TDVCHAR* pSection, const TDVCHAR* pName);

	int GetSiteMinAge(int iSiteID);
	int GetSiteMaxAge(int iSiteID);

	bool GetSiteUsesIdentitySignIn(int iSiteID);
#ifdef DEBUG
	bool SetSiteUsesIdentitySignIn(int iSiteID, bool bUseIdentity);
#endif

	bool GetSiteIsKidsSite(int iSiteID);

	bool IsDateRangeInclusive(int iSiteID);

	CTDVString GetSiteInfomationXML(int iSiteID);

protected:
	CInputContext m_InputContext;
	COutputContext* m_pOutputContext;
	
	CUser* m_pCurrentUser;
	EXTENSION_CONTROL_BLOCK*		m_pECB;
	CRipleyStatistics*		m_pStatistics;
	CTDVString				m_Query;
	CTDVString				m_Command;
	CXMLTree*				m_pConfigData;
	CTDVString				m_IPAddress;

    //CSkinSelector           m_SkinSelector;

	int m_SiteID;
	int m_ThreadOrder;
	int m_AllowRemoveVote;
	int m_IncludeCrumbtrail;
	int m_AllowPostCodesInSearch;
	int m_ThreadEditTimeLimit;
	CTDVString m_SiteName;
	CTDVString m_SSOService;
	CTDVString m_SkinName;
	bool m_bPreModeration;
	bool m_bWasInitialisedFromDatabase;
	bool m_bNoAutoSwitch;
	bool m_bQueuePostings;
	CTDVString	m_SiteDescription;
	CTDVString	m_SiteConfig;
	CTDVString	m_sTopicsXML;	
	VARIABLEMAP m_ServerVariables;

	long m_IdentityCalDuration;

	static bool m_bShowTimers;
	DWORD m_TickStart;
	CTDVString m_TimerHeaders;
	DWORD m_LastEventTime;

	bool m_bFastBuilderMode;

	bool m_bSiteListInitialisedFromDB;
	bool m_bDatabaseAvailable;
	bool m_bPreviewMode;
	bool m_bTimeTransform;
	static CMimeExt m_MimeExt;

	CTDVString m_sRipleyServerInfoXML;
	
	static std::map<int, CTDVString> m_AllowedURLListsMap;

	bool m_bSiteEmergencyClosed;

#ifdef _DEBUG
protected:
	bool GetDebugCookie(CTDVString& sUserID);
	void SetDebugCookie(CTDVString sUserID);
	void ClearDebugCookie();
	bool CreateDebugCurrentUser(int iDebugUserID);
	bool m_bSetDebugCookie;
	CTDVString m_sDebugUserID;

public:
	bool GetDebugCookieString(CTDVString& sCookie);
#endif

	protected:
		DBO* GetWriteDatabaseObject();
		void BuildConnectionString(const char* pServer, const char* pDbName,
			const char* pUser, const char* pPassword, 
			const char* pApp, const char* pPooling, CTDVString& sConn);
public:

	// Cache of user groups. Can be NULL
	CUserGroups* m_pUserGroups;

	// Dynamic lists class. Can be NULL
	CDynamicLists* m_pDynamicLists;
	static void StaticInit();
	static bool DoesFileExist(const TDVCHAR* pFileName);
private:
	static CRITICAL_SECTION s_CSLogFile;
	static DWORD s_CurLogFilePtr;
	static CTDVString s_LastLogFile;

    CTDVString m_sHeaders;

    void WriteContext(const TDVCHAR* pszFormat);
    void WriteHeaders(const TDVCHAR* pszFormat);

private:
	void GenerateLogFileNameAndDate(CTDVString& sLogFileName, CTDVString& sDate);
	void TruncateLogFile(CTDVString& sLogFile, DWORD nFilePointer);
	void HandleExistingLogFile();
	void WriteLogFilePointer(DWORD nLogFilePtr);
	DWORD ReadLogFilePtr();
};

class CMimeExt
{
	public:
		typedef map<CTDVString, const char*> CMimesMap;
		CMimesMap m_Map;

	public:
		CMimeExt();
};
#endif // !defined(AFX_CGI_H__03E3D46A_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
