
CREATE PROCEDURE dynamiclistgetliststopublish @siteurlname VARCHAR(30) = null 
AS
SELECT ID, PublishState, name, xml, siteurlname
FROM DynamicListDefinitions
WHERE PublishState = 1 or PublishState = 3 AND ISNULL(@siteurlname,siteurlname) = siteurlname
ORDER BY lastupdated asc