CREATE PROCEDURE addnewemailvocabentry @siteid int, @name varchar(255), @substitution varchar(255)
AS
IF NOT EXISTS (SELECT * FROM EmailVocab WHERE SiteID = @siteid AND Name = @name)
BEGIN
	INSERT INTO EmailVocab (SiteID, Name, Substitution) VALUES (@siteid, @name, @substitution)
END
