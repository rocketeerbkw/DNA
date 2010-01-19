CREATE PROCEDURE createnewmoderationclass @classname varchar(50), @description varchar(255), @basedonclass int
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
insert into ModerationClass (Name, Description, SortOrder )
	VALUES(@classname, @description, @sortorder)
set @newclassid = @@IDENTITY

-- now we have to add all the same moderators to this class
insert into ModerationClassMembers (ModClassID, UserID )
	SELECT @newclassid, UserID  FROM ModerationClassMembers m
		WHERE m.ModClassID = @basedonclass
		
-- Now duplicate all profanities for this class
insert into Profanities (Profanity, ModClassID, Refer)
	SELECT Profanity, @newclassid, Refer
		FROM Profanities p
			WHERE p.ModClassID = @basedonclass
			
COMMIT TRANSACTION

SELECT 'Result' = 0, 'Reason' = 'success', 'ModClassID' = @newclassid
