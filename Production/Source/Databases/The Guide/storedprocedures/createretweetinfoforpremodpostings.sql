CREATE PROCEDURE createretweetinfoforpremodpostings @modid int, @tweetid bigint, @retweetoriginaltweetid bigint, @isoriginaltweetforretweet bit  
AS  
BEGIN  
  
 IF EXISTS (SELECT * FROM dbo.PreModPostingsTweetInfo WHERE ModId = @modid)  
 BEGIN  
  UPDATE dbo.PreModPostingsTweetInfo  
  SET OriginalTweetId = @retweetoriginaltweetid,  
   IsOriginalTweetForRetweet = @isoriginaltweetforretweet  
  WHERE   
   ModId = @modid  
  AND   
   TweetId = @tweetid  
 END  
 ELSE  
 BEGIN  
  RAISERROR('Original Tweet not found',16,1)  
 END  
  
END 