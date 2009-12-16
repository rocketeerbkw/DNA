CREATE PROCEDURE getemailinsertgroups
AS
BEGIN
SELECT DISTINCT InsertGroup FROM EmailInserts
END