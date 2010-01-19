create procedure getmodreasons @modclassid int = 0, @siteid int = 0
as
begin
	if (@modclassid = 0 AND @siteid != 0)
	begin
		select @modclassid = modclassid from sites where siteid = @siteid
	end
	
	if ( @modclassid != 0 )
	begin
	select M.ReasonID, M.DisplayName, M.EmailName, M.EditorsOnly 
		from ModReason M
		inner join EmailInserts E on E.InsertName = M.EmailName and E.ModClassID = @modclassid	
	end
	else
	begin
		select M.ReasonID, M.DisplayName, M.EmailName, M.EditorsOnly 
		from ModReason M
	end
	return @@ERROR
end