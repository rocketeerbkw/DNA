CREATE procedure commentsreadbyforumid_xdm 
	@forumid int, 
	@startindex int = null, 
	@itemsperpage int = null, 
	@sortby varchar(20) ='created', 
	@sortdirection varchar(20) = 'descending'
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
/*
xdm = exclude distress message
--Test cases
exec commentsreadbyforumid 23073226, 20, 20 --Should show @ comments
exec commentsreadbyforumid 24353385, 0, 15 --Should NOT show @ comments
exec commentsreadbyforumid 24353385, 0, 5 --Should NOT show @ comments
exec commentsreadbyforumid 24353385, 5, 5 --Should NOT show @ comments
exec commentsreadbyforumid 24353385, 15, 5 --Should NOT show @ comments

--http://www.bbc.co.uk/sport/0/olympics/2012/
*/

declare @totalresults int 
if (@startindex is null) set @startindex = 0
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
if (@itemsPerPage > 500) set @itemsPerPage = 500
if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

select @totalresults = count(*) 
from dbo.ThreadEntries te 
where te.forumid = @forumid

BEGIN
	;with cte_usersposts as
	(
		select row_number() over ( order by te.threadid, te.PostIndex asc) as n, te.EntryID
		from dbo.ThreadEntries te
		where te.forumid = @forumid
		and @sortBy = 'created' and @sortDirection = 'ascending'

		union all

		select row_number() over ( order by te.threadid, te.PostIndex desc) as n, te.EntryID
		from dbo.ThreadEntries te
		where te.forumid = @forumid
		and @sortBy = 'created' and @sortDirection = 'descending'
		
		union all

		select row_number() over ( order by case when value is null then 0 else value end asc) as n, te.EntryID
		from dbo.ThreadEntries te
		left join dbo.VCommentsRatingValue crv with(noexpand) on crv.entryid = te.entryid
		where te.forumid = @forumid
		and @sortBy = 'ratingvalue' and @sortDirection = 'ascending'
		
		union all

		select row_number() over ( order by case when value is null then 0 else value end desc) as n, te.EntryID
		from dbo.ThreadEntries te
		left join dbo.VCommentsRatingValue crv with(noexpand)  on crv.entryid = te.entryid
		where te.forumid = @forumid
		and @sortBy = 'ratingvalue' and @sortDirection = 'descending'
	)
	select cte_usersposts.n, 
		vu.*,
		case 
			when ISNULL(tet.OriginalTweetId, 0) <> 0
			then tet.OriginalTweetId
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
	left join dbo.ThreadEntriesTweetInfo tet on vu.Id = tet.ThreadEntryId 
	left join dbo.VCommentsRatingValue crv with(noexpand)  on crv.entryid = cte_usersposts.EntryID
	-- get related distress message entryid if exists
  	left join ThreadEntryDistressMessage dm on vu.Id = dm.ParentEntryId
	left join threadentries te2 on dm.DistressMessageId = te2.EntryId
	-- make sure we filter out distress messages from this list so paging etc. not affected.
  	where n > @startindex and n <= @startindex + @itemsPerPage and vu.Id not in (
  		select dm.DistressMessageId
		from threadentries te
		inner join ThreadEntryDistressMessage dm on te.entryid = dm.parententryid)
	order by n
	
END
