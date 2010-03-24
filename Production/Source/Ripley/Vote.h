// Vote.h: interface for the CVote class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_VOTE_H__85D4E8DF_291C_4BA8_A520_72750293851B__INCLUDED_)
#define AFX_VOTE_H__85D4E8DF_291C_4BA8_A520_72750293851B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "TDVDateTime.h"
#include "TDVString.h"

class CVote : public CXMLObject  
{
public:
	CVote(CInputContext& inputContext);
	virtual ~CVote();

public:
	bool IsUserAuthorisedToCreateVote(int iItemID, int iVoteType, int iUserID, bool& bIsAuthorised);
	bool HasUserAlreadyVoted(int iVoteID, int iUserID, CTDVString& sBBCUID, bool& bAlreadyVoted);
	bool IsVoteClosed(bool& bClosed);
	bool AddVoteToClubTable(int iVoteID, int iClubID, CTDVString* psClubName = NULL);
	bool AddVoteToThreadTable(int iVoteID, int iThreadID);
	bool GetObjectIDFromVoteID(int iVoteID, int iType, int& iObjectID);
	int CreateVote(int iType, CTDVDateTime& dClosingDate, int iOwnerID, bool bUseYesNoVoting);
	bool AddResponceToVote(int iVoteID, int iUserID, CTDVString& sBBCUID, int iResponse, bool bVisible, int iThreadID = 0);
	bool GetAllUsersWithResponse(int iVoteID, int iResponse);
	bool GetVote(int iVoteID);

	int GetVoteID()								{ return m_iVoteID; }
	void GetVoteName(CTDVString& sName)			{ sName = m_sVoteName; }
	int GetType()								{ return m_iType; }
	void GetCreatedDate(CTDVDateTime& dCreated)	{ dCreated = m_dCreatedDate; }
	void GetClosingDate(CTDVDateTime& dClosing)	{ dClosing = m_dClosingDate; }
	bool IsVotingYesNo()						{ return m_bIsYesNoVoting; }
	int	GetOwner()								{ return m_iOwnerID; }

	void ResetVote();
	bool RemoveUsersVote(int iVoteID, int iUserID);
	
	bool GetVotesCastByUser( int iUserID, int iSiteID);

protected:
	void ClearVote();

private:
	int				m_iVoteID;
	CTDVString		m_sVoteName;
	int				m_iType;
	CTDVDateTime	m_dCreatedDate;
	CTDVDateTime	m_dClosingDate;
	bool			m_bIsYesNoVoting;
	int				m_iOwnerID;

};

#endif // !defined(AFX_VOTE_H__85D4E8DF_291C_4BA8_A520_72750293851B__INCLUDED_)
