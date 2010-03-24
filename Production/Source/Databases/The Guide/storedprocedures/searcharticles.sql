/*
searcharticles
	@searchterm - text to search for (see below for format)
	@showapproved - 1 if we should search approved articles
	@shownormal - 1 if we should search normal entries
	@showsubmitted - 1 if we should search submitted (status = 4) articles

	This sp will perform a search based on the search term.

	The user types in a search term - words sometimes surrounded by quote.
	examples are:  "Arthur Dent" zaphod
		becomes:	"Arthur Dent" AND FORMSOF(INFLECTIONAL, zaphod
		and:		starship titanic
		becomes:	FORMSOF(INFLECTIONAL, starship) AND FORMSOF(INFLECTIONAL, titanic)
*/

CREATE PROCEDURE searcharticles @searchterm varchar(1024), @showapproved int = 1, @shownormal int = 1, @showsubmitted int = 1
AS

DECLARE @SafeSearchTerm varchar (4000)
select @SafeSearchTerm = REPLACE(@searchterm, '''','''''')
select @SafeSearchTerm = QUOTENAME(@SafeSearchTerm, '''');
declare @query nvarchar(max)

declare @statuslist varchar(256)
select @statuslist = ''
if @showsubmitted = 1
BEGIN
	select @statuslist = ',4'
END
if @showapproved = 1
BEGIN
	select @statuslist = @statuslist + ',1'
END

if @shownormal = 1
BEGIN
	select @statuslist = @statuslist + ',3,4,5,11,12'
END

select @statuslist = SUBSTRING(@statuslist, 2, LEN(@statuslist)-1)

select @query = 'select	
		''EntryID'' = g.EntryID, 
		''Subject'' = g.Subject, 
		''h2g2ID'' = g.h2g2ID, 
		g.Status, 
		g.DateCreated,
		g.LastUpdated,
		''InTitle'' = CASE WHEN  CONTAINS(g.Subject, @SafeSearchTerm) THEN 1 ELSE 0 END
	from GuideEntries g 
	where (CONTAINS(g.text, @SafeSearchTerm) OR CONTAINS(g.Subject, @SafeSearchTerm)) 
		AND (g.Status IN (' + @statuslist + ')) AND g.EntryID IS NOT NULL 
		ORDER BY InTitle DESC, g.Status ASC, g.DateCreated DESC'

-- EXEC(@query)

	EXECUTE sp_executesql @query, 
							N'@SafeSearchTerm varchar(4000)', 
							@SafeSearchTerm = @SafeSearchTerm 

