Create Procedure freshestconversations @siteid int, @show int = 10000, @skip int =0
As

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

set @show = @show + 1 -- add one

	;WITH threadsconvo AS
	(
		SELECT t.ThreadID, ROW_NUMBER() OVER(ORDER BY t.LastPosted DESC) n
		FROM Threads t
		WHERE t.SiteID = @siteid AND t.VisibleTo IS NULL AND t.CanRead = 1
	)
	SELECT t.ThreadID, t.Forumid,
		'FirstSubject' = 
			CASE 
				WHEN t.FirstSubject IS NULL OR t.FirstSubject = '' 
					THEN 'No subject' 
					ELSE t.FirstSubject 
				END, 
			t.LastPosted
	FROM threadsconvo TC
	inner join Threads t on TC.ThreadID = t.ThreadID
	WHERE n > @skip AND n <=(@skip+@show)

return (0)