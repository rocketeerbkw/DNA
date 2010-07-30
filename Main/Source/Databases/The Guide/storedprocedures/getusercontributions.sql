
/****** Object:  StoredProcedure [dbo].[getusercontributions]    Script Date: 07/13/2010 16:18:59 ******/
if object_id('[getusercontributions]') is not null
	DROP PROCEDURE getusercontributions
GO


create procedure getusercontributions
@identityuserid int, 
@startindex int = null, 
@itemsperpage int = null, 
@sitetype int = null, 
@sitename varchar(50) = null,
@sortdirection varchar(20) = 'descending'

as SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

declare @userid int 
declare @siteid int
declare @totalresults int 
if (@startindex is null) set @startindex = 1
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'ascending'

select @userid = DnaUserID from SignInUserIDMapping where IdentityUserID = @identityuserid
if (@userid IS NULL) 
BEGIN
	return 1 -- User not found
END

select @siteid = SiteID from Sites where ShortName = @sitename

create table #PagedMessageBoardPosts
(
	n int,
	EntryId int
);

IF @sortDirection = 'descending' 
BEGIN
	with numberedPostsDesc as
	(
		select row_number() over(order by te.dateposted desc) n,
			te.EntryId
		from 
			ThreadEntries te
		where 
			te.userid = @userid
	),
	pagedPostsDesc as
	(
		select * 
		from
			numberedPostsDesc
		where
			n >= @startindex and n <= (@startindex+@itemsPerPage)		
	)
	insert #PagedMessageBoardPosts select n,entryid from pagedPostsDesc order by n 
END
ELSE
BEGIN

	with numberedPostsDesc as
	(
		select row_number() over(order by te.dateposted asc) n,
			te.EntryId
		from 
			ThreadEntries te
		where 
			te.userid = @userid
	
	),
	pagedPostsDesc as
	(
		select * 
		from
			numberedPostsDesc
		where
			n >= @startindex and n <= (@startindex+@itemsPerPage)
			
	)
	insert #PagedMessageBoardPosts select n,entryid from pagedPostsDesc
END



;with contributions as
(
		select
			p.n as PostIndex,
			te.EntryID as ThreadEntryID,
			te.DatePosted as [TimeStamp],
			te.Subject as Subject,
			t.FirstSubject as FirstSubject,
			te.[text] as Body,
			f.Title as ForumTitle,
			s.Description as SiteDescription,
			s.URLName as SiteUrl,
			so.[Value] as SiteType,
			s.ShortName as SiteName,
			cf.Url as CommentForumUrl,
			ge.subject as GuideEntrySubject
		from 	
			#PagedMessageBoardPosts p
			inner join threadentries as te on p.entryid = te.entryid
			inner join threads as t on te.threadid = t.threadid
			inner join forums as f on f.forumid = t.forumid
			inner join sites as s on t.siteid  = s.siteid
			left outer join siteoptions as so on s.siteid  = so.siteid	
			left outer join commentforums as cf on cf.forumid  = f.forumid	
			left outer join guideentries as ge on ge.forumid  = f.forumid	
		where
			(				
				so.[Name] = 'SiteType'	
				and
				(
				(@sitetype is null)
				or 
				((@sitetype is not null) and (so.[value] = @sitetype))
				)
			)
			and
			(
				(@siteid is null)
				or
				((@siteid is not null) and (s.siteid = @siteid))
			)		
)

select * from contributions order by PostIndex
return 0




