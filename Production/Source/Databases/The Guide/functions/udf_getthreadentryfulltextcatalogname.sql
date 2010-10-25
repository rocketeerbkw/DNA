CREATE FUNCTION udf_getthreadentryfulltextcatalogname (@siteid int)
RETURNS VARCHAR(255)
WITH EXECUTE AS OWNER
AS
BEGIN

	/*	
		Returns the name of the database object that has a full-text index for ThreadEntries (Subject, Text) searches. 
		If there is a site specific one use it, otherwise use the full-text index on GuideEntries. 
	*/ 

	DECLARE @fulltextindexedobject varchar(255)

	SELECT @fulltextindexedobject = 'VThreadEntryText_'

	SELECT @fulltextindexedobject = @fulltextindexedobject + s.URLName
	  FROM dbo.Sites s
	 WHERE s.SiteID = @siteid
	IF EXISTS (SELECT	1 
				 FROM	sys.objects o
						INNER JOIN sys.fulltext_indexes i ON o.object_id = i.object_id AND i.is_enabled = 1
						INNER JOIN sys.fulltext_catalogs c ON i.fulltext_catalog_id = c.fulltext_catalog_id
				WHERE	o.name = @fulltextindexedobject)
	BEGIN
		RETURN @fulltextindexedobject
	END
	
	RETURN 'ThreadEntries' -- default to full-text index on ThreadEntries
END