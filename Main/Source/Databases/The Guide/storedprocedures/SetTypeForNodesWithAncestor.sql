CREATE PROCEDURE settypefornodeswithancestor @ancestor int, @typeid int, @siteid int
As

UPDATE Hierarchy SET Type = @typeid
WHERE NodeId in (
	SELECT a.NodeID FROM Ancestors a 
	WHERE a.AncestorID = @ancestor 
	OR a.NodeID = @ancestor
) AND SiteID = @siteid 