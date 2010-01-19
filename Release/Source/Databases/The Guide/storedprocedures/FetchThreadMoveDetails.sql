/*
	Fetches relevant details on moving a particular thread
	to a particular new forum.
*/

create procedure fetchthreadmovedetails @threadid int, @forumid int
as
declare @NewForumID int
declare @NewForumTitle nvarchar(255)
-- get the ID and title for the new forum
select @NewForumID = ForumID, @NewForumTitle = Title
from Forums with(Nolock)
where ForumID = @forumid
-- then combine this with the ID and title for the old forum
select	'ThreadSubject' = T.FirstSubject,
		'OldForumID' = T.ForumID,
		'OldForumTitle' = F.Title,
		'NewForumID' = @NewForumID,
		'NewForumTitle' = @NewForumTitle
from Threads T with (nolock)
inner join Forums F with(nolock) on F.ForumID = T.ForumID
where T.ThreadID = @threadid
return (0)
