CREATE PROCEDURE getsitesformoderationclass @modclassid int
AS
	/*
		Function: Gets sites in a given moderation class. 

		Params:
			@modclassid - The moderation class.

		Results Set: SiteID, ShortName and URLName. 

		Returns: @@ERROR
	*/

	SELECT	s.SiteID, s.ShortName, s.urlname
	  FROM	dbo.Sites s
	 WHERE	s.ModClassID = @modclassid
	 ORDER	BY ShortName

RETURN @@ERROR