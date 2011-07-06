create procedure getuserstatus  @userid int =0
as 
begin
	select status from Users where userid=@userid

end