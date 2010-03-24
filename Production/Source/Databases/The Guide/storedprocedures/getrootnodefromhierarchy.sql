Create Procedure getrootnodefromhierarchy @siteid int
As
	SELECT h.NodeID FROM Hierarchy h
	WHERE h.SiteID = @siteid and parentid is null
	return (0)