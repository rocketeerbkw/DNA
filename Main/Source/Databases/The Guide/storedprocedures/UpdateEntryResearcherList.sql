/*
	Updates the researcher list for a specific entry by first deleting all
	current researchers, then inserting the ones provided.
	Only does up to 20 user IDs so if more than this needed they must be
	added seperately using AddEntryResearchers
*/

create procedure updateentryresearcherlist
	@entryid int,
	@id0 int = null,	@id10 int = null,
	@id1 int = null,	@id11 int = null,
	@id2 int = null,	@id12 int = null,
	@id3 int = null,	@id13 int = null,
	@id4 int = null,	@id14 int = null,
	@id5 int = null,	@id15 int = null,
	@id6 int = null,	@id16 int = null,
	@id7 int = null,	@id17 int = null,
	@id8 int = null,	@id18 int = null,
	@id9 int = null,	@id19 int = null
as

BEGIN TRANSACTION
DECLARE @ErrorCode INT

-- first delete all the current researchers for this entry
delete from Researchers where EntryID = @entryid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT 'Success' = 0
	RETURN @ErrorCode
END

-- then insert the new ones, if there are any
insert into Researchers (EntryID, UserID)
	select @entryid, UserID
	from Users
	where UserID in (@id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9, @id10, @id11, @id12, @id13, @id14, @id15, @id16, @id17, @id18, @id19)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	SELECT 'Success' = 0
	RETURN @ErrorCode
END

COMMIT TRANSACTION

-- finally return a success field
select 'Success' = 1
return (0)
