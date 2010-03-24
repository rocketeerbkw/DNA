CREATE PROCEDURE getindexofthread @threadid int, @forumid int
As
declare @lastposted datetime
SELECT @lastposted = LastPosted FROM Threads WITH(NOLOCK) WHERE ThreadID = @threadid
select 'Index' = count(*) from Threads WITH(INDEX=threads0,NOLOCK)
WHERE ForumID = @Forumid AND LastPosted > @lastposted AND VisibleTo IS NULL