/*********************************************************************************

	create procedure removekeyphrasesfromarticles	@h2g2id int, @phrasenamespaceids VARCHAR(256)
	Author:		Steven Francis
	Created:	27/01/2006
	Inputs:		h2g2id - the article h2g2id
				phrasenamespaceids  - ID of keyphrase - namespace pair
	Outputs:	
	Returns:	
	Purpose:	Removes the link between a KeyPhrase - Namespace pair and an article
*********************************************************************************/
CREATE PROCEDURE removekeyphrasesfromarticles @h2g2id int, @phrasenamespaceids VARCHAR(256)
AS

-- Get article's EntryID
DECLARE @EntryID INT
SELECT @EntryID = @h2g2id / 10

-- Delete association between Article and KeyPhraseNamespaces, outputing removed key phrases.
IF EXISTS (SELECT 1 FROM dbo.VVisibleGuideEntries WHERE EntryID = @EntryID)
BEGIN
	DELETE	FROM dbo.ArticleKeyPhrases 
	OUTPUT	DELETED.phrasenamespaceid, kp.Phrase, n.Name
	  FROM	dbo.udf_splitvarchar(@phrasenamespaceids) u 
			INNER JOIN PhraseNameSpaces pns ON u.element = pns.PhraseNameSpaceId
			INNER JOIN KeyPhrases kp ON pns.PhraseId = kp.PhraseId
			LEFT JOIN NameSpaces n ON pns.NameSpaceId = n.NamespaceId
	 WHERE	u.element = ArticleKeyPhrases.PhraseNamespaceID
	   AND	EntryID = @EntryID
END
ELSE 
BEGIN
	DELETE	FROM dbo.ArticleKeyPhrasesNonVisible
	OUTPUT	DELETED.phrasenamespaceid, kp.Phrase, n.Name
	  FROM	dbo.udf_splitvarchar(@phrasenamespaceids) u 
			INNER JOIN PhraseNameSpaces pns ON u.element = pns.PhraseNameSpaceId
			INNER JOIN KeyPhrases kp ON pns.PhraseId = kp.PhraseId
			LEFT JOIN NameSpaces n ON pns.NameSpaceId = n.NamespaceId
	 WHERE	u.element = ArticleKeyPhrasesNonVisible.PhraseNamespaceID
	   AND	EntryID = @EntryID
END