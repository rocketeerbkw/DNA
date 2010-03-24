CREATE PROCEDURE gettaglimitsforuser
As
SELECT h.NodeType, u.Limit, h.Description, h.SiteID FROM UserTagLimits u
INNER JOIN HierarchyNodeTypes h ON u.NodeTypeID = h.NodeTypeID