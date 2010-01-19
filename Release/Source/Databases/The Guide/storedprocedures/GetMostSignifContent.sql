CREATE PROCEDURE getmostsignifcontent
	@siteid		int,
	@rowcount	int = 20 
AS
	SET ROWCOUNT @RowCount

	CREATE TABLE #_SignifContent
	(
		Type			int,
		ContentID		int, 
		ContentTitle	varchar(255),
		ForumID			int,
		Score			float
	)

	INSERT INTO #_signifcontent 
	SELECT 1, csu.UserId, u.UserName, null, csu.Score
	  FROM dbo.ContentSignifUser csu 
	       INNER JOIN dbo.Users u ON u.UserID = csu.UserID
	 WHERE csu.SiteID = @SiteID
	 ORDER BY csu.Score DESC
	
	INSERT INTO #_signifcontent 	
	SELECT 2, ge.h2g2ID, ge.Subject, null, csa.Score
	  FROM dbo.ContentSignifArticle csa
	       INNER JOIN GuideEntries ge ON ge.EntryID = csa.EntryID
	 WHERE csa.SiteID = @SiteID
	 ORDER BY Score DESC	

	INSERT INTO #_signifcontent 
	SELECT 3, csn.NodeId, h.DisplayName , null, csn.Score
	  FROM dbo.ContentSignifNode csn
	       INNER JOIN Hierarchy h ON h.NodeID = csn.NodeID
	 WHERE csn.SiteID = @SiteID
	 ORDER BY Score DESC

	INSERT INTO #_signifcontent 
	SELECT 4, csf.ForumId, f.Title, null, csf.Score
	  FROM dbo.ContentSignifForum csf
	       INNER JOIN dbo.Forums f ON f.ForumID = csf.ForumID
	 WHERE csf.SiteID = @SiteID
	 ORDER BY Score DESC

	INSERT INTO #_signifcontent 
	SELECT 5, csc.ClubID, c.Name, null, csc.Score
	  FROM dbo.ContentSignifClub csc
	       INNER JOIN Clubs c ON c.ClubID = csc.ClubId
	 WHERE csc.SiteID = @SiteID
	 ORDER BY Score DESC	

	INSERT INTO #_signifcontent 
	SELECT 6, cst.ThreadId, t.FirstSubject, t.ForumID, cst.Score
	  FROM dbo.ContentSignifThread cst
	       INNER JOIN  dbo.Threads t ON cst.ThreadID = t.ThreadID
	 WHERE cst.SiteID = @SiteID
	 ORDER BY Score DESC
	
	SET ROWCOUNT 0 
	
	SELECT *
	  FROM #_signifcontent 
	 ORDER BY Type ASC, Score DESC

RETURN @@ERROR
