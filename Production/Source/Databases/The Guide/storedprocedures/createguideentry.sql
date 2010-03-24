CREATE PROCEDURE createguideentry
@subject varchar(255), 
@bodytext varchar(max), 
@extrainfo text,
@editor int, 
@style int = 1, 
@status int = NULL,
@typeid int,  
@keywords varchar(255) = NULL,
@researcher int = NULL,
@siteid int = 1,
@submittable tinyint = 1,
@hash uniqueidentifier = NULL,
@preprocessed int = 0,
@canread tinyint = 1,
@canwrite tinyint = 0, 
@canchangepermissions tinyint = 0,
@forumstyle tinyint = 0,
@groupnumber int = NULL

AS
if (NOT (@editor IS NULL))
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT
	DECLARE @FoundDuplicate TINYINT
	DECLARE @h2g2ID INT
	DECLARE @forumid INT
	DECLARE @curdate DATETIME
	DECLARE @guideentry INT

	-- Call the internal version as this takes into account duplicate guideentries!!!
	EXEC @ErrorCode = createguideentryinternal	@subject, @bodytext, @extrainfo,
													@editor, @style, @status, @keywords, @researcher,
													@siteid, @submittable, @typeid,
													@guideentry OUTPUT,
													@curdate OUTPUT, 
													@forumid OUTPUT,
													@h2g2ID OUTPUT, 
													@FoundDuplicate OUTPUT, 
													@hash, @preprocessed,
													@canread,
													@canwrite,
													@canchangepermissions,
													@forumstyle, 
													@groupnumber
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	SELECT 'EntryID' = @guideentry, 'DateCreated' = @curdate, 'ForumID' = @forumid, 'h2g2ID' = @h2g2ID
END
