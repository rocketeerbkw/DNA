CREATE VIEW VHosts WITH SCHEMABINDING
AS
	/*
		Function: View on users with host status

		Params:

		Results Set: UserID INT, SiteID INT

		Returns:
	*/

	SELECT UserID, SiteID
	  FROM dbo.Groups g
			INNER JOIN dbo.GroupMembers gm on g.GroupID = gm.GroupID
	 WHERE Name = 'Editor'