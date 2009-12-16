Create Procedure stats_getpostingstats @rawstartdate datetime, @interval tinyint, @forcerecalc tinyint = 0
as
declare @startdate datetime, @enddate datetime

-- Interval 1 = day, 2 = week, 3 = month
-- We have to adjust rawstartdate so that we start counting from the same place
-- so we round down to the day, the week (starting Monday) and the month depending on Interval

if @interval = 1
begin
select @startdate = DATEADD(day, datediff(day, 'jan 2 2006', @rawstartdate), 'jan 2 2006')
select @enddate = DATEADD(day,1,@startdate)
end
else if @interval = 2
begin
select @startdate = DATEADD(week, datediff(day, 6, @rawstartdate)/7, 6)	-- day 6 gives us a start day of Sunday - week ends on Saturday
select @enddate = DATEADD(week,1,@startdate)
end
else if @interval = 3
begin
select @startdate = DATEADD(month, datediff(month, 'jan 1 2006', @rawstartdate), 'jan 1 2006')
select @enddate = DATEADD(month,1,@startdate)
end

if @enddate > getdate()
begin
	set @enddate = getdate()
end

-- Always recalc if this isn't a complete interval
if exists (select * from Stats_Postings where StartDate = @startdate and Interval = @interval AND EndDate < @enddate)
begin
	set @forcerecalc = 1
end

if (@forcerecalc = 1)
begin
	delete from Stats_Postings where StartDate = @startdate and Interval = @interval
end

if not exists (select * from Stats_Postings where StartDate = @startdate and Interval = @interval)
begin
		insert into Stats_Postings (StartDate, EndDate, Interval, SiteID, URLName, ForumID, Title, TotalPosts, TotalUsers)
		select	@startdate, 
				@enddate,
				@interval,
				SiteID, 
				URLName, 
				ForumID, 
				Title, 
				'totalposts' = count(*), 
				'total users' = count(distinct UserID) 
		from 
		(select s.SiteID, s.URLName, f.ForumID, f.Title, te.UserID, te.DatePosted 
		FROM PreModPostings te WITH(NOLOCK)
		join forums f WITH(NOLOCK) on te.forumid = f.forumid
		join GuideEntries g WITH(NOLOCK) on f.ForumID = g.ForumID
		join Topics t WITH(NOLOCK) on g.h2g2id = t.h2g2id
		join Sites s with(NOLOCK) on f.SiteID = s.SiteID
		UNION ALL
		select s.SiteID, s.URLName, f.ForumID, f.Title, te.UserID, te.DatePosted 
		FROM ThreadEntries te WITH(NOLOCK)
		join forums f WITH(NOLOCK) on te.forumid = f.forumid
		join GuideEntries g WITH(NOLOCK) on f.ForumID = g.ForumID
		join Topics t WITH(NOLOCK) on g.h2g2id = t.h2g2id
		join Sites s with(NOLOCK) on f.SiteID = s.SiteID) posts
		where 
			--t.TopicStatus = 0 and		-- don't eliminate archived topics
			DatePosted between @startdate and @enddate
		Group by SiteID, URLName, ForumID, Title

		insert into Stats_Postings (StartDate, EndDate, Interval, SiteID, URLName, ForumID, Title, TotalPosts, TotalUsers)
		select	@startdate, 
				@enddate,
				@interval,
				SiteID, URLName, NULL, NULL, 'totalposts' = count(*), 'total users' = count(distinct UserID) 
		from 
		(select s.SiteID, s.URLName, te.UserID, te.DatePosted
		from threadentries te WITH(NOLOCK)
		join forums f WITH(NOLOCK) on te.forumid = f.forumid
		join Sites s with(NOLOCK) on f.SiteID = s.SiteID
		union all
		select s.SiteID, s.URLName, te.UserID, te.DatePosted
		from PreModPostings te WITH(NOLOCK)
		join forums f WITH(NOLOCK) on te.forumid = f.forumid
		join Sites s with(NOLOCK) on f.SiteID = s.SiteID) posts
		where DatePosted between @startdate and @enddate
		AND SiteID NOT IN (select SiteID FROM Topics)
		Group by SiteID, URLName
		
end

select * from Stats_Postings
	where StartDate = @startdate and Interval = @interval
	order by SiteID, Title
	