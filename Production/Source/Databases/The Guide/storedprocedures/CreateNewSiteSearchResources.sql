create PROCEDURE createnewsitesearchresources
	@siteid int,
	@urlname nvarchar(30),
	@monthstoretain int
AS

	DECLARE @TOTALSQL nvarchar(MAX)

/*----------------------------------------------------------------------*/
/* Put the site into our table                                          */
/*----------------------------------------------------------------------*/

INSERT INTO dbo.SearchSites (siteid, urlname, monthstoretain) VALUES (@SiteID, @URLName, @monthstoretain)
				
/*----------------------------------------------------------------------*/
/* Create the view                                                      */
/*----------------------------------------------------------------------*/
		
		SELECT @TOTALSQL = '
		CREATE VIEW VThreadEntriesText_' + @URLName + ' WITH SCHEMABINDING
		AS
			SELECT	ThreadEntryID,
					subject,
					[text]
			 FROM	dbo.SearchThreadEntries te 			 
			 INNER JOIN	dbo.SearchSites s ON te.SiteID = s.SiteID
			 WHERE	s.URLName = ''' + @URLName + '''
		'
		PRINT @TOTALSQL
		EXECUTE sp_executesql @TOTALSQL

		SELECT @TOTALSQL = '
		GRANT SELECT ON [dbo].[VThreadEntriesText_' + @URLName + '] TO [ripleyrole]
		'
		PRINT @TOTALSQL
		EXECUTE sp_executesql @TOTALSQL
			 
/*----------------------------------------------------------------------*/
/* Create the index on the view                                         */
/*----------------------------------------------------------------------*/
		
		SELECT @TOTALSQL = '
		CREATE UNIQUE CLUSTERED INDEX [IX_VThreadEntriesText_' + @URLName + ' ] ON [dbo].[VThreadEntriesText_'+ @URLName + '] 
		(
			[ThreadEntryID]
		)'
		PRINT @TOTALSQL
		EXECUTE sp_executesql @TOTALSQL

/*----------------------------------------------------------------------*/
/* Create the fulltext index                                            */
/*----------------------------------------------------------------------*/


		SELECT @TOTALSQL = '
		CREATE FULLTEXT INDEX ON dbo.VThreadEntriesText_' + @URLName + ' 
		( 
			subject LANGUAGE 0,
			text LANGUAGE 0
		)
		KEY INDEX IX_VThreadEntriesText_' + @URLName + ' ON SearchThreadEntriesCat WITH CHANGE_TRACKING AUTO
		'
		PRINT @TOTALSQL
		EXECUTE sp_executesql @TOTALSQL
	
RETURN 0;
