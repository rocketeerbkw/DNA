create procedure gettextboxelementkeyphrases @siteid INT, @textboxelementid INT
AS

SELECT phrase from keyphrases kp
INNER JOIN textboxelementkeyphrases bpkp ON  bpkp.phraseid = kp.phraseid AND bpkp.textboxelementid = @textboxelementid