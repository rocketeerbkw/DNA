create procedure updatethreadfirstsubject @threadid int, @firstsubject nvarchar(255)
as
declare @CurrentDate datetime 
declare @ForumID int

select	@ForumID = ForumID from Threads WITH(NOLOCK) where ThreadID = @threadid
set @CurrentDate = getdate()

BEGIN TRANSACTION
DECLARE @ErrorCode INT

update Threads
set FirstSubject = @firstsubject,
LastUpdated = @CurrentDate
where ThreadID = @ThreadID
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


-- update the LastUpdated field in the Forum table also
INSERT INTO ForumLastUpdated (ForumID, lastUpdated)
	VALUES(@forumid, @currentdate)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
	
return(0)