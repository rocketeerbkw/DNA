Create Procedure dynamiclistaddlist @siteurlname varchar(30) , @name varchar(50), @xml varchar(MAX), @duplicate int output
AS 

SET @duplicate = 0

Select [ID] FROM DynamicListDefinitions where [name] = @name
IF @@ROWCOUNT != 0
BEGIN
	SET @duplicate = 1
	RETURN @@ERROR
END 
	
INSERT INTO DynamicListDefinitions(SiteURLName, [Name],[xml],LastUpdated,DateCreated) 
Values(@siteurlname, @name,@xml,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
RETURN @@ERROR