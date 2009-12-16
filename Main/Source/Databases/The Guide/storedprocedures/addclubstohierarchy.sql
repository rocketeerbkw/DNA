/*adds a comma separated list of clubs to the hierarchy at a particular node*/

CREATE PROCEDURE addclubstohierarchy @nodeid int, @clubslist VARCHAR(255), @userid int, @siteid INT
AS

DECLARE @success INT
DECLARE @Duplicate INT
DECLARE @ErrorCode 	INT

BEGIN TRANSACTION 

DECLARE @clubid INT
DECLARE club_cursor CURSOR DYNAMIC FOR
SELECT clubid 
FROM Clubs c WITH (NOLOCK)
INNER JOIN udf_splitvarchar(@clubslist) u ON u.element = clubid
WHERE c.SiteId = @siteid

OPEN club_cursor
FETCH NEXT FROM club_cursor INTO @clubid
WHILE ( @@FETCH_STATUS = 0 )
BEGIN
	SET @duplicate = 0
	SET @success = 1
	IF EXISTS ( SELECT clubid FROM HierarchyClubMembers where clubid = @clubid and nodeid = @nodeid )
	BEGIN
		SET @duplicate = 1
		SET @success = 0
	END
	
	IF @duplicate = 0 
	BEGIN
		INSERT INTO hierarchyclubmembers (NodeID,ClubID) 
		VALUES (  @nodeid, @clubid )
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE hierarchy SET ClubMembers = ISNULL(ClubMembers,0) + 1 WHERE nodeid=@nodeid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError


		-- Refresh the clubs guide entry.  Forces the article cache to clear
		UPDATE GuideEntries SET LastUpdated  = getdate()
		FROM Clubs c, GuideEntries g
		WHERE c.clubid = @clubid AND g.h2g2id = c.h2g2id
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
		EXEC @ErrorCode = addtoeventqueueinternal 'ET_CATEGORYCLUBTAGGED', @nodeid, 'IT_NODE', @clubid, 'IT_CLUB', @userid

		-- update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!
		EXEC @ErrorCode = dbo.updatecontentsignif	@activitydesc	= 'AddClubToHierarchy',
													@siteid		= @SiteID, 
													@nodeID		= @nodeid, 
													@clubid		= @clubid, 
													@userid		= @userid
	END

	--Return a resultset for each row updated.
	Select	'Success' = @Success, 
			'Duplicate' = @duplicate, 
			'ObjectName' = g.Subject, 
			'ClubId' = c.clubid,
			( SELECT DisplayName FROM Hierarchy h WHERE h.NodeId = @nodeid) AS NodeName
	FROM Clubs c 
	INNER JOIN GuideEntries g ON g.h2g2id = c.h2g2id
	WHERE c.clubid = @clubid
	
	FETCH NEXT FROM club_cursor INTO @clubid
END

COMMIT TRANSACTION

CLOSE club_cursor
DEALLOCATE club_cursor

RETURN 0

HandleError:
ROLLBACK TRANSACTION
CLOSE club_cursor
DEALLOCATE club_cursor
SELECT 'Success' = 0
RETURN @ErrorCode
