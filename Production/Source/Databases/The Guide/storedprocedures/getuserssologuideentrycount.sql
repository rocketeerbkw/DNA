CREATE PROCEDURE getuserssologuideentrycount @userid int, @count int OUTPUT
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT @count = COUNT(*)
		FROM
			(SELECT r.entryid,r.userid 
				FROM researchers r 
				INNER JOIN guideentries g ON g.entryid=r.entryid AND g.siteid=1 AND g.type=1 AND g.status=1 
				INNER JOIN researchers r2 ON r2.entryid=r.entryid 
				WHERE r.userid = @userid AND g.editor <> @userid
				GROUP BY r.entryid, r.userid 
				HAVING count(*) <= 2 ) s
				 
