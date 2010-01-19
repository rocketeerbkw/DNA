CREATE PROCEDURE profanitydeleteprofanity @profanityid int
AS
DELETE FROM Profanities WHERE ProfanityID = @profanityid
