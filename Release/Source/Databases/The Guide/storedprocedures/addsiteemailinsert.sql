CREATE PROCEDURE addsiteemailinsert @siteid int, @name varchar(255), @group varchar(255), @text nvarchar(MAX)
AS
BEGIN TRANSACTION

IF NOT EXISTS (SELECT * FROM EmailInserts WHERE SiteID = @siteid AND InsertName = @name)
    BEGIN
        INSERT INTO EmailInserts (SiteID, InsertName, InsertGroup, InsertText)
        VALUES(@siteid, @name, @group, @text)
        -- Check to see if the is an entry for the ModClass - usually there will be
        -- If there isn't we should add these as ModClass entries too - to keep things in sync
        DECLARE @modclassid int
        SET @modclassid = (SELECT ModClassID FROM Sites WHERE SiteID = @siteid)
        IF NOT EXISTS (SELECT * FROM EmailInserts WHERE ModClassID = @modclassid AND InsertName = @name)
        BEGIN
            INSERT INTO EmailInserts (ModClassID, InsertName, InsertGroup)
			VALUES (@modclassid, @name, @group)
        END
    END
COMMIT TRANSACTION