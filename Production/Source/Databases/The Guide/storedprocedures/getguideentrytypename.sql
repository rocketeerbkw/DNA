create procedure getguideentrytypename @id int
as

SELECT Name FROM GuideEntryTypes WHERE Id = @id
