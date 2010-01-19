/*********************************************************************************

	create procedure removeallkeyphrasesfromarticle	@id int
	Author:		Steven Francis
	Created:	19/06/2006
	Inputs:		id - the article id
	Outputs:	
	Returns:	
	Purpose:	Removes all the links to key phrases from an article
*********************************************************************************/
CREATE PROCEDURE removeallkeyphrasesfromarticle @id int
AS

DECLARE @EntryID INT

SELECT @EntryID = @id / 10

DELETE FROM dbo.ArticleKeyPhrases 
WHERE EntryID = @EntryID 

DELETE FROM dbo.ArticleKeyPhrasesNonVisible
WHERE EntryID = @EntryID