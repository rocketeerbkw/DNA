DECLARE @siteid INT
SELECT @siteid=siteid FROM sites WHERE urlname = 'memoryshare'

DECLARE @newphrases VARCHAR(1024)
SET @newphrases = 'BBC London|BBC Norfolk|BBC South Yorkshire|BBC Cumbria|BBC Liverpool|BBC Derby|BBC Lincolnshire|BBC Isle of Man|BBC Oxford|BBC Bradford & West Yorkshire|BBC Radio 4 - Today|BBC Radio 4 - Writing the Century|BBC World Service - Free to Speak|BBC Radio 1|BBC Memories|BBC Memoryshare|BBC England|BBC Leeds|BBC Humber|BBC Radio4 - Writing the Century|BBC Radio4 - 1968|BBC Pop on Trial|BBC Wales'

--Insert New Phrases where they dont already exist.
INSERT INTO KeyPhrases ( phrase )
SELECT element FROM  udf_splitvarchar(@newphrases) u
LEFT JOIN KeyPhrases kp ON kp.Phrase = u.element
WHERE kp.phrase IS NULL

--Insert PhraseNameSpaceIds where they dont already exist.
INSERT INTO PhraseNameSpaces ( phraseId, NameSpaceId )
SELECT kp.phraseid, NULL
FROM KeyPhrases kp 
INNER JOIN udf_splitvarchar(@newphrases) u ON u.element = kp.Phrase
LEFT JOIN PhraseNamespaces pn ON pn.phraseid = kp.phraseid AND pn.NameSpaceId IS NULL
WHERE pn.PhraseNameSpaceId IS NULL

-- Link Articles with PhrasenameSpaceIds.
INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-london'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC London'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-norfolk'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Norfolk'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-southyorkshire'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC South Yorkshire'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-cumbria'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Cumbria'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-liverpool'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Liverpool'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-derby'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Derby'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-lincolnshire'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Lincolnshire'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-isleofman'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Isle of Man'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-oxford'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Oxford'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-bradford'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Bradford & West Yorkshire'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-radio4today'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Radio 4 - Today'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-writingthecentury'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Radio 4 - Writing the Century'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-worldservice'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC World Service - Free to Speak'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-radio1'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Radio 1'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-bbcmemories'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Memories'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-memoryshare'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Memoryshare'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-england'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC England'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-leeds'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Leeds'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-humber'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Humber'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-radio4writingthecentury'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Radio 4 - Writing the Century'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-radio4_1968'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Radio 4 - 1968'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-popontrial'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Pop on Trial'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL

INSERT INTO ArticleKeyPhrases ( siteId, EntryId, PhrasenameSpaceId ) 
SELECT @siteid 'siteid', akp.entryid, pn2.phrasenamespaceid
FROM ArticleKeyPhrases akp
INNER JOIN PhraseNameSpaces pn ON pn.PhrasenamespaceId = akp.PhraseNameSpaceId
INNER JOIN KeyPhrases kp ON kp.PhraseId = pn.PhraseId AND kp.Phrase = '_client-wales'
INNER JOIN KeyPhrases kp2 ON kp2.Phrase = 'BBC Wales'
INNER JOIN PhraseNameSpaces pn2 ON pn2.phraseId = kp2.phraseId AND pn2.NameSpaceId IS NULL
LEFT JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId AND akp2.PhraseNameSpaceId = pn2.PhraseNameSpaceId
WHERE akp.siteid = @siteid AND akp2.EntryId IS NULL
