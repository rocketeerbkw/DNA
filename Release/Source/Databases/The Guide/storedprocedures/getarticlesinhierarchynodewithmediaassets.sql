/*
	@nodeid - category node / hierarchy node
	@type - filter for article type
	@maxresults - max number of results to fetch.
	@showcontentrating - adds content rating info to resultset.
	@currentsiteid - ?
	The idea of this stored procedure is to restrict the number of articles returned to maxresults 
	but also to balance the articltypes returned. 
	It attempts to pull out the same number of each article type but will allow any
	unused allocation to 'roll-over' to subsequent article types.
*/
CREATE PROCEDURE getarticlesinhierarchynodewithmediaassets 	@nodeid INT, 
						@type  INT = 0, 
						@maxresults INT = 500, 
						@showcontentratingdata int = 0, 
						@currentsiteid INT = 0
AS
BEGIN
	if @type > 0
	begin
		if @showcontentratingdata = 1
		begin
			EXEC getarticlesinhierarchynodewithmediaassets_rating_withtype @nodeid, @type, @maxresults, @currentsiteid
		end
		else
		begin
			EXEC getarticlesinhierarchynodewithmediaassets_simple_withtype @nodeid, @type, @maxresults, @currentsiteid
		end
	end
	else
	begin
		if @showcontentratingdata = 1
		begin
			EXEC getarticlesinhierarchynodewithmediaassets_rating @nodeid, @maxresults, @currentsiteid
		end
		else
		begin
			EXEC getarticlesinhierarchynodewithmediaassets_simple @nodeid, @maxresults, @currentsiteid
		end
	end
END