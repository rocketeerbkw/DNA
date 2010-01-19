Create Procedure getnodeidforthreadid @ithreadid int, @isiteid int
As
SELECT NodeID FROM Hierarchy WHERE SiteID = @isiteid AND h2g2ID IN (
	SELECT h2g2ID FROM GuideEntries WHERE ForumID IN (
		SELECT ForumID FROM Threads WHERE ThreadID = @ithreadid ) )
