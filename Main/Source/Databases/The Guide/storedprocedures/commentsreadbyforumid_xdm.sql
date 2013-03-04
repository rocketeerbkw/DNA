create procedure commentsreadbyforumid_xdm
	@forumid int, 
	@startindex int = null, 
	@itemsperpage int = null, 
	@sortby varchar(20) ='created', 
	@sortdirection varchar(20) = 'descending'
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

declare @totalresults int 
if (@startindex is null) set @startindex = 0
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
if (@itemsPerPage > 500) set @itemsPerPage = 500
if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

-- TODO: what do we want @totalresults to reflect?
select @totalresults = count(*) 
from dbo.ThreadEntries te 
where te.forumid = @forumid

DECLARE @SiteID int
SELECT @SiteID = SiteID from dbo.Forums WHERE ForumID = @forumid

DECLARE @IsTwitterSite bit
IF (@SiteID IN (select siteid from sites where urlname like '%tweet%'))
BEGIN
	SET @IsTwitterSite = 1
END

IF (@IsTwitterSite = 1)
BEGIN
	;with cte_usersposts as
	(
		select row_number() over ( order by te.threadid, te.PostIndex asc) as n, te.EntryID
		from dbo.ThreadEntries te
		where te.forumid = @forumid
		and @sortBy = 'created' and @sortDirection = 'ascending'
		AND SUBSTRING(te.text, 1, 1) != N'@'

		union all

		select row_number() over ( order by te.threadid, te.PostIndex desc) as n, te.EntryID
		from dbo.ThreadEntries te
		where te.forumid = @forumid
		and @sortBy = 'created' and @sortDirection = 'descending'
		AND SUBSTRING(te.text, 1, 1) != N'@'
		
		union all

		select row_number() over ( order by case when value is null then 0 else value end asc) as n, te.EntryID
		from dbo.ThreadEntries te
		left join dbo.VCommentsRatingValue crv with(noexpand) on crv.entryid = te.entryid
		where te.forumid = @forumid
		and @sortBy = 'ratingvalue' and @sortDirection = 'ascending'
		AND SUBSTRING(te.text, 1, 1) != N'@'
		
		union all

		select row_number() over ( order by case when value is null then 0 else value end desc) as n, te.EntryID
		from dbo.ThreadEntries te
		left join dbo.VCommentsRatingValue crv with(noexpand)  on crv.entryid = te.entryid
		where te.forumid = @forumid
		and @sortBy = 'ratingvalue' and @sortDirection = 'descending'
		AND SUBSTRING(te.text, 1, 1) != N'@'
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
		case when crv.value is null then 0 else crv.value end as nerovalue,
		te2.EntryID as 'DmId',
		te2.DatePosted as 'DmCreated',
		te2.UserId as 'DmUserId',
		te2.Text as 'DmText',
		te2.Hidden as 'DmHidden',
		te2.PostStyle as 'DmPostStyle',
		u.UserName as 'DmUserName',
		u.Status as 'DmStatus',
		te2.LastUpdated as 'DmLastUpdated',
		s.IdentityUserId as 'DmIdentityUserId',
		u.LoginName as 'DmIdentityUserName',
		p.SiteSuffix as 'DmSiteSpecificDisplayName',
		te2.UserName as 'DmAnonymousUserName',
		te2.PostIndex as 'DmPostIndex',
		dbo.udf_isusermemberofgroup(te2.UserId, 
            @SiteID, 'EDITOR') AS 'DmUserIsEditor'
		
	from cte_usersposts
	inner join dbo.VComments vu on vu.Id = cte_usersposts.EntryID
	left join dbo.ThreadEntriesTweetInfo tet on vu.Id = tet.ThreadEntryId 
	left join dbo.VCommentsRatingValue crv with(noexpand)  on crv.entryid = cte_usersposts.EntryID
	-- get related distress message entryid if exists
  	left join dbo.ThreadEntryDistressMessage dm on vu.Id = dm.ParentEntryId
	left join dbo.ThreadEntries te2 on dm.DistressMessageId = te2.EntryId
	left join dbo.Users u on te2.UserId = u.UserId
	left join dbo.Preferences p on p.UserID = u.UserId and p.SiteId = @SiteID
	left join dbo.SignInUserIDMapping s on s.DnaUserID = u.UserID
	-- filter out distress messages from this list so paging etc. not affected.
  	where n > @startindex and n <= @startindex + @itemsPerPage and vu.Id not in (
  		select dm.DistressMessageId
		from threadentries te
		inner join ThreadEntryDistressMessage dm on te.entryid = dm.parententryid)
	order by n
END
ELSE
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
		case when crv.value is null then 0 else crv.value end as nerovalue,
		te2.EntryID as 'DmId',
		te2.DatePosted as 'DmCreated',
		te2.UserId as 'DmUserId',
		te2.Text as 'DmText',
		te2.Hidden as 'DmHidden',
		te2.PostStyle as 'DmPostStyle',
		u.UserName as 'DmUserName',
		u.Status as 'DmStatus',
		te2.LastUpdated as 'DmLastUpdated',
		s.IdentityUserId as 'DmIdentityUserId',
		u.LoginName as 'DmIdentityUserName',
		p.SiteSuffix as 'DmSiteSpecificDisplayName',
		te2.UserName as 'DmAnonymousUserName',
		te2.PostIndex as 'DmPostIndex',
		dbo.udf_isusermemberofgroup(te2.UserId, 
            @SiteID, 'EDITOR') AS 'DmUserIsEditor'
		
	from cte_usersposts
	inner join dbo.VComments vu on vu.Id = cte_usersposts.EntryID
	left join dbo.ThreadEntriesTweetInfo tet on vu.Id = tet.ThreadEntryId 
	left join dbo.VCommentsRatingValue crv with(noexpand)  on crv.entryid = cte_usersposts.EntryID
	-- get related distress message entryid if exists
  	left join dbo.ThreadEntryDistressMessage dm on vu.Id = dm.ParentEntryId
	left join dbo.ThreadEntries te2 on dm.DistressMessageId = te2.EntryId
	left join dbo.Users u on te2.UserId = u.UserId
	left join dbo.Preferences p on p.UserID = u.UserId and p.SiteId = @SiteID
	left join dbo.SignInUserIDMapping s on s.DnaUserID = u.UserID
	-- filter out distress messages from this list so paging etc. not affected.
  	where n > @startindex and n <= @startindex + @itemsPerPage and vu.Id not in (
  		select dm.DistressMessageId
		from threadentries te
		inner join ThreadEntryDistressMessage dm on te.entryid = dm.parententryid)
	order by n
END
