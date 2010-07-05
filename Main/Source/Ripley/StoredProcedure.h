// StoredProcedure.h: interface for the CStoredProcedure class.
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


#if !defined(AFX_STOREDPROCEDURE_H__562B53B1_E8BA_11D3_89EF_00104BF83D2F__INCLUDED_)
#define AFX_STOREDPROCEDURE_H__562B53B1_E8BA_11D3_89EF_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "InputContext.h"
#include "DBO.h"
#include "TDVString.h"	// Added by ClassView
#include "DNAArray.h"
#pragma warning(disable:4786)
#include <map>
#include <vector>
#include "StoredProcedureBase.h"
#include "Phrase.h"

class CGI;
class CExtraInfo;
class CUser;

class CStoredProcedure : public CStoredProcedureBase
{
	friend class CGI;

public:
	enum
	{
		ARTICLEUPDATEEDITORID		= 2,	
		ARTICLEUPDATESTATUS			= 4,
		ARTICLEUPDATESTYLE			= 8,
		ARTICLEUPDATEBODY			= 16,
		ARTICLEUPDATEEXTRAINFO		= 32,
		ARTICLEUPDATETYPE			= 64,
		ARTICLEUPDATESUBMITTABLE	= 128,
		ARTICLEUPDATESUBJECT		= 256,
		ARTICLEUPDATEPREPROCESSED	= 512,
		ARTICLEUPDATEPERMISSIONS	= 1024,
		ARTICLEUPDATECLUBEDITORS	= 2048,
		ARTICLEUPDATECONTENTSIGNIF	= 4096,
		ARTICLEUPDATEDATECREATED	= 8192
	};

	//Flags for specifying hidden status/reason
	enum HIDDENSTATUS
	{
		HIDDENSTATUSREMOVED = 1,
		HIDDENSTATUSREFERRED = 2,
		HIDDENSTATUSPREMODERATION = 3,
		HIDDENSTATUSLEGACYMODERATION = 4,
		HIDDENSTATUSCOMPLAINT = 6,
		HIDDENSTATUSUSERHIDDEN = 7
	};

	enum KEYPHRASETYPE
	{
		THREAD = 1,
		ARTICLE = 2,
		ASSET = 3
	};

	static const int MOD_TRIGGER_PROFANITY;
	static const int MOD_TRIGGER_AUTO;
	static const int MOD_TRIGGERED_BY_NOUSER;

	CStoredProcedure(DBO* pDBO, int iSiteID, CGI* pCGI);
	CStoredProcedure();
	virtual ~CStoredProcedure();
	bool GetTaggedContent(int iMaxRows, int iSort, const char* pIdes);
	bool GetHierarchyCloseNodes(int iNodeId, int iBaseLine);
	bool GetTaggedContentForNode(int iMaxRows, int iNodeID);

	bool GetTagLimitsForSite(const int iSiteID);
	bool GetTagLimitsForItem(int iTypeID);
	bool GetTagLimitsForThread();
	bool GetTagLimitsForUser();

	bool SetTagLimitForItem(int iItemType, int iNodeType, int iLimit, int iSiteID);
	bool SetTagLimitForThread(int iNodeType, int iLimit, int iSiteID);
	bool SetTagLimitForUser(int iNodeType, int iLimit, int iSiteID);

	bool IsUserAuthorisedToCreateVote(int iItemID, int iVoteType, int iUserID);
	bool GetUserHierarchyNodes(int iUserID, int iSiteID);
	bool GetMultipleHierarchyNodeDetails(CDNAIntArray& NodeArray,int i = 0);
	bool GetTreeLevelForNodeID(int iNodeID, int iSiteID);
	bool GetAllLocalAuthorityNodes(const int iSiteID, const int iNodeID = 0, const int iAuthorityLevel = 5);
	bool MarkAllThreadsRead(int iUserID);
	bool ForumGetNoticeInfo(int iForumID, int iThreadID);
	bool ForumGetNoticeBoardPosts(int iForumID);
	bool GetNoticeBoardPostsForNode( int iNodeID, int iSiteID );
	bool GetUsersForNode( int iNodeID, int iSiteID );
	bool GetAllEventsInTheNextNumberOfDays(int iForumID, int iDays = 356);
	bool GetNodeIDForThreadID(int iThreadID, int iSiteID);
	bool AddVoteToThreadVoteTable(int iThreadID, int iVoteID);
	bool GetForumDetailsFromNodeID(int iNodeID, int iSiteID);
	bool GetVoteIDForThreadID(int iThreadID);
	bool CanUserAddToNode(int iNodeID,bool& bCanAdd);

	bool MoveItemFromSourceToDestinationNode(int iItemID, int iItemType, int iNodeIDFrom, int iNodeIDTo, bool& bSuccess);
	bool MoveThreadFromSourceToDestinationNode(int iThreadID, int iNodeIDFrom, int iNodeIDTo, bool& bSuccess);
	bool MoveUserFromSourceToDestinationNode(int iThreadID, int iNodeIDFrom, int iNodeIDTo, bool& bSuccess);

	//Teams
    bool IsUserAuthorForArticle(int iUserID, int iforumID, bool &bAuthor );
	bool IsUserAuthorisedForItem(int iTypeID, int iItemID, int iUserID);
	bool IsUserAuthorisedForThread(int iThreadID, int iUserID, bool& bAuthor);
	bool IsUserInOwnerMembersOfClub(int iUserID, int iClubID, bool& bIsInTeam);
	bool IsUserInTeamMembersOfClub(int iUserID, int iClubID, bool& bIsInTeam);
	bool IsUserAMemberOfThisTeam(int iTeamID, int iUserID, bool& bIsMember);
	bool GetForumIDForTeamID(int iTeamID, int& iForumID);

	bool GetAllNodesThatItemBelongsTo(int iItemID, int iItemType);
	bool GetAllNodesThatNoticeBoardPostBelongsTo ( int iThreadID );
	bool GetAllNodesThatUserBelongsTo ( int iUserID );

	bool HasUserAlreadyVoted(int iVoteID, int iUserID, CTDVString& sBBCUID);
	bool GetNumberOfVotesWithResponse(int iVoteID, int iResponse, int& iVisible, int& iHidden);
	bool GetVoteIDFromClubID(int iClubID);
	bool GetUserDetailsFromID(int iUserID, int iSiteID);
	bool GetTaxonomyNodeFromID(const TDVCHAR* pID, int& iNode);
	bool AddVoteToClubTable(int iClubID, int iVoteID);
	bool GetNewClubsInLastMonth();
	bool GetClubList(int iSiteID, bool bOrderByLastUpdated);
	bool GetObjectIDFromVoteID(int iType, int iVoteID);
	bool CreateNewVote(int& iVoteID, int iType, CTDVDateTime& dClosingDate, bool bIsYesNo, int iOwnerID, int iResponseMin = - 1, int iResponseMax = -1, bool bAllowAnonymousRating = false);
	bool AddResponseToVote(int iVoteID, int iUserID, CTDVString& sBBCUID, int iResponse, bool bVisible, int iSiteID, int iThreadID = 0);
	bool GetVoteDetails(int iVoteID, bool& bSuccess);
	bool GetAllVotingUsersWithReponse(int iVoteID, int iResponse, int iSiteID);
	bool UpdateUsersRole(int iUserID, int iClubID, const TDVCHAR *psRole);
	bool CheckUserBelongsToClub(int iUserID, int iClubID, bool& bUserBelongs);
	bool GetThreadListForForum(int iForumID);

	bool GetNumberOfTeamMembers(int iTeamID, int iInLastNoOfDays = 0);
	bool GetAllClubsThatUserBelongsTo(int iUserID, int iInLastNoOfDays = 1, int iSiteID = 0);
	bool GetRelatedClubs(int ih2g2ID);
	bool GetRelatedArticles(int ih2g2ID);
	bool CopySingleLinkToClub(int iLinkID, int iClubID, const TDVCHAR* pClubLinkGroup);
	bool GetClubLinks(int iClubID, const TDVCHAR* pLinkGroup, bool bShowPrivate);
	bool GetEditableClubLinkGroups(int iUserID);
	bool GetAllEditableClubs(int iUserID);
	bool CopyLinksToClub(int iUserID, int iClubID, const TDVCHAR* pLinkGroup);
	bool GetClubsArticleLinksTo(int iArticleID);

	bool ChangeLinkPrivacy(int iLinkID, bool bHidden);
	bool MoveLink(int iLinkID, const TDVCHAR* pNewLocation);
	bool DeleteLink(int iLinkID, int iUserID, int iSiteID, bool& bDeleted);

	bool DeleteArticleFromAllNodes(int ih2g2Id,  int iSiteID, const char* pNodeType);
	bool DeleteUserFromAllNodes(int iUserID, int iSiteID, const TDVCHAR* pNodeType);
	bool DeleteClubFromAllNodes(int ih2g2Id,  int iSiteID );
	bool DeleteThreadFromAllNodes(int ih2g2Id,  int iSiteID );

	bool GetUserLinks(int iUserID, const TDVCHAR* pLinkGroup, bool bShowPrivate);
	bool GetFrontPageElementLinks(int iElementID, bool bShowPrivate);
	bool GetFrontPageElementKeyPhrases( int iSiteId, int iElementType, int iElementID, int* pDefaultKeyPhrasePromo  );
	bool GetLinkGroups(const TDVCHAR* pSourceType, int iSourceID);
	bool GetVoteLinks(int iVoteID, const TDVCHAR* pLinkGroup, bool bShowPrivate);
	bool ClipPageToObject(const TDVCHAR* pSourceType, int iSourceID, 
		const TDVCHAR *pDestType, int iDestID, const TDVCHAR* pTitle, 
		const TDVCHAR *pLinkDescription, const TDVCHAR *pLinkGroup, 
		bool bHidden, int iTeamID, const TDVCHAR *pRelationship, const TDVCHAR* pUrl,
		int iSubmitterID, int iDestinationSiteId );
	bool ClipPageToUserPage(const TDVCHAR *pPageType, int iObjectID, const TDVCHAR *pLinkDescription, const TDVCHAR *pLinkGroup, const TDVCHAR* pRelationship, CUser* pViewingUser, int iDestinationSiteId, bool bPrivate );
	bool ClipPageToClub(int iClubID,const TDVCHAR* pPageType, int iPageID, 
		const TDVCHAR* pTitle, const TDVCHAR* pLinkDescription, 
		const TDVCHAR* pLinkGroup,int iTeamID,const TDVCHAR* pRelationship, 
		const TDVCHAR* pUrl, int iSubmitterID, int iDestinationSiteId );

	bool GetThreadsWithKeyPhrases(const CTDVString& sPhrases, int iSkip, int iShow);
	bool GetKeyPhrasesForSite( int iSiteID );
	bool GetKeyPhrasesFromThread( int iThreadID );
	bool GetKeyPhraseScore(int iSiteId, const CTDVString& sPhrasesToScore, const CTDVString& sFilter );
	bool GetSiteKeyPhraseScores(int iSiteId, const CTDVString& sFilter );
	bool GetKeyPhraseHotList(int iSiteId, const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy );
	bool AddKeyPhrasesToThread( int iThreadID, const CTDVString& sPhrases);

	bool GetMediaAssetsWithKeyPhrases(const CTDVString& sPhrases, int iContentType, int iSkip, int iShow, CTDVString sSortBy);
	bool AddKeyPhrasesToMediaAsset( int iAssetID, const CTDVString& sPhrases);
	bool GetKeyPhraseMediaAssetHotList( int iSiteId, const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType );
	bool GetKeyPhrasesFromMediaAsset( int iAssetID );

	bool SearchHierarchy(const TDVCHAR* pSearchTerm, int iSiteID);
	bool GetForumPostsAsGuestbook(int ForumID, int iAscendingOrder = 0);
	bool GetForumPostsAsGuestbookSkipAndShow(int iForumID, int iAscendingOrder = 0, int iSkip = 0, int iShow = 20);
	bool UpdateDefaultPermissions( int iSiteID,
	int iClubCanAutoJoinMember,
	int iClubCanAutoJoinOwner, 
	int iClubCanBecomeMember, 
	int iClubCanBecomeOwner, 
	int iClubCanApproveMembers, 
	int iClubCanApproveOwners, 
	int iClubCanDemoteOwners, 
	int iClubCanDemoteMembers, 
	int iClubCanViewActions, 
	int iClubCanView, 
	int iClubCanPostJournal, 
	int iClubCanPostCalendar,
	int iClubCanEdit, 

	int iClubOwnerCanAutoJoinMember, 
	int iClubOwnerCanAutoJoinOwner, 
	int iClubOwnerCanBecomeMember, 
	int iClubOwnerCanBecomeOwner, 
	int iClubOwnerCanApproveMembers, 
	int iClubOwnerCanApproveOwners, 
	int iClubOwnerCanDemoteOwners, 
	int iClubOwnerCanDemoteMembers, 
	int iClubOwnerCanViewActions, 
	int iClubOwnerCanView, 
	int iClubOwnerCanPostJournal, 
	int iClubOwnerCanPostCalendar, 
	int iClubOwnerCanEdit, 

	int iClubMemberCanAutoJoinMember, 
	int iClubMemberCanAutoJoinOwner, 
	int iClubMemberCanBecomeMember, 
	int iClubMemberCanBecomeOwner, 
	int iClubMemberCanApproveMembers, 
	int iClubMemberCanApproveOwners, 
	int iClubMemberCanDemoteOwners, 
	int iClubMemberCanDemoteMembers, 
	int iClubMemberCanViewActions, 
	int iClubMemberCanView, 
	int iClubMemberCanPostJournal, 
	int iClubMemberCanPostCalendar, 
	int iClubMemberCanEdit, 

	int iClosedClubCanAutoJoinMember, 
	int iClosedClubCanAutoJoinOwner, 
	int iClosedClubCanBecomeMember, 
	int iClosedClubCanBecomeOwner, 
	int iClosedClubCanApproveMembers, 
	int iClosedClubCanApproveOwners, 
	int iClosedClubCanDemoteOwners, 
	int iClosedClubCanDemoteMembers, 
	int iClosedClubCanViewActions, 
	int iClosedClubCanView, 
	int iClosedClubCanPostJournal, 
	int iClosedClubCanPostCalendar, 
	int iClosedClubCanEdit, 

	int iClosedClubOwnerCanAutoJoinMember, 
	int iClosedClubOwnerCanAutoJoinOwner, 
	int iClosedClubOwnerCanBecomeMember, 
	int iClosedClubOwnerCanBecomeOwner, 
	int iClosedClubOwnerCanApproveMembers, 
	int iClosedClubOwnerCanApproveOwners, 
	int iClosedClubOwnerCanDemoteOwners, 
	int iClosedClubOwnerCanDemoteMembers, 
	int iClosedClubOwnerCanViewActions, 
	int iClosedClubOwnerCanView, 
	int iClosedClubOwnerCanPostJournal, 
	int iClosedClubOwnerCanPostCalendar, 
	int iClosedClubOwnerCanEdit, 

	int iClosedClubMemberCanAutoJoinMember, 
	int iClosedClubMemberCanAutoJoinOwner, 
	int iClosedClubMemberCanBecomeMember, 
	int iClosedClubMemberCanBecomeOwner, 
	int iClosedClubMemberCanApproveMembers, 
	int iClosedClubMemberCanApproveOwners, 
	int iClosedClubMemberCanDemoteOwners, 
	int iClosedClubMemberCanDemoteMembers, 
	int iClosedClubMemberCanViewActions, 
	int iClosedClubMemberCanView, 
	int iClosedClubMemberCanPostJournal, 
	int iClosedClubMemberCanPostCalendar,
	int iClosedClubMemberCanEdit
		);
	bool GetUserActionList(int iUserID);
	bool GetClubActionList(int iClubID);
	bool GetClubIDAndClubTeamsForTeamID(int iTeamID, int& iClub, int& iMember, int& iOwner, bool& bSuccess);
	bool GetAllTeamMembers(int iTeamID, int iSiteID, bool &bNoMembers);
	bool CompleteClubAction(int iActionID, int iUserID, int iActionResult);
	bool PerformClubAction(int iClubID, int iUserID, int iActionUserID, int iActionType, const int iSiteID);
	bool GetClubPermissions(int iUserID, int iClubID, bool &oCanAutoJoinMember, bool &oCanAutoJoinOwner, bool &oCanBecomeMember, bool &oCanBecomeOwner, bool &oCanApproveMembers, bool &oCanApproveOwners, bool &oCanDemoteOwners, bool &oCanDemoteMembers, bool &oCanViewActions, bool &oCanView, bool &oCanEdit);
	bool UpdateForumPermissions(int iForumID, bool bChangeRead, int iRead, bool bChangeWrite, int iWrite, bool bChangeThreadRead, int iThreadRead, bool bChangeThreadWrite, int iThreadWrite);
	bool GetThreadPermissions(int iUserID, int iThreadID, bool& oCanRead, bool& oCanWrite);
	bool GetForumPermissions(int iUserID, int iForumID, bool& oCanRead, bool& oCanWrite);
	bool UpdateLocalPassword(const TDVCHAR* pLoginName, const TDVCHAR* pPassword, const TDVCHAR* pNewPassword);
	bool RegisterLocalUser(const TDVCHAR* pLoginName, const TDVCHAR* pPassword, const TDVCHAR* pEmail, int* oErrorCode, int* oUserID, CTDVString* oCookie, CTDVString* oBBCUID);
	bool LoginLocalUser(const char* pLoginName, const char* pPassword, int* oUserID, CTDVString* oUserName, CTDVString* oCookie, CTDVString *oBBCUID);
	int GetFirstNewPostInThread(int iThreadID, CTDVDateTime dTime);
	bool FetchWatchingUsers(int iUserID, int iSiteID);
	bool UserUpdatePrefXML(const TDVCHAR* pXML);
	bool UserUpdateTitle(const TDVCHAR* pTitle);
	void UserUpdateSiteSuffix(const TDVCHAR* pSiteSuffix);
	bool FetchWatchedJournalPosts(int iUserID);
	bool DoDeleteWatchUsers();
	bool AddDeleteWatchUser(int iWatchedUserID);
	bool StartDeleteWatchUser(int iUserID);
	bool StopWatchingUserJournal(int iUserID, int iWatchedUserID);
	bool WatchUserJournal(int iUserID, int iWatchedUserID, int iSiteID);
	bool FetchInterestList(int iUserID);
	bool AddInterest(int iUserID, int iSiteID, const TDVCHAR* pInterest);
	bool AddFriend(int iUserID, int iFriendID, int iSiteID);
	bool GetModerationBilling(const TDVCHAR* pStart, const TDVCHAR* pEnd, int ForceRecalc);
	bool AddSkinToSite(int SiteID, const TDVCHAR* pSkinName, const TDVCHAR* pSkinDescription, int iUseFrames);
	bool CreateNewSite(const TDVCHAR* pURLName, const TDVCHAR* pShortName, const TDVCHAR* pSSOService,
		const TDVCHAR* pDescription, const TDVCHAR* pDefaultSkin, 
		const TDVCHAR* pSkinDescription, const TDVCHAR* pSkinSet, bool bUseFrames, int iPreModeration, 
		int iNoAutoSwitch, int iCustomTerms, const TDVCHAR* pcModeratorsEmail, 
		const TDVCHAR* pcEditorsEmail, const TDVCHAR* pcFeedbackEmail,int iAutoMessageUserID, bool bPassworded,
		bool bUnmoderated, bool ArticleGuestBookForums, const int iThreadOrder, const int iThreadEditTimeLimit,
		const TDVCHAR* psEventEmailSubject, int iEventAlertMessageUserID, int iIncludeCrumbtrail, int iAllowPostCodesInSearch);
	bool GetArticleCrumbTrail(int ih2g2ID);
	bool GetUserCrumbTrail(int iUserID);
	bool GetClubCrumbTrail(int iClubID);
	bool UpdateFrontpage(int iSiteID, const TDVCHAR* pSubject, const TDVCHAR* pBody, int iUserID, const TDVCHAR* pDate, const TDVCHAR* psExtraInfo);
	bool UpdateFrontpagePreview(int iSiteID, const TDVCHAR* pBody, int iUserID, const TDVCHAR* pEditKey, CExtraInfo& ExtraInfo);
	bool UpdateSkinDescription(int iSiteID, const TDVCHAR* pName, const TDVCHAR* pDescription, int iUseFrames);
	int UpdateSiteDetails(int iSiteID, const TDVCHAR* pShortName, const TDVCHAR* pSSOService,
		const TDVCHAR* pDescription,  const TDVCHAR* pDefaultSkin, const TDVCHAR* pSkinSet, bool premoderation, 
		bool noautoswitch, bool autoagreedterms, CTDVString* oError, 
		const TDVCHAR* pcModeratorsEmail, const TDVCHAR* pcEditorsEmail,
		const TDVCHAR* pcFeedbackEmail, int iAutoMessageUserID, bool bPassworded, bool bUnmoderated,
		bool bArticleGuestBookForums, const int ThreadOrder, const int iThreadEditTimeLimit,
		const TDVCHAR* psEventEmailSubject, int iEventAlertMessageUserID, int iAllowRemoveVote, int iIncludeCrumbtrail, 
		int iAllowPostCodesInSearch, bool bQueuePostings, int iTopicClosed);
	bool UpdateSiteConfig(int iSiteID,const TDVCHAR* pConfig);
	bool DoSetTopFive();
    bool DeleteTopFive(int iSiteID, const TDVCHAR* pGroupName);
	bool StartSetTopFiveArticleList(int iSiteID, const TDVCHAR* pGroupName, const TDVCHAR* pGroupDescription);
	bool StartSetTopFiveForumList(int iSiteID, const TDVCHAR* pGroupName, const TDVCHAR* pGroupDescription);
	bool AddTopFiveID(int ih2g2ID, int iThreadID = 0);
    bool AddArticleTopFiveID(int ih2g2ID);
	bool GetSiteListOfLists(int iSiteID, CTDVString* oResult);
	bool GetSiteTopFives(int iSiteID, const TDVCHAR* pGroupName = NULL);
	bool DoDeleteKeyArticles();
	bool AddDeleteKeyArticle(const TDVCHAR* pArticleName);
	bool StartDeleteKeyArticles(int iSiteID);
	bool SetKeyArticle(const TDVCHAR* pArticleName, int h2g2id, int iSiteID, bool bAllowOthereSites, const TDVCHAR* pDate, CTDVString* oError);
	bool GetKeyArticleList(int iSiteID);
	bool GetKeyArticleText(const TCHAR* pName,int iSiteID);
	bool UserUpdateAgreedTerms(bool bAgreedTerms);
	bool CacheGetArticleListDate(int UserID, int SiteID, CTDVDateTime* oDate);
	bool GetAcceptedEntries(int iSiteID);
	bool FetchSiteData(int iSiteID = 0);
	bool FetchSubbedArticleDetails(int h2g2ID);
	bool FetchSubNotificationStatus(int* piNumberUnnotified);
	bool FetchGroupMembershipList(const TDVCHAR* pcGroupName, int iSiteID, int iSystem);
	bool ClearBBCDetails(int iUserID);
	bool CreateNewUserGroup(int iUserID, const TDVCHAR* pcNewGroupName);
	bool FetchSubEditorsAllocationsList(int iSubID, const TDVCHAR* pcUnitType, int iNumberOfUnits);
	bool FetchScoutRecommendationsList(int iScoutID, const TDVCHAR* pcUnitType, int iNumberOfUnits);
	bool UpdateScoutDetails(int iUserID, int iQuota, const TDVCHAR* pcInterval);
	bool UpdateSubDetails(int iUserID, int iQuota);
	bool DeactivateAccount(int iUserID);
	bool ReactivateAccount(int iUserID);
	bool FetchScoutStats(int iScoutID);
	bool FetchSubEditorStats(int iSubID);
	bool FetchUserGroupsList();
	bool DoUpdateUserAdd(int iNodeID,int iUserAdd,bool &bSuccess);
	
	//moderation related
	bool GetPreModerationState();
	bool FetchArticleModerationHistory(int ih2g2ID);
	bool FetchPostModerationHistory(int iPostID);
	bool UnreferArticle(int iModID, int iCalledBy, const TDVCHAR* pcNotes);
	bool UnreferPost(int iModID, const TDVCHAR* pcNotes);
	bool GetQueuedModPerSite(int iUserID);
	bool UpdateFastMod(int iSiteId, int iForumId, bool bFastMod);
	bool IsEmailInBannedList(CTDVString sEmailToCheck);

	// Upload related
	bool AddNewUpload(int iTeamID, int iUserID, CTDVString& sFileName, int iFileType, int& iUploadID, bool& bSuccess);
	bool UpdateUploadStatus(int iUploadID, int iNewStatus, bool& bSuccess);
	bool GetUploadsForTeam(int iTeamID, bool& bSuccess);
	bool GetUploadsForUser(int iUserID, bool& bSuccess);
	bool DeleteUpload(int iUploadID, bool& bSuccess);

	bool FetchUsersLastSession(int iUserID);
	bool FetchLockedItemsStats();
	bool IsDatabaseRunning();
	bool FetchEditorsList();
	bool FetchModeratorsList();
	bool UserHasEntryLockedForModeration(int iUserID, int ih2g2ID);
	bool HideArticle(int iEntryID, int iHiddenStatus, int iModId, 
		int iTriggerId, int iCalledBy);
	bool UnhideArticle(int iEntryID, int iModId, int iTriggerId, int iCalledBy);
	bool HidePost(int iPostID, int iHiddenStatus = HIDDENSTATUSREMOVED);
	bool UnhidePost(int iPostID );
	bool UpdatePostDetails(CUser* pUser, int iPostID, const TDVCHAR* pcSubject, const TDVCHAR* pcText, const TDVCHAR* pEventDate, bool bSetLastUpdated, bool bForceModerateAndHide, bool bIgnoreModeration);
	
	bool UnlockModeratePostsForUser( int iUserID, int iModClassId = 0 );
	bool UnlockModeratePostsForSite ( int iUserID, int iSiteID, bool bSuperUser = false );
	bool UnlockModeratePosts( int iUserID, bool bSuperUser = false );

	bool UnlockAllArticleModerations(int iUserID, int iCalledBy, int iModClassID);
	bool UnlockAllForumModerations(int iUserID);
	bool UnlockAllNicknameModerations(int iUserID, int iClassModID);
	bool UnlockUsersExLinkModerations(int iUserID, int iClassModID);
	
	bool UnlockAllGeneralModerations(int iUserID);
	bool UnlockAllArticleReferrals(int iUserID, int iCalledBy);
	bool UnlockAllForumReferrals(int iUserID);
	bool UnlockAllGeneralReferrals(int iUserID);
	bool QueueArticleForModeration(int ih2g2ID, int iTriggerId,
		int iTriggeredBy, const TDVCHAR* pcNotes, int* pModId = NULL);
	bool QueueNicknameForModeration(int iUserID, int iSiteID, const CTDVString& sNickName );
	bool RegisterArticleComplaint(int iComplainantID, int ih2g2ID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText, const TDVCHAR* pIPAddress, const TDVCHAR* pBBCUID);
	bool RegisterPostingComplaint(int iComplainantID, int iPostID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText, const TDVCHAR* pIPAddress, const TDVCHAR* pBBCUID);
	bool LockPostModerationEntry(int iModID, int iUserID);
	bool RegisterGeneralComplaint(int iComplainantID, const TDVCHAR* pcURL, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText,int iSiteID, const TDVCHAR* pIPAddress, const TDVCHAR* pBBCUID);
	bool GetArticleModDetailsFromModID(int iModID);
	bool GetThreadModDetailsFromModID(int iModID);
	bool GetArticleModerationStatus(int ih2g2ID,int &iModerationStatus);
	bool IsArticleInModeration (int ih2g2ID,int &isArticleInModeration);

	bool FetchPostDetails(int iPostID);
	bool FetchArticleDetails(int iEntryID);

	bool CreateNewUserFromBBCUID(const TDVCHAR* pLoginName, const TDVCHAR* pUID, const TDVCHAR* pEmail, int iSiteID, int* oUserID, CTDVString* oCookie);
	bool FindBBCUID(const TDVCHAR* pUID, int iSiteID, int* oUserID, CTDVString* oCookie);
	bool AssociateBBCUID(const TDVCHAR* pLoginName, const TDVCHAR* pBBCUID, const TDVCHAR* pEmail, const TDVCHAR* pPassword, int* oUserID, int* oError, CTDVString* oErrorString, CTDVString* oCookie, int* oFirstTime);
	// moderation SPs
	bool UpdatePostingsModeration(int iForumID, int iThreadID, int iPostID, 
		int iModID, int iStatus, const TDVCHAR* pcNotes, int iReferTo, int iReferredBy, int iThreadModStatus = 0,  bool bNewStyle = false);
	bool FetchNextPostModerationBatch(int iUserID, const TDVCHAR* pcShowType, 
		int iReferrals, bool bFastMod, bool bNotFastMod);
	bool UpdateArticleModeration(int ih2g2ID, int iModID, int iStatus, 
		const TDVCHAR* pcNotes, int iReferTo, int iReferrerID);
	bool FetchNextArticleModerationBatch(int iUserID, const TDVCHAR* pcShowType, int iReferrals);
	bool FetchNextGeneralModerationBatch(int iUserID, int iReferrals);
	bool UpdateGeneralModeration(int iModID, int iStatus, const TDVCHAR* pcNotes, 
		int iReferTo, int iReferredBy);
	bool UpdateNicknameModeration(int iModID, int iStatus );
	bool FetchNextNicknameModerationBatch(int iUserID);

	bool FetchMonthEntrySummary(int iSiteID = 1); //DR
	bool CacheGetTimeOfMostRecentGuideEntry(CTDVDateTime* pDate); //DR
	bool GetHierarchyNodeDetailsViaNodeID(int iNodeID,CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pTypeID, int* pSiteID = NULL, int* pBaseLine = NULL);
	bool GetHierarchyNodeDetailsViaH2G2ID(int iH2G2ID,CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pTypeID, int* pSiteID = NULL, int* pBaseLine = NULL);
	bool GetHierarchyNodeAliases(int iNodeID, bool& bSuccess);//DR
	bool GetHierarchyNodeArticles(int iNodeID, bool& bSuccess, int iType, int iShow, bool bIncludeContentRatingData=false);//DR
	bool GetHierarchyNodeArticlesWithLocal(int iNodeID,  int iType=0, int iMaxResults =500, bool bIncludeContentRatingData = false, int iUserTaxonomyNodeID=0);
	bool GetHierarchyNodesArticles( const std::vector<int>& nodes, int iType = 0 );
	bool GetHierarchyNodeClubs(int iNodeID, bool& bSuccess );//DR
	bool GetHierarchyNodeClubsWithLocal(int iNodeID, int iUserTaxonomyNodeID);
	bool GetRootNodeFromHierarchy(int iSiteID, int* pNodeID); //DR
	bool SetTypeForNodesWithAncestor(const int iAncestor, const int iTypeID, const int iSiteID);
	
	bool UpdateHierarchyDescription(int iNodeID,const TDVCHAR* pDescription,int iSiteID); //DR
	bool UpdateHierarchyDisplayName(int iNodeID,const TDVCHAR* pDisplayName); //DR
	bool UpdateHierarchySynonyms(int iNodeID,const TDVCHAR* pSynonyms, bool &bSuccess); //DR
	bool AddNodeToHierarchy(int iParentID, const TDVCHAR* pDisplayName,int &iNewSubjectID,int iSiteID); //DR
	bool MoveHierarchyNode(int iParentID,int iMovingNode, CTDVString& sErrorReason); //DR
	bool AddAliasToHierarchy(int iNodeID,int iLinkNodeID); //DR
	bool DeleteAliasFromHierarchy(int iLinkNodeId,int iNodeId); //DR
	bool GetClubsInRelatedHierarchiesOfClub(int iClubID,bool& bSuccess); //DR
	bool GetArticlesInRelatedHierarchiesOfClub(int iClubID,bool& bSuccess); //DR
	bool DeleteNodeFromHierarchy(int iNodeID); //DR
	
	bool AddArticleToHierarchy(int iNodeID, int iH2G2ID, int iViewingUser, bool& bSuccess); //DR
	bool AddClubToHierarchy(int iNodeID, int iClubID, int iViewingUser, bool& bSuccess); //DR
	bool AddThreadToHierarchy(int iNodeID, int iThreadID, int iViewingUser, bool& bSuccess);
	bool AddUserToHierarchy(int iNodeID, int iUserID, int iViewingUser, bool& bSuccess);
	
	bool DeleteArticleFromHierarchy(int iH2G2ID, int iNodeID, bool& bSuccess); 
	bool DeleteClubFromHierarchy(int iClubID, int iNodeID, bool& bSuccess); 
	bool DeleteThreadFromHierarchy(int iThreadID, int iNodeID, bool& bSuccess); 
	bool DeleteUserFromHierarchy( int iUserID, int iNodeID, bool& bSuccess );
	
	bool GetNodeIdFromAliasId(int iLinkNodeID); //DR
	bool IsArticleInReviewForum(int iH2G2ID,int iSiteID,int* pReviewForumID = NULL); //DR
	bool GetReviewForums(int iSiteID); //DR
	bool FetchForumFromH2G2ID(int iH2G2ID, int *pForumID);//
	bool FetchReviewForumDetailsViaReviewForumID(int iReviewForumID);
	bool FetchReviewForumDetailsViaH2G2ID(int iH2G2ID);
	bool AddArticleToReviewForumMembers(int iH2G2ID,int iSubmitterID,int iSiteID,int iReviewForumID,const TDVCHAR* sSubject,const TDVCHAR* sContent,int* iForumID,int* iThreadID,int* iPostID, CTDVString* pErrors); //DR
	bool ArticleUpdateSubmittable(int iSubmittable); //DR
	bool ArticleUpdateType(int iType);
	bool ArticleUpdateDateCreated();
	bool FetchReviewForumMemberDetails(int iH2G2ID); //DR
	bool FetchReviewForumThreadsByDateEntered(int iReviewForumID,bool bMostRecentFirst = true); //DR
	bool FetchReviewForumThreadsByLastPosted(int iReviewForumID,bool bMostRecentFirst = true); //DR
	bool FetchReviewForumThreadsByUserID(int iReviewForumID,bool bAscending = true); //DR
	bool FetchReviewForumThreadsByUserName(int iReviewForumID,bool bAscending = true); //DR
	bool FetchReviewForumThreadsByH2G2ID(int iReviewForumID,bool bAscending = true); //DR
	bool FetchReviewForumThreadsBySubject(int iReviewForumID,bool bAscending = true); //DR
	bool CacheGetMostRecentReviewForumThreadDate(int iReviewForumID, CTDVDateTime* pDate); //DR
	bool CacheGetHierarchyMostRecentUpdateTime(CTDVDateTime *oDate);
	bool IsForumAReviewForum(int iForumID, int *iReviewForumID); //DR
	bool FetchPersonalSpaceForum(int iUserID, int iSiteID, int* iForumID); //DR
	bool GetForumFromThreadID(int iThreadID, int* iForumID); //DR
	bool GetH2G2IDFromForumID(int iForumID, int* iH2G2ID); //DR
	bool RemoveArticleFromPeerReview(int iH2G2ID); //DR
	bool UpdateThreadFirstSubject(int iThreadID, const TDVCHAR* sFirstSubject); //DR
	bool SetGuideEntrySubmittable(int iH2G2ID, int iValue); //DR
	bool UpdateReviewForum(int iReviewForumID, const TDVCHAR* sName,const TDVCHAR* sURL, bool bRecommendable,int iIncubateTime); //DR
	bool AddNewReviewForum( const TDVCHAR* sForumName, const TDVCHAR* sURLFriendlyName, int iIncubateTime,
							bool bRecommendable, int iSiteID, int* iReviewForumID, int iUserID,
							CExtraInfo& Extra, int iType ); //DR
	bool FetchAllReviewForumDetails(); //DR
	bool GetModeratorsForSite(int iSiteID); //DR
	bool ForceUpdateEntry(int iH2G2ID); //DR

	bool FetchWatchedJournals(int iUserID);
	
	// checks if this user is currently subbing this entry
	bool CheckIsSubEditor(int iUserID, int iEntryID);
	// fetcha random article
	bool FetchRandomArticle(int iSiteID, int iStatus1 = 3, int iStatus2 = -1, int iStatus3 = -1, int iStatus4 = -1, int iStatus5 = -1);
	// submitting a scouts recommendation
	bool SubmitScoutRecommendation(int iUserID, int iEntryID, const TDVCHAR* pcComments = NULL);
	// submitting a recommendation was it has been subbed
	bool SubmitSubbedEntry(int iUserID, int iEntryID, const TDVCHAR* pcComments = NULL);
	// move a thread to a new forum
	bool MoveThread(int iThreadID, int iForumID);
	// undo the moving of a thread
	bool UndoThreadMove(int iThreadID, int iPostID);
	// fetches the details on a thread moving operation
	bool FetchThreadMoveDetails(int iThreadID, int iForumID);
	// update a Guide Entries list of researchers
	bool UpdateEntryResearcherList(int iEntryID, int iEditorID, int* piResearcherIDArray, int iTotalResearchers);

	bool AddRecommendedUser(int iUserID, int iRecommendedUserID);
	bool VerifyUserKey(int iUserID, int iKey, int* oResult, CTDVString* oReason, CTDVString* oEmail, CTDVDateTime* oDateReleased, int* oActive);
	bool LogUserCancelled(int iUserID, const TDVCHAR* pIPaddress, int iUserCancelled);
	bool FetchEmailText(int iSiteID, const TDVCHAR* pEmailName, CTDVString* pText, 
						CTDVString* pSubject);
	bool CancelUserAccount(int iUserID, const TDVCHAR* pKey, int *piResult, CTDVString* pReason);
	bool ChangePassword(int iUserID, const TDVCHAR* pPassword);
	bool LogRegistrationAttempt(int iUserID, const TDVCHAR* pEmail, const TDVCHAR* pIPaddress);
	bool UnsubscribeFromJournalThread(int iUserID, int iThreadID, int iForumID);
	bool UnsubscribeFromForum(int iUserID, int iForumID);
	bool SubscribeToForum(int iUserID, int iForumID);
	bool UnsubscribeFromThread(int iUserID, int iThreadID, int iForumID);
	bool SubscribeToThread(int iUserID, int iThreadID, int iForumID);
	bool FetchNewUsers(int iNumberOfUnits, const TDVCHAR* pUnitType = "Day", 
						bool bFilterUsers = false,
						const TDVCHAR* pFilterType = NULL,
						int iSiteID = 0,  int iShowUpdatingUsers = 0);

#if defined(_ADMIN_VERSION) // methods only available in the admin version
	bool FetchUsersSecretKey(int iUserID, int* piSecretKey);

	bool FetchUsersMailshotSubscriptions(int iUserID, bool* pbMonthly, bool* pbWeekly, bool* pbDaily, bool* pbOneOff);
	bool UpdateUsersMailshotSubscriptions(int iUserID, bool bMonthly, bool bWeekly, bool bDaily, bool bOneOff);
	bool FetchMailshotDetails(const TDVCHAR* pMailshotName);
	bool FetchMailingListMembers(int iListID);
	bool UpdateUsersSendRequests(int iUserID, int iShotID);
#endif // _ADMIN_VERSION

	int GetIndexOfThreadInForum(int iThreadID, int iForumID);
	bool AddEditHistory(int h2g2ID, int iUserID, int iAction, const TDVCHAR* pReason);
	bool CacheGetKeyArticleDate(const TDVCHAR* pName, int iSiteID, CTDVDateTime* oDate);
	bool CacheGetArticleDate(int h2g2ID, CTDVDateTime* oDate);
	bool CacheGetArticleInfo(int h2g2ID, CTDVDateTime* opDate = NULL, int* opTopicID = NULL, int* opBoardPromoID = NULL);
	bool CacheGetMostRecentThreadDate(int iForumID, CTDVDateTime* pDate);
	bool CacheGetForumMostRecentPost(int iForumID, int iThreadID, int* oPostID, CTDVDateTime* oDate);
	bool CacheGetThreadLastUpdated( int iThreadId, CTDVDateTime* pLastUpdated );
	bool CatGetArticles(int iCatID);
	bool CatGetSubjects(int iNodeID, bool& bSuccess);
	bool GetAncestry(int iNodeID);
	bool CatGetNodeDetails(int iNodeID, CTDVString* pName, int* piCatID, CTDVString* pCatName, CTDVString* pDescription);
	bool ActivateUser(int iUserID, int iSecretKey, CTDVString* pCookie);
	bool MarkForumThreadRead(int iUserID, int iThreadID, int iPostID, bool bForce);
	bool ChangeUserEmailAddress(int iUserID, const TDVCHAR* pOldEmail, const TDVCHAR* pNewEmail, int* piSecretKey, CTDVString* pReport);
	bool StoreEmailRegistration(const TDVCHAR* pEmail, CTDVString* pCookie, CTDVString* pKey, CTDVString* pPassword, int* piUserID, bool* pbExists, bool *pbNew);
	bool ActivateNewEmail(int iUserID, int iKey, CTDVString* pReason);
	bool UpdateUserJournalModerationStatus(int iUserID, int iNewStatus);
	bool PostToJournal(int iUserID, int iJournalID, const TDVCHAR* pUsername, const TDVCHAR* pSubject, const TDVCHAR* pBody, int iSiteID, int iPostStyle, bool bForceModerate = false, bool bIgnoreModeration = false, const TDVCHAR* pIPAddress = NULL, const TDVCHAR* pBBCUID = NULL);
	int GetIndexOfPostInThread(int iThreadID, int iPostID);
	bool UpdateForumModerationStatus(int iForumID,int iNewStatus);
	bool PostToForum(int iUserID, int iForumID, int iReplyTo, int iThreadID, const TDVCHAR *pSubject, const TDVCHAR *pBody, int iPostStyle, int* oThreadID, int* oPostID, const TDVCHAR* pType = NULL, const TDVCHAR* pEventDate = NULL, bool bForceModerate = false,  bool bForcePreMod = false, bool bIgnoreModeration = false, int iClub = 0, int iNodeID = 0, const TDVCHAR* pIPAddress = NULL, const TDVCHAR* pPhrases = NULL, bool bAllowQueuing = false, bool* pbWasQueued = NULL, bool* pbIsPreModPosting = NULL, bool* pbIsPreModerated = NULL, const TDVCHAR* pBBCUID = NULL, bool bIsNotable = false, const TDVCHAR*  pModNotes = NULL);
	bool PostToEndOfThread(int iUserID, int iThreadID, const TDVCHAR *pSubject, const TDVCHAR *pBody, int* oPostID);
	bool GetPostContents(int iReplyTo, int iUserID, int* iForumID, int* iThreadID, CTDVString* sUsername, CTDVString *pSiteSuffix, CTDVString* sBody, CTDVString* pSubject, bool* oCanRead, bool* oCanWrite, int* oPostStyle, int* oPostIndex, int* oUserID);
	bool BeginUpdateArticle(int ih2g2ID);
	bool BeginUpdateArticle(int ih2g2ID, int iUserID);
	bool ArticleUpdateSubject(const TDVCHAR* pSubject);
	bool ArticleUpdateBody(const TDVCHAR* pBody);
	bool ArticleUpdateStyle(int iStyle);
	bool ArticleUpdateStatus(int iStatus);
	bool ArticleUpdateEditorID(int iEditorID);
	bool ArticleUpdateExtraInfo(CExtraInfo& ExtraInfo);
	bool ArticleUpdatePreProcessed(bool bPreProcessed);
	bool ArticleUpdatePermissions(bool bCanRead, bool bCanWrite, bool bCanChangePermissions);
	bool DoUpdateArticle(bool bUpdateContentSignif = false, int iEditingUser = 0);
	bool CreateNewArticle(int iUserID, const TDVCHAR* pSubject, const TDVCHAR* pBody, CExtraInfo& ExtraInfo,int iStyle, int iSiteID, int iSubmittable, int iTypeID, int iStatus, int* pih2g2ID, bool bPreProcessed = false, bool bDefaultCanRead = true, bool bDefaultCanWrite = false, bool bDefaultCanChangePermissions = false, int iForumStyle = 0, int iGroupNumber = 0);
	bool UpdateArticleModerationStatus(int ih2g2ID,int iNewStatus);

	bool BeginUpdateClub(int iClubID,int iUserID, bool bChangeEditor);
	bool ClubUpdateTitle(const TDVCHAR* pTitle);
	bool ClubUpdateBodyText(const TDVCHAR* pBodyText);
	bool ClubUpdateExtraInfo(const CExtraInfo& ExtraInfo);
	bool DoUpdateClub(bool& bSuccess);
	//bool CreateNewUserFromUserID(const TDVCHAR *pUserName,int iUserID,  const TDVCHAR* pEmail, int iSiteID, const TDVCHAR* pFirstName, const TDVCHAR* pLastName );
	bool UpdateClubModerationStatus(int iClubID,int iNewStatus);
	bool GetClubModerationStatus(int iClubID,int &iModerationStatus);

	bool UpdateUsersGroupMembership(int iUserID, int iSiteID, const map<CTDVString, int>& Groups);
	bool BeginUpdateUser(int iUserID, int iSiteID);
	bool SynchroniseUserWithProfile(CTDVString* pFirstNames, CTDVString* pLastName, int iUserID, 
		const TDVCHAR* sEmail, const TDVCHAR* sLoginName, int iSiteID, const WCHAR* pDisplayName, BOOL bIdentitySite);
	bool GetUserFromIDAndLogSession(int iID, int iSiteID);
/*
	bool UserUpdateIsModerator(bool bIsModerator);
	bool UserUpdateIsSub(bool bIsSub);
	bool UserUpdateIsAce(bool bIsAce);
	bool UserUpdateIsFieldResearcher(bool bIsFieldResearcher);
	bool UserUpdateIsSectionHead(bool bIsSectionHead);
	bool UserUpdateIsArtist(bool bIsArtist);
	bool UserUpdateIsGuru(bool bIsGuru);
	bool UserUpdateIsScout(bool bIsScout);
	bool UserUpdateIsGroupMember(const TDVCHAR* pcGroupName, bool bIsMember);
*/
	bool UserUpdateUsername(const TDVCHAR* pUsername);
	bool UserUpdateFirstNames(const TDVCHAR* pFirstNames);
	bool UserUpdateLastName(const TDVCHAR* pLastName);
	bool UserUpdateEmail(const TDVCHAR* pEmail);
	bool UserUpdatePassword(const TDVCHAR* pPassword);
	bool UserUpdateMasthead(int iMasthead);
	bool UserUpdateStatus(int iStatus);
	bool UserUpdateActive(bool bActive);
	bool UserUpdateAnonymous(bool bAnonymous);
	bool UserUpdateCookie(const TDVCHAR* pCookie);
	bool UserUpdateDateJoined(const CTDVDateTime& rDateJoined);
	bool UserUpdateDateReleased(const CTDVDateTime& rDateReleased);
	bool UserUpdateJournal(int iJournal);
	bool UserUpdateSinBin(int iSinBin);
	bool UserUpdateLatitude(double dLatitude);
	bool UserUpdateLongitude(double dLongitude);
	bool UserUpdatePrefSkin(const TDVCHAR* pPrefSkin);
	bool UserUpdatePostcode(const TDVCHAR* pPostcode);
	bool UserUpdateRegion(const TDVCHAR* pRegion);
	bool UserUpdateArea(const TDVCHAR* pArea);
	bool UserUpdateTaxonomyNode(int iNode);
	bool UserUpdatePrefUserMode(int iPrefUserMode);
	bool UserUpdatePrefForumStyle(int iPrefForumStyle);
	bool UserUpdatePrefForumThreadStyle(int iPrefForumThreadStyle);
	bool UserUpdatePrefForumShowMaxPosts(int iPrefForumShowMaxPosts);
	bool UserUpdatePrefReceiveWeeklyMailshot(bool bPrefReceiveWeeklyMailshot);
	bool UserUpdatePrefReceiveDailyUpdates(bool bPrefReceiveDailyUpdates);
	bool UserUpdateAllowSubscriptions(bool bAllowSubscriptions);
	bool DoUpdateUser();

	bool FetchJournalEntries(int iForumID);
	bool ForumGetSource(int& iForumID, int iThreadID, int& iType, int& ID, CTDVString& sTitle, int &iSiteID, int &iUserID, int &iReviewForumID, int& iClubID, int& iAlertInstantly, CTDVString & sFirstNames, CTDVString & sLastName, CTDVString & sArea, int & nStatus, int & nTaxonomyNode, int & nJournal, int & nActive, CTDVString & sSiteSuffix, CTDVString & sSiteTitle, int& iHiddenStatus, int& iArticleStatus, CTDVString& sUrl);
	int ForumGetLatestThreadID(int iForumID);
	bool CreateNewClub(const TDVCHAR* sClubTitle, int iCreator, int iOpenMembership, int iSiteID,const TDVCHAR* sBody, CExtraInfo& ExtraInfo,int &oClubID, int &oH2G2ID, int &oOwnerTeam);
	bool GetUsersMostRecentPosts(int iUserID, int iPostType, int iMaxResults, bool bShowUserHidden = false, int iSiteId = 0);
	bool GetUsersMostRecentEntries(int iUserID, int iWhichType, int iSiteID = 0, int iGuideType = 0);

	bool GetUserNames(CTDVString& sResult);
	bool AddUserID(int iUserID);
	bool BeginFetchUserNames();

	bool GetArticleSubjects(CTDVString& sResult);
	bool GetResearchersFromH2G2id(int ih2g2ID);
	bool GetEntrySubjectFromh2g2ID(int ih2g2ID, CTDVString& sResult);
	int GetEntryStatusFromh2g2ID(int ih2g2ID);
	bool GetGroupsFromUserAndSite(int iUserID, int iSiteID);
	bool AddArticleID(int h2g2ID);
	bool BeginFetchArticleSubjects();
	bool ForumGetThreadPostHeaders(int ThreadID, int iFirstIndex, int iLastIndex);
	bool ForumGetThreadPosts(int ThreadID, int iFirstIndex = 0, int iLastIndex = 2100000000, bool bOrderByDatePostedDesc=false);
	bool GetForumSiteID(int& iForumID, int iThreadID,int &iSiteID);
	bool GetForumModerationStatus(int iForumID, int iThreadID,int &iModerationStatus);
	bool GetThreadList(int ForumID, int iFirstIndex, int iLastIndex, int iThreadOrder);
	bool GetUserStats(int iUserID);
	bool FetchGuideEntry(int h2g2ID, int& oh2g2ID, int& oEntryID, int& oEditor, int& oForumID, int& oStatus, int& oStyle, CTDVDateTime& oDateCreated, CTDVString& oSubject, CTDVString& oText, int& iHidden, int& iSiteID, int& iSubmittable, CExtraInfo& ExtraInfo, int& iTypeID, int& iModerationStatus, CTDVDateTime& oLastUpdated, bool& bPreProcessed, bool& bDefaultCanRead, bool& bDefaultCanWrite, bool& bDefaultCanChangePermissions, int& iTopicID, int& iBoardPromoID,
									   CTDVDateTime& oDateRangeStart, CTDVDateTime& oDateRangeEnd, int& iRangeInterval, int& iLocationCount);
	bool FetchGuideEntry(const TDVCHAR* pName, int& oh2g2ID, int& oEntryID, int& oEditor, int& oForumID, int& oStatus, int& oStyle, CTDVDateTime& oDateCreated, CTDVString& oSubject, CTDVString& oText, int& iHidden, int& iSiteID, int& iSubmittable, CExtraInfo& ExtraInfo, int& iTypeID, int& iModerationStatus, CTDVDateTime& oLastUpdated, bool& bPreProcessed, bool& bDefaultCanRead, bool& bDefaultCanWrite, bool& bDefaultCanChangePermissions, CTDVDateTime& oDateRangeStart, CTDVDateTime& oDateRangeEnd, int& iRangeInterval, int& iLocationCount);
	bool FetchGuideEntryExtraInfo(int h2g2ID, CExtraInfo& ExtraInfo);
	bool ForumGetMostRecent(int iForumID, CTDVString& sResult);
	bool GetUserFromUserID(int iUserID, int iSiteID = 1,bool bLogUserSession = false);
	bool GetUserFromH2G2ID(int iH2G2ID, int iSiteID = 1);
	bool GetUserFromCookie(const TDVCHAR* pCookie, int iSiteID = 0);
	bool GetTopFiveForums(const TDVCHAR* pName);
	bool GetTopFive(const TDVCHAR* pName);
	bool FetchSimpleArticle(const TDVCHAR* pArticleName, int iSiteID, CTDVString& sResult);
	// simple method for getting the summary details of an entry
	bool FetchArticleSummary(int iEntryID, int* pih2g2ID, CTDVString* psSubject, CTDVString* psEditorName, int* piEditorID, int* piStatus, bool* pbIsSubCopy, int* piOriginalEntryID, bool* pbHasSubCopy, int* piSubCopyID, int* piRecommendationStatus, int* piRecommendedByScoutID, CTDVString* psRecommendedByUserName, CTDVString* psComments);
	// fetch details of a particular scout recommendation
	bool FetchRecommendationDetails(int iRecommendationID);
	// fetch details of a particular scout recommendation from the entry id associated with it
	bool FetchRecommendationDetailsFromEntryID(int iEntryID);
	// fetch all the scouts currently recommended articles which have no decision yet
	bool FetchUndecidedRecommendations();
	// fetch all unallocated accepted recommendations
	bool FetchUnallocatedAcceptedRecommendations();
	// fetch all allocated unreturned recommendations
	bool FetchAllocatedUnreturnedRecommendations();
	// fetch all the details we need about the sub editors
	bool FetchSubEditorsDetails();
	// fetch details on all the researchers for a particular entry
	bool FetchEntriesResearchers(int iEntryID,int iSiteID);
	// fetch a subs allocations that they have not yet been notified of
	bool FetchAndUpdateSubsUnnotifiedAllocations(int iSubID);
	// accept a scouts recommendation
	bool AcceptScoutRecommendation(int iRecommendationID, int iUserID, const TDVCHAR* pcComments);
	// reject a scouts recommendation
	bool RejectScoutRecommendation(int iRecommendationID, int iUserID, const TDVCHAR* pcComments);
	// allocate entries to a sub
	bool AllocateEntriesToSub(int iSubID, int iAllocatorID, const TDVCHAR* pComments, int* piEntryIDs, int iTotalEntries);
	// automatically allocate the next X entries to a sub
	bool AutoAllocateEntriesToSub(int iSubID, int iNumberToAllocate, int iAllocatorID, const TDVCHAR* pComments = NULL, int* piTotalAllocated = NULL);
	// deallocate entries from the subs they are allocated to
	bool DeallocateEntriesFromSubs(int iDeallocatorID, int* piEntryIDs, int iTotalEntries);
	// Methods specifically for calling specific stored procedures
	bool FetchTextOfArticle(int h2g2ID, CTDVString& sResult);	// Fetch a whole <H2G2> block
	bool FetchSimpleArticle(int h2g2ID, CTDVString& sResult);	// Fetch an <ARTICLE> block
	bool FetchCurrentUsers(CTDVString& sResult, int iSiteID, bool bSiteOnly = false);  // Fetch an XML block with all the online users

	// Fetch XML for a group of article entries
	bool FetchIndexEntries(const TDVCHAR* sLetter, int iSiteID, CTDVString& sResult, bool bShowApproved, bool bShowSubmitted, bool bShowUnapproved, CTDVString& sGroupFilter, const int iTypesCount = 0, int* pTypesList = NULL, int iOrderBy = 0);

	// Fetch path to the blob requested	inside a <PICTURE/> block
	bool FetchBlobServerPath(int iBlobID, const TDVCHAR* sBGColour, CTDVString& sResult);
	bool FetchKeyBlobServerPath(const TDVCHAR* pBlobName, const TDVCHAR* pBGColour, CTDVString& sResult);

	// returns the total number of registered users we have at the time
	int TotalRegisteredUsers();
	// returns the number of articles in the queue waiting to be approved
	int SubmittedQueueSize();

	// All in the last 10 minutes
	// returns the total number of approved articles on h2g2
	int TotalApprovedEntries(int iSiteID);
	// returns the 10 most prolific posters to forums
	bool FetchProlificPosters(CTDVString& sResult, int iSiteID);
	// returns the 10 most erudite posters to forums
	bool FetchEruditePosters(CTDVString& sResult, int iSiteID);
	// returns the 10 longest posts
	bool FetchMightyPosts(CTDVString& sResult);
	// returns the 20 longest conversations
	bool FetchFreshestConversations(CTDVString& sResult, int iSiteID, int iSkip = 0, int iShow = 20);
	// returns articles updated in the last 24 hours
	bool FetchFreshestArticles(CTDVString& sResult, int iSiteID, int iSkip = 0, int iShow = 20);

	// search the forums for a keyword and return XML for the results
	bool SearchForums(const TDVCHAR* sSearchString, CTDVString& sResult, const CTDVString* psUserGroups, int iSkip, int iShow, int iSiteID, int iForumID, int iThreadID, int* piBestPostID, double* pdBestScore);
	// search the articles for a keyword and return XML for the results
	bool SearchArticles(const TDVCHAR* sSearchString, int iShowApproved, int iShowNormal, int iShowSubmitted, const CTDVString* psUserGroups, CTDVString& sResult, int* piBestEntryID, double* pdBestScore, int iSkip, int iShow, int iSiteID, int iCategory, int iShowContentRatingData, int iArticleType, int iArticleStatus);
	bool SearchArticlesFast(const TDVCHAR* sSearchString, int iShowApproved, int iShowNormal, int iShowSubmitted, const CTDVString* psUserGroups, CTDVString& sResult, int* piBestEntryID, double* pdBestScore, int iSkip, int iShow, int iSiteID, int iCategory, int iShowContentRatingData, int iArticleType);
	bool SearchArticlesFreetext(const TDVCHAR* sSearchString, int iShowApproved, int iShowNormal, int iShowSubmitted, const CTDVString* psUserGroups, CTDVString& sResult, int* piBestEntryID, double* pdBestScore, int iSkip, int iShow, int iSiteID, int iCategory, int iShowContentRatingData, int iArticleType, int iArticleStatus);
	// search the database for a user and return XML for the results
	bool SearchUsers(const TDVCHAR* pUserNameOrEmail, bool bAllowEmailSearch, CTDVString& sResult, int iSkip, int iShow, int* piBestUserID, double* pdBestScore, int iSiteID = 0);

	//Recent Search Recording
	bool GetRecentSearches( int iSiteID );
	bool UpdateRecentSearch( int iSiteID, int Type, const CTDVString& sSearch);

	// recording each new search action
//	bool AddNewArticleSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID,
//									bool bApprovedEntries, bool bSubmittedEntries, bool bNormalEntries,
//									int iBestEntryID, double dBestScore);
//	bool AddNewForumSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID,
//								int iBestPostID, double dBestScore);
//	bool AddNewUserSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID, int iBestUserID, double dBestScore);

	// update a users current active searches
//	bool UpdateUsersActiveSearches(int iUserID);
	// fetch a users currently active searches
//	bool FetchUsersActiveSearches(int iUserID);
// fetch a summary of the active searches needing notification
//bool FetchActiveSearchNotificationsSummary(int* piTotalSearchers, int* piTotalSearches, int* piTotalCategoryMatches, int* piTotalEntryMatches, int* piTotalPostMatches, int* piTotalUserMatches, int* piTotalURLMatches);
//bool UpdateSearchNotificationDates(int iUserID, const CTDVDateTime& dtDateOfNotification);
	// fetch all the data on the active searches needing notification
//	bool FetchActiveSearchNotifications();

	// fetch the groups to which this user belongs
	bool FetchUserGroups(int iUserID, int iSiteID);
	// Find out if the user is subscribed to this thread/forum
	bool IsUserSubscribed(int iUserID, int iThreadID, int iForumID, bool* pbThreadSubscribed, bool* pbForumSubscribed, int* piLastPostCountRead, int* piLastUserPostID);
	
	//fetch user statistics
	bool FetchUserStatistics(int iUserID, int iDisplayMode, CTDVDateTime dtStartDate, CTDVDateTime dtEndDate, int& iRecordsCount);
	//get the date of the users last post
	bool CacheGetFreshestUserPostingDate(int iUserID, CTDVDateTime *oDate);
	
	bool FetchRefereeList();
	bool IsRefereeForAnySite(int iUserID, bool& isReferee);
	bool RemoveFromResearcherList(int iEntryID, int iUserID);
	bool MoveArticleToSite(int ih2g2ID, int iSiteID);
	bool MoveForumToSite(int iForumID, int iSiteID);

	bool FetchClubDetailsViaClubID(int iClubID, bool& bSuccess);
	bool FetchClubDetailsViaH2G2ID(int iH2G2ID, bool& bSuccess);
	static bool GenerateHash(const TDVCHAR* pContent, CTDVString& oResult);

	bool GetHierarchyByTreeLevelAndParent(const int iSiteID);
	bool AddNewHierarchyType(const int iTypeID, const CTDVString& sDescription, const int iSiteID);

	bool GetTopics(int iTopicStatus = 1,int iSiteID = 0);
	bool GetTopicForumIDs(int iTopicStatus = 1, int iSiteID = 0);
	bool GetProfanityGroupList(const int iGroupId);
//	bool CreateNewProfanityGroup(const TDVCHAR* pGroupName);
//	bool AddNewProfanity(const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, const int iRating, const TDVCHAR* pProfanityReplacement);
	bool AddNewProfanity(const TDVCHAR* pProfanity, const int iModClassID, const int iRefer);
	bool UpdateProfanity(const int iProfanityId, const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, const int iRating, const TDVCHAR* pProfanityReplacement);
	bool UpdateProfanity(const int iProfanityId, const CTDVString& sProfanity, const int iModClassId, const int iRefer);
	bool GetAllProfanities();
	bool GetProfanityInfo(const int iProfanityId);
	bool GetProfanityInfoByName(const TDVCHAR* pProfanity);
	bool DeleteProfanity(const int iProfID);
	bool GetProfanityListForSite(const int iSiteId);
	bool GetProfanityListForGroup(const int iGroupId);
	bool GetProfanityGroupInfo(const int iGroupId);
//	bool UpdateProfanityGroup(const int iGroupId, const TDVCHAR* pGroupName);
//	bool AddSiteToProfanityGroup(const int iGroupId, const int iSiteId);
//	bool RemoveSiteFromProfanityGroup(const int iSiteId);
//	bool DeleteProfanityGroup(const int iGroupId);

	bool GetReservedArticles(int iUserID);

	bool FetchGuideEntryDetails(int iH2G2ID);
	bool GetArticlePermissionsForUser(const int iH2G2Id, const int iUserId, bool& bUserFound, 
					bool& bCanRead, bool& bCanWrite, bool& bCanChangePermissions);

	bool GetSiteSpecificContentSignifSettings(int p_iSiteID);
	bool SetSiteSpecificContentSignifSettings(int piSiteID, CTDVString p_param1, CTDVString p_param2, CTDVString p_param3, CTDVString p_param4, CTDVString p_param5, CTDVString p_param6, CTDVString p_param7, CTDVString p_param8, CTDVString p_param9, CTDVString p_param10, CTDVString p_param11, CTDVString p_param12, CTDVString p_param13, CTDVString p_param14, CTDVString p_param15, CTDVString p_param16, CTDVString p_param17, CTDVString p_param18, CTDVString p_param19, CTDVString p_param20, CTDVString p_param21, CTDVString p_param22, CTDVString p_param23, CTDVString p_param24, CTDVString p_param25, CTDVString p_param26, CTDVString p_param27, CTDVString p_param28, CTDVString p_param29, CTDVString p_param30, CTDVString p_param31, CTDVString p_param32, CTDVString p_param33, CTDVString p_param34, CTDVString p_param35);
	bool DecrementContentSignif(int p_iSiteID);
	bool GetMostSignifContent(int p_iSiteID);
	bool GetUserFromIDWithOrWithoutMasthead(int iUserID, int iSiteID);

protected:
	bool FetchReviewForumDetails(int iReviewForumID, bool bIDIsReviewForumID); //DR
	bool FetchClubDetails(int iID, bool bIDIsClubID, bool& bSuccess);
	bool GetUserFromID(int iID, bool bIDIsUserID, int iSiteID = 1);
	bool GetHierarchyNodeDetails2(int iID,bool bIDIsNodeID, CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pTypeID, int* pSiteID, int* pBaseLine);

	int m_SiteID;
	int m_iUpdateBits;
	int m_iItemCount;
	CTDVString m_sUserListUID;

public:
	// Creates a new forum event
	bool CreateForumEvent(CDNAIntArray& iForums, int iAction, CTDVDateTime& dEventTime, int iEventType, int iDayType, bool bDeleteExistingEvents);
	bool GetForumEventInfo(CDNAIntArray& iForums);
	bool DeleteForumEvents(CDNAIntArray& iEvents);
	bool SetForumActiveStatus(CDNAIntArray& iForums, int iActive);
	bool RunScheduledForumEvents(void);
	bool DeleteForumEventsMatching(CDNAIntArray&  iForums, int iAction, int iEventType, int iDayType);

	// Set the visible state of a thread
	bool SetThreadVisibleToUsers(int iThread, int iForumID, bool bVisible);

	// Set the 'archive' status of this article - whether the forum attached to the article is 'read-only'
	bool SetArticleForumArchiveStatus(int iH2G2ID, bool bArchive);

	// Gets the status based on the forum attached to the article
	bool GetArticleForumArchiveStatus(int iH2G2ID, bool& bArchive);
	bool GetGroupMembersForGroup(const TDVCHAR* psGroupName, int iSiteID);
	bool GetMatchingUserAccounts(const TDVCHAR* psFirstNames, const TDVCHAR* psLastName, const TDVCHAR* psEmail);
	/*
	bool GetEntireGuideEntryBatch(const int iFirstInBatch, const int iLastInBatch);
	bool GetGuideEntryBatchHavingUpdates(const int iFirstInBatch, const int iLastInBatch, CTDVDateTime dMoreRecentThan);
	*/
	bool GetCurrentGuideEntryBatchIDs(int iFirstInBatch, CTDVDateTime* p_dMoreRecentThan);
	bool RemoveUsersVote(int iVoteID, int iUserID);
	bool GetAlertsToSend();
	bool DeleteEMailEventsForUserAndSite(int iUserID, int iSiteID, int iEMailType, int iNotifyType);
	bool PostPrivateAlertMessage(int iSendToUserID, int iSiteID, const TDVCHAR* psSubject, const TDVCHAR* psMessage);
	bool SendDNASystemMessage(int piSendToUserID, int piSiteID, const TDVCHAR* psMessageBody);

	// event queue functions
	bool AddToEventQueue(int iET,int iUserID,int iItemID,int iItemType,int iItemID2,int iItemType2);
	bool DeleteAllFromEventQueue();
	bool DeleteByDateFromEventQueue(CTDVDateTime* p_dDate);
	bool SearchArticlesNew(const TDVCHAR* sSearchWords, bool bShowApproved, bool bShowNormal, bool bShowSubmitted, bool bUseANDSearch, int iSiteID, int iCategory, int iMaxResults);
	int GetUpdateBits();
	bool UpdateForumAlertInstantly(int iAlertInstantly, int iForumID);
	//bool GetForumIDForThreadEntry(int iPostID);
	bool GetForumDetails(int iItemID, int iItemType, int iUserID);
	bool GetUsersEmailAlertSubscriptionForItem(int iUserID, int iItemID, int iItemType);
	bool CheckEMailAlertStatus(int iInstantTimeRange, int iNormalTimeRange);
	bool GetBREAKAndPARABREAKArticles();	
	bool GetForumStyle(int iForumID);

	// Message Board FrontPage Element Functions
	bool CreateFrontPageElement(int iSiteID, int iUserID, int iElementType, int iElementStatus, int iElementLinkID, int iFrontPagePos);
	bool DeleteFrontPageElement(int iElementID, int iElementType, int iUserID);
	bool StartUpdateFrontPageElement(int iElementID, int iElementType );
	bool UpdateFrontPageElement(int iUserID, const TDVCHAR* psEditKey);
	void SetFPElementTopicID(int iTopicID);
	void SetFPElementTemplateType(int iTemplateType);
	void SetFPElementTextBoxType(int iTextBoxType);
	void SetFPElementBorderType(int iBorderType);
	void SetFPElementPosition(int iPosition);
	void SetFPElementStatus(int iStatus);
	void SetFPElementLinkID(int iLinkID);
	void SetFPElementTitle(const TDVCHAR* psTitle);
	void SetFPElementText(const TDVCHAR* psText);
	void SetFPElementImageName(const TDVCHAR* psImageName);
	void SetFPElementUseNoOfPosts(int iUseNoOfPosts);
	void SetFPElementTemplateTypeToAllInSite(bool bApplyTemplateToAllInSite);
	void SetFPElementImageWidth(int iImageWidth);
	void SetFPElementImageHeight(int iImageHeight);
	void SetFPElementImageAltText(const TDVCHAR* psImageAltText);
	bool GetFrontPageElementsForSiteID(int iSiteID, int iElementType, int iElementStaus, int iElementStatus2 = -1);
	bool GetFrontPageElementDetails(int iElementID, int iElementType);
	bool GetFrontPageElementsForPhrases(int iSiteID, const std::vector<PHRASE>& lphrases, int iElementType, int iElementStaus );

	bool ArticleUpdateClubEditors(int iClubID);
	bool MakeFrontPageElementActive(int iElementID, int iEditorID, int iElementType);
	bool MakeFrontPageElementsActive(int iSiteID, int iEditorID, int iElementType);

	//message board topic functions
	bool CreateTopic(int& iTopicID, int iSiteID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, int iTopicStatus, int iTopicLinkID); 
	bool EditTopic(int iTopicID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, int iStyle, const TDVCHAR* sEditKey); 
	bool MoveTopicPositionally(int iTopicID, int iDirection, const TDVCHAR* sEditKey);
	bool GetTopicsForSiteID(int iSiteID, int iTopicStatus, bool bIncludeArchivedTopics = false);	
	bool GetTopicDetails(int iTopicID);
	bool DoesTopicAlreadyExist( int iSiteID, const TDVCHAR* psTitle,  int iTopicStatus, bool& bTopicAlreadyExist, int iTopicIDToExclude=0);
	bool DeleteTopic(int iTopicID);	
	bool GetTopicTitle(int iTopicID, CTDVString& sTitle);
	bool GetNumberOfTopicsForSiteID(int iSiteID, int iTopicStatus, int& iNumTopics);
	bool GetNumberOfFrontPageElementsForSiteID(int iSiteID, int iElementType, int iElementStatus, int& iNumElements);
	bool MakePreviewTopicActiveForSite(const int iSiteID, int iTopicID, int iEditorID);
	bool MakePreviewTopicsActiveForSite(const int iSiteID, int iEditorID);

	//message board admin functions
	bool UpdateAdminStatus(int iSiteID, int iType, int iStatus);
	bool UpdateEveryAdminStatusForSite(int iSiteID, int iStatus);
	bool GetMessageBoardAdminStatusIndicators(int iSiteID);


	//Email Moderation Management Functions
	bool FetchEmailVocab(void);
	bool AddNewEmailVocabEntry(const int iSiteID, const CTDVString& sName, const CTDVString& sSubstitution);
	bool RemoveEmailVocabEntry(const int iSiteID, const CTDVString& sName);
	bool FetchEmailTemplate(const int iSiteID, const CTDVString& sTemplateName, const int iModClassID = -1);
	bool AddNewEmailTemplate(const int iModClassID, const CTDVString& sTemplateName, const CTDVString& sSubject, const CTDVString& sBody);
	bool UpdateEmailTemplate(const int iModClassID, const CTDVString& sTemplateName, const CTDVString& sSubject, const CTDVString& sBody);
	bool RemoveEmailTemplate(const int iModClassID, const CTDVString& sTemplateName);
	bool GetEmailTemplates(const int iModClassID, const CTDVString& sViewObject);
	bool CreateEmailTemplateSet(const int iModClassID);
	bool GetEmailTemplateIDByName(const int iViewID, CTDVString& sViewObject, const CTDVString& sTemplateName, int& iTemplateID);

	//Email Moderation Management Inserts
	bool AddSiteEmailInsert( const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sDescription);
	bool AddModClassEmailInsert( const int iModClassID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sDescription);
	bool UpdateSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sDescription);
	bool UpdateModClassEmailInsert(const int iViewID, const CTDVString& sViewObject, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sDescription);
	bool RemoveSiteEmailInsert(const int iSiteID, const CTDVString& sName);
	bool RemoveModClassEmailInsert(const int iModClassID, const CTDVString& sName);
	bool GetEmailInserts(const int iViewID, const CTDVString& sViewObject);
	bool GetEmailInsertGroups(void);
	bool GetEmailInsert(const int iSearchID, const CTDVString& sInsertName);

protected:
	bool Initialise(DBO* pDBO, int iSiteID, CGI* pCGI);

public:
	bool GetFullModeratorList(void);
	bool GiveModeratorsAccess(const TDVCHAR* pAccessObject, int AccessID);
	bool StartAddUserToTempList();
	bool AddUserToTempList(int iUserID);
	bool FlushTempUserList(void);
	bool GetModerationClassList(void);
	bool GetModerationPosts( int iUserId, bool bIsSuperUser, bool bAlerts, bool bReferrals, bool bHeldItems = false, bool bLockedItems = false, int iModClassId = 0, int iPostId = 0, bool bDuplicateComplaints = false, int iShow = 10, bool bFastMod = false);
	bool GetModerationNickNames( int iUserID, bool bSuperUser, bool bAlerts, bool bHeldItems, bool bLockedItems, int iModClassId = 0, int iShow = 10 );
	bool GetModerationMediaAssets ( int iUserID, bool bSuperUser, bool bAlerts, bool bReferrals, bool bHeldItems, bool bLockedItems );
	bool GetModerationArticles(int iUserId, bool bIsSuperUser, bool bAlerts, bool bReferrals, bool bLockedItems, int iModClassId = 0 );
	bool GetSitesModerationDetails( int iUserID = 0, bool bIsSuperUser = false, bool bRefereeFilter = false );
	bool RemoveModeratorAccess(const TDVCHAR* pAccessObject, int AccessID);
	bool FindUserFromEmail(const TDVCHAR* pEmail);
	bool AddNewModeratorToClasses(int iUserID);
	bool GetGroupsAndGroupMembersForSite(int iSiteID);
	bool MakeFrontPageLayoutActive(int iSiteID);
	bool CreateNewModerationClass(const TDVCHAR* pClassName, const TDVCHAR* pDescription, int iBasedOn);
	bool CheckPreModPostingExists(int iModID, bool bCreate = false);

public:	// Polls
	
	bool GetPollDetails(int nPollID);
	bool LinkPollWithItem(int nPollID, int nItemID, int nItemType);
	bool HidePoll(bool bHide, int nPollID, int nItemID, int nItemType);
	bool GetPagePolls(int nItemID, int nItemType);
	bool GetUserVotes(int nPollID, int nUserID);
	bool GetBBCUIDVotes(int nPollID, const TDVCHAR * pBBCUID);
	bool GetPollResults(int nPollID);
	bool GetVoteLinksTotals(int iPollId);
	bool PollContentRatingVote(int nPollID, int nUserID, int nResponse);
	bool PollGetItemIDs(std::vector<int> & vecItemIDs, int nPollID, int nItemType = 0);
	bool PollGetArticleAuthorID(int & nAuthorID, int nArticleID);

	bool GetVotesCastByUser( int iUserID, int iSiteID);

public: // User Groups

	bool FetchGroupsAndMembers();
	bool FetchGroupsForUser(int iUserID);

public:

	bool AddNewModeratorToSites(int iUserID);
	bool ChangeModerationClassOfSite(int iSiteID, int iClassID);
	bool GetNewUnScheduledForumIDsForSiteID(const int iSiteID);
	bool GenerateDuplicateScheduledEventsForNewForums(const int iSiteID, CDNAIntArray& iForums);
	bool GetBoardPromoLocations(int iBoardPromoID);
	bool SetBoardPromoLocations(int iBoardPromoID, CDNAIntArray& TopicList, const TDVCHAR* psEditKey, int iUserID);
	bool GetTopicFromForumID(int iForumID);
	bool GetTopicFromh2g2ID(int ih2g2ID);
	bool CleanUpActiveTopicBoardPromoLocations(int iSiteID);
	bool SetDefaultBoardPromoForTopics(int iSiteID, int iBoardPromoID, int iUserID);
	bool UpdatePreviewSiteConfigData(const TDVCHAR* psSiteConfig, int iSiteID, const TDVCHAR* psEditKey);
	bool FetchPreviewSiteData(int iSiteID);
	bool FetchPreviewSiteConfigData(int iSiteID);
	bool SetBoardPromoName(int iPromoID, const TDVCHAR* psName, const TDVCHAR* psEditKey);
	bool UpdateBoardPromoKeyPhrases( int iBoardPromoID, const std::vector<PHRASE>& vPhrases, bool bDefault = false );
	bool UpdateTextBoxKeyPhrases( int iTextBoxID, const std::vector<PHRASE>& vPhrases);

	// Category List Procedures
	bool CreateCategoryList(int iUserID, int iSiteID, const TDVCHAR* psDescription, const TDVCHAR* psWebSiteURL, int iOwnerFlag);
	bool DeleteCategoryList(CTDVString& sCategoryListID);
	bool AddNodeToCategoryList(CTDVString& sCategoryListID, int iNodeID);
	bool RemoveNodeFromCategoryList(CTDVString& sCategoryListID, int iNodeID);
	bool RenameCategoryList(CTDVString& sCategoryListID, const TDVCHAR* psDescription);
	bool SetListWidth(CTDVString& sCategoryListID, int iListWidth);
	bool GetCategoryListNodes(CTDVString& sCategoryListID);
	bool GetCategoryListLastUpdated(CTDVString& sCategoryListID);
	bool GetCategoryListOwner(CTDVString& sCategoryListID);
	bool GetCategoryListsForUser(int iUserID, int iSiteID);
	bool GetCategoryListForGUID(CTDVString& sCategoryListID);

	// EMail Alert List Procedures
	bool CreateEmailAlertList(int iUserID, int iSiteID, int iEmailType);
	bool AddItemToEmailAlertList(int iItemID, int iItemType, int iNotificationType, CTDVString& sEmailAlertListID, int iEmailType);
	bool GetEMailListsForUser(int iUserID, int iSIteID, int iEmailType);
	bool RemoveItemFromEmailList(int iMemberID, CTDVString& sEmailAlertListID, int iEmailType);
	bool ChangeEMailListTypeForItemMember(int iUserID, int iSiteID, int iMemberID, int iCurrentListType, int iNewListType);
	bool GetItemDetailsFromEMailALertMemberID(int iEMailListType, int iMemberID);
	bool SetNotificationTypeForEmailAlertItem(int iMemberID, int iNotifyType, int iEmailListType, CTDVString& sEmailAlertListID);
	bool GetEMailListForEmailAlertListID(int iEmailListType, const TDVCHAR* psEmailAlertListID);
	bool DisableUsersEmailAlerts(int iUserID, CTDVString sGUID);

	// Dynamic Lists
	bool DynamicListsGetGlobal();
	bool GetDynamicListXML(const TDVCHAR* ListName);
	bool GetDynamicListData(const TDVCHAR* ListName);
	bool GetThreadDetails(int iThreadID);

	// Alert Group Procedures
	bool AddClubAlertGroup(int iUserID, int iSiteID, int iClubID, /*int iNotifyType, int iAlertType, */int& iGroupID, int& iResult);
	bool AddNodeAlertGroup(int iUserID, int iSiteID, int iNodeID, /*int iNotifyType, int iAlertType, */int& iGroupID, int& iResult);
	bool AddThreadAlertGroup(int iUserID, int iSiteID, int iThreadID, /*int iNotifyType, int iAlertType, */int& iGroupID, int& iResult);
	bool AddForumAlertGroup(int iUserID, int iSiteID, int iForumID, /*int iNotifyType, int iAlertType, */int& iGroupID, int& iResult);
	bool AddArticleAlertGroup(int iUserID, int iSiteID, int ih2g2ID, /*int iNotifyType, int iAlertType, */int& iGroupID, int& iResult);

	bool RemoveGroupAlert(int iUserID, int iGroupID);
	bool EditGroupAlert(int iUserID, int iGroupID, int iNotifyType, int iAlertType, int& iResult);
	bool GetGroupAlertsForUser(int iUserID, int iSiteID);
	bool EditGroupAlerts(int iUserID, int iSiteID, int iIsOwner, int iNotifyType, int iAlertType, int& iResult);

	bool GetArticleGroupAlertID(int iUserID, int iSiteID, int ih2g2ID);
	bool GetClubGroupAlertID(int iUserID, int iSiteID, int iClubID);
	bool GetNodeGroupAlertID(int iUserID, int iSiteID, int ihNodeID);
	bool GetForumGroupAlertID(int iUserID, int iSiteID, int iFroumID);
	bool GetThreadGroupAlertID(int iUserID, int iSiteID, int iThreadID);


	//Link Management
	bool GetClubLinkDetails(int iLinkID);
	bool EditClubLinkDetails(int iLinkID, CTDVString& sTitle, CTDVString& sURL, CTDVString& sDescription, int iUserID );
	bool GetLinkTeamID(int iLinkID, int& iTeamID);

	//Members Home Page	
	bool GetTrackedUsers(int iSiteID, int iSkip, int iShow, int iDirection, CTDVString sSortedOn);
	bool SearchTrackedUsers(int iSiteID, CTDVString sSearchOn, CTDVString sUserName, int iUserID, CTDVString sEmail, int iSkip, int iShow, int* piReturn);

	//User Tags
	bool GetUserTags(void);

	//Tracked Users Details
	bool GetTrackedMemberDetails(int iSiteID, int iUserID);
	bool UpdateTrackedMemberProfile(int iUserID, int iSiteID, int iStatus, int iDuration, CTDVString sTagIDs, bool bApplyToAltIDs, bool bAllProfiles);
	bool GetTrackedMemberSummary(int iUserID, int iSiteID);

	bool GetModReasons(int iID, bool bIsModClassID);
	bool GetUserStatuses(void);

	bool GetMediaAsset(int iMediaAssetID, int iContentType = 0);

	bool CreateMediaAsset(int *piMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType, const TDVCHAR* pExtraElementXML, 
									int iUserID, const TDVCHAR* pDescription, bool bAddToLibrary, CTDVDateTime &dtDateCreated, CTDVDateTime &dtLastUpdated,
									int iFileLength, const TDVCHAR* pIPAddress = NULL, bool bSkipModeration = false,
									const TDVCHAR* pExternalLinkURL = NULL );
	
	bool UpdateMediaAsset(int iMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType, const TDVCHAR* pExtraElementXML, 
									int iUserID, const TDVCHAR* pDescription, CTDVDateTime &dtDateCreated, CTDVDateTime &dtLastUpdated, int iHidden,
									const TDVCHAR* pExternalLinkURL = NULL );

	bool MediaAssetUploadQueueAdd(int iMediaAssetID, const TDVCHAR* pServer, bool bAddToLibrary = false, bool bSkipModeration = false);
	bool LinkArticleAndMediaAsset(int iH2G2ID, int iMediaAssetID);
	bool GetArticlesAssets(int iH2G2ID);
	bool RemoveLinkedArticlesAssets(int iH2G2ID);

	bool GetUsersMediaAssets(int iUserID, int iContentType, int iSkip, int iShow, bool bOwner, CTDVString sSortBy);
	bool GetUsersArticlesWithMediaAssets(int iUserID, int iContentType, int iSkip, int iShow, bool bOwner, CTDVString sSortBy);

	bool ModerateMediaAsset( int iModID, int iStatus, const CTDVString& sNotes, int iReferTo, int iUserID);
	bool ModerateMediaAssetByArticleID(int iArticleModID, int iStatus, const CTDVString& sNotes, int iReferTo, int iUserID);

	bool QueueMediaAssetForModeration( int iMediaAssetID, int iSiteID, int iComplainantID = NULL, const TDVCHAR* pcCorrespondenceEmail = NULL, const TDVCHAR* pcComplaintText = NULL );
	bool HideMediaAsset(int iMediaAssetID, int iHiddenStatus);

	// Article Key Phrase
	bool GetKeyPhrasesFromArticle(int iH2G2ID);
	bool GetArticlesWithKeyPhrases(const CTDVString& sPhrases, int iContentType, int iSkip, int iShow, CTDVString sSortBy);
	bool AddKeyPhrasesToArticle( int iH2G2ID, const CTDVString& sPhrases);
	bool AddKeyPhrasesToArticleWithNamespaces( int iH2G2ID, const CTDVString& sPhrases, const CTDVString& sNamespaces);

	bool RemoveKeyPhrasesFromAssets(int iID, CTDVString& sPhrases );
	bool RemoveAllKeyPhrases(int iID, KEYPHRASETYPE eKeyPhraseType);
	bool RemoveKeyPhrasesFromThread(int iThreadID, CTDVString& sPhraseIDs);
	bool RemoveKeyPhrasesFromArticle( int iH2G2ID, std::vector<int> phrasenamespaceids );

	bool GetKeyPhraseArticleHotList( int iSiteId, const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType );
	
	//Upload Limit checker
	bool CheckUsersFileUploadLimit(int iFileLength, int iCurrentUserID);

	bool GetFTPUploadQueue(int iSiteId = 0);
	bool ReprocessFailedUploads( int iSiteID, int iMediaAssetID = 0 );

	bool GetSiteOpenCloseTimes(int iSiteID);
	bool UpdateSiteClosed(int iSiteID, int iClosedStatus);
	bool CloseThread(int iThreadID, bool bHide = false);
	bool ReOpenThread(int iThreadID);
	bool UpdateSiteOpenCloseSchedule(int iSiteID, std::vector<CTDVString>& SQLParamVector);
	bool CreateDailyRecurSchedule(int iSiteID, int iRecurrentEventOpenHours, int iRecurrentEventCloseHours, int iRecurrentEventOpenMinutes, int iRecurrentEventCloseMinutes);
	bool DeleteScheduledEvents(int iSiteID); 

	bool GetDistressMessages( int iModClassId = 0 );
	bool GetDistressMessage( int iMessageId );
	bool AddDistressMessage( int iModClassId, CTDVString sTitle, CTDVString sText );
	bool RemoveDistressMessage( int iMessageID );
	bool UpdateDistressMessage( int iMessageID, int iModClassID, CTDVString sTitle, CTDVString sText );
	bool GetModeratorInfo(int iUserID);

	bool CheckUserPostFreq(int iUserID, int iSiteID, int& iSeconds);

	bool GetAllSiteOptions();
	bool SetSiteOption(int iSiteID, CTDVString& sSection, CTDVString& sName, CTDVString& sValue);
	bool DeleteSiteOption(int iSiteID, CTDVString& sSection, CTDVString& sName);
	bool UserJoinedSite(int UserID, int SiteID);
	bool GetUserPrefStatus(int iUserID, int iSiteID, int* iPrefStatus);

	// User Privacy Functions
	bool GetUserPrivacyDetails(int iUserID);
	bool StartUserPrivacyUpdate(int iUserID);
	bool UpdateUserPrivacyHideLocation(bool bHide);
	bool UpdateUserPrivacyHideUserName(bool bHide);
	bool CommitUserPrivacyUpdates();

	bool SetUsersHideLocationFlag(int iUserID, bool bHide);
	bool SetUsersHideUserNameFlag(int iUserID, bool bHide);

	bool GetAllAllowedURLs();
	bool AddNewAllowedURL(const TDVCHAR* pURL, const int iSiteID);
	bool UpdateAllowedURL(const int iAllowedURLID, const CTDVString& sAllowedURL, 
									 const int iSiteID);
	bool DeleteAllowedURL(const int iAllowedURLID);

	bool UnArchiveTopic(int iTopicID, int iUserID, bool& bValidTopic);
	bool GetUserSystemMessageMailbox(int iUserID, int iSiteID, int iSkip, int iShow);
	bool GetPostingStats(const TDVCHAR* pDate, int interval);

	bool GetMBStatsModStatsPerTopic(int iSiteID, CTDVDateTime& dtDate);
	bool GetMBStatsModStatsTopicTotals(int iSiteID, CTDVDateTime& dtDate);
	bool GetMBStatsTopicTotalComplaints(int iSiteID, CTDVDateTime& dtDate);
	bool GetMBStatsHostsPostsPerTopic(int iSiteID, CTDVDateTime& dtDate);

	bool GetEmailAlertStats(int iSiteID = 0);
	bool UpdateEmailAlertStats(int iTotalEmailsSent, int iTotalPrivateMsgSent, int iTotalFailed, int iUpdateType);

	bool GetUserPostDetailsViaBBCUID(const TDVCHAR* pBBCUID);
	bool GetIsEditorOnAnySite(int iUserID);
	bool GetSitesUserIsEditorOf(int iUserID);
	bool DeleteDNASystemMessage(int iMsgID); 

	bool FetchGuideEntry(int iH2G2ID);

	bool GetHierarchyNodeArticlesWithLocalWithMediaAssets(int iNodeID,  int iType/*=0*/, int iMaxResults /*=500*/, bool bIncludeContentRatingData, int iUserTaxonomyNodeID/*=0*/);
	bool GetHierarchyNodeArticlesWithMediaAssets(int iNodeID, bool& bSuccess,  int iType/*=0*/, int iMaxResults /*=500*/, bool bIncludeContentRatingData);

	bool GetNewUserForSite(int iSiteID, const TDVCHAR* pTimeUnit, int iNoOfUnits, int* pTotal);

	bool SetArticleDateRange(int iEntryID, CTDVDateTime& dStartDate, CTDVDateTime& dEndDate, int iTimeInterval);
	bool RemoveArticleDateRange(int iEntryID);

	bool PollAnonymousContentRatingVote(int nPollID, int nUserID, int nResponse, CTDVString& sBBCUID);


	bool GetHierarchyNodeArticlesWithKeyPhrases(int iNodeID,  int iType = 0, int iMaxResults = 500, bool bShowMediaAssetInfo = false);

	bool GetUsersMostRecentComments(int iUserID, int iSiteId, int iSkip, int iShow );

	bool AddArticleSubscription( int h2g2Id);

	bool GetRecentArticlesOfSubscribedToUsers( int iUserID, int iSiteID ); 
	
	bool GetArticleLocations(int iEntryID);
	bool AddEntryLocations(int ih2g2id, int iUserID, CTDVString& sLocationXML);

	bool IsEmailBannedFromComplaints(CTDVString& sEMail);

	bool GetBookmarkCount(int iH2G2ID, int* iBookmarkCount);
	
	bool IsNickNameInModerationQueue(int iUserID);

	bool GetMemberArticleCount( int iUserID, int siteID, int& userarticlecount );

	bool CreateNewUserFromIdentityID(const TDVCHAR *pIdentityUserID, int iLegacySSOUserID, const TDVCHAR *pUserName, const TDVCHAR* pEmail, int iSiteID, const TDVCHAR* pFirstName, const TDVCHAR* pLastName, const TDVCHAR* pDisplayName);
	bool CreateNewUserFromSSOID(int iSSOUserID, const TDVCHAR *pUserName, const TDVCHAR* pEmail, int iSiteID, const TDVCHAR* pFirstName, const TDVCHAR* pLastName, const TDVCHAR* pDisplayName);

	bool GetDNAUserIDFromSSOUserID(int iSSOUserID, bool& bIDFound);
	bool GetDNAUserIDFromIdentityUserID(const TDVCHAR *pIdentityUserID, bool& bIDFound);
};

#endif // !defined(AFX_STOREDPROCEDURE_H__562B53B1_E8BA_11D3_89EF_00104BF83D2F__INCLUDED_)
