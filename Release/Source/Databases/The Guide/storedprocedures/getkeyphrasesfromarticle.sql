/*********************************************************************************

	create procedure getkeyphrasesfromarticle @h2g2id int as

	Author:		Steven Francis
	Created:	14/12/2005
	Inputs:		@h2g2id - ID of the article
	Outputs:	
	Purpose:	Get the key phrase detail of an article
	
*********************************************************************************/

CREATE PROCEDURE getkeyphrasesfromarticle @h2g2id INT
AS

DECLARE @EntryID INT

SELECT @EntryID = @h2g2id / 10

IF EXISTS (SELECT 1 FROM dbo.VVisibleGuideEntries WHERE EntryID = @EntryID)
BEGIN
	SELECT k.Phrase, artk.EntryID,artk.PhrasenameSpaceID, n.Name 'Namespace'  FROM [dbo].ArticleKeyPhrases artk WITH(NOLOCK)
	INNER JOIN [dbo].PhraseNameSpaces pns WITH(NOLOCK) ON artk.PhraseNamespaceID = pns.PhraseNameSpaceID
	INNER JOIN [dbo].KeyPhrases k WITH(NOLOCK) ON pns.PhraseID = k.PhraseID
	LEFT JOIN [dbo].NameSpaces n WITH(NOLOCK) ON n.NameSpaceID = pns.NameSpaceID
	WHERE artk.EntryID = @EntryID
END
ELSE
BEGIN
	SELECT k.Phrase, artk.EntryID,artk.PhrasenameSpaceID, n.Name 'Namespace'  FROM [dbo].ArticleKeyPhrasesNonVisible artk WITH(NOLOCK)
	INNER JOIN [dbo].PhraseNameSpaces pns WITH(NOLOCK) ON artk.PhraseNamespaceID = pns.PhraseNameSpaceID
	INNER JOIN [dbo].KeyPhrases k WITH(NOLOCK) ON pns.PhraseID = k.PhraseID
	LEFT JOIN [dbo].NameSpaces n WITH(NOLOCK) ON n.NameSpaceID = pns.NameSpaceID
	WHERE artk.EntryID = @EntryID
END

RETURN @@error