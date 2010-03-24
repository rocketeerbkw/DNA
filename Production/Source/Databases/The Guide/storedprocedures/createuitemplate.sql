CREATE PROCEDURE createuitemplate @uitemplatexml xml
AS
BEGIN
	
	-- @uitemplatexml type expected format
	-- <UITEMPLATE UITEMPLATEID="2">
	--		<BUILDERGUID>4EE8FFB8-1A0B-40bf-9D22-34DE6915129A</title>
	--		<UIFIELDS>
	--			<UIFIELD UIFIELDID="1"
	--				     ISKEYPHRASE="1"
	--				     REQUIRED="1"
	--				     ESCAPE="0"
	--				     RAWINPUT="0"
	--				     INCLUDEINGUIDEENTRY="0"
	--				     VALIDATEEMPTY="1"
	--				     VALIDATENOTEQUALTO="1"
	--				     VALIDATEPARSESOK="0"
	--				     VALIDATECUSTOM="0"
	--				     STEP="">
	--				<NAME>SUBJECT</NAME>
	--				<LABEL>Title of the article</LABEL>
	--				<TYPE>Text</TYPE>
	--				<DESCRIPTION>The title of the article</DESCRIPTION>
	--				<KEYPHRASENAMESPACE>TITLE</KEYPHRASENAMESPACE>
	--				<DEFAULTVALUE></DEFAULTVALUE>
	--				<NOTEQUALTOVALUE></NOTEQUALTOVALUE>
	--			</UIFIELD>
	--			...
	--		</UIFIELDS>
	-- </UITEMPLATE>
BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT
	DECLARE @UITemplateID INT
		
	INSERT INTO UITemplate (BuilderGUID, TemplateName)
	SELECT d1.c1.value('./BUILDERGUID[1]','nvarchar(256)') as BuilderGUID,
		d1.c1.value('./NAME[1]','nvarchar(256)') as TemplateName	
	FROM @uitemplatexml.nodes('/UITEMPLATE') as d1(c1)
	SELECT @UITemplateID = SCOPE_IDENTITY()
			
	DECLARE @UIFields table (UIFieldID int)
	
	INSERT INTO UIField ([Name], Label, Type, Description, IsKeyPhrase, KeyPhraseNamespace, Required, 
									DefaultValue, [Escape], RawInput, IncludeInGuideEntry, ValidateEmpty,
									ValidateNotEqualTo, ValidateParsesOK, NotEqualToValue, ValidateCustom, Step, Permissions )
	OUTPUT INSERTED.UIFieldID INTO @UIFields 
	SELECT  d1.c1.value('./NAME[1]','nvarchar(256)') as [Name],
			d1.c1.value('./LABEL[1]','nvarchar(256)') as Label,
			d1.c1.value('./TYPE[1]','nvarchar(256)') as Type,
			d1.c1.value('./DESCRIPTION[1]','nvarchar(256)') as Description,
			d1.c1.value('./@ISKEYPHRASE[1]','bit') as IsKeyPhrase,
			d1.c1.value('./KEYPHRASENAMESPACE[1]','nvarchar(256)') as KeyPhraseNamespace,
			d1.c1.value('./@REQUIRED[1]','bit') as Required,
			d1.c1.value('./DEFAULTVALUE[1]','nvarchar(256)') as DefaultValue,
			d1.c1.value('./@ESCAPE[1]','bit') as [Escape],
			d1.c1.value('./@RAWINPUT[1]','bit') as RawInput,
			d1.c1.value('./@INCLUDEINGUIDEENTRY[1]','bit') as IncludeInGuideEntry,
			d1.c1.value('./@VALIDATEEMPTY[1]','bit') as ValidateEmpty,
			d1.c1.value('./@VALIDATENOTEQUALTO[1]','bit') as ValidateNotEqualTo,
			d1.c1.value('./@VALIDATEPARSESOK[1]','bit') as ValidateParsesOK,
			d1.c1.value('./NOTEQUALTOVALUE[1]','nvarchar(256)') as NotEqualToValue,
			d1.c1.value('./@VALIDATECUSTOM[1]','bit') as ValidateCustom,				
			d1.c1.value('./@STEP[1]','int') as Step,								
			d1.c1.value('./PERMISSIONS[1]','nvarchar(256)') as Permissions				
	FROM @uitemplatexml.nodes('/UITEMPLATE/UIFIELDS/UIFIELD') as d1(c1)

	INSERT INTO UITemplateField (UITemplateID, UIFieldID)
	SELECT @UITemplateID, UIFieldID FROM @UIFields

	COMMIT TRANSACTION
	EXEC getuitemplate @UITemplateID
END TRY
BEGIN CATCH
 -- Whoops, there was an error
  IF @@TRANCOUNT > 0
     ROLLBACK TRANSACTION

  -- Raise an error with the details of the exception
  DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
  SELECT @ErrMsg = ERROR_MESSAGE(),
         @ErrSeverity = ERROR_SEVERITY()

  RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
END