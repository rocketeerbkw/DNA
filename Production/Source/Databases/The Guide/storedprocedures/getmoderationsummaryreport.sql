CREATE PROCEDURE getmoderationsummaryreport
@startdate datetime,
@enddate datetime,
@urlname varchar(50) = null

AS


IF dbo.udf_tableexists ('ModerationSummaryReport') = 0
BEGIN
CREATE TABLE ModerationSummaryReport (
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[SiteName] [varchar](50)  NULL,
	[SiteUrl] [varchar](30)  NULL,
	[SiteDescription] [varchar](255)  NULL,
	[Division] [nvarchar](50) NOT NULL,
	[ActiveUsers] [int] NULL,
	[TotalModerations] [int] NULL,
	[TotalReferredModerations] [int] NULL,
	[TotalComplaints] [int] NULL,
	[TotalNotablePosts] [int] NULL,
	[TotalHostPosts] [int] NULL,
	[TotalPosts] [int] NULL,
	[TotalExLinkModerations] [int] NULL,
	[TotalExLinkReferrals] [int] NULL,
	[TotalExLinkModPasses] [int] NULL,
	[TotalExLinkModFails] [int] NULL
) ON [PRIMARY]
END


IF dbo.udf_indexexists('ThreadMod','IX_ThreadMod_DateQueued') = 0
begin
	CREATE NONCLUSTERED INDEX [IX_ThreadMod_DateQueued] ON [dbo].ThreadMod
	(
		[DateQueued] ASC
	)
end

IF dbo.udf_indexexists('ThreadEntries','IX_ThreadEntries_DatePosted_Userid') = 0
begin
	CREATE NONCLUSTERED INDEX [IX_ThreadEntries_DatePosted_Userid] ON [dbo].[ThreadEntries] 
	(
		[DatePosted] ASC
	)
	INCLUDE ( [ForumID], [Hidden], userid)
end


declare @siteid int
declare @notablesGroupId int
declare @HostsGroupId int
declare @dataExists bit


SELECT  @dataExists = 1 FROM ModerationSummaryReport 
WHERE StartDate = @startDate AND EndDate = @endDate


IF (@dataExists IS NULL) -- does does not exist
BEGIN
	select @siteid = SiteID from dbo.Sites s where UrlName = @urlname

	select @notablesGroupId = GroupId from Groups where [Name] = 'Notables'
	select @HostsGroupId = GroupId from Groups where [Name] = 'Editor'

	insert into ModerationSummaryReport
	select 
		@startDate as StartDate,
		@endDate as EndDate,
		sites.Shortname as SiteName,
		sites.urlname as SiteUrl,
		sites.Description as SiteDescription,
		div.BBCDivisionName as Division,

		(select count(distinct userid) from 
			(
			select userid from threadentries te
			inner join forums f on f.forumid=te.forumid
			where f.SiteID = sites.siteid and	
			DatePosted between @startDate and @endDate
			union all
			select editor as userid from guideentries ge
			where ge.SiteID = sites.siteid and	
			DateCreated between @startDate and @endDate and
			Type <= 1000 and status<>10 -- status 10 is frontpage
			) s
		) as ActiveUsers,

		(select count(*) from threadmod tm
		where 
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @endDate) as TotalModerations,

		(select count(*) from threadmod tm
		where 
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @endDate and
		 (tm.ReferredBy is not null)) as TotalReferredModerations,

		(select count(*) from threadmod tm
		where 
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @endDate and
		 (tm.ComplaintText is not null)) as TotalComplaints,
		

		(select  count(*) from threadentries te 
		inner join users u on u.userid = te.userid		
		inner join groupmembers gm on gm.userid = u.userid and  gm.GroupId = @notablesGroupId  and gm.siteid = sites.siteid
		inner join forums f on f.forumid = te.forumid
		where 
		f.SiteID = sites.siteid and	
		DatePosted > @startDate and DatePosted < @endDate) as TotalNotablePosts,

		(select  count(*) from threadentries te 
		inner join users u on u.userid = te.userid		
		inner join groupmembers gm on gm.userid = u.userid and  gm.GroupId = @HostsGroupId  and gm.siteid = sites.siteid
		inner join forums f on f.forumid = te.forumid
		where 
		f.SiteID = sites.siteid and	
		DatePosted > @startDate and DatePosted < @endDate) as TotalHostPosts,

		(select  count(*) from threadentries te 
		inner join forums f on f.forumid = te.forumid
		where 
		f.SiteID = sites.siteid and	
		DatePosted > @startDate and DatePosted < @endDate) as TotalPosts,

		(select count(*) from exlinkmod em
		where 
		em.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @endDate) as TotalExLinkModerations,		

		(select count(*) from exlinkmod em
		where 
		em.SiteID = sites.siteid and	
		em.ReferredBy IS NOT NULL and
		DateQueued > @startDate and DateQueued < @endDate) as TotalExLinkReferrals,		

		(select count(*) from exlinkmod em
		where 
		em.SiteID = sites.siteid and	
		em.Status = 3 and
		DateQueued > @startDate and DateQueued < @endDate) as TotalExLinkModPasses,

		(select count(*) from exlinkmod em
		where 
		em.SiteID = sites.siteid and	
		em.Status = 4 and
		DateQueued > @startDate and DateQueued < @endDate) as TotalExLinkModFails

		
	from dbo.Sites sites
	inner join BBCDivision div on sites.BBCDivisionID = div.BBCDivisionID
END


SELECT   convert(char(10),startdate,121) StartDate
		,convert(char(10),enddate,121) EndDate
		,*
FROM dbo.ModerationSummaryReport 
WHERE 
	(@urlname IS NULL OR SiteName = @urlname)
	AND
	(StartDate = @startDate AND EndDate = @endDate)
ORDER BY SiteName
