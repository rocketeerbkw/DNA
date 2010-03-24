CREATE VIEW VModerators WITH SCHEMABINDING
AS
	/*
		Function: View on moderators

		Params:

		Results Set: UserID INT, SiteID INT

		Returns:
	*/

	SELECT UserID, SiteID
	  FROM dbo.Groups g
			INNER JOIN dbo.GroupMembers gm on g.GroupID = gm.GroupID
	 WHERE Name = 'Moderator'