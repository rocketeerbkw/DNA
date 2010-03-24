
Create Procedure getarticlesincategory @catid int
As
	SELECT g.h2g2ID, g.Subject, c.Section, c.SectionDescription FROM CategoryMembers c
		INNER JOIN GuideEntries g ON g.h2g2ID = c.h2g2ID
	WHERE c.CategoryID = @catid
	return (0)
