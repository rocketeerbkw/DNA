/*********************************************************************************
create Procedure getbbcuidvotes @pollid int, @bbcuid uniqueidentifier as

	Author:		James Pullicino
	Created:	02/02/2005
	Inputs:		ID of poll and BBCUID
	Outputs:	All votes for a user for a poll
	Purpose:	Get all options that a user with a BBCUID voted for in a poll
				If poll allowed multiple selection, then multiple
				records can be returned. For single selection polls
				a max of one record is returned.
*********************************************************************************/
create Procedure getbbcuidvotes @pollid int, @bbcuid uniqueidentifier as
select response from VoteMembers where VoteID=@pollid and UID=@bbcuid