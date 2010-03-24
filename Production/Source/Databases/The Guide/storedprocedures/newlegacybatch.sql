CREATE PROCEDURE newlegacybatch
As
SET IDENTITY_INSERT ThreadMod ON

INSERT INTO ThreadMod (
	ModID,
	ForumID,
	ThreadID,
	PostID,
	DateQueued,
	DateLocked,
	LockedBy,
	NewPost,
	Status,
	Notes,
	DateReferred,
	DateCompleted,
	ReferredBy,
	ComplainantID,
	CorrespondenceEmail,
	ComplaintText, 
	SiteID)
	SELECT TOP 2000 ModID,
		ForumID,
		ThreadID,
		PostID,
		DateQueued,
		DateLocked,
		LockedBy,
		NewPost,
		Status,
		Notes,
		DateReferred,
		DateCompleted,
		ReferredBy,
		ComplainantID,
		CorrespondenceEmail,
		ComplaintText,
		1 
	FROM ThreadModOld WHERE Status = 0 ORDER BY ModID

SET IDENTITY_INSERT ThreadMod OFF

DELETE FROM ThreadModOld WHERE ModID IN 
	(SELECT TOP 2000 ModID FROM ThreadModOld WHERE Status = 0 ORDER BY ModID)

