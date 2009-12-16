Create Procedure dynamiclistgetlist @listid INT
AS
SELECT [XML],LastUpdated,DateCreated,siteURLName FROM DynamicListDefinitions d
WHERE d.[ID] = @listid