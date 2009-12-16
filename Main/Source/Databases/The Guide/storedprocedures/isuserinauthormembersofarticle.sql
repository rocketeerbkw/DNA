CREATE  PROCEDURE isuserinauthormembersofarticle @userid INT, @h2g2id INT = null, @forumid INT = null
AS
	IF @forumid IS NOT NULL
	BEGIN
		SELECT h2g2id FROM GuideEntries
		WHERE forumid = @forumid AND editor = @userid
	END
	ELSE
	BEGIN
		SELECT h2g2id FROM GuideEntries WHERE h2g2ID = @h2g2id AND editor = @userid
	END

