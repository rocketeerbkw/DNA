CREATE PROCEDURE createnewmoderationclass @classname varchar(50), @description varchar(255),@language varchar(10), @itemretrievaltype tinyint=0, @basedonclass int
as

if not exists (select * from dbo.moderationclass where ModClassID = @basedonclass)
BEGIN
	SELECT 'Result' = 1, 'Reason' = 'nosuchclass', 'ModClassID' = NULL
	return 0
END

-- insert into this table

BEGIN TRANSACTION

DECLARE @sortorder INT
SELECT @sortorder = COUNT(*) FROM ModerationClass

declare @newclassid int
insert into ModerationClass (Name, Description, SortOrder, ClassLanguage, ItemRetrievalType )
	VALUES(@classname, @description, @sortorder, @language, @itemretrievaltype )
set @newclassid = @@IDENTITY

-- now we have to add all the same moderators to this class
insert into ModerationClassMembers (ModClassID, UserID )
	SELECT @newclassid, UserID  FROM ModerationClassMembers m
		WHERE m.ModClassID = @basedonclass
		
-- Now duplicate all profanities for this class
insert into termsbymodclass (termid, modclassid, actionid)
	SELECT termid, @newclassid, actionid
		FROM termsbymodclass
			WHERE modClassID = @basedonclass
			
COMMIT TRANSACTION

SELECT 'Result' = 0, 'Reason' = 'success', 'ModClassID' = @newclassid
