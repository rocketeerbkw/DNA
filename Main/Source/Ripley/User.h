// User.h: interface for the CUser class.
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


#if !defined(AFX_USER_H__0CC07E8E_EE07_11D3_86F8_00A024998768__INCLUDED_)
#define AFX_USER_H__0CC07E8E_EE07_11D3_86F8_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "TDVDateTime.h"
#include "TDVString.h"

class CStoredProcedure;

#pragma warning(disable:4786)
#include <map>
using namespace std;

class CProfileApi;

/*
	class CUser

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	01/03/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation of user information.

*/

class CUser : public CXMLObject  
{
public:
	virtual bool SetTaxonomyNode(int iNode);
	bool GetPrefXML(CTDVString* oXML);
	bool SetPrefXML(const TDVCHAR* pXML);
	bool GetIsBannedFromPosting();
	bool GetIsInBannedEmailList();
	bool GetIsBannedFromComplaints();
	bool GetIsPreModerated();
	bool GetIsPostModerated();
	bool GetIsPostingAllowed();
	bool SetAgreedTerms(bool bAgreedTerms);
	bool GetAgreedTerms();
	bool SetIsEditor(bool bIsEditor);
	bool GetSignedInStatusAsString(CTDVString& sSigned, bool bUseIdentity);

	// User Privacy related functions	
	bool GetIsUserLocationHidden(); 
	bool GetIsUserNameHidden();
	bool SetUsersLocationHidden(bool bHide);
	bool SetUsersUserNameHidden(bool bHide);

	// don't know if we may wish to subclass therefore make them virtual
	bool SetSiteID(int iSiteID);		// Sets the Site this user's prefs come from
	virtual bool IsUserInGroup(const TDVCHAR* pGroupName);
	virtual bool QueueForModeration(int iSiteID, const CTDVString& sUserName );
	virtual bool GetIsModerator();
	virtual bool GetIsSub();
	virtual bool GetIsAce();
	virtual bool GetIsFieldResearcher();
	virtual bool GetIsSectionHead();
	virtual bool GetIsArtist();
	virtual bool GetIsGuru();
	virtual bool GetIsScout();
	virtual bool GetIsNotable();
	virtual bool GetIsEditor();
	virtual bool GetIsSuperuser();
	virtual bool GetIsBBCStaff();
	virtual bool GetIsImmuneFromModeration(int ih2g2id);
	virtual	bool HasSpecialEditPermissions(int ih2g2id);

	virtual bool GetLoginName(CTDVString& sLoginName);
	virtual bool GetSsoUserName(CTDVString& sSsoUsername);
	virtual int GetUserID();
	virtual int GetMasthead();
	virtual bool GetUserID(int* piUserID);
	virtual bool GetUsername(CTDVString& sUsername);
	virtual bool GetPostcode(CTDVString& sPostcode);
	virtual bool GetArea(CTDVString& sArea);
	virtual bool GetRegion(CTDVString& sArea);
	virtual bool GetFirstNames(CTDVString& sFirstNames);
	virtual bool GetLastName(CTDVString& sLastName);
	virtual bool GetEmail(CTDVString& sEmail);
	virtual bool GetCookie(CTDVString& sCookie);
	virtual bool GetBBCUID(CTDVString& sBBCUID);
	virtual bool GetPassword(CTDVString& sPassword);
	virtual bool GetDateJoined(CTDVString& sDateJoined);
	virtual bool GetDateReleased(CTDVString& sDateReleased);
	virtual bool GetMasthead(int* piMasthead);
	virtual bool GetTaxonomyNode(int* piNode);
	virtual bool GetPrivateForum(int* piPrivateForum);
	virtual bool GetJournal(int* piJournal);
	virtual bool GetSinBin(int* piSinBin);
	virtual bool GetStatus(int* piStatus);
	virtual bool GetLatitude(double* pdLatitude);
	virtual bool GetLongitude(double* pdLongitude);
	virtual bool GetActive(bool* pbActive);
	virtual bool GetAnonymous(bool* pbAnonymous);
	virtual bool GetPrefSkin(CTDVString* pPrefSkin);
	virtual bool GetPrefUserMode(int* piPrefUserMode);
	virtual bool GetPrefForumStyle(int* piPrefForumStyle);
	virtual bool GetPrefForumThreadStyle(int* piPrefForumThreadStyle);
	virtual bool GetPrefForumShowMaxPosts(int* piPrefForumShowMaxPosts);
	virtual bool GetPrefReceiveWeeklyMailshot(bool* pbPrefReceiveWeeklyMailshot);
	virtual bool GetPrefReceiveDailyUpdates(bool* pbPrefReceiveDailyUpdates);
	virtual bool GetTitle(CTDVString& sTitle);
	virtual bool GetTeamID(int* piTeamID);
	virtual bool GetUnreadPublicMessageCount(int* piUnreadPublicMessageCount);
	virtual bool GetUnreadPrivateMesageCount(int* piUnreadPrivateMessageCount);
	virtual bool GetSiteSuffix(CTDVString& sSiteSuffix);
	virtual bool GetAcceptSubscriptions();
	virtual bool LoginUserToProfile();
	
	// how many of these needed ???
	virtual bool SetIsSub(bool bIsSub);
	virtual bool SetIsModerator(bool bIsModerator);
	virtual bool SetIsAce(bool bIsAce);
	virtual bool SetIsFieldResearcher(bool bIsFieldResearcher);
	virtual bool SetIsSectionHead(bool bIsSectionHead);
	virtual bool SetIsArtist(bool bIsArtist);
	virtual bool SetIsGuru(bool bIsGuru);
	virtual bool SetIsScout(bool bIsScout);
	virtual bool SetIsGroupMember(const TDVCHAR* pcGroupName, bool bIsMember);
	virtual bool ClearGroupMembership();

	virtual void SetSsoUserName(const TDVCHAR* sSsoUsername);
	virtual bool SetUsername(const TDVCHAR* pUsername);
	virtual bool SetFirstNames(const TDVCHAR* pFirstNames);
	virtual bool SetLastName(const TDVCHAR* pLastName);
	virtual bool SetEmail(const TDVCHAR* pEmail);
	virtual bool SetCookie(const TDVCHAR* pCookie);
	virtual bool SetTitle(const TDVCHAR* pTitle);
	virtual bool SetSiteSuffix(const TDVCHAR* pSiteSuffix);
	virtual bool SetPassword(const TDVCHAR* pPassword);
	virtual bool SetPostcode(const TDVCHAR* pPostcode);
	virtual bool SetRegion(const TDVCHAR* pRegion);
	virtual bool SetArea(const TDVCHAR* pArea);
	virtual bool SetDateJoined(const TDVCHAR* pDateJoined);
	virtual bool SetDateReleased(const TDVCHAR* pDateReleased);
	//virtual bool SetMasthead(int iMasthead);	// Deprecated - can no longer set this field programatically
	//virtual bool SetJournal(int iJournal); //Never called
	virtual bool SetSinBin(int iSinBin);
	virtual bool SetStatus(int iStatus);
	virtual bool SetLatitude(double dLatitude);
	virtual bool SetLongitude(double dLongitude);
	virtual bool SetActive(bool bActive);
	virtual bool SetAnonymous(bool bAnonymous);
	virtual bool SetPrefSkin(const TDVCHAR* pPrefSkin);
	virtual bool SetPrefUserMode(int iPrefUserMode);
	virtual bool SetPrefForumStyle(int iPrefForumStyle);
	virtual bool SetPrefForumThreadStyle(int iPrefForumThreadStyle);
	virtual bool SetAcceptSubscriptions( bool bAcceptSubscriptions );
	//virtual bool SetPrefForumShowMaxPosts(int iPrefForumShowMaxPosts);
	//virtual bool SetPrefReceiveWeeklyMailshot(bool bPrefReceiveWeeklyMailshot);
	//virtual bool SetPrefReceiveDailyUpdates(bool bPrefReceiveDailyUpdates);

	// getters for finding out what is visible
	virtual bool EverythingIsVisible();
	virtual bool EmailIsVisible();
	// setters for determining visibility of various elements, i.e. whether
	// or not they are expressed by the object when it is asked for its contents
	// currently only three levels - could have visibility settings for each
	// element but this seems overkill
	// don't like these names much...
	virtual bool SetEverythingVisible();
	virtual bool SetIDNameEmailVisible();
	virtual bool SetIDNameVisible();

	// 3 different unique identifiers for users, so three different ways
	// to create one
	virtual bool CreateFromIDInternal(int iUserID, bool bCreateIfNotFound = false);
	virtual bool CreateFromSigninIDInternal(int iSignInUserID, bool bCreateIfNotFound = false);
	virtual bool CreateFromID(int iUserID);
	virtual bool CreateFromSigninIDAndInDatabase(int iUserID);
	//virtual bool CreateFromCookie(const TDVCHAR* pCookie);
	virtual bool CreateFromEmail(const TDVCHAR* pEmail);
	virtual bool CreateFromH2G2ID(int ih2g2ID, int iSiteID = 1);
	virtual bool CreateFromIDForSite(int iUserID, int iSiteID);
	virtual bool CreateFromID(int iUserID, bool bFailIfNoMasthead);

	virtual bool GetAsString(CTDVString& sResult);
	virtual bool AddInside(const TDVCHAR* pTagName, CXMLObject* pObject);
	virtual bool AddInside(const TDVCHAR* pTagName, const TDVCHAR* pXMLText);
	virtual bool DoesTagExist(const TDVCHAR* pNodeName);
	virtual bool IsEmpty();
	virtual bool Destroy();
	virtual bool UpdateDetails();
	virtual bool GotUserData();
	virtual void SetUserSignedIn();
	virtual void SetUserNotSignedIn(const char* sErrMsg);
	virtual void SetUserLoggedIn();
	virtual void SetUserNotLoggedIn();
	virtual bool IsUserSignedIn();
	virtual bool IsUserLoggedIn();
	CUser(CInputContext& inputContext);
	virtual ~CUser();
	virtual bool SynchroniseWithProfile( bool bForceUpdate = false);
	bool CUser::HasEntryLockedForModeration(int ih2g2ID);
	bool GetMatchingUserAccounts(CTDVString& sXML);

	bool IsUsersEMailVerified(bool& bVerified);
	bool GetIsAutoSinBin();
	bool GetIsEditorOnAnySite();
	bool GetSitesUserIsEditorOfXMLWithEditPermissionCheck(int iUserID, CTDVString& sSitesUserIsEditorOf, int& iFirstSiteID, int iSiteID);
	bool GetSitesUserIsEditorOfXML(int iUserID, CTDVString& sSitesUserIsEditorOf, int& iFirstSiteID);
	bool GetSitesUserIsEditorOf(int iUserID, std::vector<int>& vSiteIDsUserEditorOf); 
	bool IsSynchronised();
	bool HasUserSetUserName();
	void SetSyncByDefault(bool set) { m_syncByDefault = set; }

protected:
	bool CreateFromCacheText(const TDVCHAR* pCacheText);
	bool CreateCacheText(CTDVString* pCacheText);
	bool InitUpdate();
	// internal flag for recording current status of object:
	// NO_USER_DATA => object totally unitialiased, no data whatsoever
	// USERID_ONLY => object has a user ID and nothing else
	// COOKIE_ONLY => object has a cookie and nothing else
	// EMAIL_ONLY => object has an email address and nothing else
	// PARTIAL_DATA => object has minimal data on the user
	// COMPLETE_DATA => object has all data on the user
	enum EObjectStatusType { NO_USER_DATA, USERID_ONLY, COOKIE_ONLY, EMAIL_ONLY, COMPLETE_DATA } m_ObjectStatus;

	// internal flag for visibility level of contents
	// only three levels currently
	enum EVisibilityType { EVERYTHING_VISIBLE, ID_NAME_EMAIL_VISIBLE, ID_NAME_VISIBLE } m_VisibilityStatus;

	// internal flag to say if any of the users details have been modified
	bool				m_bDataModified;
	bool				m_bGroupsModified;
	CStoredProcedure*	m_pStoredProcedure;
	
	// member variables to store XML data instead of using the tree
	int				m_UserID;
	CTDVString		m_LoginName;
	CTDVString		m_Username;
	CTDVString		m_FirstNames;
	CTDVString		m_LastName;
	CTDVString		m_Email;
	CTDVString		m_Cookie;
	CTDVString		m_IdentityCookie;
	CTDVString		m_BBCUID;
	CTDVString		m_Password;
	CTDVString		m_Postcode;
	CTDVString		m_Region;
	CTDVString		m_Area;
	int				m_TaxonomyNode;
	CTDVString		m_SsoUsername;
	CTDVString		m_ProfileErrorMsg;
	CTDVDateTime	m_DateJoined;
	CTDVDateTime	m_DateReleased;
	CTDVDateTime	m_LastUpdated;
	int				m_Masthead;
	int				m_Journal;
	int				m_SinBin;
	int				m_Status;
	double			m_Latitude;
	double			m_Longitude;
	bool			m_Active;
	bool			m_Anonymous;
	bool			m_LoggedIn;
	bool			m_SignedIn;
	int				m_PrivateForum;
	int				m_TeamID;
	int				m_UnreadPublicMessageCount;
	int				m_UnreadPrivateMessageCount;
	// groups that they belong to
	map<CTDVString, int>	m_Groups;
	// current preferences
	CTDVString		m_PrefSkin;
	int				m_PrefUserMode;
	int				m_PrefForumStyle;
	int				m_PrefForumThreadStyle;
	int				m_PrefForumShowMaxPosts;
	bool			m_PrefReceiveWeeklyMailshot;
	bool			m_PrefReceiveDailyUpdates;
	CTDVString		m_PrefXML;
	int				m_PrefStatus;
	int				m_SiteID;
	bool			m_AgreedTerms;
	bool			m_bCreateNewUser;
	CTDVString		m_Title;
	CTDVString		m_sSiteSuffix;
	bool			m_bIsModClassMember;
	int				m_HideLocation; 
	int				m_HideUserName;
	bool			m_bIsAutoSinBin;
	bool			m_bIsEditorOnAnySite;
	bool			m_bIsSynchronised;
	bool			m_bFailIfUserHasNoMasthead;
	bool			m_bAcceptSubscriptions;
	static CArray<CTDVString,CTDVString&> m_sBannedCookies;
	bool			m_bInBannedEmailList;
	bool			m_bBannedFromComplaints;
	CRITICAL_SECTION m_criticalsection;
	bool			m_bPromptUserName;
	bool			m_syncByDefault;

	virtual bool CreateFromXMLText(const TDVCHAR* xmlText);
	virtual CXMLTree* ExtractTree();
	// protected methods for accessing objects status internally
	bool GotNoData();
	bool GotUserID();
	bool GotCookie();
	bool GotEmail();
	bool GotCompleteData();
	void SetStatusNoData();
	void SetStatusUserIDOnly();
	void SetStatusCookieOnly();
	void SetStatusEmailOnly();
	void SetStatusCompleteData();
	// fills in missing data from the database/cache/whatever
	bool FetchData();
	bool CreateNewUserInDatabase(CStoredProcedure& SP);
	bool IsUsersEmailInTheBannedList();
};


inline void CUser::SetUserSignedIn()
{
	m_SignedIn = true;
	m_ProfileErrorMsg.Empty();
}

inline void CUser::SetUserNotSignedIn(const char* sErrMsg)
{
	m_SignedIn = false;
	m_LoggedIn = false;

	if (sErrMsg != NULL)
	{
		m_ProfileErrorMsg = sErrMsg;
	}
}

inline void CUser::SetUserLoggedIn()
{
	m_LoggedIn = true;
}

inline void CUser::SetUserNotLoggedIn()
{
	m_LoggedIn = false;
}

inline bool CUser::IsUserSignedIn()
{
	return m_SignedIn;
}

inline bool CUser::IsUserLoggedIn()
{
	return m_LoggedIn;
}

inline bool CUser::GotUserData()
{
	return GotCompleteData();
}

#endif // !defined(AFX_USER_H__0CC07E8E_EE07_11D3_86F8_00A024998768__INCLUDED_)
