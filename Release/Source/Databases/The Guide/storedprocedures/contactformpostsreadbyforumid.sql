CREATE procedure contactformpostsreadbyforumid @forumid int, @startindex int = null, @itemsperpage int = null, @sortby varchar(20) ='created', @sortdirection varchar(20) = 'descending'
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

EXEC openemailaddresskey;

declare @totalresults int 
if (@startindex is null) set @startindex = 0
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
if (@sortBy is null or @sortBy ='') set @sortBy = 'created'
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'

select @totalresults = count(*) 
from dbo.ThreadEntries te
inner join dbo.threadentriesencrypted tee on te.entryid = tee.entryid
where te.forumid = @forumid
;with cte_usersposts as
(
	select row_number() over ( order by te.threadid, te.PostIndex asc) as n, te.EntryID
	from dbo.ThreadEntries te
	inner join dbo.threadentriesencrypted tee on te.entryid = tee.entryid
	where te.forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'ascending'

	union all

	select row_number() over ( order by te.threadid, te.PostIndex desc) as n, te.EntryID
	from dbo.ThreadEntries te
	inner join dbo.threadentriesencrypted tee on te.entryid = tee.entryid
	where te.forumid = @forumid
	and @sortBy = 'created' and @sortDirection = 'descending'
)
select cte_usersposts.n, 
	vu.id,
	vu.Created,
	vu.UserID,
	vu.ForumID,
	vu.parentUri,
	'Text' = dbo.udf_decryptemailaddress(tee.EncryptedText,tee.EntryID),
	vu.Hidden,
	vu.PostStyle,
	vu.forumuid,
	vu.userJournal,
	vu.UserName,
	vu.userstatus,
	vu.userIsEditor,
	vu.userIsNotable,
	vu.lastupdated,
	vu.IdentityUserID,
	vu.IdentityUserName,
	vu.SiteSpecificDisplayName,
	vu.IsEditorPick,
	vu.PostIndex,
	vu.AnonymousUserName,
	vu.TweetId,
	vu.TwitterScreenName,
	null as 'RetweetId',
	null as 'RetweetedBy',
	null as 'Retweet',
	@totalresults as totalresults,
	null as nerovalue
from cte_usersposts
inner join dbo.VComments vu on vu.Id = cte_usersposts.EntryID
inner join dbo.threadentriesencrypted tee on vu.id = tee.entryid
where n > @startindex and n <= @startindex + @itemsPerPage
order by n
