CREATE PROCEDURE moderationadddistressmessage @modclassid INT, @subject VARCHAR(255), @text VARCHAR(5000)
AS

INSERT INTO DistressMessages( subject, text, modclassid ) VALUES ( @subject, @text, @modclassid )
RETURN @@ERROR