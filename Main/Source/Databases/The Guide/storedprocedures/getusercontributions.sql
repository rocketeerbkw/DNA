CREATE PROCEDURE getusercontributions   @identityuserid varchar(255), 
										@startindex int = null, 
										@itemsperpage int = null, 
										@sitetype int = null, 
										@sitename varchar(50) = null,
										@sortdirection varchar(20) = 'descending',
										@usernametype varchar(40) = 'identityuserid',
										@count int OUTPUT
										

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

declare @userid int 
declare @siteid int
declare @totalresults int 
if (@startindex is null or @startindex = 0) set @startindex = 1
if (@itemsPerPage is null or @itemsPerPage = 0) set @itemsPerPage = 20
if (@sortDirection is null or @sortDirection ='') set @sortDirection = 'descending'


if not (@identityuserid is null)

BEGIN
	IF @userNameType = 'identityuserid'
	BEGIN
		SELECT @userid = DnaUserID from dbo.SignInUserIDMapping where IdentityUserID = @identityuserid
		IF (@userid IS NULL) 
		BEGIN
			return 1 -- User not found
		END
	END
	ELSE IF @userNameType = 'dnauserid'
	BEGIN
		BEGIN TRY
			SELECT @userid = CONVERT(int, @identityuserid)
			IF NOT EXISTS( SELECT * FROM Users WHERE UserID = @userid) 
			BEGIN
				return 1 -- User not found
			END
		END TRY
		BEGIN CATCH
				return 1 -- error converting the string
		END CATCH
	END
	ELSE
	BEGIN --get dna id from identityusername
		SELECT @userid = dbo.udf_getdnauseridfromloginname (@identityuserid)
		IF (@userid IS NULL) 
		BEGIN
			return 1 -- User not found
		END
	END
END

select @siteid = SiteID from dbo.Sites where UrlName = @sitename

create table #UnPagedMessageBoardPosts
(
	n int,
	EntryId int,
);

create table #PagedMessageBoardPosts
(
	n int,
	EntryId int
);

IF @sortDirection = 'descending' 
BEGIN

	insert #UnPagedMessageBoardPosts 
	select 
		row_number() over(order by te.dateposted desc) n,			
		te.EntryId
	from 
		dbo.threadentries as te 
		inner join dbo.threads as t on te.threadid = t.threadid
		inner join dbo.forums as f on f.forumid = t.forumid
		inner join dbo.sites as s on f.siteid  = s.siteid
		left outer join dbo.siteoptions as so on s.siteid  = so.siteid AND so.section='General' AND so.[Name] = 'SiteType'			
	where 
		te.userid = @userid
	and
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

END
ELSE
BEGIN

	insert #UnPagedMessageBoardPosts 
	select 
		row_number() over(order by te.dateposted asc) n,			
		te.EntryId
	from 
		dbo.threadentries as te 
		inner join dbo.threads as t on te.threadid = t.threadid
		inner join dbo.forums as f on f.forumid = t.forumid
		inner join dbo.sites as s on f.siteid  = s.siteid
		left outer join dbo.siteoptions as so on s.siteid  = so.siteid AND so.section='General' AND so.[Name] = 'SiteType'			
	where 
		te.userid = @userid
	and
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
END


SELECT @count = @@ROWCOUNT

insert #PagedMessageBoardPosts 
select  n,entryid
from
	#UnPagedMessageBoardPosts
where
	n >= @startindex and n < (@startindex+@itemsPerPage)	
order by n		


select
	p.n as PostIndex,
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
	ge.subject as GuideEntrySubject
from 	
	#PagedMessageBoardPosts p
	inner join dbo.threadentries as te on p.entryid = te.entryid
	inner join dbo.threads as t on te.threadid = t.threadid
	inner join dbo.forums as f on f.forumid = t.forumid
	inner join dbo.sites as s on t.siteid  = s.siteid
	left outer join dbo.siteoptions as so on s.siteid  = so.siteid AND so.section='General' AND so.[Name] = 'SiteType'
	left outer join dbo.commentforums as cf on cf.forumid  = f.forumid	
	left outer join dbo.guideentries as ge on ge.forumid  = f.forumid	
order by PostIndex	

return 0
