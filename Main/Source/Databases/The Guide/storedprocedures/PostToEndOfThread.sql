/*
	Appends the post to the end of the given thread using the standard
	posttoforum procedure.
*/

create procedure posttoendofthread
	@userid int,
	@threadid int,
	@subject nvarchar(255),
	@content nvarchar(max),
	@hash uniqueidentifier,
	@keywords varchar(255),
	@nickname nvarchar(255) = NULL
as
declare @ForumID int
declare @LastPostID int
-- first get the ID of the last post in the thread, and the forum it belongs to
select top 1 @ForumID = ForumID, @LastPostID = EntryID
from ThreadEntries
where ThreadID = @threadid and Hidden is null
order by DatePosted desc
-- now call the standard posttoforum sp
DECLARE @ReturnCode INT
exec @ReturnCode = posttoforum @userid, @ForumID, @LastPostID, @threadid, @subject, @content, 2, @hash, @keywords, @nickname
RETURN @ReturnCode


