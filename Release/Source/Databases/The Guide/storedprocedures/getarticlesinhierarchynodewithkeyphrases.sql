/*
	@nodeid - category node / hierarchy node
	@type - filter for article type
	@maxresults - max number of results to fetch.
	@showmediaassetdata - adds media asset info to resultset.
	@currentsiteid - ?
	The idea of this stored procedure is to restrict the number of articles returned to maxresults 
	but also to balance the articltypes returned if a type is not given 
	It attempts to pull out the same number of each article type but will allow any
	unused allocation to 'roll-over' to subsequent article types.
*/
CREATE PROCEDURE getarticlesinhierarchynodewithkeyphrases 	@nodeid INT, 
						@type  INT = 0, 
						@maxresults INT = 500, 
						@showmediaassetdata int = 0, 
						@currentsiteid INT = 0
AS
BEGIN
	if @type > 0
	begin
		if @showmediaassetdata = 0
		begin
			EXEC getarticlesinhierarchynodewithkeyphrases_simple_withtype @nodeid, @type, @maxresults, @currentsiteid
		end
		else
		begin
			EXEC getarticlesinhierarchynodewithkeyphraseswithmediaassets_simple_withtype @nodeid, @type, @maxresults, @currentsiteid
		end
	end
	else
	begin
		if @showmediaassetdata = 0
		begin
			EXEC getarticlesinhierarchynodewithkeyphrases_simple @nodeid, @maxresults, @currentsiteid
		end
		else
		begin
			EXEC getarticlesinhierarchynodewithkeyphraseswithmediaassets_simple @nodeid, @maxresults, @currentsiteid
		end
	end
END