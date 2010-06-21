CREATE Procedure gethierarchynodedetails2 @nodeid int = null, @h2g2id int = null
As
	if (@nodeid IS NOT NULL)
	BEGIN
	SELECT h.NodeID, h.DisplayName, h.Description, h.LastUpdated, h.ParentID, h.h2g2ID, h.Synonyms, h.UserAdd, h.Type, h.SiteID, h.BaseLine, h.RedirectNodeID, 'RedirectNodeName' = h2.DisplayName
		FROM Hierarchy h WITH(NOLOCK)
		LEFT JOIN Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = h.RedirectNodeID
		WHERE (h.NodeID = @nodeid)
	END
	ELSE
	BEGIN
	SELECT h.NodeID, h.DisplayName, h.Description, h.LastUpdated, h.ParentID, h.h2g2ID, h.Synonyms, h.UserAdd, h.Type, h.SiteID, h.BaseLine, h.RedirectNodeID, 'RedirectNodeName' = h2.DisplayName
		FROM Hierarchy h WITH(NOLOCK)
		LEFT JOIN Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = h.RedirectNodeID
		WHERE (h.h2g2id = @h2g2id)
	END
	return (0) 