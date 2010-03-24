CREATE PROCEDURE profanityupdateprofanity @profanityid int, @profanity varchar(50), @modclassid int, @refer tinyint
AS
UPDATE Profanities 
SET Profanity = @profanity, ModClassID = @modclassid, Refer = @refer
WHERE ProfanityID = @profanityid