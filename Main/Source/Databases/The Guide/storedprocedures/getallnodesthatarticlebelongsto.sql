CREATE PROCEDURE getallnodesthatarticlebelongsto @ih2g2id INT
AS
BEGIN
	DECLARE @EntryID int
	SET @EntryID=@ih2g2id/10

	SELECT h.NodeID, h.Type, h.DisplayName, h.SiteID, h.NodeMembers 
		FROM Hierarchy AS h WITH(NOLOCK)
		INNER JOIN HierarchyArticleMembers ha WITH(NOLOCK) ON ha.NodeID = h.NodeID
		WHERE ha.EntryID = @EntryID
END