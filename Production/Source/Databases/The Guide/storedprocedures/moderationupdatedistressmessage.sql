CREATE PROCEDURE moderationupdatedistressmessage @id INT, @modclassid INT, @subject VARCHAR(255), @text VARCHAR(5000)
AS

UPDATE DistressMessages 
SET subject = @subject,text =  @text, modclassid = @modclassid
WHERE messageid = @id
RETURN @@ERROR