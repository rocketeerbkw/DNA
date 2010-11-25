create PROCEDURE createsitedailysummaryreport
@startdate datetime =null,
@enddate datetime =null,
@siteid int =0

AS


declare @notablesGroupId int
declare @HostsGroupId int

if @startdate is null
begin
	set @startdate = dbo.udf_dateonly(dateadd(d, -1, getdate()))
end

if @enddate is null
begin
	set @enddate = dbo.udf_dateonly(dateadd(d, 1, @startdate))
end 
else
begin
	set @enddate = dbo.udf_dateonly(dateadd(d, 1, @enddate))
end

select @notablesGroupId = GroupId from Groups where [Name] = 'Notables'
select @HostsGroupId = GroupId from Groups where [Name] = 'Editor'

while @startdate < @enddate
begin

	print 'Processing ' + convert(varchar(50), @startdate)

	declare @tmpEndDate datetime
	set @tmpEndDate = dbo.udf_dateonly(dateadd(d, 1, @startdate))

--delete existing data if thre
	delete from SiteDailySummaryReport
	where @startdate = date and
	(@siteid=0 or siteid=@siteid)

-- add new data
	insert into SiteDailySummaryReport
	select 
		@startDate as Date,
		sites.siteid as SiteId,
		(select count(*) from threadmod tm
		where 
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @tmpenddate) as TotalModerations,

		(select count(*) from threadmod tm
		where 
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @tmpenddate and
		 (tm.ReferredBy is not null)) as TotalReferredModerations,

		(select count(*) from threadmod tm
		where 
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @tmpenddate and
		 (tm.ComplaintText is not null)) as TotalComplaints,
		
		(select  count(distinct u.userid) from threadmod tm
		inner join threadentries te on tm.postid = te.entryid
		inner join users u on u.userid = te.userid
		where 
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @tmpenddate) as UniqueUsers,

		(select  count(*) from threadentries te 
		inner join users u on u.userid = te.userid		
		inner join groupmembers gm on gm.userid = u.userid and  gm.GroupId = @notablesGroupId  and gm.siteid = sites.siteid
		inner join forums f on f.forumid = te.forumid
		where 
		f.SiteID = sites.siteid and	
		DatePosted > @startDate and DatePosted < @tmpenddate) as TotalNotablePosts,

		(select  count(*) from threadentries te 
		inner join users u on u.userid = te.userid		
		inner join groupmembers gm on gm.userid = u.userid and  gm.GroupId = @HostsGroupId  and gm.siteid = sites.siteid
		inner join forums f on f.forumid = te.forumid
		where 
		f.SiteID = sites.siteid and	
		DatePosted > @startDate and DatePosted < @tmpenddate) as TotalHostPosts,

		(select  count(*) from threadentries te 
		inner join forums f on f.forumid = te.forumid
		where 
		f.SiteID = sites.siteid and	
		DatePosted > @startDate and DatePosted < @tmpenddate) as TotalPosts,

		(select count(*) from exlinkmod em
		where 
		em.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @tmpenddate) as TotalExLinkModerations,		

		(select count(*) from exlinkmod em
		where 
		em.SiteID = sites.siteid and	
		em.ReferredBy IS NOT NULL and
		DateQueued > @startDate and DateQueued < @tmpenddate) as TotalExLinkReferrals,		

		(select count(*) from exlinkmod em
		where 
		em.SiteID = sites.siteid and	
		em.Status = 3 and
		DateQueued > @startDate and DateQueued < @tmpenddate) as TotalExLinkModPasses,

		(select count(*) from exlinkmod em
		where 
		em.SiteID = sites.siteid and	
		em.Status = 4 and
		DateQueued > @startDate and DateQueued < @tmpenddate) as TotalExLinkModFails,

		(select count(*) from threadmod tm
		where 
		status=4 and
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @tmpenddate) as 'TotalPostsFailed',

		(select count(*) from dbo.Preferences p
		where	
		p.SiteID = sites.siteid and	
		DateJoined > @startDate and DateJoined < @tmpenddate) as 'TotalNewUsers',

		(select count(*) from dbo.Preferences p
		where
		prefstatus=3 and --3 = banned
		p.SiteID = sites.siteid and	
		PrefStatusChangedDate > @startDate and PrefStatusChangedDate < @tmpenddate) as 'TotalBannedUsers',
		
		(select count(*) from Nicknamemod em
		where 
		em.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @tmpenddate) as 'TotalNickNamesModerations',
		
		(select count(*) from dbo.Preferences p
		where
		prefstatus<>0 and --3 = banned
		p.SiteID = sites.siteid and	
		PrefStatusChangedDate > @startDate and PrefStatusChangedDate < @tmpenddate) as 'TotalRestrictedUsers'
		
	from dbo.Sites sites
	where (@siteid=0 or sites.siteid = @siteid)

	set @startdate =@tmpEndDate
END
