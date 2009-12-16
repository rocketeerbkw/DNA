CREATE PROCEDURE updatesitetopicsopencloseschedule @siteid	INT, 
											  @param0	varchar(32) = null,
											  @param1	varchar(32) = null,
											  @param2	varchar(32) = null,
											  @param3	varchar(32) = null,
											  @param4	varchar(32) = null, 
											  @param5	varchar(32) = null, 
											  @param6	varchar(32) = null, 
											  @param7	varchar(32) = null, 
											  @param8	varchar(32) = null, 
											  @param9	varchar(32) = null, 
											  @param10	varchar(32) = null, 
											  @param11	varchar(32) = null, 
											  @param12	varchar(32) = null, 
											  @param13	varchar(32) = null, 
											  @param14	varchar(32) = null, 
											  @param15	varchar(32) = null, 
											  @param16	varchar(32) = null, 
											  @param17	varchar(32) = null, 
											  @param18	varchar(32) = null, 
											  @param19	varchar(32) = null, 
											  @param20	varchar(32) = null, 
											  @param21	varchar(32) = null, 
											  @param22	varchar(32) = null, 
											  @param23	varchar(32) = null, 
											  @param24	varchar(32) = null, 
											  @param25	varchar(32) = null, 
											  @param26	varchar(32) = null, 
											  @param27	varchar(32) = null
AS
DECLARE @Error int

BEGIN TRANSACTION

DELETE FROM dbo.SiteTopicsOpenCloseTimes WHERE SiteID = @SiteID
SET @Error = @@ERROR; IF (@Error <> 0) GOTO HandleError

IF (@param0 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param0
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param1 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param1
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param2 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param2
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param3 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param3
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param4 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param4
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param5 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param5
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param6 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param6
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param7 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param7
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param8 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param8
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param9 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param9
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param10 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param10
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param11 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param11
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param12 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param12
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param13 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param13
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param14 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param14
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param15 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param15
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param16 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param16
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param17 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param17
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param18 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param18
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param19 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param19
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param20 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param20
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param21 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param21
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param22 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param22
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param23 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param23
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param24 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param24
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param25 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param25
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param26 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param26
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

IF (@param27 IS NOT NULL)
BEGIN
	EXEC @Error = dbo.ProcessSiteTopicsScheduledEvent @siteid = @siteid, @Event = @param27
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF (@Error <> 0) GOTO HandleError
END

COMMIT TRANSACTION
RETURN 0

-- Handle the error
HandleError:
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END