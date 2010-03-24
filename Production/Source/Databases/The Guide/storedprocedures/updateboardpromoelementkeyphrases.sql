create procedure updateboardpromoelementkeyphrases @boardpromoid int, @keyphrases varchar(8000) = '', @bdefault BIT = 0
as

DECLARE @ErrorCode INT
BEGIN TRANSACTION

--Allow association with empty string.
--IF @keyphrases = '' 
--BEGIN
--	SET @keyphrases = ','
--END

-- clear existing entries for this board promo.
delete from boardpromoelementkeyphrases where boardpromoelementid = @boardpromoid
IF @@ERROR <> 0
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

-- Insert any phrases not already present.
INSERT INTO KeyPhrases( Phrase ) 
( 
	SELECT element 'Phrase' from udf_splitvarchar(@keyphrases) where not exists
	(
		select PhraseId from KeyPhrases where  Phrase = element
	)
)
IF @@ERROR <> 0
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

--set up link between board promo and phrase(s)
insert into boardpromoelementkeyphrases(boardpromoelementid, phraseid ) 
( 
	SELECT @boardpromoid 'boardpromoelementid', kp.phraseId from KeyPhrases kp
	INNER JOIN udf_splitvarchar(@keyphrases) s ON s.element = kp.Phrase
)
IF @@ERROR <> 0 
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

-- Default Promo association - The association of a promo with phraseid = 0 indicates that it is the default.
IF @bdefault <> 0 
BEGIN
	--wish to setup this board promo as a default - find the site for the promo in question.
	declare @siteid INT
	SELECT TOP 1 @siteid = fpe.siteid FROM FrontPageElements fpe
	INNER JOIN BoardPromoElements bpe ON bpe.elementid = fpe.elementid AND bpe.boardpromoelementid = @boardpromoid
	
	-- delete promos linked to phraseId = 0 for the current site.
	delete from boardpromoelementkeyphrases 
	where phraseId = 0 AND boardpromoelementid IN
	(	SELECT boardpromoelementid from boardpromoelements bpe
		INNER JOIN frontpageelements fpe ON fpe.elementid = bpe.elementid AND fpe.siteid = @siteid
	)
	IF @@ERROR <> 0 
	BEGIN
		SET @ErrorCode = @@ERROR
		ROLLBACK TRANSACTION
		RETURN @ErrorCode
	END
	 
	--add a new default board promo association.
	insert into boardpromoelementkeyphrases(boardpromoelementid, phraseid ) VALUES(@boardpromoid,0)
	IF @@ERROR <> 0 
	BEGIN
		SET @ErrorCode = @@ERROR
		ROLLBACK TRANSACTION
		RETURN @ErrorCode
	END
END

COMMIT TRANSACTION

return 0