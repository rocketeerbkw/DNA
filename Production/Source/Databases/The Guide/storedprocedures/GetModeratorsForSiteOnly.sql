CREATE PROCEDURE getmoderatorsforsiteonly @siteid int
AS
	/*
		Function: Returns the moderators for a given site. (Given the name GetModeratorsForSiteOnly because 
				  name GetModeratorsForSite is used for an SP that returns moderators for all sites

		Params:
			@siteid - SiteID.

		Results Set: UserID, UserName

		Returns: @@ERROR
	*/

	SELECT	m.UserID, u.UserName
	  FROM	dbo.VModerators m
			INNER JOIN dbo.Users u on m.UserID = u.UserID
	 WHERE	m.SiteID = @siteid

RETURN @@ERROR