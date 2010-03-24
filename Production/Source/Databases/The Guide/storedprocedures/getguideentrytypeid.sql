create procedure getguideentrytypeid @name varchar(255)
as

SELECT Id FROM GuideEntryTypes WHERE Name = @name
