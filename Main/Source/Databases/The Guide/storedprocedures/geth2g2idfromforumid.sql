Create Procedure geth2g2idfromforumid @forumid int
As
	SELECT H2G2ID FROM GuideEntries WHERE ForumID = @forumid

return (0)