// ContentRatingPoll.h
// Prototype for content rating poll class
// James Pullicino
// 20th Jan 2005

#pragma once

#include "Poll.h"
#include "Polls.h"

/*********************************************************************************

	class CPollContentRating : public CPoll

		Author:		James Pullicino
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Implements a content rating poll

*********************************************************************************/

class CPollContentRating : public CPoll
{

public:
	CPollContentRating(CInputContext& inputContext, int nPollID = -1);
	virtual ~CPollContentRating();

protected:
	virtual bool Vote();
	virtual bool RemoveVote();
	virtual bool UnhandledCommand(const CTDVString & sCmd);
	virtual bool HidePoll(bool bHide, int nItemID=0,  ItemType nItemType=ITEMTYPE_UNKNOWN);
	virtual bool LinkPoll(int nItemID, ItemType nItemType);

private:
	void AddPollErrorCodeToURL(CTDVString & sURL, ErrorCode Code, const TDVCHAR * pDescription=0);
	const PollType GetPollType() const { return POLLTYPE_CONTENTRATING; }

public:
	void SetContentRatingStatistics(int nVoteCount, double dblAverageRating);
};