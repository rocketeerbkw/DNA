CREATE PROCEDURE canuseaddtonode @inodeid int
As
SELECT 'CanAdd' =
CASE WHEN EXISTS
(
SELECT * FROM Hierarchy WHERE NodeID = @inodeid AND UserAdd != 0
) THEN 1
ELSE 0
END