create procedure gettrackedmemberdetails @siteid int, @userid int
as
begin
	EXEC openemailaddresskey

	select U.UserName, U.FirstNames, U.LastName, dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) as Email,
	U.UserID, UT2.UserTagID, UT2.UserTagDescription, P.PrefStatus, P.PrefStatusChangedDate, P.PrefStatusDuration, P.SiteID
	from Users U WITH(NOLOCK)
	inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID
	left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
	left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
	where U.UserID = @userid and P.SiteID = @siteid

	declare @hashedemail varbinary(900)
	select @hashedemail = U2.hashedemail from Users U2 where UserID = @userid

	if (@hashedemail is not null)
	begin
		select U.UserName, U.FirstNames, U.LastName, dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserId) as Email,
		U.UserID, UT2.UserTagID, UT2.UserTagDescription, P.PrefStatus, P.PrefStatusChangedDate, P.PrefStatusDuration, P.SiteID
		from Users U WITH(NOLOCK)
		inner join Mastheads m on m.UserID = U.UserID
		inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID and P.SiteID = m.SiteID
		left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = P.SiteID
		left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
		where U.HashedEmail = @hashedemail
	end
	--and P.SiteID = @siteid
end