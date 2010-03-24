/*********************************************************************************

	create procedure addkeyphrasestoarticle @h2g2id INT, @keywords VARCHAR(8000) as

	Author:		Steven Francis
	Created:	14/12/2005
	Inputs:		@h2g2id - ID of Article to add the keyphrases to
	Outputs:	
	Purpose:	Associate the list of key phrases with this particular article
	
*********************************************************************************/

CREATE PROCEDURE addkeyphrasestoarticle @h2g2id INT,@keywords VARCHAR(8000), @namespaces VARCHAR(8000) = NULL
AS
	/*
		This procedure associates a list of key phrases - namespace pairs to an article with the following steps:
			1. Create new keyphrases if they don't already exist and are associated with a recognised namespaces
			2. Create new PhraseNameSpaces if they don't already exist
			3. Associate article with PhraseNameSpaces.

		@namespaces can either be null, in which case all keyphrases have a null namespace, or a comma separated list of namespaces. 
		If @namespaces contains namespaces and null namespaces then the string null must be passed in. 'null' will be converted to a 
		db null in udf_getkeyphrasenamespacepairs. 
	*/
	
	DECLARE @KeyPhraseNamespaces TABLE (Phrase VARCHAR(100) NOT NULL, PhraseID INT NULL, Namespace varchar(255) NULL, NameSpaceID INT NULL)

	INSERT INTO @KeyPhraseNamespaces (Phrase, PhraseID, Namespace, NameSpaceID)
	SELECT DISTINCT	kpns.Phrase, 
					kp.PhraseID,
					kpns.Namespace,
					ns.NameSpaceID
	  FROM dbo.udf_getkeyphrasenamespacepairs (@namespaces, @keywords) kpns
			LEFT JOIN dbo.KeyPhrases kp ON kpns.Phrase = kp.Phrase
			LEFT JOIN dbo.NameSpaces ns ON kpns.Namespace = ns.Name

	-- Only keyphrases with recognised namespaces are allowed. Keyphrases without an associated namespace are allowed. Delete unwanted rows.
	DELETE FROM @KeyPhraseNamespaces
	 WHERE NameSpaceID IS NULL -- unrecognised namespace
	   AND Namespace IS NOT NULL -- null namespaces are allowed. 

	-- 1. Create new keyphrases if they don't already exist and are associated with a recognised namespaces
 	INSERT INTO dbo.KeyPhrases (Phrase)
	SELECT Phrase
	  FROM @KeyPhraseNamespaces
	 WHERE PhraseID IS NULL

	-- Fill in new PhraseIDs for this article
	UPDATE @KeyPhraseNamespaces
	   SET PhraseID = kp.PhraseID
	  FROM @KeyPhraseNamespaces kpns
			INNER JOIN dbo.KeyPhrases kp ON kpns.Phrase = kp.Phrase

	-- 2. Create new PhraseNameSpaces if they don't already exist
	INSERT INTO dbo.PhraseNameSpaces (PhraseID, NameSpaceID)
	SELECT kpns.PhraseID, kpns.NameSpaceID
	  FROM @KeyPhraseNamespaces kpns
	 WHERE NOT EXISTS (SELECT 1
						 FROM dbo.PhraseNameSpaces pns
						WHERE kpns.PhraseID = pns.PhraseID
						  AND ISNULL(kpns.NameSpaceID, -1) = ISNULL(pns.NameSpaceID, -1))

	-- 3. Associate article with PhraseNameSpaces
	DECLARE @EntryID INT

	SELECT @EntryID = @h2g2id / 10

	IF EXISTS (SELECT 1 FROM dbo.VVisibleGuideEntries WHERE EntryID = @EntryID)
	BEGIN
		-- Only visible articles are placed in ArticleKeyPhrases
		INSERT INTO dbo.ArticleKeyPhrases (SiteID, EntryID, PhraseNamespaceID)
		SELECT ge.SiteID, 
			   @EntryID, 
			   pns.PhraseNameSpaceID
		  FROM @KeyPhraseNamespaces kpns
				INNER JOIN dbo.PhraseNameSpaces pns ON kpns.PhraseID = pns.PhraseID AND (ISNULL(kpns.NameSpaceID, -1) = ISNULL(pns.NameSpaceID, -1))
				INNER JOIN dbo.GuideEntries ge ON ge.EntryID = @EntryID
		 WHERE NOT EXISTS (SELECT 1 FROM dbo.ArticleKeyPhrases akp WHERE akp.EntryID = @EntryID AND pns.PhraseNameSpaceID = akp.PhraseNameSpaceID)
	END
	ELSE
	BEGIN
		-- Non-visible articles are placed in ArticleKeyPhrasesNonVisible
		INSERT INTO dbo.ArticleKeyPhrasesNonVisible (SiteID, EntryID, PhraseNamespaceID)
		SELECT ge.SiteID, 
			   @EntryID, 
			   pns.PhraseNameSpaceID
		  FROM @KeyPhraseNamespaces kpns
				INNER JOIN dbo.PhraseNameSpaces pns ON kpns.PhraseID = pns.PhraseID AND (ISNULL(kpns.NameSpaceID, -1) = ISNULL(pns.NameSpaceID, -1))
				INNER JOIN dbo.GuideEntries ge ON ge.EntryID = @EntryID
		 WHERE NOT EXISTS (SELECT 1 FROM dbo.ArticleKeyPhrasesNonVisible akp WHERE akp.EntryID = @EntryID AND pns.PhraseNameSpaceID = akp.PhraseNameSpaceID)
	END
RETURN @@ERROR