CREATE PROCEDURE setpremoderationstate @newstate int
As
UPDATE MasterSettings SET PreModeration = @newstate
return 0
