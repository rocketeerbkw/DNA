CREATE PROCEDURE createtweetinfoforpremodpostings @modid int, @tweetid bigint, @retweetoriginaltweetid bigint, @isoriginaltweetforretweet bit
As
IF EXISTS (SELECT * FROM dbo.PreModPostingsTweetInfo WHERE TweetId = @tweetid)
BEGIN
	UPDATE dbo.PreModPostingsTweetInfo
	SET OriginalTweetId = @retweetoriginaltweetid, IsOriginalTweetForRetweet = @isoriginaltweetforretweet
	WHERE TweetId = @tweetid
END
ELSE
BEGIN
	INSERT dbo.PreModPostingsTweetInfo(ModId,TweetId,OriginalTweetId,IsOriginalTweetForRetweet) 
	VALUES (@modid, @tweetid, @retweetoriginaltweetid, @isoriginaltweetforretweet)
END	