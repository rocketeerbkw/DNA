/*
	Allocates up to 50 entries to a particular sub editor, if they are not already allocated.
	Also returns fields showing the status of those entries in the AcceptedRecommendations
	table after the update is done, which can then be scrutinised to check if the update
	was successful.
*/

create procedure allocateentriestosub
	@subid int,
	@allocatorid int,
	@comments varchar(4000) = null,
	@id0 int = null,
	@id1 int = null,
	@id2 int = null,
	@id3 int = null,
	@id4 int = null,
	@id5 int = null,
	@id6 int = null,
	@id7 int = null,
	@id8 int = null,
	@id9 int = null,
	@id10 int = null,
	@id11 int = null,
	@id12 int = null,
	@id13 int = null,
	@id14 int = null,
	@id15 int = null,
	@id16 int = null,
	@id17 int = null,
	@id18 int = null,
	@id19 int = null,
	@id20 int = null,
	@id21 int = null,
	@id22 int = null,
	@id23 int = null,
	@id24 int = null,
	@id25 int = null,
	@id26 int = null,
	@id27 int = null,
	@id28 int = null,
	@id29 int = null,
	@id30 int = null,
	@id31 int = null,
	@id32 int = null,
	@id33 int = null,
	@id34 int = null,
	@id35 int = null,
	@id36 int = null,
	@id37 int = null,
	@id38 int = null,
	@id39 int = null,
	@id40 int = null,
	@id41 int = null,
	@id42 int = null,
	@id43 int = null,
	@id44 int = null,
	@id45 int = null,
	@id46 int = null,
	@id47 int = null,
	@id48 int = null,
	@id49 int = null
as

BEGIN TRANSACTION
DECLARE @ErrorCode INT

-- now update the AcceptedRecommendations table for each entry if it has a status of 1
update AcceptedRecommendations
set SubEditorID = @subid, AllocatorID = @allocatorid, DateAllocated = getdate(), Comments = isnull(@comments, Comments), Status = 2
where Status = 1 and EntryID IN (@id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
								 @id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
								 @id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
								 @id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
								 @id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


EXEC @ErrorCode = ChangeEditorOnMultipleArticles @subid, @id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
															@id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
															@id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
															@id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
															@id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


COMMIT TRANSACTION

-- extract the current sub editor, date allocated, and status of the entries
-- so that these fields can be examined by the caller to check the success
-- if necessary
select AR.EntryID, G.h2g2ID, G.Subject, AR.SubEditorID, U.Username, AR.DateAllocated, AR.Status
from AcceptedRecommendations AR
inner join GuideEntries G on G.EntryID = AR.EntryID
inner join Users U on U.UserID = AR.SubEditorID
where AR.EntryID IN (@id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
					 @id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
					 @id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
					 @id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
					 @id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49)

return (0)

