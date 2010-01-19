Create Procedure updatearticleindex
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

DELETE FROM ArticleIndex
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO ArticleIndex (EntryID, Subject, SortSubject, IndexChar, UserID, Status, SiteID)
	SELECT g.EntryID, LTRIM(Subject), 
		CASE WHEN LEFT(LTRIM(Subject),4) = 'the ' 
			THEN LTRIM(SUBSTRING(LTRIM(Subject),5,LEN(LTRIM(Subject))))
			WHEN LEFT(LTRIM(Subject),2) = 'a '
			THEN LTRIM(SUBSTRING(LTRIM(Subject),3,LEN(LTRIM(Subject))))
			WHEN LEFT(LTRIM(Subject),1) = ''''
			THEN LTRIM(SUBSTRING(LTRIM(Subject),2,LEN(LTRIM(Subject))))
			ELSE LTRIM(Subject)
			END As SortBy, 
		CASE WHEN LEFT(LTRIM(Subject),1) >= 'a' AND LEFT(LTRIM(Subject),1) <= 'z' 
			THEN LEFT(LTRIM(Subject),1) 
			ELSE '.' END, 
			u.UserID, g.Status, g.SiteID
		FROM GuideEntries g 
		LEFT JOIN Mastheads m on g.EntryID = m.EntryID AND g.SiteID = m.SiteID
		LEFT JOIN Users u ON u.UserID = m.UserID
		WHERE g.Status IN (1,3,4) AND LTRIM(Subject) <> '' AND g.Hidden IS NULL
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ArticleIndex
	Set IndexChar = CASE WHEN LEFT(LTRIM(SortSubject),1) >= 'a' AND LEFT(LTRIM(SortSubject),1) <= 'z' THEN LEFT(LTRIM(SortSubject),1) ELSE '.' END
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)