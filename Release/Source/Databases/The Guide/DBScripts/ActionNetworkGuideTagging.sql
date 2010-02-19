--select top 10 * from hierarchyarticlemembers

DECLARE @siteid int
SELECT @siteid = SiteID FROM Sites WHERE URLName = 'actionnetwork'
IF (@SiteID IS NULL)
BEGIN
	PRINT 'Failed to get siteid for Actionnetwork'
	RETURN
END

-- Get the help node that we want to attatch the new guides node to
DECLARE @HelpNodeID int
select @HelpNodeID = nodeid from hierarchy where displayname like 'Help' and siteid = 16 and treelevel = 1
IF (@HelpNodeID IS NULL)
BEGIN
	PRINT 'Failed to the help node for actionnetwork'
	RETURN
END

BEGIN TRANSACTION

-- Now check to see if the guides node is already a child of the help
DECLARE @ReturnCode int, @GuidesNodeID INT
SELECT @GuidesNodeID = NodeID FROM Hierarchy WHERE displayname = 'Guides' AND SiteID = 16 AND ParentID = @HelpNodeID
IF (@GuidesNodeID IS NULL)
BEGIN
	-- Create the guides node
	EXEC @ReturnCode = addnodetohierarchyinternal @HelpNodeID, 'Guides', @SiteID, @GuidesNodeID OUTPUT
	IF (@ReturnCode <> 0)
	BEGIN
		PRINT 'Failed to create the guides node for actionnetwork'
		ROLLBACK TRANSACTION
		RETURN
	END
END

-- Now check to see if the Rights node exists and it belongs to guides
DECLARE @RightsNodeID INT
SELECT @RightsNodeID = NodeID FROM Hierarchy WHERE displayname = 'Rights' AND SiteID = 16 AND ParentID = @GuidesNodeID
IF (@RightsNodeID IS NULL)
BEGIN
	-- Create the guides node
	EXEC @ReturnCode = addnodetohierarchyinternal @GuidesNodeID, 'Rights', @SiteID, @RightsNodeID OUTPUT
	IF (@ReturnCode <> 0)
	BEGIN
		PRINT 'Failed to create the Rights node for actionnetwork'
		ROLLBACK TRANSACTION
		RETURN
	END
END

-- Now check to see if the HowTo's node exists and it belongs to guides
DECLARE @HowtoNodeID INT
SELECT @HowtoNodeID = NodeID FROM Hierarchy WHERE displayname = 'How To''s' AND SiteID = 16 AND ParentID = @GuidesNodeID
IF (@HowtoNodeID IS NULL)
BEGIN
	-- Create the guides node
	EXEC @ReturnCode = addnodetohierarchyinternal @GuidesNodeID, 'How To''s', @SiteID, @HowtoNodeID OUTPUT
	IF (@ReturnCode <> 0)
	BEGIN
		PRINT 'Failed to create the How Tos node for actionnetwork'
		ROLLBACK TRANSACTION
		RETURN
	END
END

-- Now check to see if the System Overviews node exists and it belongs to guides
DECLARE @OverviewsNodeID INT
SELECT @OverviewsNodeID = NodeID FROM Hierarchy WHERE displayname = 'System Overviews' AND SiteID = 16 AND ParentID = @GuidesNodeID
IF (@OverviewsNodeID IS NULL)
BEGIN
	-- Create the guides node
	EXEC @ReturnCode = addnodetohierarchyinternal @GuidesNodeID, 'System Overviews', @SiteID, @OverviewsNodeID OUTPUT
	IF (@ReturnCode <> 0)
	BEGIN
		PRINT 'Failed to create the Overviews node for actionnetwork'
		ROLLBACK TRANSACTION
		RETURN
	END
END

-- Now check to see if the Briefings node exists and it belongs to guides
DECLARE @BriefingsNodeID INT
SELECT @BriefingsNodeID = NodeID FROM Hierarchy WHERE displayname = 'Briefings' AND SiteID = 16 AND ParentID = @GuidesNodeID
IF (@BriefingsNodeID IS NULL)
BEGIN
	-- Create the guides node
	EXEC @ReturnCode = addnodetohierarchyinternal @GuidesNodeID, 'Briefings', @SiteID, @BriefingsNodeID OUTPUT
	IF (@ReturnCode <> 0)
	BEGIN
		PRINT 'Failed to create the Briefings node for actionnetwork'
		ROLLBACK TRANSACTION
		RETURN
	END
END

-- Now check to see if the Campaigning node exists and it belongs to guides
DECLARE @CampaigningNodeID INT
SELECT @CampaigningNodeID = NodeID FROM Hierarchy WHERE displayname = 'Campaigning' AND SiteID = 16 AND ParentID = @GuidesNodeID
IF (@CampaigningNodeID IS NULL)
BEGIN
	-- Create the guides node
	EXEC @ReturnCode = addnodetohierarchyinternal @GuidesNodeID, 'Campaigning', @SiteID, @CampaigningNodeID OUTPUT
	IF (@ReturnCode <> 0)
	BEGIN
		PRINT 'Failed to create the Campaigning node for actionnetwork'
		ROLLBACK TRANSACTION
		RETURN
	END
END

-- Now create a temp table to hold all the articles to be tagged and to which node
CREATE TABLE #ArticlesToTag (EntryID int, NodeID int)
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to create the temporary table'
	ROLLBACK TRANSACTION
	RETURN
END

-- Now add all the article to be tagged to rights
INSERT INTO #ArticlesToTag SELECT 'EntryID' = Guides.EntryID, 'NodeID' = @RightsNodeID
FROM
(
	--Rights
	SELECT EntryID FROM GuideEntries WHERE h2g2id IN
	(
		1185527,1186904,1185167,2053900,2314801,2160695,2151785,2179109,2179884,2202373,2398700,
		1186896,1186012,1186085,1186021,1186157,1181972,1181990,1181981,1181882,1181846,1184672,
		2139770,2494208,2053793,2053739,1175041,2053180,1174916,1186922,1186931,1185202,1185671,
		1185428,1185473,1186887,1175726,1175276,1185888,1185662,1185842,1175735,1175933,1175942
	)
) AS guides
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to add rights nodes to temp table'
	ROLLBACK TRANSACTION
	RETURN
END

-- Now add all the article to be tagged to How to's
INSERT INTO #ArticlesToTag SELECT 'EntryID' = Guides.EntryID, 'NodeID' = @HowtoNodeID
FROM
(
	--Howto’s
	SELECT EntryID FROM GuideEntries WHERE h2g2id IN
	(
		2671526,12794781,12795023,12795320,12795203,12794970,12794871,12795078,12795258,12794844,13132874,
		13219788,2451124,2839070,2802476,2815463,2218114,1181657,2494343,2494172,3412676,2269811,2270323,
		1183259,1181783,2258462,4289349,2795060,2378504,2235917,2494127,2515790,2389511,2152423,2494154,
		2494262,2458208,2379594,2207323,2265608,2185003,1183376,2263402,2283130,2286434,2696565,2205361,
		2454554,3158327,1174727,1181774,3667386,2309348,1183222,1182449,1183466,1175681,1183295,2404054,
		2453870,2494325,1181693,2797464,3044206,1183448,1183015,1182584,1185879,2110753,2494145,1181756,
		1181710,3177245,3085571,3167688,1181684,2228159,4289385,3193571,8492547,2816633,2816336,2809677
	)
) AS Guides
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to add How to nodes to temp table'
	ROLLBACK TRANSACTION
	RETURN
END

-- Now add all the article to be tagged to Overviews
INSERT INTO #ArticlesToTag SELECT 'EntryID' = Guides.EntryID, 'NodeID' = @OverviewsNodeID
FROM
(
	--System overviews
	SELECT EntryID FROM GuideEntries WHERE h2g2id IN
	(
		1181800,1181792,2202166,1181819,4289358,1939944,2151686,1183312,2459388,2455472,
		2891315,2066951,4289394,4289303,4289321,4289367,2454978,1173322,2494181
	)
) AS Guides
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to add Overview nodes to temp table'
	ROLLBACK TRANSACTION
	RETURN
END

-- Now add all the article to be tagged to Briefings
INSERT INTO #ArticlesToTag SELECT 'EntryID' = Guides.EntryID, 'NodeID' = @BriefingsNodeID
FROM
(
	--Briefings
	SELECT EntryID FROM GuideEntries WHERE h2g2id IN
	(
		3074690,2319176,3009890,2998092,3032326,2369892,2908262,2702143,2979499,2418509,1185419,
		2352232,2641060,2700956,3161279,3739278,2969517,2830637,2459874,2309564,2519327,2455652,
		2852462,2427275,2303966,2979165,2434457,2836550
	)
) AS Guides
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to add Briefing nodes to temp table'
	ROLLBACK TRANSACTION
	RETURN
END

-- Now add all the article to be tagged to Campaigning
INSERT INTO #ArticlesToTag SELECT 'EntryID' = Guides.EntryID, 'NodeID' = @CampaigningNodeID
FROM
(
	--Campaigning
	SELECT EntryID FROM GuideEntries WHERE h2g2id IN
	(
		1177715,2066320,2109764,9088581,4288926,2064115,4289150,4289123,4288908,1183321,5927970,4289619,
		2062234,2128033,4289628,4289114,4289042,4288917,2034145,4289745,4288935,4289015,4288944,4289169,
		4289141,4289178,2404856,4289970,2182907,4289060,4289088,4289484,2283824,2063783,4289763,4290293,
		2066726,2240812,4289132,2110627,4289664,4289420,4289501,4289493,4289565,2064188,4289259,4289376,
		2053405,2053423,2053504,2053612,2053649,2053469,4289204,4289213,1183330,4289277,4289312,4289457,
		4289510,2584497,2219951,4286658,2119079,4289411,2066140,4289033,2103913,2228519,2228528,4288890,
		4288953,4288971,1930367,2033687,4289907
	)
) AS Guides
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to add Campaign nodes to temp table'
	ROLLBACK TRANSACTION
	RETURN
END

DECLARE @Count int
SELECT @Count = COUNT(*) FROM #ArticlesToTag
PRINT 'Items to tag = ' + CAST(@Count AS varchar(5))

-- Now insert all the entries into the table
INSERT INTO HierarchyArticleMembers SELECT Guides.EntryID, Guides.NodeID
FROM
(
	SELECT EntryID, NodeID FROM #ArticlesToTag
) AS Guides
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to add Campaign nodes to temp table'
	ROLLBACK TRANSACTION
	RETURN
END

-- Now tag all entries to the guides node
INSERT INTO HierarchyArticleMembers SELECT Guides.EntryID, @GuidesNodeID
FROM
(
	SELECT EntryID FROM #ArticlesToTag
) AS Guides
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to add Campaign nodes to temp table'
	ROLLBACK TRANSACTION
	RETURN
END;

-- Delete all the duplicates
WITH cte AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY EntryID, NodeID ORDER BY EntryID) rn FROM HierarchyArticleMembers
)
DELETE FROM cte WHERE rn > 1
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to delete duplicate entries'
	ROLLBACK TRANSACTION
	RETURN
END

DROP TABLE #ArticlesToTag
IF (@@ERROR <> 0)
BEGIN
	PRINT 'Failed to drop the temporary table'
	ROLLBACK TRANSACTION
	RETURN
END
COMMIT TRANSACTION

