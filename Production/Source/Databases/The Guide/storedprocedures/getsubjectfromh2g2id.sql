Create Procedure getsubjectfromh2g2id @h2g2id int
As
	SELECT Subject FROM GuideEntries WHERE h2g2ID = @h2g2id AND Status != 7 AND (Hidden IS NULL)
return (0)