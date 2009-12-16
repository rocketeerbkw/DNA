CREATE PROCEDURE fetchemailvocab
AS
SELECT SiteID,  Name, Substitution FROM EmailVocab
GROUP BY SiteID, Name, Substitution
ORDER BY SiteID, Name, Substitution DESC
