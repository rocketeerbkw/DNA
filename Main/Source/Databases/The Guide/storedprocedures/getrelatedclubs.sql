CREATE PROCEDURE  getrelatedclubs @h2g2id INT
AS
BEGIN
	DECLARE @EntryID int
	SET @EntryID=@h2g2id/10

	SELECT c.ClubID, g.Subject, g.ExtraInfo, g.type 
	FROM Clubs AS c WITH(NOLOCK), GuideEntries AS g WITH(NOLOCK) 
	WHERE g.status <> 7 AND g.Hidden IS NULL  AND  	g.EntryID = c.h2g2ID/10 AND c.ClubID IN
																	 (	
																			SELECT DISTINCT c.ClubID 
																			FROM Clubs AS c WITH(NOLOCK), HierarchyClubMembers AS h WITH(NOLOCK) 
																			WHERE c.ClubID = h.ClubID AND h.NodeID IN 
																						(	
																								SELECT NodeID 
																								FROM HierarchyArticleMembers WITH(NOLOCK) 
																								WHERE EntryID = @EntryID 
																						) 
																		)
	ORDER BY g.LastUpdated

END
