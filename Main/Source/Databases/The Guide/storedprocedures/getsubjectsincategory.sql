CREATE PROCEDURE getsubjectsincategory @nodeid int
AS
-- First, select all the children of the given node and their children's children
SELECT	h.*,
		'SubName' = h1.DisplayName,
		'SubNodeID' = h1.NodeID,
		'SubNodeType' = h1.type,
		'weighting' = h1.NodeMembers + h1.NodeAliasMembers + h1.ArticleMembers,
		'RedirectNodeID' = h.RedirectNodeID,
		'RedirectNodeName' = h2.DisplayName,
		'SubRedirectNodeID' = h1.RedirectNodeID,
		'SubRedirectNodeName' = h3.DisplayName
FROM Hierarchy h WITH(NOLOCK)
LEFT JOIN Hierarchy h1 WITH(NOLOCK) ON h1.parentid = h.nodeid
LEFT JOIN Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = h.RedirectNodeID
LEFT JOIN Hierarchy h3 WITH(NOLOCK) ON h3.NodeID = h1.RedirectNodeID
WHERE h.ParentID = @nodeid
-- Now add the children's children that are link nodes to the node's children
UNION
SELECT	h.*,
		'SubName' = h1.DisplayName,
		'SubNodeID' = h1.NodeID,
		'SubNodeType' = h1.type,
		'weighting' = h1.NodeMembers + h1.NodeAliasMembers + h1.ArticleMembers,
		'RedirectNodeID' = h.RedirectNodeID,
		'RedirectNodeName' = h2.DisplayName,
		'SubRedirectNodeID' = h1.RedirectNodeID,
		'SubRedirectNodeName' = h3.DisplayName
FROM Hierarchy h WITH(NOLOCK)
INNER JOIN hierarchynodealias ha WITH(NOLOCK) ON ha.nodeid=h.nodeid
INNER JOIN Hierarchy h1 WITH(NOLOCK) ON h1.nodeid=ha.linknodeid
LEFT JOIN Hierarchy h2 WITH(NOLOCK) ON h2.NodeID = h.RedirectNodeID
LEFT JOIN Hierarchy h3 WITH(NOLOCK) ON h3.NodeID = h1.RedirectNodeID
WHERE h.ParentID = @nodeid 
ORDER BY h.DisplayName, weighting DESC