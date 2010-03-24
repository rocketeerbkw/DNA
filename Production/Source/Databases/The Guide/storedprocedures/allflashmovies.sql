Create Procedure allflashmovies
As
	SELECT URL, Description, MovieID, ResearcherName, Date FROM FlashMovies  WHERE Active = 1 ORDER BY Date
	return (0)