Create Procedure getkeyphrasehotlistwithphrase @siteid int, @keyphraselist VARCHAR(500), @skip int = 0, @show int = 500, @sortbyphrase bit = null
AS
set transaction isolation level read uncommitted
DECLARE @elements TABLE(element VARCHAR(100) COLLATE database_default)
INSERT @elements SELECT element FROM dbo.udf_splitvarchar(@keyphraselist)

DECLARE @AssociatedPhrases TABLE( PhraseId int, Phrase VARCHAR(100) COLLATE database_default )

--Get number of key phrases
--DECLARE @count INT; 
--SELECT @count = count(*) FROM @elements

-- Get the discussion that have the phrase  @keyphraselist
--Optimised for only one key phrase.
INSERT @AssociatedPhrases select distinct  kp2.PhraseId, kp2.Phrase FROM ThreadKeyPhrases tkp
INNER JOIN KeyPhrases kp ON kp.PhraseId = tkp.PhraseId 
INNER JOIN  @elements svc ON svc.element = kp.Phrase
INNER JOIN threads th ON th.threadid = tkp.threadid AND th.visibleto IS NULL
INNER JOIN forums f ON f.forumid = th.forumid AND f.siteid = @siteid

--Get the phrases for each of the discussions
INNER JOIN ThreadKeyPhrases tkp2 ON tkp2.ThreadId = tkp.ThreadId
INNER JOIN KeyPhrases kp2 ON kp2.PhraseId = tkp2.PhraseId

--WHERE kp.Phrase = @keyphraselist


-- Remove the initial search phrases - only want related phrases
DELETE FROM @AssociatedPhrases WHERE Phrase IN ( Select element FROM @elements )

--Remove Site Key Phrases.
DELETE FROM @AssociatedPhrases WHERE PhraseId IN ( SELECT PhraseId FROM SiteKeyPhrases where siteid = @siteid )


-- Normalisation factor 
DECLARE @maxphrasecount DECIMAL
SELECT @maxphrasecount =  ISNULL(MAX(kmax.[count]),1.0)
from 
( select tk.PhraseId,
	count(*) 'count'
	from ThreadKeyPhrases tk
	INNER JOIN threads th ON th.threadid = tk.threadid
	INNER JOIN forums f ON f.forumid = th.forumid AND f.siteid = @siteid
	group by tk.PhraseId 
) AS kmax
INNER JOIN @AssociatedPhrases ap ON ap.PhraseId = kmax.PhraseId 

--Normalisation factor.
DECLARE @maxphrasepostcount DECIMAL
SELECT @maxphrasepostcount = ISNULL(MAX(tmax.[score]),1.0)
from 
( 
  select PhraseId, SUM(cst.Score) 'score'
  from ThreadKeyPhrases tk
  INNER JOIN dbo.ContentSignifThread cst ON cst.ThreadId = tk.ThreadId AND cst.siteId = @siteid
  group by PhraseId
) as tmax
INNER JOIN @AssociatedPhrases ap ON ap.PhraseId = tmax.PhraseId 

--create temp table to select into for skip and show.
DECLARE @temphotphrases TABLE( id int NOT NULL IDENTITY(1,1) PRIMARY KEY, Rank float, Phrase VARCHAR(256), PhraseId int, SortByPhrase VARCHAR(100) )

insert @temphotphrases(Rank,Phrase,PhraseId,SortByPhrase)
select CAST(0.6*tk1.[count]/@maxphrasecount + 0.4*tt1.[score]/@maxphrasepostcount AS FLOAT) 'Rank',
		kk.Phrase,
		kk.PhraseId,
		'SortByPhrase' = CASE WHEN @sortbyphrase IS NOT NULL THEN kk.Phrase ELSE NULL END
FROM KeyPhrases kk
INNER JOIN (

--No of times a phrase has been associated/tagged to a thread.
select tk.PhraseId,
	count(*) 'count'
from ThreadKeyPhrases tk
INNER JOIN threads th ON th.threadid = tk.threadid
INNER JOIN forums f ON f.forumid = th.forumid AND f.siteid = @siteid
group by tk.PhraseId ) AS tk1 ON kk.PhraseId = tk1.PhraseId

INNER JOIN (

-- Get total Score for threads associated with phrase.
select PhraseId, SUM(cst.Score)/@maxphrasepostcount 'score'
from ThreadKeyPhrases tk
INNER JOIN dbo.ContentSignifThread cst ON cst.ThreadId = tk.ThreadId AND cst.SiteId = @siteid
group by PhraseId  ) AS tt1 ON tt1.PhraseId = kk.PhraseId


--filter on phrases that are also associated to the same discussions.
INNER JOIN @AssociatedPhrases ap ON ap.PhraseId = kk.PhraseId 

ORDER BY SortByPhrase ASC,Rank DESC

-- Remove entries to be skipped. 
declare @count int
select @count = MAX(id) from @temphotphrases
delete from @temphotphrases where id < @skip or id > @skip + @show

select @count 'count', * from @temphotphrases