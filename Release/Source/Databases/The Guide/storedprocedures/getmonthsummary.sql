CREATE PROCEDURE getmonthsummary @siteid int = 1
AS
	
	SELECT DateCreated, Subject, h2g2ID , Type
	FROM GuideEntries 
	WHERE DateCreated>= DATEADD(month,-1,getdate()) 
		AND status = 1 
		AND DateCreated < getdate() 
		AND SiteID = @siteid
		ORDER BY DateCreated DESC
	return (0)
