
/*********************************************************************************

	CREATE PROCEDURE pollgetitemids @pollid int, @itemtype int

	Author:		James Pullicino
	Created:	21/02/2005
	Inputs:		- poll id
				- item type. If 0, item ids of all types are returned
	Outputs:	ItemID and ItemType fields
	Returns:	-
	Purpose:	Get item ids that a poll is linked to
*********************************************************************************/
CREATE PROCEDURE pollgetitemids @pollid int, @itemtype int as
if (@itemtype = 0) begin
	select ItemID, ItemType from dbo.PageVotes WITH(NOLOCK) where VoteID = @pollid
end
else begin
	select ItemID, ItemType from dbo.PageVotes WITH(NOLOCK) where VoteID = @pollid AND ItemType = @itemtype
end