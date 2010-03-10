CREATE PROCEDURE commentforumsreadbysitenameprefix @siteurlname varchar(30), @startindex int = 0, @itemsperpage int = 0, @prefix varchar(100), @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
	AS
	
	IF @prefix='movabletype%'
		RETURN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	declare @totalresults int
	if (@startindex = 0 ) set @startindex = 0
	if (@itemsperpage = 0 ) set @itemsperpage = 20
	if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
	if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

	declare @siteid int
	select @siteid= siteid from dbo.sites where urlname = @siteurlname

	select @totalresults = count(*) 
	from dbo.commentforums cf
	where cf.siteid = @siteid and cf.uid like @prefix
	
	print @sortDirection
	
	;with cte_commentforum as
	(
		select row_number() over ( order by f.forumid desc) as n, f.ForumID
		from dbo.commentforums cf
		inner join dbo.forums f on f.forumid = cf.forumid
		where f.siteid = @siteid
		and @sortBy = 'created' and @sortDirection = 'descending'
		and cf.uid like @prefix
		
		union all
		
		select row_number() over ( order by f.forumid asc) as n, f.ForumID
		from dbo.commentforums cf
		inner join dbo.forums f on f.forumid = cf.forumid
		where f.siteid = @siteid
		and @sortBy = 'created' and @sortDirection = 'ascending'
		and cf.uid like @prefix
		
		union all

		select * from (select row_number() over ( order by f.lastposted desc) as n, f.ForumID
		from dbo.commentforums cf
		inner join dbo.forums f on f.forumid = cf.forumid
		where f.siteid = @siteid and cf.uid like @prefix) x
		where x.n > @startindex and x.n <= @startindex + @itemsperpage
		and @sortBy = 'lastposted' and @sortDirection = 'descending'
			
		union all
		
		select * from (select row_number() over ( order by f.lastposted asc) as n, f.ForumID
		from dbo.commentforums cf
		inner join dbo.forums f on f.forumid = cf.forumid
		where f.siteid = @siteid and cf.uid like @prefix) x
		where x.n > @startindex and x.n <= @startindex + @itemsperpage
		and @sortBy = 'lastposted' and @sortDirection = 'ascending'
	)
	select cte.n, 
	cte.forumID, 
	uid as uid, 
	sitename,
	title, 
	forumpostcount, 
	moderationstatus, 
	datecreated,  
	lastupdated, 
	url, 
	isnull(forumclosedate, getdate()) as forumclosedate, 
	siteid,
	@totalresults as totalresults, 
	@startindex as startindex, 
	@itemsperpage as itemsperpage, 
	vcf.canRead, 
	vcf.canWrite, 
	vcf.lastposted
	from cte_commentforum cte 
	inner join VCommentForums vcf on vcf.forumid = cte.forumID
	where n > @startindex and n <= @startindex + @itemsperpage
	order by n
	OPTION (OPTIMIZE FOR (@prefix='%',@siteid=1, @sortBy = 'created' ,@sortDirection = 'descending'))

