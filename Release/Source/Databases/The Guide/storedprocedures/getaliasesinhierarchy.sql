Create Procedure getaliasesinhierarchy @nodeid int
As
	SELECT 	a.linknodeid, h.DisplayName, h.articlemembers, h.nodealiasmembers, h.nodemembers, 'SubName' = h1.DisplayName, 'SubNodeID' = h1.NodeID 
		FROM Hierarchy h
		INNER JOIN HierarchyNodeAlias a ON h.nodeid = a.linknodeid 
		LEFT JOIN Hierarchy h1 ON h1.ParentID = a.linknodeid
		WHERE a.nodeid = @nodeid
		ORDER BY h.DisplayName, h1.DisplayName
	return (0)