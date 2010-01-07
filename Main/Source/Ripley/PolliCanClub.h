// PolliCanClub.h
// James Pullicino
// 29th Jan 2005
// Header file for iCan poll class

#pragma once

#include "poll.h"

/*********************************************************************************

	class CPolliCanClub : public CPoll

		Author:		James Pullicino
        Created:	26/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Implements ICan voting features in new poll framework

*********************************************************************************/

class CPolliCanClub : public CPoll
{
public:
	CPolliCanClub(CInputContext& inputContext, int nPollID = -1);
	~CPolliCanClub();

protected:
	bool LoadPollResults(resultsMap& pollResults, int& nUserVote);
	bool ViewVote();
	bool AddClubLinksXml(int iClubId);
	bool AddPollXml();
	bool GetCommonInfo(int& m_iObjectID, int& m_iUserID);
	bool AddUserXml(int iUserId);
	bool AddRootXml();

private:
	bool Vote();
	bool internalVote(int & m_iObjectID);
	bool RemoveVote();
	//bool SubmitURL(); moved to CClub and CClubBuilder (jamesp 15/june/05)
	bool DispatchCommand(const CTDVString & sCmd);
	const PollType GetPollType() const { return POLLTYPE_CLUB; }
	bool LinkPoll(int nItemID, ItemType nItemType);
	bool LoadCurrentUserVote(int & nUserVote);
	bool RealGetCommonInfo(int& iObjectId, int& iUserId);
};