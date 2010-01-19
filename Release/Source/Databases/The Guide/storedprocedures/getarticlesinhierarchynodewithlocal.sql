/*
	@nodeid - category node / hierarchy node
	@type - filter for article type
	@maxresults - max number of results to fetch.
	@showcontentrating - adds content rating info to resultset.
	@usernodeid - local user node/location node
	@currentsiteid - ?
	This stored procedure is a special case of getarticlesinhierarchynode with the additional feature of 
	being able to identify if an article is local to user. If this is modified then also propogate the change into
	getarticlesinhierarchy node.
	The idea of this stored procedure is to restrict the number of articles returned to maxresults 
	but also to balance the articltypes returned. 
	It attempts to pull out the same number of each article type but will allow any
	unused allocation to 'roll-over' to subsequent article types.
*/
CREATE PROCEDURE getarticlesinhierarchynodewithlocal @nodeid INT, @type  INT = 0, @maxresults INT = 500, 
	@showcontentratingdata int = 0, @usernodeid int = 0, @currentsiteid int = 0
AS
BEGIN
	if @type = 0
	BEGIN
		if @usernodeid > 0
		BEGIN
			if @showcontentratingdata = 1
			BEGIN
				EXEC dbo.getarticlesinhierarchynodewithlocal_rating_usernode @nodeid, @maxresults, @usernodeid, @currentsiteid
			END
			ELSE
			BEGIN
				EXEC dbo.getarticlesinhierarchynodewithlocal_usernode @nodeid, @maxresults, @usernodeid, @currentsiteid
			END
		END
		ELSE
		BEGIN
			if @showcontentratingdata = 1
			BEGIN
				EXEC dbo.getarticlesinhierarchynodewithlocal_rating @nodeid, @maxresults, @currentsiteid
			END
			ELSE
			BEGIN
				EXEC dbo.getarticlesinhierarchynodewithlocal_simple @nodeid, @maxresults, @currentsiteid
			END
		END
	END
	ELSE
	BEGIN
		if @usernodeid > 0
		BEGIN
			if @showcontentratingdata = 1
			BEGIN
				EXEC dbo.getarticlesinhierarchynodewithlocal_rating_usernode_withtype @nodeid, @type, @maxresults, @usernodeid, @currentsiteid
			END
			ELSE
			BEGIN
				EXEC dbo.getarticlesinhierarchynodewithlocal_usernode_withtype @nodeid, @type, @maxresults, @usernodeid, @currentsiteid
			END
		END
		ELSE
		BEGIN
			if @showcontentratingdata = 1
			BEGIN
				EXEC dbo.getarticlesinhierarchynodewithlocal_rating_withtype @nodeid, @type, @maxresults, @currentsiteid
			END
			ELSE
			BEGIN
				EXEC dbo.getarticlesinhierarchynodewithlocal_simple_withtype @nodeid, @type, @maxresults, @currentsiteid
			END
		END
	END
END



