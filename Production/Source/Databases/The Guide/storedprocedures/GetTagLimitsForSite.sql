CREATE PROCEDURE gettaglimitsforsite @isiteid int
AS

-- Get all node types in the hierarchy for a site and getting limits where they exist for each node type.
SELECT 'TYPEDARTICLE' 'Type', a.ArticleType, a.Limit, h.NodeType, h.Description FROM HierarchyNodeTypes h
LEFT JOIN ArticleTagLimits a ON h.NodeTypeID = a.NodeTypeID
WHERE h.SiteID = @isiteid

UNION 

SELECT 'THREAD' 'Type', NULL, th.Limit, h.NodeType, h.Description FROM HierarchyNodeTypes h
LEFT JOIN ThreadTagLimits th ON h.NodeTypeID = th.NodeTypeID
WHERE h.SiteID = @isiteid

UNION

SELECT 'USER' 'Type', NULL, u.Limit, h.NodeType, h.Description FROM HierarchyNodeTypes h
LEFT JOIN UserTagLimits u ON h.NodeTypeID = u.NodeTypeID
WHERE h.SiteID = @isiteid

ORDER BY Type, a.ArticleType
