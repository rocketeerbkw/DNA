create procedure gettrackedmemberdetails @siteid int, @userid int
as
begin
	select U.UserName, U.FirstNames, U.LastName, U.Email, U.UserID, UT2.UserTagID, UT2.UserTagDescription, P.PrefStatus, P.PrefStatusChangedDate, P.PrefStatusDuration, P.SiteID
	from Users U WITH(NOLOCK)
	inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID
	left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
	left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
	where U.UserID = @userid and P.SiteID = @siteid

	declare @email varchar(255)
	select @email = NULLIF(U2.Email,'0') from Users U2 where UserID = @userid

	if (@email is not null)
	begin
		select U.UserName, U.FirstNames, U.LastName, U.Email, U.UserID, UT2.UserTagID, UT2.UserTagDescription, P.PrefStatus, P.PrefStatusChangedDate, P.PrefStatusDuration, P.SiteID
		from Users U WITH(NOLOCK)
		inner join Mastheads m on m.UserID = U.UserID
		inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID and P.SiteID = m.SiteID
		left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = P.SiteID
		left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
		where U.Email = @email
	end
	--and P.SiteID = @siteid
end