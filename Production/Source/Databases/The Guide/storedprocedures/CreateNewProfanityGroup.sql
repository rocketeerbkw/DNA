CREATE PROCEDURE createnewprofanitygroup @groupname varchar(255)
AS

BEGIN TRANSACTION

-- Check to see if this profanity already exists for this site or it's in the global list.
DECLARE @GroupID int
SELECT @GroupID = GroupID FROM ProfanityGroups WHERE GroupName = @groupname
IF (@GroupID > 0)
BEGIN
	-- Already Exists!!! Return the ID for the current one
	ROLLBACK TRANSACTION
	SELECT GroupID = @GroupID, GroupName = @groupname, AlreadyExists = 1
	RETURN 0
END

DECLARE @Error int

-- Insert the new profanity
INSERT INTO ProfanityGroups (GroupName) VALUES (@groupname)
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END

-- Success! Return the new GroupID
SELECT GroupID, GroupName = @groupname, AlreadyExists = 0 FROM ProfanityGroups WHERE GroupName = @groupname

COMMIT TRANSACTION