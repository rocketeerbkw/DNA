  
CREATE procedure commentsreadbyforumidseditorpicksfilter @forumuids nvarchar(max), @startindex int = null, @itemsperpage int = null, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending', @siteurlname  varchar(30)  
as  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
declare @totalresults int   
if (@startindex is null) set @startindex = 0  
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20  
if (@sortBy is null or @sortBy ='') set @sortBy = 'created'  
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'  

-- Temporary table to store individual forum uids
IF OBJECT_ID('tempdb..#SPLITDEMILITERFORUMIDSEDITORPICKS') IS NOT NULL
BEGIN
    DROP TABLE #SPLITDEMILITERFORUMIDSEDITORPICKS
END

SELECT 
	ug.element AS SplitForumUID INTO #SPLITDEMILITERFORUMIDSEDITORPICKS 
FROM 
	dbo.udf_splitvarcharwithdelimiter(@forumuids, ',') ug

-- Temporary table to store the forum if for the forum uids sent as a parameter

IF OBJECT_ID('tempdb..#FORUMIDSEDITORPICKS') IS NOT NULL
BEGIN
    DROP TABLE #FORUMIDSEDITORPICKS
END

SELECT 
	cf.forumid AS ForumID INTO #FORUMIDSEDITORPICKS
FROM 
	dbo.VCommentForums cf
INNER JOIN 
	#SPLITDEMILITERFORUMIDSEDITORPICKS sf 
ON cf.UID = sf.SplitForumUID

-------------------------------------------------------

  
select @totalresults = count(*)   
from dbo.ThreadEntries te   
inner join threadentryeditorpicks ep ON ep.entryid = te.entryid  
inner join #FORUMIDSEDITORPICKS ctf on te.ForumID = ctf.ForumID  
  
;with cte_usersposts as  
(  
 select row_number() over ( order by te.threadid, te.PostIndex asc) as n, te.EntryID  
 from dbo.ThreadEntries te  
 inner join threadentryeditorpicks ep ON ep.entryid = te.entryid  
 inner join #FORUMIDSEDITORPICKS ctf on te.ForumID = ctf.ForumID   
 where @sortBy = 'created' and @sortDirection = 'ascending'  
  
 union all  
  
 select row_number() over ( order by te.threadid, te.PostIndex desc) as n, te.EntryID  
 from dbo.ThreadEntries te  
 inner join threadentryeditorpicks ep ON ep.entryid = te.entryid  
 inner join #FORUMIDSEDITORPICKS ctf on te.ForumID = ctf.ForumID  
 where @sortBy = 'created' and @sortDirection = 'descending'  
  
)  
select cte_usersposts.n,   
 vu.*,  
 @totalresults as totalresults,  
 case when crv.value is null then 0 else crv.value end as nerovalue  
from cte_usersposts  
inner join VComments vu on vu.Id = cte_usersposts.EntryID  
left join dbo.VCommentsRatingValue crv WITH(NOEXPAND)  on crv.entryid = cte_usersposts.EntryID  
where n > @startindex and n <= @startindex + @itemsPerPage  
order by n  
 