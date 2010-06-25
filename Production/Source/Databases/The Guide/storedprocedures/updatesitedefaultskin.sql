CREATE PROCEDURE updatesitedefaultskin	@siteid int,
										@defaultskin varchar(255),
										@skinset varchar(255),
										@skindescription varchar(255) ='',
										@useframes int = 0
As

--add skin to skins for site
IF NOT EXISTS(SELECT * FROM SiteSkins WHERE SkinName = @defaultskin AND SiteID=@siteid)
BEGIN
	INSERT INTO SiteSkins (SiteID, SkinName, Description, UseFrames)
		VALUES(@siteid, @defaultskin, @skindescription, @useframes)
END

if EXISTS (SELECT * FROM SiteSkins WHERE SiteID = @siteid AND SkinName = @defaultskin)
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	update sites 
		SET DefaultSkin				= @defaultskin,
			SkinSet                 = @skinset
		WHERE SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Result' = 1, 'Error' = 'Internal error' 
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	SELECT 'Result' = 0
END
ELSE
BEGIN
	SELECT 'Result' = 1, 'Error' = 'Default skin does not belong to site' 
END