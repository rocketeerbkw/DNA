create procedure getboardpromoelementkeyphrases @siteid INT, @boardpromoelementid INT, @defaultkeyphrasepromo INT OUTPUT
AS

-- A default boardpromokeyphrasepromo will be associated with phraseID = 0.
SELECT @defaultkeyphrasepromo = CASE WHEN EXISTS ( SELECT * FROM boardpromoelementkeyphrases bpkp 
			INNER JOIN BoardPromoElements bpe ON bpe.BoardPromoElementID = bpkp.BoardPromoElementID
			INNER JOIN FrontPageElements fpe ON fpe.ElementID = bpe.ElementID AND fpe.siteid = @siteid
			WHERE bpkp.BoardPromoElementID = @boardpromoelementid AND bpkp.PhraseID = 0  ) 
			THEN 1
			ELSE 0	
			END

SELECT phrase from keyphrases kp
INNER JOIN boardpromoelementkeyphrases bpkp ON  bpkp.phraseid = kp.phraseid AND bpkp.boardpromoelementid = @boardpromoelementid