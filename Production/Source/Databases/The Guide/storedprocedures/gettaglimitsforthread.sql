CREATE PROCEDURE gettaglimitsforthread
As
SELECT h.NodeType, tl.Limit, h.Description, h.SiteID FROM ThreadTagLimits tl
INNER JOIN HierarchyNodeTypes h ON tl.NodeTypeID = h.NodeTypeID