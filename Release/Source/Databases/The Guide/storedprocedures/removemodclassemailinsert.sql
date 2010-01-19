CREATE PROCEDURE removemodclassemailinsert @modclassid int, @name varchar(255)
AS
DELETE FROM EmailInserts 
WHERE ModClassID = @modclassid 
AND InsertName = @name