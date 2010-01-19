Create Procedure fetchpersonalspaceforum @userid int, @siteid int
As
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

Select g.ForumID 
	from Mastheads m
		inner join guideentries g on m.EntryID = g.EntryID 
		where m.userid=@userid AND m.SiteID = @siteid

return(0)