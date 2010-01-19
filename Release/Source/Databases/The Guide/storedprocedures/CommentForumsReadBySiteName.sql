CREATE PROCEDURE commentforumsreadbysitename @siteurlname varchar(30) = null, @startindex int = 0, @itemsperpage int = 0, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
	AS
	
	declare @totalresults int
	if (@startindex = 0 ) set @startindex = 0
	if (@itemsperpage = 0 ) set @itemsperpage = 20
	if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
	if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'
	declare @siteid int
	select @siteid= siteid from dbo.sites where urlname = @siteurlname

	select @totalresults = count(*) 
	from dbo.commentforums cf
	where cf.siteid = @siteid

	;with cte_commentforum as
	(
		select row_number() over ( order by cf.forumid desc) as n, cf.ForumID
		from dbo.commentforums cf
		where cf.siteid = @siteid
		and @sortBy = 'created' and @sortDirection = 'descending'
		
		union all
		
		select row_number() over ( order by cf.forumid asc) as n, cf.ForumID
		from dbo.commentforums cf
		where cf.siteid = @siteid
		and @sortBy = 'created' and @sortDirection = 'ascending'
	)
	select cte.n, cte.forumID, uid as uid, sitename,title, forumpostcount, moderationstatus, datecreated,  lastupdated, url, isnull(forumclosedate, getdate()) as forumclosedate, siteid,
	@totalresults as totalresults, @startindex as startindex, @itemsperpage as itemsperpage, vcf.canRead, vcf.canWrite, vcf.lastposted
	from cte_commentforum cte 
	inner join VCommentForums vcf on vcf.forumid = cte.forumID
	where n > @startindex and n <= @startindex + @itemsperpage
	order by n
	OPTION (OPTIMIZE FOR (@sortBy = 'created' ,@sortDirection = 'descending'))

