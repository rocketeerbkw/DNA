Create Procedure nextnewflashmovie @userid int
As
SELECT TOP 1 URL, Description, f.MovieID, ResearcherName, Date FROM FlashMovies f WHERE NOT EXISTS (SELECT * FROM ViewedMovies v WHERE v.UserID = @userid AND v.MovieID = f.MovieID) AND f.Active = 1 ORDER BY Date
	return (0)