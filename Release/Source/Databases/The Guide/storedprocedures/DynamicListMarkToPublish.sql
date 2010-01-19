-- Marks a list to be published by dlistupdateservice
create procedure dynamiclistmarktopublish @id int
as
begin transaction
update dynamiclistdefinitions set PublishState = 1
where id = @id and PublishState = 0
declare @ErrorCode int
set @ErrorCode = @@ERROR
if(@ErrorCode <> 0)
begin
rollback transaction
return @ErrorCode
end
commit transaction