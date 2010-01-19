create procedure gettrackedusers @siteid int, 
	@show int, 
	@skip int, 
	@sortedon varchar(255), 
	@direction int = 1
as
begin

	declare @numusers int
	select @numusers = count(*) from Preferences P where P.SiteID = @siteid and
		P.ContentFailedOrEdited = 1
		
	declare @numusertags int
	select @numusertags = count(*) from UserTags
		
	create table #tempmemberslist (id int NOT NULL IDENTITY(0, 1) PRIMARY KEY,
		UserID int, UserName varchar(255), PrefStatus int, PrefStatusChangedDate datetime, PrefStatusDuration int, UserTagDescription varchar(255), TotalUsers int)

	if (@sortedon = 'nickname')
	begin
		if (@direction = 1)
		begin
			insert into #tempmemberslist
			select U.UserID, 
				U.Username, 
				P.PrefStatus, 
				P.PrefStatusChangedDate, 
				P.PrefStatusDuration,
				UT2.UserTagDescription,
				'TotalUsers' = @numusers
			from Users U WITH(NOLOCK) 
			inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID AND P.ContentFailedOrEdited = 1
			left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
			left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
			where P.SiteID = @siteid
			ORDER BY U.UserName DESC
		end
		if (@direction = 0)
		begin
			insert into #tempmemberslist
			select U.UserID, 
				U.Username, 
				P.PrefStatus, 
				P.PrefStatusChangedDate, 
				P.PrefStatusDuration,
				UT2.UserTagDescription,
				'TotalUsers' = @numusers
			from Users U WITH(NOLOCK) 
			inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID AND P.ContentFailedOrEdited = 1
			left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
			left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
			where P.SiteID = @siteid
			ORDER BY U.UserName ASC
		end
	end
	
	if (@sortedon = 'status')
	begin
		if (@direction = 1)
		begin
			insert into #tempmemberslist
			select U.UserID, 
				U.Username, 
				P.PrefStatus, 
				P.PrefStatusChangedDate, 
				P.PrefStatusDuration,
				UT2.UserTagDescription,
				'TotalUsers' = @numusers
			from Users U WITH(NOLOCK) 
			inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID AND P.ContentFailedOrEdited = 1
			left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
			left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
			where P.SiteID = @siteid
			ORDER BY P.PrefStatus DESC
		end
		if (@direction = 0)
		begin
			insert into #tempmemberslist
			select U.UserID, 
				U.Username, 
				P.PrefStatus, 
				P.PrefStatusChangedDate, 
				P.PrefStatusDuration,
				UT2.UserTagDescription,
				'TotalUsers' = @numusers
			from Users U WITH(NOLOCK) 
			inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID AND P.ContentFailedOrEdited = 1
			left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
			left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
			where P.SiteID = @siteid
			ORDER BY P.PrefStatus ASC
		end
	end
	
	if (@sortedon = 'usertags')
	begin
		if (@direction = 1)
		begin
			insert into #tempmemberslist
			select U.UserID, 
				U.Username, 
				P.PrefStatus, 
				P.PrefStatusChangedDate, 
				P.PrefStatusDuration,
				UT2.UserTagDescription,
				'TotalUsers' = @numusers
			from Users U WITH(NOLOCK) 
			inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID AND P.ContentFailedOrEdited = 1
			left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
			left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
			where P.SiteID = @siteid
			ORDER BY U.UserName, UT2.UserTagDescription DESC
		end
		if (@direction = 0)
		begin
			insert into #tempmemberslist
			select U.UserID, 
				U.Username, 
				P.PrefStatus, 
				P.PrefStatusChangedDate, 
				P.PrefStatusDuration,
				UT2.UserTagDescription,
				'TotalUsers' = @numusers
			from Users U WITH(NOLOCK) 
			inner join Preferences P WITH(NOLOCK) on P.UserID = U.UserID AND P.ContentFailedOrEdited = 1
			left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
			left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
			where P.SiteID = @siteid
			ORDER BY U.UserName, UT2.UserTagDescription ASC
		end
	end
	
	set @numusertags=1
	
--	select * from #tempmemberslist 
--	select @skip,@show,((@skip+@show)*@numusertags)

	select * from #tempmemberslist where id >= @skip and id < ((@skip+@show)*@numusertags)
	drop table #tempmemberslist
	
end