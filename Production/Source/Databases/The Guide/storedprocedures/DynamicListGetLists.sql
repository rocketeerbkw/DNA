Create Procedure dynamiclistgetlists @siteurlname varchar(30)
AS
SELECT [Id],[name],[XML],LastUpdated,DateCreated,PublishState FROM
DynamicListDefinitions d
WHERE d.SiteURLName = @siteurlname