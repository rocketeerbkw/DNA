// Club.h: interface for the CClub class.
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

#if !defined(AFX_CLUB_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_)
#define AFX_CLUB_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "User.h"
#include "XMLObject.h"
#include "MultiStep.h"
#include "DNAArray.h"

class CInputContext;
class CExtraInfo;
class CDNAIntArray;



class CClub : public CXMLObject  
{
public:
	CClub(CInputContext& inputContext);
	virtual ~CClub();

public:

	bool GetClubVoteDetails(int iClubID, int iVoteID, CTDVString& sXML);
	bool UpdateUsersRole(int iUserID, CTDVString& sRole);
	bool DoesUserBelongToClub(int iUserID, int iClubID, bool& bUserBelongs);
	bool GetAllPostsForClubForum(int iForumID, CTDVString& sClubPostsXML, int& iTotalThreads, int& iNewThreads);
	bool FindAllClubsThatUserBelongsTo(int iUserID, CTDVString &sAllClubsXML);
	bool GetEditableClubLinkGroups(int iUserID);
	bool GetAllEditableClubs(int iUserID);
	bool CanUserEditClub(int iUserID, int iClubID);
	bool GetAllPendingAndCompletedActionsForClub(int iClubID, CTDVString &sActionsXML, int& iPending, int& iCompleted);
	bool GetUsersStatusForClub(int iUserID, int iClubID,CTDVString& sStatus, CTDVString& sRole);
	bool GetNumberOfMembers(int iTeamID, int iInPastNumberOfDays, CTDVString& iTotalMembers, CTDVString& iNewMembers);
	int GetClubForumType();
	bool GetClubPermissions(int iUserID, int iClubID);
	bool GetUserActionList(int iUserID, int iSkip, int iShow);
	bool GetClubActionList(int iClubID, CUser* pUser, int iSkip, int iShow);
	enum ActionType {	ACTION_NONE					= 0, 
						ACTION_JOINMEMBER			= 1, 
						ACTION_JOINOWNER			= 2, 
						ACTION_INVITEMEMBER			= 3, 
						ACTION_INVITEOWNER			= 4, 
						ACTION_OWNERTOMEMBER		= 5,
						ACTION_OWNERRESIGNS			= 6,
						ACTION_MEMBERRESIGNS		= 7, 
						ACTION_OWNERDEMOTESOWNER	= 8, 
						ACTION_OWNERREMOVESOWNER	= 9, 
						ACTION_OWNERREMOVESMEMBER	= 10
					};
	bool PerformAction(int iClubID, CUser* pUser, int iActionUserID, ActionType iActionType, const int iSiteID);
	bool CompleteAction(int iActionID, CUser* pUser, int iActionResult);
	bool InitialiseViaClubID(int iClubID, bool bShowHidden = false);
	bool InitialiseViaH2G2ID(int ih2g2ID, bool bShowHidden = false);
	bool CreateClub(int &iClubID, bool& bCreatedClub, CDNAIntArray& NodeArray, bool& bProfanityFound, bool& bNonAllowedURLsFound, bool& bEmailAddressFound );
	bool PreviewClub(CTDVString& sTitle, CTDVString& sGuideML);
	bool UpdateClub(const CTDVString& sTitle,const CTDVString& sBodyText,const CExtraInfo& NewExtraInfo);
	bool GetVoteIDForClubID(int iClubID, int& iVoteID);
	bool GetDataFromMultiStep(CMultiStep& Multi, CTDVString& sTitle, 
		const char* pPicture, const char* pPreviewPicture, CTDVString& sGuideML);
	
	bool CreateRelatedMembersXML(int iClubID,CTDVString& sRelatedMembersXML);

	void SetLabel(const TDVCHAR* sLabel);
	
	bool IsInitialised();
	bool IsDeleted();
		
	int GetClubID();
	int GetMemberTeamID();
	int GetOwnerTeamID();
	int GetJournalID();
	int GetForumID();
	int GetSiteID();
	int GetStatus();
	void GetName(CTDVString &sName);
	int GetArticleID();
	void GetGuideML(CTDVString &sBodyXML);

	int GetClubModerationStatus();
	bool UpdateClubModerationStatus(int iClubID, int iNewStatus);
	static bool UpdateClubModerationStatus(CInputContext& inputContext, int iClubID, int iNewStatus);

	bool IsUserInOwnerMembersOfClub(int iUserID, int iClubID);
	bool IsUserInTeamMembersOfClub(int iUserID, int iClubID);
	bool IsUserAllowedToEditClub(CUser* pUser, int iClub);

	bool EditClub(CMultiStep& Multi, int iClubID);
	bool EditClubPreview(int iClubID, CMultiStep& Multi, CTDVString& sTitle, CTDVString& sGuideML);
	bool GetMultiStepInput(CMultiStep& Multi, const char* pPicture,
		const char* pPreviewPicture, CTDVString& sTitle, CTDVString& sGuideML);


	bool AddLink(CUser* pUser,const TDVCHAR* pDestType,int iDestID,const TDVCHAR* pRelationship, 
		const TDVCHAR* pUrl, const TDVCHAR* pTitle,
		const TDVCHAR* pDescription);

	bool AddUrl(const TDVCHAR* sUrl, const TDVCHAR* sTitle, const TDVCHAR* sDescription, const TDVCHAR* sRelationship);

	bool Delete();
	bool UnDelete();

	static enum ClubStatus {OPEN = 1, CLOSED};

protected:
	bool Initialise(int iID, bool bIDIsClubID, bool bShowHidden);
	bool CreateElement(CTDVString& sElement,CTDVString& sElementValue,
									 CTDVString& sElementXML);
	bool GetAllElementsAsXMLString(CInputContext& inputContext,
												 CTDVString &sXMLElements);
	void Clean();
	bool AddParameterAsXML(const TDVCHAR* sElementName,CTDVString sParameter,
								CTDVString& sXML);

	void AddToExtraInfo(CExtraInfo& extrainfo, const TDVCHAR* pTagName, const CTDVString& sDescription);
	void GetTextFromGuideML(const CTDVString& sGuideML, CTDVString& sResult);
	bool UploadImageIfSubmitted(CTDVString& sImageName);
	bool IsImageSubmitted();

	bool CreateUserBlock(CTDVString & sXML, CTDVString sUserType, CStoredProcedure & SP);

protected:

	int m_iClubID;
	int m_ih2g2ID;
	int m_iOwnerTeamID;
	int m_iMemberTeamID;
	int m_iJournalID;
	int m_iForumID;
	int m_iSiteID;
	int m_iClubForumType;
	CTDVString m_sName;
	CTDVString m_sLabel;
	int m_iStatus;
	bool m_bInitialised;
	CTDVDateTime m_dDateCreated;
	CTDVDateTime m_dLastUpdated;
	int m_iHidden;
	CTDVString m_sGuideML;
	int m_iGuideStatus;
	int m_iProfanityTriggered;
	int m_iNonAllowedURLTriggered;

	int m_PermissionUser;
	int m_PermissionClub;
	bool m_bCanAutoJoinMember;
	bool m_bCanAutoJoinOwner;
	bool m_bCanBecomeMember;
	bool m_bCanBecomeOwner;
	bool m_bCanApproveMembers;
	bool m_bCanApproveOwners;
	bool m_bCanDemoteOwners;
	bool m_bCanDemoteMembers;
	bool m_bCanViewActions;
	bool m_bCanView;
	bool m_bCanEdit;

	int m_iClubType;
};

/*********************************************************************************

	inline bool CClub::IsInitialised()

	Author:		Dharmesh Raithatha
	Created:	5/14/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if the club has been initialised false, otherwise
	Purpose:	Returns the initialised status of the club

*********************************************************************************/

inline bool CClub::IsInitialised()
{
	return m_bInitialised;
}

inline int CClub::GetClubID(){return m_iClubID;};
inline 	int CClub::GetMemberTeamID(){return m_iMemberTeamID;};
inline 	int CClub::GetOwnerTeamID(){return m_iOwnerTeamID;};
inline 	int CClub::GetJournalID(){return m_iJournalID;};
inline 	int CClub::GetForumID(){return m_iForumID;};
inline 	int CClub::GetSiteID(){return m_iSiteID;};
inline 	int CClub::GetStatus(){return m_iStatus;};
inline 	void CClub::GetName(CTDVString &sName){sName = m_sName;};
inline int CClub::GetArticleID(){return m_ih2g2ID;};
inline int CClub::GetClubForumType(){return m_iClubForumType;};
inline 	void CClub::GetGuideML(CTDVString &sGuideML){sGuideML= m_sGuideML;};
	
#endif // !defined(AFX_CLUB_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_)
