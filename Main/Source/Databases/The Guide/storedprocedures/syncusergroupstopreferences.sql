create procedure syncusergroupstopreferences @userid int, @siteid int
as
begin
	declare @status int
	--default to standard and then set the preferences status to the most severe.
	set @status = 0
	if (exists (select * from groupmembers where siteid = @siteid and userid = @userid and groupid = (select groupid from groups where name = 'postmoderated')))
	begin
		--postmoderated
		set @status = 2
	end
	if (exists (select * from groupmembers where siteid = @siteid and userid = @userid and groupid = (select groupid from groups where name = 'restricted')))
	begin
		--banned
		set @status = 4
	end
	
	update preferences
	set PrefStatus = @status, PrefStatusDuration = 0
	where userid = @userid and siteid = @siteid
end