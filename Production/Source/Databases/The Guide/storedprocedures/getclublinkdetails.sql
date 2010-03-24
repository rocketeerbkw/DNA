CREATE PROCEDURE getclublinkdetails @linkid INT
AS
BEGIN
	SELECT l.*, c.name AS clubName, e.url 
	FROM dbo.links	AS l
	INNER JOIN dbo.externalurls AS e ON e.URLID = l.destinationid
	INNER JOIN dbo.clubs AS c ON c.clubid = l.sourceid
	WHERE linkID = @linkid AND l.sourcetype = 'club'
END