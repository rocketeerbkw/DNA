--drop procedure dynamiclistsetpublished
-- Marks a list as being published
CREATE PROCEDURE dynamiclistsetpublished @id int, @listtype varchar(30)
AS
BEGIN TRANSACTION

DECLARE @ErrorCode INT

DECLARE @name VARCHAR(50)
DECLARE @siteURLName VARCHAR(30)
SELECT @name = Name, @siteURLName = siteurlname
FROM DynamicListDefinitions WHERE Id = @Id AND PublishState=1


DECLARE @siteid INT
select @siteid = siteid from sites where urlname = @siteURLName

-- Insert into Dynamic Lists table if no talready published.
IF ( NOT EXISTS ( SELECT * FROM DynamicLists WHERE name = @name ) )
BEGIN
	INSERT INTO DynamicLists (Global, name, Type, siteID)
	VALUES ( 1, @name, @listtype, @siteid )

	SET @ErrorCode = @@ERROR 
	if(@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

-- Set as published
UPDATE DynamicListDefinitions SET PublishState = 2
WHERE id=@id
SET @ErrorCode = @@ERROR 
if(@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION