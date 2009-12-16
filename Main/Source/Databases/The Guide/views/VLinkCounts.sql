CREATE VIEW VLinkCounts WITH SCHEMABINDING
AS
	/*
		Function: View on link counts

		Params:

		Results Set: DestinationID INT, Count INT

		Returns:
	*/

	SELECT DestinationID, count(*) AS 'Count'
	  FROM dbo.Links
	 GROUP BY DestinationID