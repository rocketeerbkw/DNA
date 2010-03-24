CREATE PROCEDURE getthreaddetails @threadid int
AS
SELECT FirstSubject FROM dbo.Threads WITH(NOLOCK) WHERE ThreadID = @threadid