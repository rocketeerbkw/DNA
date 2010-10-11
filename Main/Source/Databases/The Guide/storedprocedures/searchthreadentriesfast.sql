create procedure searchthreadentriesfast
						@siteid int = null,
						@condition nvarchar(100),
						@startindex int=0,
						@itemsperpage int=50
as

--set it to lower case to match on terms
set @condition = lower(@condition)

--get urlname
declare @urlname varchar(50)
select @urlname=urlname from sites where siteid=@siteid

--Get the 'other' DB config
DECLARE @server nvarchar(255)
DECLARE @database nvarchar(255)
SELECT @server = server, @database = [database]  FROM DatabaseConfig

--create table
create table #tempResults
(
	ThreadEntryID int,
	Rank int,
	Score float
)

--generate foreign server query
DECLARE @sql nvarchar(MAX)
set @sql='exec [' + @server + '].' + @database + '.dbo.DNASearch_searchthreadentriesfast @i_condition, @i_maxresults, @i_URLName'
print @sql
insert #tempResults 
exec sp_executesql @sql, 
			N'@i_condition nvarchar(100), 
			@i_maxresults int,
			@i_URLName varchar(50)',
			@i_condition = @condition,
			@i_maxresults = 500, 
			@i_URLName = @urlname

--get total count
declare @totalCount int
select @totalCount = count(*) from #tempResults

--remove hidden comments
delete from #tempResults
where ThreadEntryID in
(
	select ThreadEntryID
	from #tempResults tr
	inner join threadentries te on te.entryid=tr.ThreadEntryID
	and te.hidden is not null 
	
)

--do pagination
;with searchresults as
(
	select row_number() over ( order by #tempResults.Rank desc, #tempResults.ThreadEntryID desc) as n, ThreadEntryID, Rank
	from #tempResults
) 
SELECT 
	sr.n as 'ResultNumber',
	t.ForumID, 
	t.ThreadID, 
	t.UserID, 
	siuidm.IdentityUserId,
	'IdentityUserName' = u.LoginName, 
	u.FirstNames, 
	u.LastName, 
	u.Area,
	P.Title,
	p.SiteSuffix,
	u.Status, u.TaxonomyNode, 'Journal' = j.forumid, u.Active,
	'UserName' = CASE WHEN LTRIM(u.UserName) = '' THEN 'Researcher ' + CAST(u.UserID AS varchar) ELSE u.UserName END, 
	'Subject' = CASE t.Subject WHEN '' THEN 'No Subject' ELSE t.Subject END, 
	t.NextSibling, 
	t.PrevSibling, 
	t.Parent, 
	t.FirstChild, 
	t.EntryID, 
	t.DatePosted, 
	t.LastUpdated,
	t.Hidden,
	f.SiteID,
	'Interesting' = NULL,
	'totalresults' = @totalCount,
	th.CanRead,
	th.CanWrite,
	t.PostStyle,
	t.text,
	'FirstPostSubject' = th.FirstSubject,
	f.ForumPostCount,
	f.AlertInstantly,
	th.Type,
	th.eventdate,
	'threadlastupdate' = th.lastupdated,
	te.postindex as 'replypostindex',
	t.postindex as 'postindex',
	sr.rank as 'rank' -- normalise to out of 100
FROM searchresults sr
	inner join ThreadEntries t WITH(NOLOCK) on t.entryid=sr.ThreadEntryID
	LEFT JOIN ThreadEntries te on te.entryid=t.parent
	INNER JOIN Users u WITH(NOLOCK) ON t.UserID = u.UserID
	LEFT JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
	INNER JOIN Threads th WITH(NOLOCK) ON t.ThreadID = th.ThreadID
	INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = t.ForumID
	LEFT JOIN Preferences p WITH(NOLOCK) on (p.UserID = u.UserID) AND (p.SiteID = f.SiteID)
	INNER JOIN Journals J with(nolock) on J.UserID = U.UserID and J.SiteID = f.SiteID
where n > @startindex and n <= @startindex + @itemsperpage
								
drop table #tempResults