/*adds a club to the hierarchy at a particular node*/

CREATE PROCEDURE addclubtohierarchy @nodeid int, @clubid int, @userid int
AS

DECLARE @Success INT
SET @Success = 1
DECLARE @Duplicate INT
SET @Duplicate = 0

IF NOT EXISTS (SELECT * from hierarchyclubmembers where nodeid=@nodeid AND clubid=@clubid)
BEGIN
	BEGIN TRANSACTION 
	DECLARE @ErrorCode 	INT

	INSERT INTO hierarchyclubmembers (NodeID,ClubID) VALUES(@nodeid,@clubid)
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	UPDATE hierarchy SET ClubMembers = ISNULL(ClubMembers,0)+1 WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	declare @h2g2id int
	SELECT @h2g2id = h2g2id FROM Clubs WHERE ClubID = @clubid
		-- Refresh the guide entry.  Forces the article cache to clear
	UPDATE GuideEntries SET LastUpdated = getdate() WHERE h2g2ID = @h2g2id
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	COMMIT TRANSACTION

	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_CATEGORYCLUBTAGGED', @nodeid, 'IT_NODE', @clubid, 'IT_CLUB', @userid

	-- update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!
	DECLARE @SiteID INT

	SELECT @siteid = SiteID  FROM Clubs  WHERE clubid = @clubid

	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddClubToHierarchy',
											  @siteid		= @SiteID, 
											  @nodeID		= @nodeid, 
											  @clubid		= @clubid, 
											  @userid		= @userid
END
ELSE
BEGIN
	SET @Success = 0
	SET @Duplicate = 1
END

Select 'Success' = @Success, 'Duplicate' = @Duplicate, 'ObjectName' = g.Subject, 'NodeName' = h.DisplayName 
			FROM GuideEntries g
			INNER JOIN Clubs c ON c.ClubID = @clubid AND g.h2g2id=c.h2g2id
			INNER JOIN Hierarchy h ON h.NodeID = @nodeid

RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode
