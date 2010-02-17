/*
ALTER TABLE dbo.Hierarchy ADD RedirectNodeID int NULL

ALTER PROCEDURE seteventtypevalinternal @eventtype varchar(50), @ieventtype int OUTPUT
AS
-- The values set here directly match those defined in the ENUM 
-- in CEventQueue.h 
-- !! Make sure both files stay up to date !!
SELECT @ieventtype = CASE 
	WHEN (@eventtype = 'ET_ARTICLEEDITED')					THEN 0
	WHEN (@eventtype = 'ET_CATEGORYARTICLETAGGED')			THEN 1
	WHEN (@eventtype = 'ET_CATEGORYARTICLEEDITED')			THEN 2
	WHEN (@eventtype = 'ET_FORUMEDITED')					THEN 3
	WHEN (@eventtype = 'ET_NEWTEAMMEMBER')					THEN 4
	WHEN (@eventtype = 'ET_POSTREPLIEDTO')					THEN 5
	WHEN (@eventtype = 'ET_POSTNEWTHREAD')					THEN 6
	WHEN (@eventtype = 'ET_CATEGORYTHREADTAGGED')			THEN 7
	WHEN (@eventtype = 'ET_CATEGORYUSERTAGGED')				THEN 8
	WHEN (@eventtype = 'ET_CATEGORYCLUBTAGGED')				THEN 9
	WHEN (@eventtype = 'ET_NEWLINKADDED')					THEN 10
	WHEN (@eventtype = 'ET_VOTEADDED')						THEN 11
	WHEN (@eventtype = 'ET_VOTEREMOVED')					THEN 12
	WHEN (@eventtype = 'ET_CLUBOWNERTEAMCHANGE')			THEN 13
	WHEN (@eventtype = 'ET_CLUBMEMBERTEAMCHANGE')			THEN 14
	WHEN (@eventtype = 'ET_CLUBMEMBERAPPLICATIONCHANGE')	THEN 15
	WHEN (@eventtype = 'ET_CLUBEDITED')						THEN 16
	WHEN (@eventtype = 'ET_CATEGORYHIDDEN')					THEN 17
	ELSE NULL
END

CREATE PROCEDURE dbu_createindexestemptable @tablename varchar(100) = NULL
AS
	WITH TableIndexes AS
	(
		SELECT	@tablename AS 'TableName',
				si.name,
				si.index_id,
				si.type_desc,
				si.is_unique,
				si.is_primary_key,
				si.is_unique_constraint
			FROM sys.indexes si
			JOIN sys.objects so ON si.object_id = so.object_id
			WHERE so.name=@tablename AND si.name IS NOT NULL
	),
	DropPK AS
	(
		SELECT 'ALTER TABLE '+ ti.TableName +' DROP CONSTRAINT '+ti.name as DropCMD,
				ti.name
				FROM TableIndexes ti
				WHERE ti.is_primary_key = 1
	),
	DropUnqConst AS
	(
		SELECT 'ALTER TABLE '+ ti.TableName +' DROP CONSTRAINT '+ti.name as DropCMD, 
				ti.name 
				FROM TableIndexes ti
				WHERE ti.is_unique_constraint = 1
	),
	DropIndexes AS
	(
		SELECT 'DROP INDEX '+ ti.name+' ON '+ti.TableName as DropCMD, 
				ti.name 
				FROM TableIndexes ti
				WHERE ti.is_primary_key = 0 AND ti.is_unique_constraint = 0
	),
	DropCmds AS
	(
		SELECT * FROM DropPK
		UNION
		SELECT * FROM DropUnqConst
		UNION
		SELECT * FROM DropIndexes
	),
	KeyCols AS
	(
		SELECT	ti.TableName, 
				ti.name,
				cols.COLUMN_NAME, 
				ic.is_included_column
			FROM sys.index_columns ic
			INNER JOIN TableIndexes ti ON ic.index_id = ti.index_id AND ic.object_id = OBJECT_ID(ti.tablename)
			INNER JOIN INFORMATION_SCHEMA.COLUMNS cols on ic.column_id = cols.ORDINAL_POSITION
			WHERE cols.TABLE_NAME = ti.TableName
	),
	KeyColList AS
	(
		SELECT DISTINCT name, '('+LEFT(colList, LEN(colList)-2)+')' AS colList
			FROM KeyCols kc
				CROSS APPLY (SELECT COLUMN_NAME+', ' AS [text()] FROM KeyCols 
								WHERE name = kc.name AND is_included_column = 0
								FOR XML PATH('')) AS s(colList)
	),
	KeyIncludeList AS
	(
		SELECT DISTINCT name, '('+LEFT(colList, LEN(colList)-2)+')' AS colList
			FROM KeyCols kc
				CROSS APPLY (SELECT COLUMN_NAME+', ' AS [text()] FROM KeyCols 
								WHERE name = kc.name AND is_included_column = 1
								FOR XML PATH('')) AS s(colList)
	),
	CreatePK AS
	(
		SELECT 'ALTER TABLE '+ ti.TableName +' ADD CONSTRAINT '+ti.name+' PRIMARY KEY'+kcl.colList as CreateCMD,
				ti.name
				FROM TableIndexes ti
				INNER JOIN KeyColList kcl ON ti.name = kcl.name
				WHERE ti.is_primary_key = 1
	),
	CreateUnqConst AS
	(
		SELECT 'ALTER TABLE '+ ti.TableName +' ADD CONSTRAINT '+ti.name+' UNIQUE'+kcl.colList as CreateCMD,
				ti.name
				FROM TableIndexes ti
				INNER JOIN KeyColList kcl ON ti.name = kcl.name
				WHERE ti.is_unique_constraint = 1
	),
	CreateIndexes AS
	(
		SELECT 'CREATE '+
					CASE WHEN ti.is_unique = 1 THEN 'UNIQUE ' ELSE N'' END+
					(ti.type_desc COLLATE Latin1_General_CI_AS)+
					' INDEX '+ (ti.name COLLATE Latin1_General_CI_AS )+' ON '+ti.TableName+kcl.colList+
					CASE WHEN kil.colList IS NOT NULL THEN ' INCLUDE '+kil.colList ELSE '' END 
					AS CreateCMD,
					ti.name 
				FROM TableIndexes ti
				INNER JOIN KeyCols kc ON ti.name = kc.name
				INNER JOIN KeyColList kcl ON ti.name = kcl.name
				LEFT JOIN KeyIncludeList kil ON ti.name = kil.name
				WHERE ti.is_primary_key = 0 AND ti.is_unique_constraint = 0
	),
	CreateCmds AS
	(
		SELECT * FROM CreatePK
		UNION
		SELECT * FROM CreateUnqConst
		UNION
		SELECT * FROM CreateIndexes
	)
	SELECT cc.CreateCMD, dc.DropCMD, ti.* 
		INTO ##TableIndexes
		FROM TableIndexes ti
		LEFT JOIN DropCmds dc ON ti.name = dc.name
		LEFT JOIN CreateCmds cc ON ti.name = cc.name
*/
BEGIN TRANSACTION

-- Set the RedirectNodeIDs for all the nodes that need to be hidden
UPDATE Hierarchy SET Hierarchy.RedirectNodeID = Nodes.ParentID FROM
(
	SELECT h1.ParentID, 'NodeID' = ISNULL(h2.NodeID,h1.NodeID) FROM Hierarchy h1
	LEFT JOIN Hierarchy h2 on h2.ParentID = h1.NodeID
	WHERE h1.ParentID IN
	(
		2663,2680,2696,2719,2736,2753,2785,2816,2836,2853,2879,2895,2913,2929,2954,2978,3031,3053,
		3077,3100,3124,3148,3174,3205,3224,3256,3573,3672,3734,4188,4345,5456,5626,6119,6546,6589,
		6854,7131,7468,7550,7950,8066,8158,8341,8551,8786,8836,8959,9173,9250,9308,9349,9473,9575,
		9691,9798,9917,10223,10420,10532,10560,10603,10665,10725,10782,10844,10958,10993,11086,11271,
		11306,11397,11504,11568,11643,11705,11748,11850,11880,11980,12066,12229,12296,12387,12557,12682,
		12776,12880,12930,13184,13234,13366,13461,13609,13695,13831,13949,14096,14303,14486,14574,14599,
		14687,14724,14847,14948,15044,15115,15198,15292,15342,15417,15503,15540,15693,15810,15864,15918,
		16221,16317,16391,16455,16534,16630,16720,16800,16952,17084,17156,17318,17356,17416,17488,17525,
		17599,17634,17795,17919,18150,18434,18473,18731,19027,19205,19311,19585,19866,19986,20147,20286,
		20421,20538,20670,20914,20962,21135,21475,21645,21990,22054,22093,22173,22226,22278,22415,22450,
		22473,22574,22657,22722,22768,22933,22981,23012,23064,23096,23216,23313,23368,23502,23575,23621,
		23833,23950,23992,24189,24289,24309,24377,24465,24547,24687,24839,24928,24942,24977,25043,25089,
		25156,25274,25351,25394,25625,25716,25803,25824,25948,26649,27558,27676,27887,28061,28143,28257,
		28343,28430,28508,28584,28817,28946,29164,29462,29697,29843,30096,30128,30160,30405,30499,30941,
		31038,31167,31191,31220,31285,31320,31360,31468,31499,31713,31737,31779,31812,31860,32040,32096,
		32288,32316,32424,32452,32590,32718,32783,32987,33017,33260,33441,33615,33711,33956,34002,34031,
		34117,34284,34320,34441,34493,34564,34586,34638,34656,34719,34765,35002,35027,35261,35409,35476,
		35504,35534,35564,35596,35631,35667,35705,35787,35826,35864,35906,35947,35984,36033,36068,36105,
		36138,36166,36213,36239,36271,36306,36339,36590,36784,36904,36940,37078,37142,37190,37348,37496,
		37607,37750,37804,37877,37979,38104,38192,38269,38491,38539,38603,38638,38669,38705,38821,38861,
		38890,38933,39099,39120,39203,39240,39297,39323,39379,39514,39556,39753,39898,40076,40233,40262,
		40306,40324,40359,40442,40569,40685,40779,40953,41038,41064,41187,41270,41292,41355,41392,41592,
		41765,41789,41956,41994,42116,42328,42516,42547,42575,42624,42650,42675,42747,42793,42992,43025,
		43237,43432,43481,43584,43924,43970,44004,44393,44627,44768,44973,45019,45254,45487,45520,45599,
		45839,46001,46409,46578,46807,47061,47275,47564,47838,48045,48292,48443,48465,48507,48800,48829,
		49047,49305,49541,49709,49979,50139,50225,50418,50532,50707,50806,50909,51115,51308,51467,52056,
		52513,52860,53189,53359,53426,53528,53709,53928,53996,54132,54315
	)
	UNION ALL
	SELECT DISTINCT h1.ParentID, h1.NodeID FROM Hierarchy h1
	INNER JOIN Hierarchy h2 on h2.ParentID = h1.NodeID
	WHERE h1.ParentID IN
	(
		2663,2680,2696,2719,2736,2753,2785,2816,2836,2853,2879,2895,2913,2929,2954,2978,3031,3053,
		3077,3100,3124,3148,3174,3205,3224,3256,3573,3672,3734,4188,4345,5456,5626,6119,6546,6589,
		6854,7131,7468,7550,7950,8066,8158,8341,8551,8786,8836,8959,9173,9250,9308,9349,9473,9575,
		9691,9798,9917,10223,10420,10532,10560,10603,10665,10725,10782,10844,10958,10993,11086,11271,
		11306,11397,11504,11568,11643,11705,11748,11850,11880,11980,12066,12229,12296,12387,12557,12682,
		12776,12880,12930,13184,13234,13366,13461,13609,13695,13831,13949,14096,14303,14486,14574,14599,
		14687,14724,14847,14948,15044,15115,15198,15292,15342,15417,15503,15540,15693,15810,15864,15918,
		16221,16317,16391,16455,16534,16630,16720,16800,16952,17084,17156,17318,17356,17416,17488,17525,
		17599,17634,17795,17919,18150,18434,18473,18731,19027,19205,19311,19585,19866,19986,20147,20286,
		20421,20538,20670,20914,20962,21135,21475,21645,21990,22054,22093,22173,22226,22278,22415,22450,
		22473,22574,22657,22722,22768,22933,22981,23012,23064,23096,23216,23313,23368,23502,23575,23621,
		23833,23950,23992,24189,24289,24309,24377,24465,24547,24687,24839,24928,24942,24977,25043,25089,
		25156,25274,25351,25394,25625,25716,25803,25824,25948,26649,27558,27676,27887,28061,28143,28257,
		28343,28430,28508,28584,28817,28946,29164,29462,29697,29843,30096,30128,30160,30405,30499,30941,
		31038,31167,31191,31220,31285,31320,31360,31468,31499,31713,31737,31779,31812,31860,32040,32096,
		32288,32316,32424,32452,32590,32718,32783,32987,33017,33260,33441,33615,33711,33956,34002,34031,
		34117,34284,34320,34441,34493,34564,34586,34638,34656,34719,34765,35002,35027,35261,35409,35476,
		35504,35534,35564,35596,35631,35667,35705,35787,35826,35864,35906,35947,35984,36033,36068,36105,
		36138,36166,36213,36239,36271,36306,36339,36590,36784,36904,36940,37078,37142,37190,37348,37496,
		37607,37750,37804,37877,37979,38104,38192,38269,38491,38539,38603,38638,38669,38705,38821,38861,
		38890,38933,39099,39120,39203,39240,39297,39323,39379,39514,39556,39753,39898,40076,40233,40262,
		40306,40324,40359,40442,40569,40685,40779,40953,41038,41064,41187,41270,41292,41355,41392,41592,
		41765,41789,41956,41994,42116,42328,42516,42547,42575,42624,42650,42675,42747,42793,42992,43025,
		43237,43432,43481,43584,43924,43970,44004,44393,44627,44768,44973,45019,45254,45487,45520,45599,
		45839,46001,46409,46578,46807,47061,47275,47564,47838,48045,48292,48443,48465,48507,48800,48829,
		49047,49305,49541,49709,49979,50139,50225,50418,50532,50707,50806,50909,51115,51308,51467,52056,
		52513,52860,53189,53359,53426,53528,53709,53928,53996,54132,54315
	)
) AS Nodes
WHERE Hierarchy.NodeID = Nodes.NodeID
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

-- Put an email alert in the emaileventqueue telling the user that their alert has been moved
DECLARE @NodeType int, @NodeHidden int, @UserID int
SELECT @UserID = EventAlertMessageUserID FROM Sites WHERE URLName = 'actionnetwork'
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC seteventtypevalinternal 'ET_CATEGORYHIDDEN', @NodeHidden OUTPUT
INSERT INTO EventQueue
	SELECT  EventType = @NodeHidden,
			ItemID = h.RedirectNodeID, ItemType = @NodeType,
			ItemID2 = h.NodeID, ItemType2 = @NodeType,
			EventDate = GetDate(), UserID = @UserID
	FROM Hierarchy h
	WHERE h.RedirectNodeID IS NOT NULL
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK13'; RETURN; END

-- Make sure that all email alerts on hidden nodes are updated to point at the redirect node
UPDATE EmailAlertListMembers SET EmailAlertListMembers.ItemID = h.RedirectNodeID
FROM Hierarchy h WHERE EmailAlertListMembers.ItemID = h.NodeID AND h.RedirectNodeID IS NOT NULL AND EmailAlertListMembers.ItemType = @NodeType
IF (@@ERROR > 0) BEGIN ROLLBACK TRANSACTION; PRINT 'ROLLBACK14'; RETURN; END

COMMIT TRANSACTION

/*
SELECT TOP 10 * FROM Hierarchy WHERE RedirectNodeID IS NOT NULL AND TreeLevel > 6
SELECT COUNT(*) FROM Hierarchy WHERE RedirectNodeID IS NOT NULL
SELECT COUNT(*) FROM HierarchyArticleMembers ham INNER JOIN Hierarchy h ON h.NodeID = ham.NodeID WHERE h.RedirectNodeID IS NOT NULL
SELECT COUNT(*) FROM HierarchyClubMembers hcm INNER JOIN Hierarchy h ON h.NodeID = hcm.NodeID WHERE h.RedirectNodeID IS NOT NULL
SELECT COUNT(*) FROM HierarchyThreadMembers htm INNER JOIN Hierarchy h ON h.NodeID = htm.NodeID WHERE h.RedirectNodeID IS NOT NULL
SELECT COUNT(*) FROM HierarchyUserMembers hum INNER JOIN Hierarchy h ON h.NodeID = hum.NodeID WHERE h.RedirectNodeID IS NOT NULL
SELECT COUNT(*) FROM Links l INNER JOIN Hierarchy h ON h.NodeID = l.DestinationID AND l.DestinationType = 'Category' AND h.RedirectNodeID IS NOT NULL
SELECT COUNT(*) FROM EventQueue
SELECT * FROM EventQueue


*/

