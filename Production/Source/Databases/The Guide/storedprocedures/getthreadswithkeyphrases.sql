CREATE PROCEDURE getthreadswithkeyphrases @keyphraselist VARCHAR(8000), @siteid int, @firstindex int, @lastindex int
AS
DECLARE @err INT

DECLARE @forumid INT
SELECT @forumid=g.forumid FROM keyarticles ka WITH(NOLOCK)
INNER JOIN guideentries g WITH(NOLOCK) ON g.entryid=ka.entryid
WHERE articlename='threadsearchphrase' AND ka.siteid=@siteid

IF ( @keyphraselist is null or @keyphraselist = '' ) 
BEGIN
	IF ( @lastindex = 20 AND @firstindex = 0 ) 
	BEGIN
		-- Optimised Version for first results page
		EXEC @err = getthreadswithkeyphrasesfirstpage @forumid
		SET @err = dbo.udf_checkerr(@@ERROR,@err)
		RETURN @err
	END
	ELSE
	BEGIN
		--Get threads for the given skip and show params.
		EXEC @err = getthreadswithkeyphrasesgeneral @forumid, @firstindex, @lastindex
		SET @err = dbo.udf_checkerr(@@ERROR,@err)
		RETURN @err
	END
END
ELSE
BEGIN
	--Get threads with the given filter
	EXEC @err = getthreadswithkeyphrasesgeneralfiltered @forumid, @keyphraselist, @firstindex, @lastindex
	SET @err = dbo.udf_checkerr(@@ERROR,@err)
	RETURN @err
END
