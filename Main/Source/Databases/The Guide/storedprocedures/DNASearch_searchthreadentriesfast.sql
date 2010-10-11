CREATE PROCEDURE dnasearch_searchthreadentriesfast
								@condition nvarchar(1000),
								@maxresults int,
								@urlname varchar(50)
		AS
			SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

			DECLARE @fulltextindex VARCHAR(255);
			DECLARE @Query nvarchar(4000)
			
			-- max results of null or zero means internal maximum
			if (ISNULL(@maxresults,0) = 0) set @maxresults = 500

			SET @Query = '
			SELECT te.ThreadEntryID, 
				KeyTable.RANK AS ''Rank'',
				CAST(KeyTable.RANK AS float)*.001 AS ''Score''
			   FROM CONTAINSTABLE(VThreadEntriesText_' + @URLName + ', (subject,[text]), @i_condition, @i_maxsearchresults) KeyTable
				INNER JOIN SearchThreadEntries te on te.ThreadEntryID = KeyTable.[KEY]
				ORDER BY KeyTable.RANK DESC'

			exec sp_executesql @Query, 
			N'@i_maxsearchresults int, 
			@i_condition varchar(4000)',
			@i_maxsearchresults = @maxresults, 
			@i_condition = @condition