CREATE PROCEDURE createtweetinfoforpremodpostings @modid int, @tweetid bigint
As
	INSERT dbo.PreModPostingsTweetInfo(ModId,TweetId) VALUES (@modid, @tweetid)
	