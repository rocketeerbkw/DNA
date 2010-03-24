create procedure getuserstatuses
as 
begin
	select * from UserStatuses
	
	return @@ERROR
end