CREATE PROCEDURE getclubcrumbtrail @clubid int
As
	SELECT 'MainNode' = a.NodeID, 'NodeID' = a.AncestorID, 'TreeLevel' = h.TreeLevel, 'DisplayName' = h.DisplayName, 'Type' = h.Type
		FROM dbo.Ancestors a 
		INNER JOIN dbo.Hierarchy h 
			ON a.AncestorID = h.NodeID
	WHERE a.NodeID IN (SELECT NodeID FROM dbo.hierarchyclubmembers h1 where clubid = @clubid)
UNION
	SELECT h.NodeID, h.NodeID, h.TreeLevel, h.DisplayName, h.Type
		FROM dbo.Hierarchy h 
	WHERE h.NodeID IN (SELECT NodeID FROM dbo.hierarchyclubmembers h1 where clubid = @clubid)
	ORDER BY a.NodeID, h.TreeLevel

