CREATE PROCEDURE ratingforumreadbyuid @uid varchar(255), @siteid int
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	select  uid as uid, 
			sitename,
			title, 
			forumpostcount, 
			moderationstatus, 
			datecreated,  
			lastupdated, 
			url, 
			isnull(forumclosedate, getdate()) as forumclosedate, 
			0 as totalresults, 
			0 as startindex, 
			0 as itemsperpage,  
			siteId, 
			forumId, 
			canRead, 
			canWrite, 
			lastposted, 
			average
			, editorpickcount
			, NotSignedInUserId
	from dbo.VRatingForums 
	where uid = @uid
	and siteid = @siteid
