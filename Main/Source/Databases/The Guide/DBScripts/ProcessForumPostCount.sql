set nocount on
declare @count int
select @count = count(*) from forumpostcountadjust
set @count = @count - 10000
while @count > 0
begin
 exec processforumpostcount
 set @count = @count -1
end