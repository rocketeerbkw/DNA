CREATE PROCEDURE updatetrackedmemberlist 
	@userids VARCHAR(8000), 
	@siteids VARCHAR(8000), 
	@prefstatus INT, 
	@prefstatusduration INT,
	@reason nvarchar(max),
	@viewinguser int
AS
BEGIN



BEGIN TRANSACTION
BEGIN TRY
	exec updatetrackedmemberlistinternal @userids, @siteids, @prefstatus, @prefstatusduration, @reason, @viewinguser

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	RETURN ERROR_NUMBER()
END CATCH
	
END