Create Procedure updatetopfiveleastviewed @siteid int = 1 
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

DELETE FROM TopFives WHERE GroupName = 'LeastViewed'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	SELECT TOP 5 'LeastViewed' = 'LeastViewed', '5 Most Neglected', @siteid, 'h2g2ID' = g.h2g2ID
		FROM GuideEntries g
		INNER JOIN (SELECT ForumID, 'cnt' = COUNT(*) FROM ThreadEntries GROUP BY ForumID) as t
			ON t.ForumID = g.ForumID
		WHERE g.SiteID = @siteid AND g.DateCreated < DATEADD(day,-7,getdate()) 
			AND g.DateCreated > DATEADD(day,-14,getdate()) AND g.Status = 1
	ORDER BY t.cnt
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
return (0)