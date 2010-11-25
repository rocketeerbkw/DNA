CREATE PROCEDURE getcontribution @threadentryid int	
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

select
	cast(te.PostIndex as bigint) as PostIndex,
	te.EntryID as ThreadEntryID,
	te.DatePosted as [TimeStamp],
	te.Subject as Subject,
	t.FirstSubject as FirstSubject,
	te.[text] as Body,
	f.Title as ForumTitle,
	s.Description as SiteDescription,
	s.UrlName as UrlName,
	so.[Value] as SiteType,
	s.ShortName as SiteName,
	cf.Url as CommentForumUrl,
	ge.subject as GuideEntrySubject,	
	(select ISNULL(forumpostcount, 0)
		from forums
		where forumid=(select forumid from threadentries where entryid=te.EntryID)) AS TotalPostsOnForum,
	u.userid as AuthorUserId,
	u.username as AuthorUsername,
	u.loginname as AuthorIdentityUserName,
	f.CanWrite as ForumCanWrite,
	s.SiteEmergencyClosed as SiteEmergencyClosed,
	cf.ForumCloseDate as ForumCloseDate,
	te.Hidden as Hidden
	
from 	
	dbo.threadentries te
	inner join dbo.users as u on u.userid = te.userid
	inner join dbo.threads as t on te.threadid = t.threadid
	inner join dbo.forums as f on f.forumid = t.forumid
	inner join dbo.sites as s on t.siteid  = s.siteid
	left outer join dbo.siteoptions as so on s.siteid  = so.siteid AND so.section='General' AND so.[Name] = 'SiteType'
	left outer join dbo.commentforums as cf on cf.forumid  = f.forumid	
	left outer join dbo.guideentries as ge on ge.forumid  = f.forumid	
where
	te.entryid = @threadentryid


return 0