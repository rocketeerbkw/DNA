  
CREATE procedure commentsreadbyforumids @forumuids nvarchar(max), @startindex int = null, @itemsperpage int = null, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending', @siteurlname  varchar(30)
as  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
declare @totalresults int   
if (@startindex is null) set @startindex = 0  
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20  
if (@sortBy is null or @sortBy ='') set @sortBy = 'created'  
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'  

-- Temporary table to store individual forum uids
IF OBJECT_ID('tempdb..#SPLITDEMILITERFORUMIDS') IS NOT NULL
BEGIN
    DROP TABLE #SPLITDEMILITERFORUMIDS
END


SELECT 
	ug.element AS SplitForumUID INTO #SPLITDEMILITERFORUMIDS 
FROM 
	dbo.udf_splitvarcharwithdelimiter(@forumuids, ',') ug

 
-- Temporary table to store the forum if for the forum uids sent as a parameter
IF OBJECT_ID('tempdb..#FORUMIDS') IS NOT NULL
BEGIN
    DROP TABLE #FORUMIDS
END

SELECT 
	cf.forumid AS ForumID INTO #FORUMIDS
FROM 
	dbo.VCommentForums cf
INNER JOIN 
	#SPLITDEMILITERFORUMIDS sf 
ON cf.UID = sf.SplitForumUID

------------------------------------------------------
  
select @totalresults = count(*)   
from dbo.ThreadEntries te   
inner join #FORUMIDS ctf on te.ForumID = ctf.ForumID 
  
;with cte_usersposts as  
(   

 select row_number() over ( order by te.threadid, te.PostIndex asc) as n, te.EntryID  
 from dbo.ThreadEntries te 
 inner join #FORUMIDS ctf on te.ForumID = ctf.ForumID 
 where @sortBy = 'created' and @sortDirection = 'ascending'  
  
 union all  
  
 select row_number() over ( order by te.threadid, te.PostIndex desc) as n, te.EntryID  
 from dbo.ThreadEntries te  
 inner join #FORUMIDS ctf on te.ForumID = ctf.ForumID 
 where @sortBy = 'created' and @sortDirection = 'descending'  
   
 union all  
  
 select row_number() over ( order by case when value is null then 0 else value end asc) as n, te.EntryID  
 from dbo.ThreadEntries te  
 left join dbo.VCommentsRatingValue crv with(noexpand) on crv.entryid = te.entryid 
 inner join #FORUMIDS ctf on te.ForumID = ctf.ForumID 
 where @sortBy = 'ratingvalue' and @sortDirection = 'ascending'  
   
 union all  
  
 select row_number() over ( order by case when value is null then 0 else value end desc) as n, te.EntryID  
 from dbo.ThreadEntries te  
 left join dbo.VCommentsRatingValue crv with(noexpand)  on crv.entryid = te.entryid
 inner join #FORUMIDS ctf on te.ForumID = ctf.ForumID  
 where @sortBy = 'ratingvalue' and @sortDirection = 'descending'  
)  
select cte_usersposts.n,   
 vu.*,  
 @totalresults as totalresults,  
 case when crv.value is null then 0 else crv.value end as nerovalue  
from cte_usersposts  
inner join dbo.VComments vu on vu.Id = cte_usersposts.EntryID  
left join dbo.VCommentsRatingValue crv with(noexpand)  on crv.entryid = cte_usersposts.EntryID  
where n > @startindex and n <= @startindex + @itemsPerPage  
order by n  
 
 
 

