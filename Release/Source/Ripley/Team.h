// Team.h: interface for the CTeam class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TEAM_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_)
#define AFX_TEAM_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "TDVAssert.h"
#include "User.h"
class CTeam  : public CXMLObject
{
public:
	CTeam(CInputContext& inputContext);
	virtual ~CTeam();

	bool GetAllTeamMembers(int iTeamID);
	bool GetTeamMembersSubSet(int iTeamID, int& show, int& numSkip);
	bool GetClubIDAndClubTeamsForTeamID(int iTeamID, CTDVString& sTeamType, int& iClubID);
	void SetType(const TDVCHAR* sType);
	bool IsUserAMemberOfThisTeam(int iTeamID, int iUserID, bool& bIsMember);
	bool GetForumIDForTeamID(int iTeamID, int& iForumID);
protected:

	CTDVString m_sType;
};

#endif // !defined(AFX_TEAM_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_)
