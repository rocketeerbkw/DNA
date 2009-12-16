-- Marks a list to be published by dlistupdateservice
create procedure dynamiclistmarktounpublish @id int
as
begin transaction
update dynamiclistdefinitions set PublishState = 3
where id = @id and PublishState = 2
declare @ErrorCode int
set @ErrorCode = @@ERROR
if(@ErrorCode <> 0)
begin
rollback transaction
return @ErrorCode
end
commit transaction