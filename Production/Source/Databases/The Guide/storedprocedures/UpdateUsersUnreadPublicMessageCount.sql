CREATE PROCEDURE updateusersunreadpublicmessagecount @userid int
AS
RAISERROR('updateusersunreadpublicmessagecount DEPRECATED',16,1)

return (0)
/*   Deprecated - only used in other unused procedure shiftuserid
     Future implementation must use SiteID and the mastheads table
	UPDATE Users
	   SET UnreadPublicMessageCount = (SELECT CASE WHEN SUM(tp.CountPosts - tp.LastPostCountRead) IS NULL THEN 0 ELSE SUM(tp.CountPosts - tp.LastPostCountRead) END
									     FROM ThreadPostings tp
									          INNER JOIN Forums f ON tp.ForumID = f.ForumID 
									          INNER JOIN GuideEntries ge ON f.ForumID = ge.ForumID
									          INNER JOIN Users publicforums ON ge.h2g2id = publicforums.MastHead
									    WHERE u.UserID = tp.UserID
									      AND tp.CountPosts > tp.LastPostCountRead)
	  FROM Users u
	 WHERE u.UserID = @UserID 
	
RETURN @@ERROR
*/