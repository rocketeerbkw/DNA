// PollNoticeBoard.h
// James Pullicino
// 31st Jan 2005
// Header file for iCan notice board voting class

#pragma once

#include "poll.h"

/*********************************************************************************

	class CPollNoticeBoard : public CPoll

		Author:		James Pullicino
        Created:	31/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Implements voting features for iCan notice boards in new
					polling system

*********************************************************************************/

class CPollNoticeBoard : public CPoll
{

public:
	CPollNoticeBoard(CInputContext& inputContext, int nPollID = -1);
	~CPollNoticeBoard();

private:
	bool Vote();
	bool internalVote(int & m_iObjectID);

	bool RemoveVote();
	bool internalRemoveVote();

	const PollType GetPollType() const { return POLLTYPE_NOTICE; }

	bool LinkPoll(int nItemID, ItemType nItemType);
	
	bool LoadCurrentUserVote(int & nUserVote);
};
