CREATE PROCEDURE cachegetcategory @nodeid INT
AS

SELECT h.LastUpdated
FROM dbo.Hierarchy h WITH(NOLOCK)
WHERE h.NodeId = @nodeid

