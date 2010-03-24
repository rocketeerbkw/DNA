CREATE procedure ratingsreadbyforumid @forumid int, @startindex int = null, @itemsperpage int = null, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

declare @totalresults int 
if (@startindex is null) set @startindex = 0
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

select @totalresults = count(*) 
from dbo.ForumReview
where forumid = @forumid



;with cte_usersposts as
(
	select row_number() over ( order by entryid asc) as n, EntryID
	from dbo.ForumReview
	where forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'ascending'

	union all

	select row_number() over ( order by entryid desc) as n, EntryID
	from dbo.ForumReview
	where forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'descending'

)
select cte_usersposts.n, 
	vu.*,
	@totalresults as totalresults
from cte_usersposts
inner join VRatings vu on vu.Id = cte_usersposts.EntryID
where n > @startindex and n <= @startindex + @itemsPerPage
order by n