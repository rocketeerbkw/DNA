create procedure userjoinedsite @userid int, @siteid int
as
begin

	BEGIN TRANSACTION
	
	DECLARE @ErrorCode int
	-- See if we need to check the preferences table to see if the user has an entry for this site?
	IF NOT EXISTS ( SELECT SiteID FROM Preferences WHERE UserID = @UserID AND SiteID = @SiteID )
	BEGIN
		EXEC @ErrorCode = SetDefaultPreferencesForUser @UserID, @SiteID
		IF (@ErrorCode <> 0)
		BEGIN
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
	
	update Preferences set datejoined = getdate()
	where userid=@userid and siteid=@siteid
	
	declare @premodduration int
	exec checkpremodduration @siteid, @premodduration output
	
	declare @postcountthreshold int
	exec checkpostcountthreshold @siteid, @postcountthreshold output
	
	if (@premodduration is null)
	begin
		set @premodduration = 0
	end
	
	if (@postcountthreshold is null)
	begin
		set @postcountthreshold = 0
	end
	
	if (@premodduration <> 0 or @postcountthreshold <> 0)
	begin
		update Preferences set AutoSinBin = 1
		where userid = @userid and siteid = @siteid
	end
	else
	begin
		update Preferences set AutoSinBin = 0
		where userid = @userid and siteid = @siteid
	end
	
	SELECT @ErrorCode = @@ERROR
	
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	COMMIT TRANSACTION			
	
end