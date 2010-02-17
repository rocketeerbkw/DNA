BEGIN TRANSACTION

	CREATE TABLE ProlificScribeGroupUpdates(	UserID int NOT NULL, 
							Count int,
							OldGroupID int,
							NewGroupID int,
							RefreshGroups int)


	DECLARE SoloGuideEntryUserList_Cursor CURSOR FAST_FORWARD FOR
	SELECT ROW_NUMBER() OVER (ORDER BY count(s.entryid) DESC) AS Row, s.userid, count(s.entryid) 'Count'
	FROM
		(SELECT r.entryid,r.userid 
		FROM researchers r 
		INNER JOIN guideentries g on g.entryid=r.entryid and g.siteid=1 and g.type=1 and g.status=1 
		INNER JOIN researchers r2 on r2.entryid=r.entryid 
		WHERE r.userid <> g.editor 
		GROUP BY r.entryid,r.userid 
		HAVING count(*) <= 2) s 
	GROUP BY s.userid
	ORDER BY 'Count' Desc	

	DECLARE @Row int
	DECLARE @UserID int
	DECLARE @Count int 

	OPEN SoloGuideEntryUserList_Cursor 

	FETCH NEXT FROM SoloGuideEntryUserList_Cursor 
	INTO @Row, @UserID, @Count

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @oldgroupid int
		DECLARE @newgroupid int 
		DECLARE @refreshgroups int 
		
		exec updateprolificscribegroup @UserID, @Count, @oldgroupid OUTPUT, @newgroupid OUTPUT, @refreshgroups OUTPUT
		print 'User ID=' +  CAST (@UserID AS VARCHAR(10)) + '- Count=' + CAST (@Count AS VARCHAR(10)) + '-Old=' + CAST (@oldgroupid AS VARCHAR(10)) + '-New=' + CAST (@newgroupid AS VARCHAR(10)) + '-Refresh=' + CAST (@refreshgroups AS VARCHAR(10)) 

		INSERT INTO ProlificScribeGroupUpdates VALUES (@UserID, @Count, @oldgroupid, @newgroupid, @refreshgroups)

		FETCH NEXT FROM SoloGuideEntryUserList_Cursor 
		INTO @Row, @UserID, @Count
	END
	CLOSE SoloGuideEntryUserList_Cursor 
	DEALLOCATE SoloGuideEntryUserList_Cursor 


COMMIT TRANSACTION