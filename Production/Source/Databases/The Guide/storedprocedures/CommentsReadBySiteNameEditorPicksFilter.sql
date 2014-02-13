CREATE procedure commentsreadbysitenameeditorpicksfilter @siteid int, @startindex int = null output, @itemsperpage int = null output, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'

as
		
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		
	declare @totalresults int 
	if (@startindex is null) set @startindex = 0
	if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
	if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
	if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

	--get total comments
	select @totalresults = count(*) from         
	dbo.ThreadEntries te 
    INNER JOIN dbo.CommentForums cf ON cf.ForumID = te.ForumID
    INNER JOIN ThreadEntryEditorPicks ep ON ep.entryid = te.entryid
	where  cf.siteid = @siteid
								 
	-- get lastupdated
	declare @lastupdate datetime
	select @lastupdate = max(te.lastupdated)
	FROM         
	dbo.ThreadEntries te
    INNER JOIN dbo.CommentForums cf ON cf.ForumID = te.ForumID
    INNER JOIN ThreadEntryEditorPicks ep ON ep.entryid = te.entryid
	where  cf.siteid = @siteid
	
	
	-- get comments
	;with cte_usersposts as
	(
		select row_number() over ( order by te.dateposted asc) as n, te.EntryID
		from dbo.ThreadEntries te 
		INNER JOIN dbo.CommentForums cf ON cf.ForumID = te.ForumID
		INNER JOIN ThreadEntryEditorPicks ep ON ep.entryid = te.entryid
		where  cf.siteid = @siteid
		and @sortBy = 'created' and @sortDirection = 'ascending'

		union all

		select row_number() over ( order by te.dateposted desc) as n, te.EntryID
		from dbo.ThreadEntries te 
		INNER JOIN dbo.CommentForums cf ON cf.ForumID = te.ForumID
		INNER JOIN ThreadEntryEditorPicks ep ON ep.entryid = te.entryid
		where  cf.siteid = @siteid
		and @sortBy = 'created' and @sortDirection = 'descending'

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

