CREATE procedure ratingsreadbyforumideditorpicksfilter @forumid int, @startindex int = null, @itemsperpage int = null, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

declare @totalresults int 
if (@startindex is null) set @startindex = 0
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

select @totalresults = count(*) 
from dbo.ThreadEntries te 
inner join threadentryeditorpicks ep ON ep.entryid = te.entryid
inner join ForumReview fr ON fr.entryid = te.entryid
where te.forumid = @forumid

;with cte_reviews as
(
	select row_number() over ( order by te.DatePosted asc) as n, te.EntryID
	from dbo.ThreadEntries te
	inner join threadentryeditorpicks ep ON ep.entryid = te.entryid
	inner join ForumReview fr ON fr.entryid = te.entryid
	where te.forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'ascending'

	union all

	select row_number() over ( order by te.DatePosted desc) as n, te.EntryID
	from dbo.ThreadEntries te
	inner join threadentryeditorpicks ep ON ep.entryid = te.entryid
	inner join ForumReview fr ON fr.entryid = te.entryid
	where te.forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'descending'

)
select cte_reviews.n, 
	vr.*,
	@totalresults as totalresults
from cte_reviews
inner join VRatings vr on vr.Id = cte_reviews.EntryID
where n > @startindex and n <= @startindex + @itemsPerPage
order by n
