create procedure gettrackedmembersummary @userid int, @siteid int
as
begin
	declare @firstactivity datetime
	
	select TOP 1 @firstactivity = DatePosted From 
	(
		select d1.* from
		(
			select TOP 1 DatePosted 
			from ThreadEntries WITH(NOLOCK)
			where UserID = @userid
			order by DatePosted ASC
		) as d1
		union all
		select d2.* from
		(
			select TOP 1 DateCreated as 'DatePosted' 
			from GuideEntries WITH(NOLOCK)
			where Editor = @userid
			order by DateCreated ASC
		) as d2
	) AS Dates
	ORDER BY Dates.DatePosted ASC
	
	declare @articlessubmitted int
	select @articlessubmitted = count(*) from GuideEntries G WITH(NOLOCK) where G.Editor = @userid
	
	declare @postssubmitted int
	select @postssubmitted = count(*) from ThreadEntries TE WITH(NOLOCK) where TE.UserID = @userid

	select @firstactivity 'FirstActivity', @articlessubmitted 'ArticlesSubmitted', 
		@postssubmitted 'PostsSubmitted', 0 as 'Count', -1 as 'ReasonID'
	union all
	select null as 'FirstActivity', 0 as 'ArticlesSubmitted', 0 as 'PostsSubmitted', count(*) as 'count', summary.reasonid from
	(
		select sum1.* from 
		(
			select null as 'FirstActivity', 0 as 'ArticlesSubmitted', 0 as 'PostsSubmitted', count(*) as 'Count', AMH.ReasonID 
			from GuideEntries GE WITH(NOLOCK)
			inner join ArticleMod AM WITH(NOLOCK) on AM.h2g2id = GE.h2g2id
			inner join ArticleModHistory AMH WITH(NOLOCK) on AMH.ModID = AM.ModID
			where GE.Editor = @userid and GE.SiteID = @siteid
			group by AMH.ReasonID
			
		) as sum1
		union all	
		select sum2.* from
		(
			select null as 'FirstActivity', 0 as 'ArticlesSubmitted', 0 as 'PostsSubmitted', count(*) as 'Count', TMH.ReasonID 
            from ThreadModHistory TMH WITH(NOLOCK)
			inner join ThreadMod TM WITH(NOLOCK) on TMH.ModID = TM.ModID and TM.SiteID = @siteid
			inner join ThreadEntries TE WITH(NOLOCK) on TE.EntryID = TM.PostID and TE.UserID = @userid
			group by TMH.ReasonID
		) as sum2
	) as summary
	group by summary.reasonid
	OPTION(OPTIMIZE FOR (@UserID = 42))
	
end