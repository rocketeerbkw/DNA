Create Procedure addbannedusersipaddress		@userid int
As
	if exists(select userid from [dbo].[BannedIPAddress] where userid=@userid)
	BEGIN
		exec removebannedusersipaddress @userid
	END
	
	
	insert into [dbo].[BannedIPAddress]
	select distinct te.userid, teia.ipaddress, teia.bbcuid
	from dbo.ThreadEntriesIPAddress teia
	inner join dbo.threadentries te on te.entryid=teia.entryid
	inner join dbo.users s on s.userid=te.userid
	inner join dbo.preferences p on p.userid = s.userid
	where p.prefstatus=4
	and s.userid=@userid