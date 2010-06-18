CREATE     PROCEDURE getindexofcomment @postid int, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
AS


declare @threadId int

select @threadid = threadid
from threadentries
where entryid = @postid

;with cte_usersposts as
(
	select row_number() over ( order by te.DatePosted asc) as n, te.EntryID
	from dbo.ThreadEntries te
	where te.threadid = @threadid
	and @sortBy = 'created' and @sortDirection = 'ascending'

	union all

	select row_number() over ( order by te.DatePosted desc) as n, te.EntryID
	from dbo.ThreadEntries te
	where te.threadid = @threadid
	and @sortBy = 'created' and @sortDirection = 'descending'

)
select cast(cte_usersposts.n -1 as int) as 'startIndex' --minus 1 to make it 0 starting
from cte_usersposts
where cte_usersposts.EntryID = @postid
order by n