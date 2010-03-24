CREATE PROCEDURE searchforums @searchterm varchar(1024)
AS

select @searchterm = REPLACE(@searchterm, '''','''''')
select @searchterm = QUOTENAME(@searchterm, '''');
declare @query varchar(4096)
select @query = 'select	''PostID'' = t.EntryID, 
		''Subject'' = t.Subject, 
		''ThreadID'' = t.ThreadID, 
		''ForumID'' = t.ForumID 
	from ThreadEntries t
	where (CONTAINS(t.text, ' + @searchterm + ')) 
		ORDER BY t.DatePosted DESC'

EXEC(@query)