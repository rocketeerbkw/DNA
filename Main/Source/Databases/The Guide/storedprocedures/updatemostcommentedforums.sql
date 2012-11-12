/*********************************************************************************
	Author:		Srihari Thiagarajan
	Created:	12/11/2012
	Inputs:		
	Outputs:	
	Purpose:	updates the TopNMostCommentedForums table with most recently 
				commented and most commented comment forums details for 'blogs'
				at the moment
	
*********************************************************************************/

CREATE PROCEDURE updatemostcommentedforums
AS

DECLARE @ErrorCode INT  

BEGIN  
  
 BEGIN TRANSACTION  
 
  DECLARE @COMMENTFORUMLIST TABLE
  (
	UID varchar(255)
  )
  
  INSERT INTO @COMMENTFORUMLIST
	SELECT   
	  cf.Uid  
	FROM CommentForums cf  
	INNER JOIN forums WITH(NOLOCK) f ON f.forumid = cf.forumid  
	INNER JOIN sites  WITH(NOLOCK) s on f.siteid = s.siteid
	INNER JOIN threads  WITH(NOLOCK) t on t.forumid = f.forumid  
	INNER JOIN threadentries  WITH(NOLOCK) te on te.threadid = t.threadid  
	WHERE s.urlname like 'blog%' AND te.DatePosted > DATEADD(month,-1,getdate())  
	GROUP BY cf.Uid  
 
  DELETE FROM TopNMostCommentedForums WHERE GroupName = 'MostRecentlyCommented'    
  SELECT @ErrorCode = @@ERROR  
  IF (@ErrorCode <> 0)  
  BEGIN  
   ROLLBACK TRANSACTION  
   EXEC Error @ErrorCode  
   RETURN @ErrorCode  
  END  
  
   INSERT INTO TopNMostCommentedForums
	(	
		GroupName,
		UID,
		SiteId,
		ForumId,
		Title,
		Url,
		CanWrite,
		ForumPostCount,
		ModerationStatus,
		DateCreated,
		ForumCloseDate,
		CommentForumListCount,
		LastPosted
	)
   SELECT 
		'MostRecentlyCommented',
		cf.Uid,
		cf.SiteID,
		cf.ForumID,
		f.Title,
		cf.Url,
		f.CanWrite,
		'ForumPostCount' = f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WHERE ForumID = f.ForumID),
		f.ModerationStatus,
		f.DateCreated,
		cf.ForumCloseDate,
		'CommentForumListCount' = (select count(*) from @COMMENTFORUMLIST),
		f.LastPosted
   FROM @COMMENTFORUMLIST tmp   
   INNER JOIN CommentForums  WITH(NOLOCK) cf on tmp.Uid = cf.Uid  
   INNER JOIN Forums  WITH(NOLOCK) f on f.ForumID = cf.ForumID 
   ORDER BY f.LastPosted desc
   
  SELECT @ErrorCode = @@ERROR  
  IF (@ErrorCode <> 0)  
  BEGIN  
   ROLLBACK TRANSACTION  
   EXEC Error @ErrorCode  
   RETURN @ErrorCode  
  END  
 COMMIT TRANSACTION  
 
 BEGIN TRANSACTION  
  DELETE FROM TopNMostCommentedForums WHERE GroupName = 'MostCommented'    
  SELECT @ErrorCode = @@ERROR  
  IF (@ErrorCode <> 0)  
  BEGIN  
   ROLLBACK TRANSACTION  
   EXEC Error @ErrorCode  
   RETURN @ErrorCode  
  END  
	  
   INSERT INTO TopNMostCommentedForums
	(	
		GroupName,
		UID,
		SiteId,
		ForumId,
		Title,
		Url,
		CanWrite,
		ForumPostCount,
		ModerationStatus,
		DateCreated,
		ForumCloseDate,
		CommentForumListCount,
		LastPosted
	)
   SELECT 
		'MostCommented',
		cf.Uid,
		cf.SiteID,
		cf.ForumID,
		f.Title,
		cf.Url,
		f.CanWrite,
		'ForumPostCount' = f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WHERE ForumID = f.ForumID),
		f.ModerationStatus,
		f.DateCreated,
		cf.ForumCloseDate,
		'CommentForumListCount' = (select count(*) from @COMMENTFORUMLIST),
		f.LastPosted
   FROM @COMMENTFORUMLIST tmp   
   INNER JOIN CommentForums  WITH(NOLOCK) cf on tmp.Uid = cf.Uid  
   INNER JOIN Forums  WITH(NOLOCK) f on f.ForumID = cf.ForumID 
   ORDER BY ForumPostCount desc
   
    SELECT @ErrorCode = @@ERROR  
    IF (@ErrorCode <> 0)  
	  BEGIN  
	   ROLLBACK TRANSACTION  
	   EXEC Error @ErrorCode  
	   RETURN @ErrorCode  
	END  
 COMMIT TRANSACTION 
 
END

RETURN (0) 

