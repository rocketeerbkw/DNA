  
CREATE PROCEDURE createretweetinfoforcomment @postid int, @tweetid bigint, @retweetoriginaltweetid bigint, @isoriginaltweetforretweet bit
AS
BEGIN

	IF EXISTS (SELECT * FROM dbo.ThreadEntriesTweetInfo WHERE ThreadEntryId = @postid)
	BEGIN
		UPDATE dbo.ThreadEntriesTweetInfo
		SET OriginalTweetId = @retweetoriginaltweetid,
			IsOriginalTweetForRetweet = @isoriginaltweetforretweet
		WHERE 
			ThreadEntryId = @postid
		AND 
			TweetId = @tweetid
	END
	ELSE
	BEGIN
		RAISERROR('Original Tweet not found',16,1)
	END

END