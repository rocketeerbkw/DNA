create procedure moderationgetdistressmessage @id INT
AS

SELECT messageid, subject, [text]
FROM distressmessages
WHERE messageid = @id