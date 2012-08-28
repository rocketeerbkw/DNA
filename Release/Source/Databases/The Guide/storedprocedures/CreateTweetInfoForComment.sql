CREATE PROCEDURE createtweetinfoforcomment @postid int, @tweetid bigint, @retweetoriginaltweetid bigint, @isoriginaltweetforretweet bit
As

IF EXISTS (SELECT * FROM dbo.ThreadEntriesTweetInfo WHERE TweetId = @tweetid)  
BEGIN  
	UPDATE dbo.ThreadEntriesTweetInfo
	SET OriginalTweetId = @retweetoriginaltweetid, IsOriginalTweetForRetweet = @isoriginaltweetforretweet
	WHERE TweetId = @tweetid
END
ELSE
BEGIN
	IF EXISTS (SELECT * FROM dbo.ThreadEntriesTweetInfo WHERE ThreadEntryId = @postid)
	BEGIN
		UPDATE dbo.ThreadEntriesTweetInfo  
		SET TweetId = @tweetid, OriginalTweetId = @retweetoriginaltweetid, IsOriginalTweetForRetweet = @isoriginaltweetforretweet  
		WHERE ThreadEntryId = @postid 
	END
	ELSE
	BEGIN
		INSERT dbo.ThreadEntriesTweetInfo(ThreadEntryId,TweetId,OriginalTweetId,IsOriginalTweetForRetweet)   
		VALUES (@postid, @tweetid, @retweetoriginaltweetid, @isoriginaltweetforretweet)  
	END
END

