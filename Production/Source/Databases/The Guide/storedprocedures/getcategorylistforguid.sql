CREATE PROCEDURE getcategorylistforguid @categorylistid uniqueidentifier
AS
SELECT	cl.LastUpdated,
		ISNULL(cl.ListWidth, 175) AS 'ListWidth',
		h.NodeID,
		h.DisplayName,
		h.Description,
		h.ParentID,
		h.h2g2ID,
		h.Synonyms,
		h.UserAdd,
		h.Type,
		h.SiteID
	FROM dbo.CategoryList cl
	INNER JOIN dbo.CategoryListMembers clm ON clm.CategoryListID = cl.CategoryListID
	INNER JOIN dbo.Hierarchy h ON h.NodeID = clm.NodeID
	WHERE cl.CategoryListID = @categorylistid
