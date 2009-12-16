CREATE PROCEDURE getusercrumbtrail @userid int
As
	SELECT 'MainNode' = a.NodeID, 'NodeID' = a.AncestorID, 'TreeLevel' = h.TreeLevel, 'DisplayName' = h.DisplayName, 'Type' = h.Type
		FROM dbo.Ancestors a WITH(NOLOCK) 
		INNER JOIN dbo.Hierarchy h WITH(NOLOCK) 
			ON a.AncestorID = h.NodeID
	WHERE a.NodeID IN (SELECT NodeID FROM dbo.hierarchyusermembers h1 WITH(NOLOCK) where userid = @userid)
UNION
	SELECT h.NodeID, h.NodeID, h.TreeLevel, h.DisplayName, h.Type
		FROM dbo.Hierarchy h WITH(NOLOCK) 
	WHERE h.NodeID IN (SELECT NodeID FROM dbo.hierarchyusermembers h1 WITH(NOLOCK) where userid = @userid)
	ORDER BY a.NodeID, h.TreeLevel