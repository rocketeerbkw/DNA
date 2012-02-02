CREATE PROCEDURE createtweetinfoforcomment @postid int, @tweetid bigint
As
	INSERT dbo.ThreadEntriesTweetInfo(ThreadEntryId,TweetId) VALUES (@postid, @tweetid)
