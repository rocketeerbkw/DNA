CREATE PROCEDURE profanityaddprofanity @profanity varchar(50), @modclassid int, @refer tinyint
AS
INSERT INTO Profanities (Profanity, ModClassID, Refer) VALUES (@profanity, @modclassid, @refer)