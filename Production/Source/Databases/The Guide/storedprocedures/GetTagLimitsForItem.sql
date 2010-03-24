CREATE PROCEDURE gettaglimitsforitem @iarticletype int
As
SELECT h.NodeType, a.Limit, h.Description, h.SiteID FROM ArticletagLimits a
INNER JOIN HierarchyNodeTypes h ON a.NodeTypeID = h.NodeTypeID
WHERE a.ArticleType = @iArticleType
