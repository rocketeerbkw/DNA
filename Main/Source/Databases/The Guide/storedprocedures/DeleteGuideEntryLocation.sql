CREATE PROCEDURE deleteguideentrylocation @h2g2id int, @locationid int
AS

	DELETE ArticleLocation
	OUTPUT DELETED.LocationID
	  FROM ArticleLocation al
		   INNER JOIN dbo.GuideEntries ge WITH(NOLOCK) ON al.EntryID = ge.EntryID
	 WHERE al.LocationID = @locationid
	   AND ge.h2g2ID = @h2g2id

RETURN @@ERROR