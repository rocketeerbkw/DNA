/*
 Gets all columns in Profanities DB in alphabetical order
*/

create procedure getallprofanities 
as

declare @count int

SELECT @count = COUNT(*) FROM Profanities
SELECT Count = @count, * FROM Profanities ORDER BY Profanity
