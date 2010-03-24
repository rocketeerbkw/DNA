Create Procedure viewedflashmovies @userid int
As
SELECT URL, Description, 'MovieID' = f.MovieID, DateViewed, Date, ResearcherName FROM FlashMovies f INNER JOIN ViewedMovies v ON v.MovieID = f.MovieID
WHERE v.UserID = @userid
ORDER BY f.Date
	return (0)