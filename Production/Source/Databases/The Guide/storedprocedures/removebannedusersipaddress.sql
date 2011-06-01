Create Procedure removebannedusersipaddress		@userid int
As
	
	delete from dbo.BannedIPAddress
	where userid=@userid
