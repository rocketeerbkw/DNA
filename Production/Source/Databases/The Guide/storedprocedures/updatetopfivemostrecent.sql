CREATE Procedure updatetopfivemostrecent	@siteid int = 1
AS

DECLARE @ErrorCode INT
DECLARE @iRnd int
DECLARE @iCount int
DECLARE @iClubID int
DECLARE @Subject varchar(255)
DECLARE @ih2g2ID int
DECLARE @iUserID int
DECLARE @GroupID int

DECLARE site_cursor CURSOR FOR
	SELECT SiteID FROM Sites
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

OPEN site_cursor

FETCH NEXT FROM site_cursor
	INTO @siteid
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		CLOSE site_cursor
		DEALLOCATE site_cursor
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

WHILE @@FETCH_STATUS = 0
BEGIN

	BEGIN TRANSACTION
		DELETE FROM TopFives WHERE GroupName = 'MostRecent' AND SiteID = @siteid	
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			CLOSE site_cursor
			DEALLOCATE site_cursor
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
			SELECT TOP 20  'MostRecent' = 'MostRecent', 'Most Recent Articles', @siteid, 'h2g2ID' = h2g2id
			FROM GuideEntries g WITH(NOLOCK)
			WHERE g.Status = 1 AND g.SiteID = @siteid AND g.Type <= 1000
			ORDER BY g.DateCreated DESC
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			CLOSE site_cursor
			DEALLOCATE site_cursor
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	COMMIT TRANSACTION
	
	-- update TopFives Users
	BEGIN TRANSACTION
		DELETE FROM TopFives WHERE GroupName = 'MostRecentUser' AND SiteID = @siteid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			CLOSE site_cursor
			DEALLOCATE site_cursor
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		SELECT @GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'BBCStaff'
		INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
		SELECT TOP 20  'MostRecentUser' = 'MostRecentUser', 'Most Recent Contributions' = 'Most Recent Contributions', @siteid, 'h2g2ID' = g.h2g2id
			FROM GuideEntries g WITH(NOLOCK)
				INNER JOIN Users u WITH(NOLOCK) ON g.Editor = u.UserID
				WHERE g.Status = 3 AND g.SiteID = @siteid AND g.Type < 1000 AND u.UserID NOT IN (
					SELECT m.UserID FROM GroupMembers m WITH(NOLOCK) WHERE m.GroupID = @GroupID AND m.SiteID = @siteid )
			ORDER BY g.DateCreated DESC
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			CLOSE site_cursor
			DEALLOCATE site_cursor
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	COMMIT TRANSACTION
	

	--update top five most recent conversations 
	BEGIN TRANSACTION
		DELETE FROM TopFives WHERE GroupName = 'MostRecentConversations' AND SiteID = @siteid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			CLOSE site_cursor
			DEALLOCATE site_cursor
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
			SELECT TOP 20  'MostRecentConversations', 'Most Recent Conversations', @siteid, 'ForumID' = t.ForumID, 'ThreadID' = t.ThreadID
			FROM Threads t WITH(NOLOCK)
			INNER JOIN Forums f WITH(NOLOCK) ON t.ForumID = f.ForumID AND f.JournalOwner IS NULL AND f.SiteID = @siteid
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.ForumID = f.ForumID AND (g.Type NOT BETWEEN 3001 AND 4000)
			WHERE t.DateCreated > DATEADD(month, -3, getdate()) AND t.CanRead = 1 AND t.VisibleTo IS NULL 
			ORDER BY t.DateCreated DESC

		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			CLOSE site_cursor
			DEALLOCATE site_cursor
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	COMMIT TRANSACTION
	
	-- Popular threads
	BEGIN TRANSACTION
		DELETE FROM TopFives WHERE GroupName = 'PopularThreads' AND SiteID = @siteid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			CLOSE site_cursor
			DEALLOCATE site_cursor
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
			select top 20 
			'PopularThreads', 'Most Popular Conversations', @siteid, 'ForumID' = te.ForumID,
			te.threadid
			from ThreadEntries te WITH(NOLOCK)
			join threads t WITH(NOLOCK) on t.threadid = te.threadid
			where t.SiteID = @siteid and te.DatePosted > DATEADD(day,-7,getdate()) and t.DateCreated > DATEADD(month,-6,getdate())
			group by te.ForumID, te.ThreadID
			order by count(*) desc


		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			CLOSE site_cursor
			DEALLOCATE site_cursor
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	COMMIT TRANSACTION

	FETCH NEXT FROM site_cursor
		INTO @siteid
END

CLOSE site_cursor;
DEALLOCATE site_cursor;

-- For the CBBC site, since they want a feed with just 5 items, delete the rest
-- so they don't have to fuss
WITH TopFivesRN AS
(
  SELECT *, ROW_NUMBER() OVER(partition by GroupName ORDER BY Rank) AS RowNum
  FROM dbo.TopFives where siteid in (select siteid from sites where urlname='mbcbbc')-- and groupname = 'PopularThreads'
)
delete from TopFivesRN where groupname in ('MostRecentConversations','PopularThreads') and RowNum > 5;

-- Just return from here - we don't care about Ican any more

RETURN (0)


-- THE REST OF THIS BATCH IS SPECIFIC TO ICAN 
SELECT @siteid = 16

-- update the topfives with most recent Clubupdates
BEGIN TRANSACTION	
	DELETE FROM TopFives WHERE GroupName = 'MostRecentClubUpdates' AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ClubID)
		SELECT top 20 'Group name'='MostRecentClubUpdates', 'GroupDescription'='Most Recent Club Updates', @siteid, c.ClubID 
		FROM Clubs c WITH(NOLOCK)
		INNER JOIN GuideEntries g WITH(NOLOCK) ON c.h2g2id = g.h2g2id 
		LEFT JOIN Threads t WITH(NOLOCK) ON c.journal = t.forumid 
		GROUP BY c.ClubID
		Order BY 
		-- if c.LastUpdated IS NULL evaluates to g.LastUpdated
		MAX (CASE WHEN c.LastUpdated > g.LastUpdated THEN c.LastUpdated ELSE g.LastUpdated END) DESC

	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
COMMIT TRANSACTION


-- Now insert the top 20 most recent issues
BEGIN TRANSACTION		
	DELETE FROM TopFives WHERE GroupName = 'MostRecentIssues' AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
		SELECT TOP 20 'MostRecentIssues', 'Most Recent Issues', @SiteID, 'h2g2ID' = g.h2g2id
		FROM GuideEntries g WITH (NOLOCK) WHERE g.SiteID = @SiteID and g.status = 3 and g.type = 1
		ORDER BY g.LastUpdated DESC 
/* -- This is the old select. We don't care about the nodes anymore, and we want status
		SELECT TOP 20 'MostRecentIssues', 'Most Recent Issues', @siteid, 'h2g2ID' = h.h2g2id, 'NodeID' = h.NodeID
		FROM GuideEntries g WITH (NOLOCK)
		INNER JOIN HierarchyArticleMembers ha WITH (NOLOCK) ON ha.h2g2id = g.h2g2id AND g.Type <= 4
		INNER JOIN Hierarchy h WITH (NOLOCK) ON h.NodeID = ha.NodeID AND h.SiteID = @SiteID AND h.Type = 2
		GROUP BY h.NodeID,h.h2g2id
		ORDER BY MAX(g.LastUpdated) DESC 
*/
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
COMMIT TRANSACTION


-- Now insert the random top fives
-- Random top five club	
BEGIN TRANSACTION
	DELETE FROM TopFives WHERE GroupName = 'RandomTopClub' AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	SELECT @iCount = Count(*) FROM TopFives WHERE GroupName = 'mostrecentclubupdates' AND SiteID = @siteid
	IF (@iCount > 0)
	BEGIN
		SELECT @iRnd = CAST(ABS(RAND() * @iCount) + 1 AS INTEGER)

		DECLARE EntryCursor SCROLL CURSOR FOR
			SELECT c.ClubID FROM Clubs c WITH(NOLOCK), TopFives f WITH(NOLOCK) WHERE c.ClubID = f.ClubID AND f.GroupName = 'mostrecentclubupdates' AND f.SiteID = @siteid

		OPEN EntryCursor
			FETCH ABSOLUTE @iRnd FROM EntryCursor INTO @iClubID
		CLOSE EntryCursor
		DEALLOCATE EntryCursor

		INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ClubID)
			SELECT 'GroupName'='RandomTopClub', 'GroupDescription'='Random Top Club', 'SiteID' = @siteid, 'ClubID' = @iClubID
	END
COMMIT TRANSACTION


-- Random top five user	
BEGIN TRANSACTION
	DELETE FROM TopFives WHERE GroupName = 'RandomTopUser' AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	SELECT @iCount = Count(*) FROM TopFives WITH(NOLOCK) WHERE GroupName = 'mostrecentuser' AND SiteID = @siteid
	IF (@iCount > 0)
	BEGIN
		SELECT @iRnd = CAST(ABS(RAND() * @iCount) + 1 AS INTEGER)

		DECLARE EntryCursor SCROLL CURSOR FOR
		SELECT 'UserID' = u.UserID FROM Users u WITH(NOLOCK)
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.Editor = u.UserID
			INNER JOIN TopFives f WITH(NOLOCK) ON g.h2g2id = f.h2g2id
			WHERE f.GroupName = 'mostrecentuser' AND f.SiteID = @siteid

		OPEN EntryCursor
			FETCH ABSOLUTE @iRnd FROM EntryCursor INTO @iUserID
		CLOSE EntryCursor
		DEALLOCATE EntryCursor

		INSERT INTO TopFives (GroupName, GroupDescription, SiteID, UserID)
			SELECT 'GroupName'='RandomTopUser', 'GroupDescription'='Random Top User', 'SiteID' = @siteid, 'UserID' = @iUserID
	END
COMMIT TRANSACTION
	
BEGIN TRANSACTION
	-- Now delete all the entries for all sites except 16 which is the new Ican site.
	DELETE FROM TopFives WHERE GroupName IN ('RandomTopUser','mostrecentclubupdates','RandomTopClub','MostRecentIssues') AND SiteID != 16
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
COMMIT TRANSACTION

-- call dedicated procedure to handle topic top fives
-- DO NOT UNCOMMENT THE CALL TO updatetopictopfives UNTIL IT HAS BEEN OPTIMISED!! (Jim/Markn 28/9/05)
--EXEC updatetopictopfives @siteid

-- update the topfives with most recent campaign diary entries
BEGIN TRANSACTION
	DELETE FROM TopFives WHERE GroupName = 'MostRecentCampaignDiaryEntries' AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID, ClubID)
	SELECT TOP 20 'MostRecentCampaignDiaryEntries', 'Most Recent Campaign Diary Entries', @siteid, t.ForumID, t.ThreadID, c.ClubID
		FROM Clubs C
		INNER JOIN Threads t ON t.ForumID = c.Journal
		WHERE t.CanRead = 1 AND 
		t.VisibleTo IS NULL AND
		t.DateCreated > DATEADD(Month,-6,GetDate()) AND
		c.SiteID = @SiteID
		ORDER BY t.DateCreated DESC
		
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
COMMIT TRANSACTION


-- Update the Top Five most recent Comments on Events, Notices, Articles and Campaign Diaries
BEGIN TRANSACTION
	DELETE FROM TopFives WHERE GroupName = 'MostRecentComments' AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID, ClubID)
	SELECT TOP 20 'MostRecentComments', 'Most Recent Comments', @siteid, 'ForumID' = comments.ForumID, 'ThreadID' = comments.ThreadID, 'ClubID' = comments.ClubID
		FROM
		(
			-- Top 20 on notices/events
			SELECT s1.* FROM
			(
				SELECT TOP 20 t.ForumID, t.ThreadID, 'ClubID' = NULL, t.LastPosted FROM Threads t WITH(NOLOCK)
					INNER JOIN Forums f WITH(NOLOCK) ON f.ForumID = t.ForumID
					WHERE 	t.Type IS NOT NULL AND
						f.SiteID = @SiteID AND
						t.ThreadPostCount > 1 AND
						t.CanRead = 1 AND
						t.VisibleTo IS NULL AND
						t.LastPosted > DATEADD(month,-6,GetDate())
					ORDER BY t.LastPosted DESC
			) AS s1
			UNION ALL
			(
				-- Top 20 on Campaign Diary entries
				SELECT s2.* FROM
				(
					SELECT TOP 20 'ForumID' = c.Journal, t.ThreadID, c.ClubID, t.LastPosted FROM Clubs c WITH(NOLOCK)
						INNER JOIN Threads t WITH(NOLOCK) ON t.ForumID = c.Journal
						WHERE 	t.ThreadPostCount > 1 AND
							c.SiteID = @SiteID AND
							t.CanRead = 1 AND
							t.VisibleTo IS NULL AND
							t.LastPosted > DATEADD(month,-6,GetDate())
						ORDER BY t.LastPosted DESC
				) AS s2
			)
			UNION ALL
			(
				-- Top 20 on Articles
				SELECT s3.* FROM
				(
					SELECT TOP 20 g.ForumID, t.ThreadID, 'ClubID' = NULL, t.LastPosted FROM GuideEntries g WITH(NOLOCK)
						INNER JOIN Threads t WITH(NOLOCK) ON t.ForumID = g.ForumID
						WHERE	t.CanRead = 1 AND
							g.SiteID = @SiteID AND
							g.Type <= 1000 AND
							t.VisibleTo IS NULL AND
							t.LastPosted > DATEADD(month,-6,GetDate())
						ORDER BY t.LastPosted DESC
				) AS s3
			)
		) AS comments
		ORDER BY comments.LastPosted DESC
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

COMMIT TRANSACTION

-- update the topfives with most recent notices
BEGIN TRANSACTION
	DELETE FROM TopFives WHERE GroupName = 'MostRecentNotice' AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	SELECT TOP 20 'MostRecentNotice', 'Most Recent Notice', @siteid, t.ForumID, t.ThreadID
	FROM Threads t WITH(NOLOCK)
	INNER JOIN Forums f WITH(NOLOCK) ON f.ForumId = t.ForumID
	WHERE t.Type = 'notice' AND t.CanRead = 1 AND t.VisibleTo IS NULL AND f.SiteID = @SiteID
	ORDER BY t.DateCreated desc

	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
COMMIT TRANSACTION

-- update the topfives with most recent events
BEGIN TRANSACTION
	DELETE FROM TopFives WHERE GroupName = 'MostRecentEvents' AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)

	SELECT TOP 20 'MostRecentEvents', 'Most Recent Events', @siteid, t.ForumID, t.ThreadID
	FROM Threads t WITH(NOLOCK)
	INNER JOIN Forums f WITH(NOLOCK) ON f.ForumId = t.ForumID
	WHERE t.Type = 'event' AND t.CanRead = 1 AND t.VisibleTo IS NULL AND f.SiteID = @SiteID AND t.EventDate > GetDate()
	ORDER BY t.EventDate ASC

	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
COMMIT TRANSACTION

RETURN (0)