create procedure removekeyphrasesfromthread @threadid int, @phraseids varchar(4096)
as

delete from dbo.ThreadKeyPhrases 
where ThreadID = @threadid 
and PhraseID in 
(
	select KP.PhraseID from udf_splitvarchar(@phraseids) pn
	inner join KeyPhrases kp on pn.element = kp.Phrase
)