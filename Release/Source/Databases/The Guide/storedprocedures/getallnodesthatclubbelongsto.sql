CREATE PROCEDURE getallnodesthatclubbelongsto @iclubid INT
AS
BEGIN
	SELECT h.NodeID, h.Type, h.DisplayName, h.SiteID, h.NodeMembers 
	FROM Hierarchy AS h
	INNER JOIN HierarchyClubMembers hc ON hc.NodeID = h.NodeID
	WHERE hc.ClubID = @iclubid
END
