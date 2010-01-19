Create Procedure fetchreviewforumthreadsbylastposted @reviewforumid int, @ascending int = 1
As
declare @forumid int
Select @forumid =  forumid from Reviewforums r WITH(NOLOCK) 
	inner join guideentries g WITH(NOLOCK) on g.EntryID = r.h2g2id/10
	where reviewforumid = @reviewforumid  

DECLARE @threadcount int
SELECT @threadcount = COUNT(*) FROM Threads th WITH(NOLOCK) 
	inner join Reviewforummembers rf WITH(NOLOCK) on th.threadid = rf.threadid 
	WHERE rf.ForumID = @forumid AND th.VisibleTo IS NULL AND rf.reviewforumid = @reviewforumid

IF (@ascending = 1)
BEGIN
SELECT	g.editor as AuthorID, 
	r.h2g2id,
	t.Threadid,
	t.FirstSubject,
	g.Subject,
	t.LastPosted, 
	r.dateentered,
	r.SubmitterID,
	u.Username,
	'forumid' = @forumid,
	'ThreadCount' = @threadcount
	FROM Threads t WITH(NOLOCK) inner join Forums f WITH(NOLOCK) on t.ForumID = f.forumid
		       inner join ReviewForumMembers r WITH(NOLOCK) on t.threadid = r.threadid 
		       inner join GuideEntries g WITH(NOLOCK) on g.EntryID = r.h2g2id/10
		       inner join Users u WITH(NOLOCK) on g.editor = u.userid 
		       Where f.forumid = @forumid AND t.VisibleTo IS NULL AND r.reviewforumid = @reviewforumid
	ORDER BY t.lastposted Asc
END
ELSE
BEGIN
SELECT	g.editor as AuthorID, 
	r.h2g2id,
	t.Threadid,
	t.FirstSubject,
	g.Subject,
	t.LastPosted, 
	r.dateentered,
	r.SubmitterID,
	u.Username,
	'forumid' = @forumid,
	'ThreadCount' = @threadcount
	FROM Threads t WITH(NOLOCK) inner join Forums f WITH(NOLOCK) on t.ForumID = f.forumid
		       inner join ReviewForumMembers r WITH(NOLOCK) on t.threadid = r.threadid 
		       inner join GuideEntries g WITH(NOLOCK) on g.EntryID = r.h2g2id/10
		       inner join Users u WITH(NOLOCK) on g.editor = u.userid 
		       Where f.forumid = @forumid AND t.VisibleTo IS NULL AND r.reviewforumid = @reviewforumid
	ORDER By t.lastposted Desc
END
return(0)