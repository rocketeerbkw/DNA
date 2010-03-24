CREATE PROCEDURE getkeyphrasesfromthread @threadid INT
AS

select k.Phrase, tk.ThreadId, th.ForumId from [dbo].ThreadKeyPhrases tk 
INNER JOIN [dbo].KeyPhrases k ON k.PhraseID = tk.PhraseID
INNER JOIN [dbo].Threads th ON th.ThreadId = tk.threadId 
where tk.threadid = @threadid