BEGIN TRANSACTION
-- Set the RedirectNodeIDs for all the nodes that need to be hidden
UPDATE dbo.Hierarchy SET RedirectNodeID = hidenodes.ParentID
FROM
(
	SELECT h1.NodeID, 'ParentID' = h.NodeID FROM Hierarchy h
	INNER JOIN dbo.Ancestors a ON a.AncestorID = h.NodeID
	INNER JOIN dbo.Hierarchy h1 ON h1.NodeID = a.NodeID
	WHERE h.TreeLevel = 3 AND h.SiteID = 16 AND h1.RedirectNodeID IS NULL AND h.Type = 2
)
AS hidenodes
WHERE hideNodes.NodeID = dbo.Hierarchy.NodeID
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK1'; RETURN; END

-- Move all Articles on hidden nodes to their redirect node ids removing diplicates
INSERT INTO HierarchyArticleMembers SELECT Entries.EntryID, Entries.NodeID FROM
(
	SELECT DISTINCT ham.EntryID, 'NodeID' = h.RedirectNodeID FROM HierarchyArticleMembers ham
	INNER JOIN Hierarchy h ON h.NodeID = ham.NodeID
	WHERE h.RedirectNodeID IS NOT NULL AND ham.NOdeID NOT IN
	(
		SELECT ham.EntryID FROM hierarchyArticleMembers ham
		INNER JOIN Hierarchy h ON h.NodeID = ham.NodeID
		WHERE h.RedirectNodeID IS NULL
	)
) AS Entries
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK3'; RETURN; END
DELETE FROM HierarchyArticleMembers WHERE NodeID IN ( SELECT NodeID FROM Hierarchy WHERE RedirectNodeID IS NOT NULL )
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK2'; RETURN; END

-- Move all Clubs on hidden nodes to their redirect node ids removing diplicates
INSERT INTO HierarchyClubMembers SELECT Clubs.ClubID, Clubs.NodeID FROM
(
	SELECT DISTINCT hcm.ClubID, 'NodeID' = h.RedirectNodeID FROM HierarchyClubMembers hcm
	INNER JOIN Hierarchy h ON h.NodeID = hcm.NodeID
	WHERE h.RedirectNodeID IS NOT NULL AND hcm.NodeID NOT IN
	(
		SELECT hcm.ClubID FROM hierarchyClubMembers hcm
		INNER JOIN Hierarchy h ON h.NodeID = hcm.NodeID
		WHERE h.RedirectNodeID IS NULL
	)
) AS Clubs
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; RETURN; END
DELETE FROM HierarchyClubMembers WHERE NodeID IN ( SELECT NodeID FROM Hierarchy WHERE RedirectNodeID IS NOT NULL )
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK4'; RETURN; END

-- remove the indexes from the hierarchy thread members table
EXEC dbo.dbu_createindexestemptable 'HierarchyThreadMembers'
DECLARE @sql varchar(max)
SELECT @sql=dropcmd FROM ##TableIndexes WHERE dropcmd LIKE '%UniqueTag%'
EXEC (@sql)

-- Move all Threads on hidden nodes to their redirect node ids removing diplicates
INSERT INTO HierarchyThreadMembers SELECT Threads.ThreadID, Threads.NodeID FROM
(
	SELECT DISTINCT htm.ThreadID, 'NodeID' = h.RedirectNodeID FROM HierarchyThreadMembers htm
	INNER JOIN Hierarchy h ON h.NodeID = htm.NodeID
	WHERE h.RedirectNodeID IS NOT NULL AND htm.NodeID NOT IN
	(
		SELECT htm.ThreadID FROM hierarchyThreadMembers htm
		INNER JOIN Hierarchy h ON h.NodeID = htm.NodeID
		WHERE h.RedirectNodeID IS NULL
	)
) AS Threads
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK5'; RETURN; END
DELETE FROM HierarchyThreadMembers WHERE NodeID IN (SELECT NodeID FROM Hierarchy WHERE RedirectNodeID IS NOT NULL)
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK6'; RETURN; END;

-- Delete all the duplicates
WITH cte AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY ThreadID, NodeID ORDER BY ThreadID) rn FROM HierarchyThreadMembers
)
DELETE FROM cte WHERE rn > 1
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK10'; DROP TABLE ##TableIndexes; RETURN; END;
PRINT 'Deleted Duplicate Entries'

-- Reapply the constaints
ALTER TABLE HierarchyThreadMembers ADD CONSTRAINT UniqueTag UNIQUE(ThreadID, NodeID)
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK12'; DROP TABLE ##TableIndexes; RETURN; END

DROP TABLE ##TableIndexes;

-- remove the indexes from the hierarchy thread members table
EXEC dbo.dbu_createindexestemptable 'HierarchyUserMembers'
SELECT @sql=dropcmd FROM ##TableIndexes WHERE dropcmd LIKE '%IX_HierarchyUserMembers%'
EXEC (@sql)

-- Move all Users on hidden nodes to their redirect node ids removing diplicates
INSERT INTO HierarchyUserMembers SELECT Users.UserID, Users.NodeID FROM
(
	SELECT DISTINCT hum.UserID, 'NodeID' = h.RedirectNodeID FROM HierarchyUserMembers hum
	INNER JOIN Hierarchy h ON h.NodeID = hum.NodeID
	WHERE h.RedirectNodeID IS NOT NULL AND UserID NOT IN
	(
		SELECT hum.UserID FROM HierarchyUserMembers hum
		INNER JOIN Hierarchy h ON h.NodeID = hum.NOdeID
		WHERE h.RedirectNodeID IS NULL
	)
) AS Users
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK8'; RETURN; END
DELETE FROM HierarchyUserMembers WHERE NodeID IN ( SELECT NodeID FROM Hierarchy WHERE RedirectNodeID IS NOT NULL )
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK7'; RETURN; END;

-- Delete all the duplicates
WITH cte AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY UserID, NodeID ORDER BY UserID) rn FROM HierarchyUserMembers
)
DELETE FROM cte WHERE rn > 1
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK10'; DROP TABLE ##TableIndexes; RETURN; END;
PRINT 'Deleted Duplicate Entries'

-- Reapply the constaints
ALTER TABLE HierarchyUserMembers ADD CONSTRAINT IX_HierarchyUserMembers UNIQUE(UserID, NodeID)
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK12'; DROP TABLE ##TableIndexes; RETURN; END

DROP TABLE ##TableIndexes;

-- Update the links table in respect to the categories
-- First drop the constraints
	EXEC dbo.dbu_createindexestemptable 'Links'
--	SELECT * FROM ##TableIndexes
--	DROP TABLE ##TableIndexes
	SELECT @sql=dropcmd FROM ##TableIndexes WHERE dropcmd LIKE '%IX_Links_Unique%'
	EXEC (@sql)

-- Now update the required links
UPDATE Links SET Links.LinkDescription = new.DisplayName, Links.DestinationID = new.NodeID
FROM
(
	SELECT h2.DisplayName, h2.NodeID, 'OriginalID' = h1.NodeID FROM Hierarchy h1
	INNER JOIN Hierarchy h2 ON h2.NodeID = h1.RedirectNodeID
	INNER JOIN Links l ON l.DestinationID = h1.NodeID
	WHERE l.DestinationType = 'Category' AND h1.RedirectNodeID IS NOT NULL
) AS new
WHERE Links.DestinationID = new.OriginalID
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK9'; DROP TABLE ##TableIndexes; RETURN; END;

-- Delete all the duplicates
WITH cte AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY SourceType, SourceID, DestinationType, DestinationID ORDER BY SourceID) rn FROM Links
)
DELETE FROM cte WHERE rn > 1
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK10'; DROP TABLE ##TableIndexes; RETURN; END;
PRINT 'Deleted Duplicate Entries'

-- Reapply the constaints
ALTER TABLE Links ADD CONSTRAINT IX_Links_Unique UNIQUE(SourceType, SourceID, DestinationType, DestinationID)
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK12'; DROP TABLE ##TableIndexes; RETURN; END

DROP TABLE ##TableIndexes;

-- Make sure that all email alerts on hidden nodes are updated to point at the redirect node
UPDATE EmailAlertListMembers SET EmailAlertListMembers.ItemID = h.RedirectNodeID
FROM Hierarchy h WHERE EmailAlertListMembers.ItemID = h.NodeID AND h.RedirectNodeID IS NOT NULL AND EmailAlertListMembers.ItemType = @NodeType
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK14'; RETURN; END

COMMIT TRANSACTION
