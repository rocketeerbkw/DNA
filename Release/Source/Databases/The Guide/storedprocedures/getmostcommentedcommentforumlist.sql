create procedure getmostcommentedcommentforumlist @prefix varchar(255) = null, @count int, @siteid int = null  
as  
begin  
 -- @prefix must include the the '%' wildcard for the like clause appended to prefix  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
   
 select top(@count)
	  Uid,  
	  SiteID,  
	  ForumID,   
	  Url,  
	  Title,  
	  CanWrite,  
	  ForumPostCount,  
	  ModerationStatus,  
	  DateCreated,   
	  ForumCloseDate,  
	  CommentForumListCount,  
	  LastPosted  
 from TopNMostCommentedForums    
 where SiteId = ISNULL(@siteid, siteid) and UID like ISNULL(@prefix,uid)
 and GroupName = 'MostCommented' 
 order by ForumPostCount desc
    
end