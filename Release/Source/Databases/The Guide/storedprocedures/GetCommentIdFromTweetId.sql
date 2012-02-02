CREATE PROCEDURE getcommentidfromtweetid @tweetid bigint
AS
	SELECT teti.ThreadEntryId 
		FROM dbo.ThreadEntriesTweetInfo teti
		WHERE teti.TweetId = @tweetid