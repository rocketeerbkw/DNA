CREATE PROCEDURE getnodeidfromaliasid @linknodeid int
As

SELECT NodeId, LinkNodeId from hierarchynodealias WHERE linknodeid = @linknodeid

return(0)