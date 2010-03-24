CREATE PROCEDURE moderationremovedistressmessage @id INT
AS

DELETE FROM DistressMessages 
WHERE messageid = @id
RETURN @@ERROR