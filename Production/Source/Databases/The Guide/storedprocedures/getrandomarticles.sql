Create Procedure getrandomarticles
As
	declare @maxarticle int
	SELECT @maxarticle = MAX(EntryID) FROM GuideEntries WHERE Status = 1
	declare @startarticle int
	SELECT @startarticle = CONVERT(int, (RAND() * @maxarticle)+1)
	SELECT TOP 5 'h2g2ID' = h2g2id, Subject FROM GuideEntries g  WHERE g.EntryID >= @startarticle AND Status = 1 ORDER BY g.EntryID 
	return (0)