/*********************************************************************************
create Procedure getuservotes @pollid int, @userid int as

	Author:		James Pullicino
	Created:	10/01/2005
	Inputs:		ID of poll and ID of user
	Outputs:	All votes for a user for a poll
	Purpose:	Get all options that a user voted for in a poll
				If poll allowed multiple selection, then multiple
				records can be returned. For single selection polls
				a max of one record is returned.
*********************************************************************************/
create Procedure getuservotes @pollid int, @userid int as
select response from VoteMembers where VoteID=@pollid and UserID=@userid