CREATE PROCEDURE updatecontentsignifsetting
	@siteid		int, 
	@setting	varchar(255)
AS
	/* 
		Parses parameter setting and calls appropriate update SP. 
		Setting comes in the form c_XXX_YYY=[value] where c=char 'i' or 'd' for increment or decrement;
		XXX is the ActionID, YYY is the ItemID and [value] is the value of the setting.
	*/

	DECLARE @SettingType				CHAR
	DECLARE @ActionID					INT
	DECLARE @ItemID						INT
	DECLARE @Value						INT
	DECLARE @EqualsCharIndex			INT
	DECLARE @FirstUnderscoreCharIndex	INT
	DECLARE @SecondUnderscoreCharIndex	INT
	DECLARE @ErrorCode					INT

	SELECT @ErrorCode	= 0 
	SELECT @FirstUnderscoreCharIndex = CHARINDEX('_', @setting)
	SELECT @SecondUnderscoreCharIndex = CHARINDEX('_', @setting, @FirstUnderscoreCharIndex+1)
	SELECT @EqualsCharIndex = CHARINDEX('=', @setting)

	SELECT @SettingType = SUBSTRING(@setting, 1, @FirstUnderscoreCharIndex)
	SELECT @ActionID = CAST(SUBSTRING(@setting, (@FirstUnderscoreCharIndex + 1), (@SecondUnderscoreCharIndex - (@FirstUnderscoreCharIndex+1))) AS INT)
	SELECT @ItemID = CAST(SUBSTRING(@setting, (@SecondUnderscoreCharIndex + 1), (@EqualsCharIndex - (@SecondUnderscoreCharIndex+1))) AS INT)
	SELECT @Value = CAST(SUBSTRING(@setting, (@EqualsCharIndex + 1), (LEN(@setting) - (@EqualsCharIndex))) AS INT)

	IF (@SettingType = 'i')
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifincrement	@actionid	= @ActionID,
															@itemid		= @ItemID, 
															@siteid		= @siteid, 
															@increment	= @Value
	END
	ELSE IF (@SettingType = 'd')
	BEGIN 
		EXEC @ErrorCode = dbo.updatecontentsignifdecrement	@actionid	= @ActionID,
															@itemid		= @ItemID, 
															@siteid		= @siteid, 
															@decrement	= @Value
	END
	ELSE 
	BEGIN
		RAISERROR ('updatecontentsignifsetting does not recognise setting type. Must be increment of decrement!!!',16,1)
		RETURN 50000
	END

RETURN @ErrorCode
