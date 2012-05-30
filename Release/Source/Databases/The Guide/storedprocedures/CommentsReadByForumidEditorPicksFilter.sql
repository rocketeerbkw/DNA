CREATE procedure commentsreadbyforumideditorpicksfilter @forumid int, @startindex int = null, @itemsperpage int = null, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
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
where te.forumid = @forumid



;with cte_usersposts as
(
	select row_number() over ( order by te.threadid, te.PostIndex asc) as n, te.EntryID
	from dbo.ThreadEntries te
	inner join threadentryeditorpicks ep ON ep.entryid = te.entryid
	where te.forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'ascending'

	union all

	select row_number() over ( order by te.threadid, te.PostIndex desc) as n, te.EntryID
	from dbo.ThreadEntries te
	inner join threadentryeditorpicks ep ON ep.entryid = te.entryid
	where te.forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'descending'

)
select cte_usersposts.n, 
	vu.*,
	case 
		when ISNULL(tet.OriginalTweetId, 0) <> 0
		then tet.TweetId
		else 0
	end as 'RetweetId',
	case 
		when ISNULL(tet.OriginalTweetId, 0) <> 0
		then (select u.loginname from dbo.ThreadEntriesTweetInfo tt
				inner join dbo.ThreadEntries te on tt.ThreadEntryId = te.EntryID
				inner join dbo.Users u on te.UserID = u.UserID
				where tt.TweetId = tet.TweetId)
		else NULL
	end as 'RetweetedBy',
	case	
		when ISNULL(tet.OriginalTweetId, 0) <> 0
		then vu.text
		else NULL
	end as 'Retweet',
	@totalresults as totalresults,
	case when crv.value is null then 0 else crv.value end as nerovalue
from cte_usersposts
inner join dbo.VComments vu on vu.Id = cte_usersposts.EntryID
left join dbo.ThreadEntriesTweetInfo tet on vu.Id = tet.ThreadEntryId and tet.IsOriginalTweetForRetweet <> 1
left join dbo.VCommentsRatingValue crv WITH(NOEXPAND)  on crv.entryid = cte_usersposts.EntryID
where n > @startindex and n <= @startindex + @itemsPerPage
order by n
