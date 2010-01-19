#pragma once

#include "XMLBuilder.h"

class CModeratePostsBuilder : public CXMLBuilder  
{
public:
	CModeratePostsBuilder( CInputContext& inputContext );
	~CModeratePostsBuilder(void);

	bool Build(CWholePage* pWholePage);
private:
	bool Process(CWholePage* pPage, CUser* pViewer);
	bool SendAuthorEmail(int iModID, int iStatus, int iSiteID,int iForumID, int iThreadID, int iPostID, int IsLegacy,  CTDVString sCustomText, CTDVString sEmailType, CTDVString sAuthorsEmail, int iAuthorID);
	bool SendComplainantEmail(int iModID, int iStatus, int iSiteID, int iForumID, int iThreadID, int iPostID, int IsLegacy, CTDVString sNotes, CTDVString sCustomText, CTDVString sComplainantsEmail, int iComplainantID);
};

class CModeratePosts : public CXMLObject
{
public:
	//The following status are understood by this class.
	enum STATUS
	{	
		MODERATEPOSTS_UNLOCKED = 0,
		//MODERATEPOSTS_LOCKED_LEGACY = 1, - Unused Status.
		MODERATEPOSTS_REFER = 2,
		MODERATEPOSTS_CONTENTPASSED = 3,
		MODERATEPOSTS_CONTENTFAILED = 4,
		//MODERATEPOSTS_UNREFER = 5,
		MODERATEPOSTS_CONTENTFAILANDEDIT = 6,
		MODERATEPOSTS_HOLD = 7,
		MODERATEPOSTS_CONTENTPASSANDEDIT = 8
	};

	CModeratePosts( CInputContext& InputContext) : CXMLObject(InputContext) {}

	bool GetPosts(int iUserID ,bool bAlerts, bool bReferrals, bool bLockedItems, bool bHeldItems, int iModClassId = 0, int iPostId = 0, int iShow = 10, bool bFastMod = false);
	bool Update(int iModID, int iSiteID, int iForumID, int& iThreadID, int& iPostID, int iUserID, 
		int iStatus, int iReferTo, int iModStatus, CTDVString sNotes,
		int& IsLegacy, int& iProcessed, CTDVString& sAuthorsEmail, std::vector<CTDVString>& sComplainantsEmail, 
		int& iAuthorID, std::vector<int>& vComplainantsID, std::vector<int>& vComplaintModId );

	bool UnlockModeratePostsForUser( int iUserID, int iModClassID = 0 );
	bool UnlockModeratePostsForSite( int iUserID, int iSiteID, bool bIsSuperUser = false );
	bool UnlockModeratePosts( int iUserID, bool bIsSuperUser = false );
};
