
/*********************************************************************************

	create procedure hidepoll	@hide bit,@pollid int,@itemid int = 0,@itemtype int = 0

	Author:		James Pullicino
	Created:	12/01/2005
	Inputs:		@hide - 1=hide 0=unhide
				@pollid		- ID of poll
				@itemid		- ID of item poll is attached to
				@itemtype	- Type of item poll is attached to
				
				Note: If ItemID and ItemType are BOTH 0, poll will be un/hidden for
				all items its attached to
				
	Outputs:	none
	Returns:	nothing
	Purpose:	Hide/Unhide a poll
	
*********************************************************************************/
	
create procedure hidepoll	@hide bit,
								@pollid int,
								@itemid int = 0,
								@itemtype int = 0
as
begin transaction
declare @ErrorCode int
if(@itemid = 0 AND @itemtype = 0) update pagevotes set hidden = @hide where voteid = @pollid
else update pagevotes set hidden = @hide where ItemID=@itemid and ItemType=@itemtype and voteid = @pollid
select @ErrorCode = @@ERROR
if(@ErrorCode <> 0)
begin
	rollback transaction
	exec Error @ErrorCode
	return @ErrorCode
end
commit transaction
return (0)