CREATE PROCEDURE getnumberoftopicsforsiteid @isiteid INT, @itopicstatus INT 
AS
BEGIN
	SELECT COUNT(*) AS "NumOfTopics" 
	FROM Topics
	WHERE SiteID = @isiteid AND TopicStatus = @itopicstatus
END
