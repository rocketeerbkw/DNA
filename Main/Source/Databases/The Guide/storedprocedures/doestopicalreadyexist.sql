CREATE PROCEDURE doestopicalreadyexist @isiteid INT, @stitle VARCHAR(255), @itopicstatus INT, @itopicidtoexclude INT = 0
AS
BEGIN
	--queries the db to determine whether a Topic ( actually a guideentry ) with the same 
	--title and the same status already exists for a particular site. Prevents duplicates
	--returns true if a correspoinding entry can be found
	--@itopicidtoexclude specifies the id of the topic to exclude when searching
	--neccessary when an existing topic's title is being edited
	
	DECLARE @iTopicAlreadyExist INT
		
	SELECT @iTopicAlreadyExist = COUNT(*) 
	FROM GuideEntries AS ge INNER JOIN Topics AS tp ON ge.h2g2ID = tp.h2g2ID 
	WHERE ( tp.SiteID = @isiteid ) AND ( LOWER(ge.Subject) = LOWER(@stitle) ) AND ( @itopicstatus = tp.TopicStatus)
	
	--if @itopicidtoexclude is specified then exclude match for this record	
	IF @itopicidtoexclude > 0
	BEGIN
		IF @iTopicAlreadyExist = 1
		BEGIN
			DECLARE @sExcludeTitle VARCHAR(255)
			
			SELECT @sExcludeTitle = LOWER(ge.Subject) 
			FROM GuideEntries AS ge INNER JOIN Topics AS tp ON ge.h2g2ID = tp.h2g2ID 
			WHERE tp.TopicID = @itopicidtoexclude 
			
			IF @sExcludeTitle =  LOWER(@stitle)
				SET @iTopicAlreadyExist = 0
		END
	END	
	
	SELECT @iTopicAlreadyExist AS "iTopicAlreadyExist"
END

