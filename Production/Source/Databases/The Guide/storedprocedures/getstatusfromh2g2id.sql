Create Procedure getstatusfromh2g2id @h2g2id int
As
	SELECT status FROM GuideEntries WHERE h2g2ID = @h2g2id
return (0)