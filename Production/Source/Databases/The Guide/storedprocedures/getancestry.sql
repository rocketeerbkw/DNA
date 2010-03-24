
Create Procedure getancestry @catid int
As
	SELECT a.AncestorID, h.DisplayName, h.TreeLevel, h.Type, h.RedirectNodeID, 'RedirectNodeName' = h2.DisplayName
		FROM Ancestors a 
		INNER JOIN Hierarchy h WITH(NOLOCK) ON a.AncestorID = h.NodeID
		LEFT JOIN Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = h.RedirectNodeID
	WHERE a.NodeID = @catid
	ORDER BY h.TreeLevel
	return (0)
