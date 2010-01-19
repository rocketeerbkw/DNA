CREATE TRIGGER trg_GuideEntries_i ON GuideEntries
FOR INSERT
AS
	IF NOT UPDATE(LastUpdated)
	BEGIN
		 UPDATE GuideEntries SET LastUpdated = getdate() WHERE EntryID IN (SELECT EntryID FROM inserted)
	END

	INSERT INTO dbo.ArticleIndex (EntryID, Subject, SortSubject, IndexChar, UserID, Status, SiteID)
	SELECT i.EntryID, 
		   i.Subject, 
		   dbo.udf_removegrammaticalarticlesfromtext (i.Subject), 
		   CASE 
				WHEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (i.Subject)),1) >= 'a' AND LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (i.Subject)),1) <= 'z' THEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (i.Subject)),1) 
				ELSE '.' END, 
		   m.UserID, 
		   i.Status, 
		   i.SiteID
	  FROM inserted i
			LEFT JOIN Mastheads m on i.EntryID = m.EntryID
	 WHERE i.Status IN (1,3,4) 
	   AND LTRIM(i.Subject) <> '' 
	   AND i.Hidden IS NULL
	   