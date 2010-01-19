create procedure updatetextboxelementkeyphrases @textboxid int, @keyphrases varchar(8000)
as

DECLARE @ErrorCode INT
BEGIN TRANSACTION

--Allow association with empty string.
IF @keyphrases = '' 
BEGIN
	SET @keyphrases = '|'
END

--clear any existing board promo - phrase associations.
delete from [dbo].textboxelementkeyphrases where textboxelementid = @textboxid
IF @@ERROR <> 0
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

-- Insert any phrases not already present.
INSERT INTO [dbo].keyphrases( phrase ) 
( 
	SELECT element 'Phrase' from udf_splitvarchar(@keyphrases) where not exists
	(
		select phraseid from KeyPhrases where  phrase = element
	)
)
IF @@ERROR <> 0
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

--set up link between board promo and phrase(s)
insert into textboxelementkeyphrases(textboxelementid, phraseid ) 
( 
	SELECT @textboxid 'textboxelementid', kp.phraseId from KeyPhrases kp
	INNER JOIN udf_splitvarchar(@keyphrases) s ON s.element = kp.Phrase
)
IF @@ERROR <> 0 
BEGIN
	SET @ErrorCode = @@ERROR
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return 0