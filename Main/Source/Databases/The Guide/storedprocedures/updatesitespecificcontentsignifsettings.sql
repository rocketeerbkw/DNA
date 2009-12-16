CREATE PROCEDURE updatesitespecificcontentsignifsettings
	@siteid		int, 
	@param1		varchar(255) = null,
	@param2		varchar(255) = null,
	@param3		varchar(255) = null,
	@param4		varchar(255) = null,
	@param5		varchar(255) = null,
	@param6		varchar(255) = null,
	@param7		varchar(255) = null,
	@param8		varchar(255) = null,
	@param9		varchar(255) = null,
	@param10	varchar(255) = null,
	@param11	varchar(255) = null,
	@param12	varchar(255) = null,
	@param13	varchar(255) = null,
	@param14	varchar(255) = null,
	@param15	varchar(255) = null,
	@param16	varchar(255) = null,
	@param17	varchar(255) = null,
	@param18	varchar(255) = null,
	@param19	varchar(255) = null,
	@param20	varchar(255) = null,
	@param21	varchar(255) = null,
	@param22	varchar(255) = null,
	@param23	varchar(255) = null,
	@param24	varchar(255) = null,
	@param25	varchar(255) = null, 
	@param26	varchar(255) = null,
	@param27	varchar(255) = null,
	@param28	varchar(255) = null,
	@param29	varchar(255) = null,
	@param30	varchar(255) = null,
	@param31	varchar(255) = null,
	@param32	varchar(255) = null,
	@param33	varchar(255) = null,
	@param34	varchar(255) = null,
	@param35	varchar(255) = null
AS
	/*
		Updates site's content signif settings. 
	*/
	BEGIN TRANSACTION

	DECLARE @ErrorCode INT

	IF ((@param1 IS NOT NULL) AND (@param1 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param1

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param2 IS NOT NULL) AND (@param2 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param2

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param3 IS NOT NULL) AND (@param3 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param3

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param4 IS NOT NULL) AND (@param4 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param4

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param5 IS NOT NULL) AND (@param5 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param5

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param6 IS NOT NULL) AND (@param6 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param6

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param7 IS NOT NULL) AND (@param7 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param7

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param8 IS NOT NULL) AND (@param8 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param8

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param9 IS NOT NULL) AND (@param9 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param9

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param10 IS NOT NULL) AND (@param10 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param10

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param11 IS NOT NULL) AND (@param11 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param11

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param12 IS NOT NULL) AND (@param12 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param12

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param13 IS NOT NULL) AND (@param13 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param13

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param14 IS NOT NULL) AND (@param14 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param14

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param15 IS NOT NULL) AND (@param15 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param15

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param16 IS NOT NULL) AND (@param16 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param16

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param17 IS NOT NULL) AND (@param17 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param17

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param18 IS NOT NULL) AND (@param18 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param18

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param19 IS NOT NULL) AND (@param19 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param19

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param20 IS NOT NULL) AND (@param20 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param20

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param21 IS NOT NULL) AND (@param21 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param21

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param22 IS NOT NULL) AND (@param22 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param22

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param23 IS NOT NULL) AND (@param23 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param23

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param24 IS NOT NULL) AND (@param24 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param24

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param25 IS NOT NULL) AND (@param25 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param25

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param26 IS NOT NULL) AND (@param26 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param26

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param27 IS NOT NULL) AND (@param27<> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param27

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param28 IS NOT NULL) AND (@param28> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param28

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param29 IS NOT NULL) AND (@param29> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param29

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param30 IS NOT NULL) AND (@param30 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param30

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param31 IS NOT NULL) AND (@param31 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param31

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param32 IS NOT NULL) AND (@param32 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param32

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param33 IS NOT NULL) AND (@param33 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param33

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param34 IS NOT NULL) AND (@param34 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param34

		IF @ErrorCode<>0 GOTO HandleError
	END 

	IF ((@param35 IS NOT NULL) AND (@param35 <> ''))
	BEGIN
		EXEC @ErrorCode = dbo.updatecontentsignifsetting @SiteID	= @siteid, 
													  	 @setting	= @param35

		IF @ErrorCode<>0 GOTO HandleError
	END 

	COMMIT TRANSACTION

RETURN 0

-- Error handling
HandleError:
	ROLLBACK TRANSACTION
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode
