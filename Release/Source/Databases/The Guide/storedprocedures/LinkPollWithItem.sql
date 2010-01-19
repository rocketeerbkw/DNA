create procedure linkpollwithitem @pollid int, @itemid int, @itemtype int as
begin transaction
insert into PageVotes (VoteID, ItemID, ItemType, Hidden) values (@pollid, @itemid, @itemtype, 0)
declare @ErrorCode int
select @ErrorCode = @@ERROR
if(@ErrorCode <> 0)
begin
	rollback transaction
	exec Error @ErrorCode
	return @ErrorCode
end
commit transaction
return (0)