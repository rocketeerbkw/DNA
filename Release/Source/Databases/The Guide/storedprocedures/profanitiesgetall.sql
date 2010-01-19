CREATE PROCEDURE profanitiesgetall
AS
SELECT P.ProfanityID, P.Profanity, P.ModClassID, P.Refer
FROM Profanities P
ORDER BY P.ModClassID, P.Refer, P.Profanity ASC