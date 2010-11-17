CREATE PROCEDURE commentforumsreadbysitename	@siteurlname varchar(30) = null, 
												@startindex int = 0, 
												@itemsperpage int = 0, 
												@sortby varchar(20) ='created', 
												@sortdirection varchar(20) = 'descending', 
												@prefix varchar(100)= null
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
		
		union all
		
		select * from (select row_number() over ( order by f.lastposted desc) as n, f.ForumID
		from dbo.commentforums cf
		inner join dbo.forums f on f.forumid = cf.forumid
		where f.siteid = @siteid) x
		where x.n > @startindex and x.n <= @startindex + @itemsperpage
		and @sortBy = 'lastposted' and @sortDirection = 'descending'
		
		union all
		
		select * from (select row_number() over ( order by f.lastposted asc) as n, f.ForumID
		from dbo.commentforums cf
		inner join dbo.forums f on f.forumid = cf.forumid
		where f.siteid = @siteid) x
		where x.n > @startindex and x.n <= @startindex + @itemsperpage
		and @sortBy = 'lastposted' and @sortDirection = 'ascending'

		union all
		
		select row_number() over ( order by forumpostcount desc) as n, ForumID
		from VCommentForums
		where siteid = @siteid 
		and @sortBy = 'postcount' and @sortDirection = 'descending'
		
		union all
		
		select row_number() over ( order by forumpostcount asc) as n, ForumID 
		from VCommentForums 
		where siteid = @siteid 
		and @sortBy = 'postcount' and @sortDirection = 'ascending'
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
	, vcf.editorpickcount
	from cte_commentforum cte 
	inner join VCommentForums vcf on vcf.forumid = cte.forumID
	where n > @startindex and n <= @startindex + @itemsperpage
	ORDER BY n
	OPTION (OPTIMIZE FOR (@sortBy = 'created' ,@sortDirection = 'descending'))

