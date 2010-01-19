create procedure moderationgetdistressmessages @modclassid INT = NULL
AS

-- Filter on mod classid only if specified 
SELECT modclassid,messageid, subject, [text]
FROM distressmessages
WHERE modclassid = ISNULL(@modclassid,modclassid)