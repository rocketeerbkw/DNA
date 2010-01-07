// Forum.h: interface for the CForum class.
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


#if !defined(AFX_FORUM_H__D17E1346_F0EE_11D3_8A0C_00104BF83D2F__INCLUDED_)
#define AFX_FORUM_H__D17E1346_F0EE_11D3_8A0C_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "User.h"
#include "GuideEntry.h"

class CForum : public CXMLObject  
{
public:
	
	enum 
	{
		LATESTPOST					= 1,
		CREATEDATE					= 2,
		//NUMMESSAGES				= 3 // not implemented yet
	};

	//Define a type for a Local Notice Board Post.
	enum
	{
		TYPENOTICEBOARDPOST  = CGuideEntry::TYPEREVIEWFORUM + 1
	};

	CForum(CInputContext& inputContext);
	virtual ~CForum();

	static int GetThreadOrderID(CTDVString& sOrderDesc);
	static bool GetThreadOrderDesc(const int iThreadOrder, CTDVString& sOrderDesc);

	bool MarkThreadRead(int iUserID, int iThreadID, int iPostID, bool bForce = false);
	bool WasLastPostRead(int* oPostID, bool* bGotLastPost);
	bool GetPostsInForum(CUser* pViewer, int iForumID, int iNumPosts, int iNumSkipped, int iAscendingOrder = 0);
	bool GetPostingPermission(CUser* pPoster, int iForumID, int iThreadID, bool& bCanRead, bool& bCanWrite);
	bool FilterThreadPermissions(CUser* pViewer, int ForumID, int ThreadID, const TDVCHAR* pTagName);
	bool FilterIndividualThreadPermissions(CUser* pViewer, const TDVCHAR* pTagName, const TDVCHAR* pItemName);
	bool FilterOnPermissions(CUser* pViewer, int ForumID, const TDVCHAR* pTagName, const TDVCHAR* pItemName = "THREAD");
	int GetSiteID();
	int GetForumID();
	bool SetSubscriptionState(int iUserID, int iThreadID, int iForumID, bool bState, bool bIsJournal = false);
	bool GetThreadSubscriptionState(int iUserID, int iThreadID, int iForumID, bool* oForumSubscribed = NULL, bool* oThreadSubscribed = NULL, int* piLastPostCountRead = NULL, int* piLastUserPostID = NULL);
	bool PostToJournal(int iUserID, int iJournalID, const TDVCHAR* pUsername, const TDVCHAR* pSubject, const TDVCHAR* pBody, int iSiteID, int iPostStyle, bool* pbProfanityFound, bool* pbNonAllowedURLsFound, bool* pbEmailAddressFound );
	bool PostToForum(CUser* pPoster, int iForumID, int iReplyTo, int iThreadID, const TDVCHAR* pSubject, const TDVCHAR* pBody, int iPostStyle, int* oThreadID, int* oPostID, 
			const TDVCHAR *pType = NULL, const TDVCHAR *pEventDate = NULL, bool* pbProfanityFound = NULL, int iClub = 0, int iNodeID = 0, const TDVCHAR* pPhrases = NULL, 
			bool bAllowQueuing = false , bool* pbWasQueued = NULL, bool bIgnoreModeration = false, int* pSecondsToWait = NULL, bool* pbNonAllowedURLsFound = NULL, bool* pbIsPreModPosting = NULL, bool* pbIsPreModerated = NULL, bool* pbEmailAddressFound = NULL );
	bool GetPostContents(CUser* pViewer, int iReplyTo, int* iForumID, int* iThreadID, CTDVString* sUserName, CTDVString* sBody, CTDVString* pSubject, int* oPostStyle, int* oPostIndex, int* oUserID);
	bool GetJournal(CUser* pViewer, int iForumID, int NumToShow, int NumSkipped, bool bShowUserHidden = false );
	bool GetUserStatistics(int iForumID, int NumToShow, int NumSkipped, int iMode, CTDVDateTime dtStartDate, CTDVDateTime dtEndDate);
	int GetLatestThreadInForum(int iForumID);
	bool GetTitle(int iForumID, int iThreadID, bool bIncludeArticle = false, int* piType = NULL, int* pID = NULL, CTDVString* psTitle = NULL, int* piSiteID = NULL, CTDVString* psUrl = NULL);
	bool GetPostHeadersInThread(CUser* pViewer, int ForumID, int ThreadID, int NumToShow, int NumSkipped);
	bool GetPostsInThread(CUser* pViewer, int ForumID, int ThreadID, int NumPosts, int NumSkipped, int iPost, bool bOrderByDatePostedDesc=false);
	bool GetThreadList(CUser* pViewer, int ForumID, int NumThreads, int NumSkipped,  int iThreadID = 0, bool bOverflow = false, const int iThreadOrder=CForum::LATESTPOST);

	bool GetMostRecent(int iForumID, CUser* pViewer);
	static void MakeTextSafe(CTDVString& sText);
	//static void MakeSubjectSafe(CTDVString& sText);
	static bool GetForumIDFromString(const CTDVString& sForumID,int* iForumID);
	static bool GetPostIDFromString(const CTDVString& sPostID,int* iPostID);
	bool GetForumSiteID(int iForumID, int iThreadID, int& iSiteID);
	static bool MoveToSite(CInputContext& inputContext, int iForumID, 
							int iNewSiteID);

	static bool GetForumModerationStatus(CInputContext& inputContext, int iForumID, int& iModerationStatus);
	static bool UpdateForumModerationStatus(CInputContext& inputContext, int iForumID, int iNewStatus);
	
	bool HideThreadFromUsers(int iThreadID, int iForumID);
	bool UnHideThreadFromUsers(int iThreadID, int iForumID);
	static bool UpdateAlertInstantly(CInputContext& inputContext, int iAlert, int iForumID);
	bool GetForumStyle(int iForumID, int& iForumStyle);
	int GetPostEditableAttribute(int iPostEditorId, const CTDVDateTime& dateCreated);
	bool IsForumATopic(int iSiteID, int iForumID);

protected:
	void SetSiteIDFromTree(const TDVCHAR* pTagName);
	void SetForumIDFromTree(const TDVCHAR* pTagName);
	int m_SiteID;
	int m_ForumID;
	bool SetUsersGroupAlertForThread(int piUserID, int piThreadID);
};

#endif // !defined(AFX_FORUM_H__D17E1346_F0EE_11D3_8A0C_00104BF83D2F__INCLUDED_)
