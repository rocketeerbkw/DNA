CREATE PROCEDURE removesiteemailinsert @siteid int, @name varchar(255)
AS
DELETE FROM EmailInserts 
WHERE SiteID = @siteid 
AND InsertName = @name