CREATE PROCEDURE getalllocalauthoritynodes @isiteid int, @inodeid int, @iauthoritylevel int
As

-- Check to see if we've been given a node to start from
DECLARE @TopTaxNode int
IF (@inodeid = 0)
	-- Find the top
	SELECT @TopTaxNode = NodeID FROM Hierarchy WHERE DisplayName = 'Location' AND SiteID = @isiteid AND Type = 3
ELSE
BEGIN
	-- Check the treelevel for the node. If it's the same or below the authority level then find the it's parent
	DECLARE @Level int
	SELECT @Level = TreeLevel FROM Hierarchy WHERE NodeID = @inodeid AND SiteID = @isiteid AND Type = 3

	IF (@Level > @iauthoritylevel)
	BEGIN
		-- We are below the Authority level, so just select the Authority Node info
		SELECT @TopTaxNode = AncestorID FROM Ancestors WHERE NodeID = @inodeid AND TreeLevel = (@iauthoritylevel)
		SELECT 'Count' = 1, * FROM Hierarchy WHERE NodeID = @TopTaxNode AND SiteID = @isiteid AND Type = 3
		RETURN
	END
	ELSE IF (@Level = @iauthoritylevel)
		-- We're at the Authority, display all related authorities
		SELECT @TopTaxNode = AncestorID FROM Ancestors WHERE NodeID = @inodeid AND TreeLevel = (@iauthoritylevel - 1)
	ELSE
		-- Just use the node we've been given
		SELECT @TopTaxNode = @inodeid
END

-- Get a count of all the nodes
DECLARE @Count int
SELECT DISTINCT @Count = COUNT(*) FROM Hierarchy h
INNER JOIN Ancestors a ON a.AncestorID = @TopTaxNode AND (a.NodeID = h.NodeID)
WHERE h.SiteID = @isiteid AND h.TreeLevel = @iauthoritylevel AND h.Type = 3

-- Now select all the authority nodes
SELECT DISTINCT 'Count' = @Count, h.* FROM Hierarchy h
INNER JOIN Ancestors a ON a.AncestorID = @TopTaxNode AND (a.NodeID = h.NodeID)
WHERE h.SiteID = @isiteid AND h.TreeLevel = @iauthoritylevel AND h.Type = 3
ORDER BY DisplayName
