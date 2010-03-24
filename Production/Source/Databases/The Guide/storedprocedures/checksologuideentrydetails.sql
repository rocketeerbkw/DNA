CREATE PROCEDURE checksologuideentrydetails @entryid int, @oldgroupid int OUTPUT,  @newgroupid int OUTPUT, @refreshgroups int OUTPUT
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @userSoloGuideEntryCount int

	DECLARE @soloResearcher int
	DECLARE @soloResearcherCount int
	
	SET @soloResearcherCount = 0
	--PRINT 'checksologuideentrydetails'
	
	SELECT @soloResearcherCount = COUNT (*) 
				FROM researchers r 
				INNER JOIN guideentries g ON g.entryid=r.entryid AND g.siteid=1 AND g.type=1 AND g.status=1 
				WHERE r.EntryID = @entryid AND g.editor <> r.userid
				 
	IF @soloResearcherCount = 1
	BEGIN
		--PRINT 'soloResearcher=1'
		SELECT @soloResearcher = r.userid
				FROM researchers r 
				INNER JOIN guideentries g ON g.entryid=r.entryid AND g.siteid=1 AND g.type=1 AND g.status=1 
				WHERE r.EntryID = @entryid AND g.editor <> r.userid
		
		EXEC dbo.getuserssologuideentrycount @soloResearcher, @userSoloGuideEntryCount OUTPUT
		
		--PRINT 'getuserssologuideentrycount'
		--PRINT @soloResearcher
		--PRINT @userSoloGuideEntryCount

		EXEC dbo.updateprolificscribegroup @soloResearcher, @userSoloGuideEntryCount, @oldgroupid OUTPUT, @newgroupid OUTPUT, @refreshgroups OUTPUT 
		
		--PRINT 'updateprolificscribegroup'
		--PRINT @oldgroupid
		--PRINT @newgroupid
		--PRINT @refreshgroups
		
	END	