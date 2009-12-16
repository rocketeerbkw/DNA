create procedure getipaddressforthreadentry @entryid int, @userid int, @reason varchar(MAX), @modid int
as
begin
	declare @ipaddress varchar(25)
	declare @dateposted datetime
	if (@entryid <> 0)
	begin
	select @ipaddress = IPAddress, @dateposted = t.DatePosted from ThreadEntriesIPAddress a WITH(NOLOCK) 
		join ThreadEntries t WITH(NOLOCK) on t.EntryID = a.EntryID
		where a.EntryID = @entryid
	end
	else
	begin
		select @ipaddress = IPAddress, @dateposted = DatePosted from PreModPostings WITH(NOLOCK) 
		where ModID = @modid
	end

	if (@ipaddress is null)
		set @ipaddress = 'no ipaddress stored'

	insert into IPLookupReason (EntryID, Reason, UserID, DataShown)
	values (@entryid, @reason, @userid, @ipaddress)

	select 'IPaddress' = @ipaddress, 'DatePosted' = @dateposted
end