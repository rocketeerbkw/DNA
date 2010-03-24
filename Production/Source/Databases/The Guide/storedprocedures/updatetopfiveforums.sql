Create Procedure updatetopfiveforums	@siteid int = 1
As

if @siteid = 1
begin
	return (0)
end

BEGIN TRANSACTION
DECLARE @ErrorCode INT

declare @now datetime
select @now = MAX(DatePosted) FROM ThreadEntries
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

DELETE FROM TopFives WHERE GroupName = 'MostThreads'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID)
	SELECT TOP 5 'MostThreads' = 'MostThreads', '5 Busiest Conversations', @siteid, 'ForumID' = t.ForumID FROM ThreadEntries t INNER JOIN Forums f ON f.ForumID = t.ForumID WHERE f.SiteID = @siteid AND f.CanRead = 1 AND t.DatePosted > DATEADD(hour, -12, @now) AND (t.Hidden IS NULL) GROUP BY t.ForumID ORDER BY Count(*) DESC
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
return (0)