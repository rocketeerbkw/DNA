create procedure insertdistressmessage @parentid int, @distressmessageid int
as
begin
	if (not exists (select * from dbo.ThreadEntryDistressMessage where ParentEntryID = @parentid and DistressMessageId = @distressmessageid))
	begin
		insert into dbo.ThreadEntryDistressMessage (ParentEntryID, DistressMessageId) values (@parentid, @distressmessageid)	
	end
end