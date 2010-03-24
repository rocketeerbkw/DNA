create procedure getclubsinrelatedhierarchiesofclub @clubid int
as
BEGIN
	-- All the clubs in all the nodes this club is in, except @clubid
	SELECT DISTINCT c.ClubID, c.Name, g.Type FROM Clubs c, HierarchyClubMembers hc, GuideEntries g
		WHERE  c.ClubID<>@clubid AND
		      hc.ClubID = c.ClubID AND 
			  g.Entryid = c.h2g2id/10 AND g.status != 7 AND
			  hc.NodeID IN (-- All nodes this club is in
							SELECT h.NodeID FROM Hierarchy h, HierarchyClubMembers hc
							WHERE hc.NodeID=h.NodeID AND 
								  hc.ClubID=@clubid)
END
return(0)