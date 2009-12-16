CREATE PROCEDURE contentsignifbatchdecrement
AS
	DECLARE @ErrorCode 	INT
	DECLARE @SiteID		INT

	DECLARE sites_cursor CURSOR DYNAMIC FOR
		SELECT SiteID 
		  FROM Sites WITH (NOLOCK)
	
	OPEN sites_cursor
	
	FETCH NEXT FROM sites_cursor 
	 INTO @SiteID

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		EXEC @ErrorCode = contentsignifsitedecrement @siteid = @SiteID
	
		FETCH NEXT FROM sites_cursor 
		 INTO @SiteID
	END 
	
	CLOSE sites_cursor
	DEALLOCATE sites_cursor

RETURN 0
