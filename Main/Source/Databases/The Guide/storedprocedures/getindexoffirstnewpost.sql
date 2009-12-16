CREATE PROCEDURE getindexoffirstnewpost @threadid int, @datefrom datetime
as

select 'Index' = count(*) from ThreadEntries WITH(NOLOCK)
WHERE ThreadID = @threadid AND DatePosted <= (DATEADD(second, 1, @datefrom))