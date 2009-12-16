
/*********************************************************************************
	getpagepolls @itemid int, @itemtype int
	
	Author:		James Pullicino
	Created:	10/01/2005
	Inputs:		ItemID and ItemType (GuideEntryType)
	Outputs:	Returns all PollIDs for this page
	Purpose:	Get all polls for a page
*********************************************************************************/
	
create procedure getpagepolls @itemid int, @itemtype int
as
select pv.VoteId, pv.Hidden, v.type
from PageVotes pv
inner join Votes v ON v.VoteId = pv.VoteId
where ItemID=@itemid and ItemType=@itemtype
