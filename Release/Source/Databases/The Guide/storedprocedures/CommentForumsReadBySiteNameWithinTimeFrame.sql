CREATE PROCEDURE commentforumsreadbysitenamewithintimeframe @siteurlname varchar(30) = null, 
															@startindex int = 0, 
															@itemsperpage int = 0, 
															@sortby varchar(20) = 'postcount', 
															@sortdirection varchar(20) = 'descending', 
															@hours int = 24, 
															@prefix varchar(100)= null
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @totalresults int
	IF (@startindex = 0 ) SET @startindex = 0
	IF (@itemsperpage = 0 ) SET @itemsperpage = 20
	IF (@sortBy is null or @sortBy ='') SET @sortBy = 'postcount'
	IF (@sortDirection is null or @sortDirection ='') SET @sortDirection = 'descending'
	DECLARE @siteid int
	SELECT @siteid= siteid 
	FROM dbo.sites 
	WHERE urlname = @siteurlname

	;WITH CTE_COMMENTSWITHINTIMEFRAME AS
	(
		SELECT row_number() OVER ( ORDER BY count(*) DESC ) AS n, count(*) AS [count], vc.forumid 
		FROM vcomments vc 
		INNER JOIN commentforums cf ON vc.forumid = cf.forumid 
		WHERE cf.siteid = @siteid AND vc.Created > DATEADD(hour, -(@hours), getdate()) 
		AND @sortBy = 'postcount' AND @sortDirection = 'descending'
		GROUP BY vc.forumid 

		UNION ALL

		SELECT row_number() OVER ( ORDER BY count(*) ASC ) AS n, count(*) AS [count], vc.forumid 
		FROM vcomments vc 
		INNER JOIN commentforums cf ON vc.forumid = cf.forumid 
		WHERE cf.siteid = @siteid AND vc.Created > DATEADD(hour, -(@hours), getdate()) 
		AND @sortBy = 'postcount' AND @sortDirection = 'ascending'
		GROUP BY vc.forumid 
	),
	CTE_TOTAL AS
	(
		SELECT (SELECT CAST(MAX(n) AS INT) FROM CTE_COMMENTSWITHINTIMEFRAME) AS 'total', * FROM CTE_COMMENTSWITHINTIMEFRAME
	)
	select cte.n, 
	cte.forumID, 
	uid as uid,
	sitename,
	title, 
	cte.count as postsintimeframe, 
	forumpostcount, 
	moderationstatus, 
	datecreated,  
	lastupdated, 
	url, 
	isnull(forumclosedate, getdate()) as forumclosedate, 
	siteid,
	cte.total as totalresults, 
	@startindex as startindex, 
	@itemsperpage as itemsperpage, 
	vcf.canRead, 
	vcf.canWrite, 
	vcf.lastposted
	from CTE_TOTAL cte WITH(NOLOCK) 
	inner join VCommentForums vcf on vcf.forumid = cte.forumID
	where n > @startindex and n <= @startindex + @itemsperpage
	ORDER BY n
	OPTION (OPTIMIZE FOR (@sortBy = 'postcount' ,@sortDirection = 'descending'))
