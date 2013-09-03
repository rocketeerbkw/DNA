CREATE procedure commentsreadbysitenameprefix @siteid int, @startindex int = null, @itemsperpage int = null, @prefix varchar(100), @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
as

	IF @prefix='movabletype%'
			RETURN
		
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	declare @totalresults int 
	if (@startindex is null) set @startindex = 0
	if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
	if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
	if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

	--get total comments
	select @totalresults=sum(f.forumpostcount)+ isnull(sum(fpca.PostCountDelta),0)
	FROM Forums f
    INNER JOIN dbo.CommentForums cf ON cf.ForumID = f.ForumID
	LEFT JOIN dbo.ForumPostCountAdjust fpca on fpca.ForumID = f.ForumID
	where  cf.siteid = @siteid
	and cf.uid like @prefix
	OPTION (OPTIMIZE FOR (@prefix='',@siteid=1))
								 
	-- get lastupdated
	declare @lastupdate datetime
	select @lastupdate=ISNULL(max(lastupdated),cast(convert(char(10),getdate(),121) AS datetime))
	FROM dbo.ForumLastUpdated flu
    INNER JOIN dbo.CommentForums cf ON cf.ForumID = flu.ForumID
	where  cf.siteid = @siteid
	and cf.uid like @prefix
	OPTION (OPTIMIZE FOR (@prefix='',@siteId=1))
	
	;with cte_usersposts as
	(
		select row_number() over ( order by te.dateposted asc) as n, te.EntryID
		from dbo.ThreadEntries te
		INNER JOIN dbo.CommentForums cf ON cf.ForumID = te.ForumID
		where  cf.siteid = @siteid
		and @sortBy = 'created' and @sortDirection = 'ascending'
		and cf.uid like @prefix

		union all

		select row_number() over ( order by te.dateposted desc) as n, te.EntryID
		from dbo.ThreadEntries te
		INNER JOIN dbo.CommentForums cf ON cf.ForumID = te.ForumID
		where  cf.siteid = @siteid
		and @sortBy = 'created' and @sortDirection = 'descending'
		and cf.uid like @prefix

	)
	select cte_usersposts.n, 
		vu.*,
		@totalresults as totalresults,
		@lastUpdate as lastupdate,
		case when crv.value is null then 0 else crv.value end as nerovalue,
		case when crv.positivevalue is null then 0 else crv.positivevalue end as neropositivevalue,
		case when crv.negativevalue is null then 0 else crv.negativevalue end as neronegativevalue
	from cte_usersposts
	inner join VComments vu on vu.Id = cte_usersposts.EntryID
	left join dbo.VCommentsRatingValue crv WITH(NOEXPAND)  on crv.entryid = cte_usersposts.EntryID
	where n > @startindex and n <= @startindex + @itemsPerPage
	order by n
	OPTION (OPTIMIZE FOR (@prefix='%',@siteid=0))
	
	