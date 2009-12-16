/*
Searchs the text of forum postings using the specified query condition
and orders them by their relative rankings.
*/

create procedure searchforumsadvanced
				@condition varchar(1000),
				@primarysite int,
				@forumid int = NULL,
				@threadid int = NULL,
				@usergroups varchar(256) = null,
				@scoretobeat real = 0.0,
				@maxresults int = null
as
-- ensure a sensible value for ScoreToBeat
if (@scoretobeat is null) set @scoretobeat = 0.0

-- max results of null or zero means internal maximum
if (@maxresults is null or @maxresults = 0) set @maxresults = 2000

/* replace any single quotes with double single quotes, otherwise they will break the query */
DECLARE @SafeCondition varchar(2000)
set @SafeCondition = replace(@condition, '''', '''''')

-- User Group clause - Filter on User Group of author
DECLARE @usergroupclause VARCHAR(512)
SET @usergroupclause = ''
IF NOT @usergroups IS NULL
BEGIN
 SET @usergroupclause =  ' INNER JOIN GROUPMEMBERS gm ON gm.UserID = TE.UserId AND gm.SiteID = F.SiteID '
 SET @usergroupclause =  @usergroupclause + ' INNER JOIN dbo.udf_splitvarcharwithdelimiter(@i_usergroups, '','') ug ON gm.GroupID = ug.element '
END

declare @Query nvarchar(3000)
set @Query = '
select top(@i_maxresults)
	''PostID'' = TE.EntryID,
	TE.Subject,
	TE.ThreadID,
	TE.ForumID,
	TE.DatePosted,
	F.SiteID,
	''PrimarySite'' = CASE WHEN F.SiteID = @i_primarysite THEN 1 ELSE 0 END,
	''Score'' = cast(ThreadEntriesKeys.Rank as float) * 0.001
from	containstable(ThreadEntries, text, @i_condition,@i_maxresults) as ThreadEntriesKeys
inner join ThreadEntries TE on TE.EntryID = ThreadEntriesKeys.[key]
inner join Threads TH on TH.ThreadID = TE.ThreadID
inner join Forums F on F.ForumID = TE.ForumID '
+ @usergroupclause + 
' where	ThreadEntriesKeys.Rank * 0.001 > @i_scoretobeat
		and TE.Hidden is null
		and TH.VisibleTo is null 
		and TH.CanRead = 1 ' 
		+ CASE WHEN @forumid IS NOT NULL THEN ' and F.ForumID = @i_forumid ' ELSE '' END
		+ CASE WHEN @threadid IS NOT NULL THEN ' and TH.ThreadID = @i_threadid ' ELSE '' END
		+ 'order by CASE WHEN F.SiteID = @i_primarysite THEN 0 ELSE 1 END, Score desc, TE.DatePosted desc'

/*
*/

exec sp_executesql @Query,
N'@i_maxresults int,
@i_scoretobeat real,
@i_condition varchar(2000),
@i_forumid int,
@i_threadid int,
@i_primarysite int,
@i_usergroups varchar(256)',
@i_maxresults = @maxresults,
@i_scoretobeat = @scoretobeat,
@i_condition = @SafeCondition,
@i_forumid = @forumid,
@i_threadid = @threadid,
@i_primarysite = @primarysite,
@i_usergroups = @usergroups
return (0)
