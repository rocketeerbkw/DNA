CREATE PROCEDURE getmoderationsummaryreport
@startdate datetime,
@enddate datetime,
@sitename varchar(50) -- url name

AS


IF dbo.udf_tableexists ('ModerationSummaryReport') = 0
BEGIN
CREATE TABLE [dbo].[ModerationSummaryReport](
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[SiteName] [varchar](50)  NULL,
	[SiteUrl] [varchar](30)  NULL,
	[SiteDescription] [varchar](255)  NULL,
	[Division] [nvarchar](50) NOT NULL,
	[TotalModerations] [int] NULL,
	[TotalReferredModerations] [int] NULL,
	[TotalComplaints] [int] NULL,
	[UniqueUsers] [int] NULL,
	[TotalNotablePosts] [int] NULL,
	[TotalHostPosts] [int] NULL
) ON [PRIMARY]
END


IF dbo.udf_indexexists('ThreadMod','IX_ThreadMod_DateQueued') = 0
begin
	CREATE NONCLUSTERED INDEX [IX_ThreadMod_DateQueued] ON [dbo].ThreadMod
	(
		[DateQueued] ASC
	)
end


declare @siteid int
declare @notablesGroupId int
declare @HostsGroupId int
declare @dataExists bit


SELECT  @dataExists = 1 FROM ModerationSummaryReport 
WHERE StartDate = @startDate AND EndDate = @endDate


IF (@dataExists IS NULL) -- does does not exist
BEGIN
	select @siteid = SiteID from dbo.Sites s where UrlName = @sitename

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
		
		(select  count(distinct u.userid) from threadmod tm
		inner join threadentries te on tm.postid = te.entryid
		inner join users u on u.userid = te.userid
		where 
		tm.SiteID = sites.siteid and	
		DateQueued > @startDate and DateQueued < @endDate) as UniqueUsers,

		(select  count(*) from threadentries te 
		inner join users u on u.userid = te.userid		
		inner join groupmembers gm on gm.userid = u.userid and  gm.GroupId = @notablesGroupId  and gm.siteid = @siteid
		inner join forums f on f.forumid = te.forumid
		where 
		f.SiteID = sites.siteid and	
		DatePosted > @startDate and DatePosted < @endDate) as TotalNotablePosts,

		(select  count(*) from threadentries te 
		inner join users u on u.userid = te.userid		
		inner join groupmembers gm on gm.userid = u.userid and  gm.GroupId = @HostsGroupId  and gm.siteid = @siteid
		inner join forums f on f.forumid = te.forumid
		where 
		f.SiteID = sites.siteid and	
		DatePosted > @startDate and DatePosted < @endDate) as TotalHostPosts		
	from dbo.Sites sites
	inner join BBCDivision div on sites.BBCDivisionID = div.BBCDivisionID
END


SELECT * 
FROM dbo.ModerationSummaryReport 
WHERE 
	(@sitename IS NULL OR SiteName = @sitename)
	AND
	(StartDate = @startDate AND EndDate = @endDate)
