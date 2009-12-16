CREATE PROCEDURE updateusersunreadprivatemessagecount @userid int = NULL
AS
	IF @userid IS NOT NULL
	BEGIN
		--Calculate Unread count for specified user only.
		UPDATE Users
	   	SET UnreadPrivateMessageCount = (SELECT CASE WHEN SUM(tp.CountPosts - tp.LastPostCountRead) IS NULL THEN 0 ELSE SUM(tp.CountPosts - tp.LastPostCountRead) END
									      FROM ThreadPostings tp
									           INNER JOIN Forums f ON tp.ForumID = f.ForumID
									           INNER JOIN Teams tm ON f.ForumID = tm.ForumID
									           INNER JOIN UserTeams privateforum ON tm.TeamID = privateforum.TeamID
									     WHERE tp.UserID = u.UserID
									       AND tp.CountPosts > tp.LastPostCountRead)
	 	FROM Users u
	 	WHERE u.UserID = @userid
	END
	ELSE
	BEGIN
		BEGIN TRANSACTION

		--Reset the unread count for all users.
		UPDATE USERS  SET UnreadPrivateMessageCount = 0
		WHERE UnreadPrivateMessageCount > 0 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
		

		--Set Count for users that have entries in their private forum.
		UPDATE Users
	   	SET UnreadPrivateMessageCount = privatecount.pcount
		FROM Users u, 
		(SELECT tp.UserId, CASE WHEN SUM(tp.CountPosts - tp.LastPostCountRead) IS NULL THEN 0 ELSE SUM(tp.CountPosts - tp.LastPostCountRead) END 'pcount'
									      FROM ThreadPostings tp
									           INNER JOIN Forums f ON tp.ForumID = f.ForumID
									           INNER JOIN Teams tm ON f.ForumID = tm.ForumID
									           INNER JOIN UserTeams privateforum ON tm.TeamID = privateforum.TeamID
										   WHERE tp.CountPosts > tp.LastPostCountRead AND tp.UserId = privateforum.userid
										   GROUP BY tp.UserId ) AS privatecount
		WHERE privatecount.userid = u.UserID

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END

		COMMIT TRANSACTION
	END

RETURN @@ERROR