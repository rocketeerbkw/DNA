CREATE PROCEDURE fetchemailtext @siteid int, @emailname varchar(255)
As
IF NOT EXISTS (SELECT * FROM keyarticles WHERE ArticleName = @emailname AND SiteID = @SiteID)
BEGIN
	SELECT @SiteID = 2
END
Select TOP 1 g.Subject, g.text FROM GuideEntries g
	INNER JOIN keyarticles k ON k.EntryID = g.EntryID
	WHERE k.ArticleName = @emailname
		AND k.DateActive <= getdate() AND k.SiteID = @SiteID
	ORDER BY k.DateActive DESC