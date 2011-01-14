CREATE PROCEDURE getrecentcontributions @startindex int = null, 
										@itemsperpage int = null, 
										@sitetype int = null, 
										@sitename varchar(50) = null
			
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


declare @siteid int
declare @totalresults int 
if (@startindex is null or @startindex = 0) set @startindex = 1
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20


select @siteid = SiteID from dbo.Sites where UrlName = @sitename


;with TheSites AS
(
	select s.siteid,s.urlname from sites s
	join siteoptions so on so.siteid=s.siteid AND so.section='General' AND so.[Name] = 'SiteType'				
	where
		(
			(@sitetype is null)
			or 
			((@sitetype is not null) and (so.[value] = @sitetype))
		)
		and
		(
			(@siteid is null)
			or
			((@siteid is not null) and (s.siteid = @siteid))
		)
),
NumberedThreadEnrtries AS
(
	select 
		row_number() over(order by te.dateposted desc) n,			
		te.EntryId
	from 
		dbo.threadentries as te 
		inner join dbo.forums as f on f.forumid = te.forumid
		inner join TheSites ts on ts.siteid=f.siteid
	where
		te.dateposted > dateadd(week,-1,getdate())
		and te.hidden is null
)

select
	cast(p.n as bigint) as PostIndex,
	te.EntryID as ThreadEntryID,
	te.DatePosted as [TimeStamp],
	te.Subject as Subject,
	t.FirstSubject as FirstSubject,
	te.[text] as Body,
	f.Title as ForumTitle,
	s.Description as SiteDescription,
	s.UrlName as UrlName,
	case when so.[Value] is null then '0' else so.[Value] end as SiteType,
	s.ShortName as SiteName,
	cf.Url as CommentForumUrl,
	ge.subject as GuideEntrySubject,	
	(select ISNULL(forumpostcount, 0)
		from forums
		where forumid=(select forumid from threadentries where entryid=te.EntryID)) AS TotalPostsOnForum,
	u.userid as AuthorUserId,
	u.username as AuthorUsername,
	u.loginname as AuthorIdentityUserName,
	0 as hidden,
	t.ThreadId as ThreadId,
	f.ForumId as ForumId,
	u.loginname as AuthorIdentityUserName,
	f.CanWrite as ForumCanWrite,
	s.SiteEmergencyClosed as SiteEmergencyClosed,
	cf.ForumCloseDate as ForumCloseDate,
	@startindex as 'startindex'
from 	
	NumberedThreadEnrtries p
	inner join dbo.threadentries as te on p.entryid = te.entryid
	inner join dbo.users as u on u.userid = te.userid
	inner join dbo.threads as t on te.threadid = t.threadid
	inner join dbo.forums as f on f.forumid = t.forumid
	inner join dbo.sites as s on t.siteid  = s.siteid
	left outer join dbo.siteoptions as so on s.siteid  = so.siteid AND so.section='General' AND so.[Name] = 'SiteType'
	left outer join dbo.commentforums as cf on cf.forumid  = f.forumid	
	left outer join dbo.guideentries as ge on ge.forumid  = f.forumid	
where
	p.n >= @startindex and p.n < (@startindex+@itemsPerPage)	
order by p.n		


return 0