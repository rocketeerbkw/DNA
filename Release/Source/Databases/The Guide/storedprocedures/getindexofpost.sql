CREATE     PROCEDURE getindexofpost @threadid int, @postid int
AS
/*
print @threadid
print @postid
select 'Index' = COUNT(*) from ThreadEntries WITH(NOLOCK)
WHERE ThreadID = @threadid AND EntryID < @postid --AND (Hidden IS NULL)
*/

IF @postid < 2147483647
BEGIN
select 'Index' = PostIndex from ThreadEntries WITH(NOLOCK)
WHERE ThreadID = @threadid AND EntryID = @postid --AND (Hidden IS NULL)
END
ELSE
BEGIN
select 'Index' = MAX(PostIndex)+1 from ThreadEntries WITH(NOLOCK)
WHERE ThreadID = @threadid --AND (Hidden IS NULL)
END
