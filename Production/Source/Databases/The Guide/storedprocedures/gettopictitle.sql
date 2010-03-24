CREATE PROCEDURE gettopictitle @itopicid INT 
AS
BEGIN

	--obtains the corresponding guide entry's subject field 
	
	SELECT subject 
	FROM GuideEntries 
	WHERE h2g2id = (SELECT h2g2id FROM Topics WHERE topicid = @itopicid) 
END