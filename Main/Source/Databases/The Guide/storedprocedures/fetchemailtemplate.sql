CREATE PROCEDURE fetchemailtemplate @siteid int, @emailname varchar(255), @modclass int = null
As
BEGIN TRANSACTION
DECLARE @modclassid int
IF @modclass IS NOT NULL
	SELECT @modclassid = @modclass
ELSE 
BEGIN
	SELECT @modclassid = (SELECT ModClassID FROM Sites WHERE SiteID = @siteid)
	IF NOT EXISTS (SELECT * FROM EmailTemplates WHERE Name = @emailname AND ModClassID = @modclassid)
	BEGIN
		SELECT @modclassid = 2
	END
END
SELECT Subject, Body FROM EmailTemplates WHERE Name = @emailname AND ModClassID = @modclassid
COMMIT
	