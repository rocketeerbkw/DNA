CREATE PROCEDURE getmoderatorsformoderationclass @modclassid int
AS
	/*
		Function: Returns the moderators in a moderation class. 

		Params:
			@modclassid - Moderation class id.

		Results Set: UserID, UserName

		Returns: @@ERROR
	*/

	SELECT	DISTINCT u.UserID, u.UserName
	  FROM	dbo.Sites s
			INNER JOIN dbo.VModerators m ON s.SiteID = m.SiteID
			INNER JOIN dbo.Users u ON m.UserID = u.UserID
	 WHERE	s.ModClassID = @modclassid
	 ORDER	BY u.UserName ASC

RETURN @@ERROR