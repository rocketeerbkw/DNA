create procedure updatefastmod	@siteid int, @forumid int, @fastmod bit
as

if (@fastmod = 1)
begin
	insert into fastmodforums (forumid) values (@forumid)
end
if (@fastmod = 0)
begin
	delete from fastmodforums where forumid = @forumid
end

return (0)