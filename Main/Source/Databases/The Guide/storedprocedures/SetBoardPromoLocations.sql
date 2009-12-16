CREATE PROCEDURE setboardpromolocations @boardpromoelementid int, @editkey uniqueidentifier, @topics varchar(4000), @userid int
AS
-- Check to make sure the edit key matches the one in the database
DECLARE @CurrentKey uniqueidentifier
SELECT @CurrentKey = fpe.EditKey FROM dbo.FrontPageElements fpe
INNER JOIN dbo.BoardPromoElements bpe ON fpe.ElementID = bpe.ElementID
WHERE bpe.BoardPromoElementID = @boardpromoelementid
IF (@CurrentKey IS NULL)
BEGIN
	SELECT 'ValidID' = 0
	RETURN 0
END
ELSE IF (@CurrentKey != @editkey)
BEGIN
	SELECT 'ValidID' = 2
	RETURN 0
END

BEGIN TRANSACTION
	DECLARE @Error int
	-- First remove existing topics
	UPDATE dbo.Topics SET BoardPromoID = 0, UserUpdated = @userid, LastUpdated = GetDate()
	WHERE BoardPromoID = @boardpromoelementid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	
	-- Go through the list of topics adding them one at atime.
	DECLARE @Index int, @TopicID varchar(4)
	WHILE ( LEN(@topics) <> 0 )
	BEGIN
		-- Get the next topicid
		SET @Index = PATINDEX('%,%',@topics)
		IF @Index = 0 
		BEGIN
			SET @Index = LEN(@topics) + 1
		END
		
		-- Now create the execution string
		SET @TopicID = SUBSTRING(@topics,0,@Index)
		UPDATE dbo.Topics SET BoardPromoID = @boardpromoelementid, EditKey = NewID(), UserUpdated = @userid, LastUpdated = GetDate()
		WHERE TopicID = CAST(@TopicID AS INT)
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN
		END

		-- Now remove the topicid we've just done.		
		SET @topics = SUBSTRING(@topics,@Index + 1,LEN(@topics))
	END
COMMIT TRANSACTION
SELECT 'ValidID' = 1
