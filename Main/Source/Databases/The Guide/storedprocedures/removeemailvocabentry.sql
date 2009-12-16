CREATE PROCEDURE removeemailvocabentry @siteid int, @name varchar(255)
AS
DELETE FROM EmailVocab WHERE SiteID = @siteid AND Name = @name
