Create Procedure fetchreviewforumthreadsbydateentered @reviewforumid int, @ascending int = 1
As
declare @forumid int
Select @forumid =  forumid from Reviewforums r 
	inner join guideentries g on g.Entryid = r.h2g2id/10
	where reviewforumid = @reviewforumid  

DECLARE @threadcount int
SELECT @threadcount = COUNT(*) FROM Threads th inner join Reviewforummembers rf on th.threadid = rf.threadid WHERE rf.ForumID = @forumid AND VisibleTo IS NULL AND rf.reviewforumid = @reviewforumid


IF (@ascending = 1)
BEGIN
SELECT	g.editor as AuthorID, 
	r.h2g2id,
	t.Threadid,
	FirstSubject,
	g.Subject,
	t.LastPosted, 
	r.dateentered,
	r.SubmitterID,
	u.Username,
	'forumid' = @forumid,
	'ThreadCount' = @threadcount
	FROM Threads t inner join Forums f on t.ForumID = f.forumid
		       inner join ReviewForumMembers r on t.threadid = r.threadid 
		       inner join GuideEntries g on g.Entryid = r.h2g2id/10
		       inner join Users u on g.editor = u.userid 
		       Where f.forumid = @forumid AND VisibleTo IS NULL AND r.reviewforumid = @reviewforumid
	ORDER BY r.dateentered Asc
END
ELSE
BEGIN
SELECT	g.editor as AuthorID, 
	r.h2g2id,
	t.Threadid,
	FirstSubject,
	g.Subject,
	t.LastPosted, 
	r.dateentered,
	r.SubmitterID,
	u.Username,
	'forumid' = @forumid,
	'ThreadCount' = @threadcount
	FROM Threads t inner join Forums f on t.ForumID = f.forumid
		       inner join ReviewForumMembers r on t.threadid = r.threadid 
		       inner join GuideEntries g on g.Entryid = r.h2g2id/10
		       inner join Users u on g.editor = u.userid 
		       Where f.forumid = @forumid AND VisibleTo IS NULL AND r.reviewforumid = @reviewforumid
	ORDER By r.dateentered Desc
END
return(0)