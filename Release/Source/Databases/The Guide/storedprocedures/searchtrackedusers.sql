create procedure searchtrackedusers @siteid int, 
	@searchon varchar(255), 
	@partialnickname varchar(255) = null, 
	@userid int = 0, 
	@emailaddress varchar(255) = null,
	@skip int = 0,
	@show int = 10
as
begin	

	declare @searchterm varchar(257)
	declare @rowcount int
	
	create table #tempmemberslist (id int NOT NULL IDENTITY(0, 1) PRIMARY KEY,
		UserID int, 
		UserName varchar(255), 
		PrefStatus int, 
		PrefStatusChangedDate datetime, 
		PrefStatusDuration int, 
		UserTagDescription varchar(255))
	
	if (@searchon = 'nickname')
	begin
		set @searchterm = '%' + @partialnickname + '%' 

		insert into #tempmemberslist
		select U.UserID, 
			U.Username, 
			P.PrefStatus, 
			P.PrefStatusChangedDate, 
			P.PrefStatusDuration,
			UT2.UserTagDescription
		from Preferences P WITH(NOLOCK) 
		inner join Users U WITH(NOLOCK) on U.UserID = P.UserID
		left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
		left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
		where P.SiteID = @siteid and U.UserName LIKE @searchterm AND P.ContentFailedOrEdited = 1
		
		set @rowcount = @@ROWCOUNT
	end
	
	if (@searchon = 'uid')
	begin
		
		insert into #tempmemberslist
		select U.UserID, 
			U.Username, 
			P.PrefStatus, 
			P.PrefStatusChangedDate, 
			P.PrefStatusDuration,
			UT2.UserTagDescription
		from Preferences P WITH(NOLOCK) 
		inner join Users U WITH(NOLOCK) on U.UserID = P.UserID
		left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
		left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
		where P.SiteID = @siteid and U.UserID = @userid
		
		set @rowcount = @@ROWCOUNT
	end
	
	if (@searchon = 'email')
	begin
		set @searchterm = '%' + @emailaddress + '%'
		
		EXEC openemailaddresskey
		
		insert into #tempmemberslist
		select U.UserID, 
			U.Username, 
			P.PrefStatus, 
			P.PrefStatusChangedDate, 
			P.PrefStatusDuration,
			UT2.UserTagDescription
		from Preferences P WITH(NOLOCK) 
		inner join Users U WITH(NOLOCK) on U.UserID = P.UserID
		left join UsersTags UT WITH(NOLOCK) on UT.UserID = U.UserID and UT.SiteID = @siteid
		left join UserTags UT2 WITH(NOLOCK) on UT2.UserTagID = UT.UserTagID
		where P.SiteID = @siteid and dbo.udf_decryptemailaddress(U.EncryptedEmail,U.UserID) LIKE @searchterm AND P.ContentFailedOrEdited = 1
		
		set @rowcount = @@ROWCOUNT
	end
	
	declare @numusertags int
	set @numusertags = 1
	
	select *, @rowcount 'TotalUsers' from #tempmemberslist where id >= @skip and id < ((@skip+@show)*@numusertags)
	drop table #tempmemberslist
	
	return @rowcount
end