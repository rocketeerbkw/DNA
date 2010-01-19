CREATE PROCEDURE getuitemplate @uitemplateid int
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	SELECT	t.UITemplateID, 
			t.TemplateName,
			t.BuilderGUID
	FROM	dbo.UITemplate t 
	WHERE	t.UITemplateID = @uitemplateid

	SELECT	f.UIFieldID,
			f.Name,
			f.Label,
			f.Type,
			f.Description,
			f.IsKeyPhrase,
			f.KeyPhraseNamespace,
			f.Required,
			f.DefaultValue,
			f.[Escape],
			f.RawInput,
			f.IncludeInGuideEntry,
			f.ValidateEmpty,
			f.ValidateNotEqualTo,
			f.ValidateParsesOK,
			f.NotEqualToValue,
			f.ValidateCustom,
			f.Step,	
			f.Permissions	
	FROM	dbo.UIField f
	INNER JOIN dbo.UITemplateField tf on tf.UIFieldID = f.UIFieldID
	WHERE	tf.UITemplateID = @uitemplateid
	ORDER BY f.Step

RETURN @@ERROR