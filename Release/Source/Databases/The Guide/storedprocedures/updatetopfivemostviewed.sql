Create Procedure updatetopfivemostviewed
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

DELETE FROM TopFives WHERE GroupName = 'MostViewed'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, h2g2ID)
	SELECT TOP 5 'MostViewed' = 'MostViewed', 'h2g2ID' = a.h2g2id FROM ArticleViews a INNER JOIN GuideEntries g ON g.EntryID = a.EntryID WHERE g.Status = 1 AND a.DateViewed > DATEADD(day,-7,getdate()) GROUP BY a.EntryID, a.h2g2ID ORDER BY Count(*) DESC
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
return (0)