CREATE PROCEDURE getphrasesfornamespace @siteid int, @namespaceid int
AS
SELECT kp.Phrase FROM dbo.KeyPhrases kp
INNER JOIN dbo.PhraseNameSpaces pns ON pns.PhraseID = kp.PhraseID
INNER JOIN dbo.NameSpaces ns ON ns.NameSpaceID = pns.NameSpaceID
WHERE ns.NameSpaceID = @NameSpaceID AND ns.SiteID = @SiteID