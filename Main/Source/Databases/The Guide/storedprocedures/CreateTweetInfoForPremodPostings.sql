CREATE PROCEDURE createtweetinfoforpremodpostings @modid int, @tweetid bigint, @retweetoriginaltweetid bigint, @isoriginaltweetforretweet bit
As
	INSERT dbo.PreModPostingsTweetInfo(ModId,TweetId,OriginalTweetId,IsOriginalTweetForRetweet) 
	VALUES (@modid, @tweetid, @retweetoriginaltweetid, @isoriginaltweetforretweet)
	