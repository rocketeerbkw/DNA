CREATE PROCEDURE getforumeventinfo @f0 int, @f1 int = NULL, @f2 int = NULL, @f3 int = NULL, @f4 int = NULL, @f5 int = NULL, @f6 int = NULL, @f7 int = NULL, @f8 int = NULL, @f9 int = NULL,
	@f10 int = NULL, @f11 int = NULL, @f12 int = NULL, @f13 int = NULL, @f14 int = NULL, @f15 int = NULL, @f16 int = NULL, @f17 int = NULL, @f18 int = NULL, @f19 int = NULL
AS
IF (@f0 = 0)
	SELECT f.*, RunStatus = CASE WHEN GetDate() > NextRun THEN 0 ELSE 1 END, ForumOpen = t.CanWrite
	FROM ForumScheduledEvents f
	INNER JOIN Forums t ON t.ForumID = f.ForumID
	ORDER BY f.ForumID, f.DayType, f.Action
ELSE
	SELECT *, RunStatus = CASE WHEN GetDate() > NextRun THEN 0 ELSE 1 END, ForumOpen = t.CanWrite
	FROM ForumScheduledEvents f
	INNER JOIN Forums t ON t.ForumID = f.ForumID
	WHERE f.ForumID IN
	(
		@f0, @f1, @f2, @f3, @f4, @f5, @f6, @f7, @f8, @f9,
		@f10, @f11, @f12, @f13, @f14, @f15, @f16, @f17, @f18, @f19
	)
	ORDER BY f.ForumID, f.DayType, f.Action
