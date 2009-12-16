CREATE PROCEDURE editclublinkdetails @linkid INT, @title VARCHAR (255), @url VARCHAR(512) , @desc VARCHAR(255), @userid INT
AS
BEGIN
	DECLARE @Error int
	
	BEGIN TRANSACTION 
	UPDATE dbo.links
	SET title = @title, linkdescription = @desc, editedby = @userid, lastupdated=getdate( )
	WHERE linkid = @linkid
	
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END	
	
	UPDATE dbo.externalurls
	SET url = @url
	WHERE urlid = (SELECT destinationid FROM links WHERE linkid = @linkid)	
	SELECT "rowcount" = @@ROWCOUNT
	
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END	
	
	COMMIT TRANSACTION		
END