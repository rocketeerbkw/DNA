CREATE PROCEDURE getnewunscheduledforumidsforsiteid @siteid int
AS

IF (@siteid > 0)
BEGIN
	/* 
	IMPORTANT: The block below will tidy up events in the forumscheduledevents 
	table that are no longer needed
	*/
	-- delete scheduled events for selected forums
	DELETE FROM ForumScheduledEvents
	WHERE ForumID IN
	(
		--get deleted or archived forumids
		SELECT DISTINCT g.ForumID FROM Topics t
		INNER JOIN GuideEntries g ON g.h2g2id = t.h2g2id
		INNER JOIN ForumScheduledEvents f ON g.ForumID = f.ForumID
		WHERE g.SiteID = @siteid and t.TopicStatus > 1
	)
	
	-- are there any existing
	DECLARE @existingid int

	Select top 1 @existingid = fse.ForumID FROM ForumScheduledEvents fse
	inner join guideentries g on g.ForumID = fse.ForumID
	WHERE g.SiteID = @siteid
	
	
	select 'ExistingID'= @existingid, g2.forumid from topics t 
	inner join guideentries g2 on g2.h2g2id = t.h2g2id
	where t.SiteID = @siteid AND t.TopicStatus <= 1
	AND t.h2g2id not in(
		Select distinct g.h2g2id from ForumScheduledEvents fse
		inner join guideentries g on g.forumid = fse.forumid
		WHERE g.SiteID = @siteid
	)
END	
ELSE
BEGIN
	return (0)
END
return (1)
