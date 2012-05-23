CREATE PROCEDURE createtweetinfoforcomment @postid int, @tweetid bigint, @retweetoriginaltweetid bigint, @isoriginaltweetforretweet bit
As
	INSERT dbo.ThreadEntriesTweetInfo(ThreadEntryId,TweetId,OriginalTweetId,IsOriginalTweetForRetweet) 
	VALUES (@postid, @tweetid, @retweetoriginaltweetid, @isoriginaltweetforretweet)
