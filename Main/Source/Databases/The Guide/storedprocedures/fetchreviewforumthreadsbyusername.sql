Create Procedure fetchreviewforumthreadsbyusername @reviewforumid int, @ascending int = 1
As
declare @forumid int
Select @forumid =  forumid from Reviewforums r inner join guideentries g on r.h2g2id = g.h2g2id where reviewforumid = @reviewforumid  

DECLARE @threadcount int
SELECT @threadcount = COUNT(*) FROM Threads th inner join Reviewforummembers rf on th.threadid = rf.threadid WHERE rf.ForumID = @forumid AND VisibleTo IS NULL


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
		       inner join GuideEntries g on r.h2g2id = g.h2g2id
		       inner join Users u on g.editor = u.userid 
		       Where f.forumid = @forumid AND VisibleTo IS NULL
	ORDER BY u.username Asc
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
		       inner join GuideEntries g on r.h2g2id = g.h2g2id
		       inner join Users u on g.editor = u.userid 
		       Where f.forumid = @forumid AND VisibleTo IS NULL
	ORDER By u.username Desc
END
return(0)