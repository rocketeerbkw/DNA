Create Procedure trackarticleview @userid int, @articleid int, @h2g2id int = NULL
As
	IF @h2g2id IS NULL
	BEGIN
		declare @temp int, @checksum int
		SELECT @temp = @articleid, @checksum = 0
		WHILE @temp > 0
		BEGIN
		SELECT @checksum = @checksum + (@temp % 10)
		SELECT @temp = @temp  / 10
		END
		SELECT @checksum = @checksum % 10
		SELECT @checksum = 9 - @checksum
		SELECT @h2g2id = @checksum + (10 * @articleid)
	END
	INSERT INTO ArticleViews (UserID, EntryID, h2g2ID)
		VALUES (@userid, @articleid, @h2g2id)
	return (0)