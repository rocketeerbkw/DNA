/*
Adds a new node to the hierarchy and updates the ancestry to refelct the changes
*/

CREATE PROCEDURE addnodetohierarchy @parentid int, @displayname varchar(255), @siteid int
As

--declare @existingdisplayname varchar(255)

--SELECT @existingdisplayname = DisplayName From hierarchy h where h.DisplayName = @displayname and h.SiteID = @siteid

DECLARE @ReturnCode int, @nodeid int
declare @parentidexists int
SELECT @parentidexists = NodeID From hierarchy h where h.NodeID = @parentid

IF (@parentidexists IS NOT NULL)
BEGIN
EXEC @ReturnCode = addnodetohierarchyinternal @parentid, @displayname, @siteid, @nodeid OUTPUT
SELECT 'NewNode' = @nodeid
END
ELSE
BEGIN
	select 'NewNode' = NULL
END
RETURN @ReturnCode

/*
declare @parentidexists int
declare @guidetypeid	int
SELECT @guidetypeid = Id FROM GuideEntryTypes where Name = 'categorypage'


SELECT @parentidexists = NodeID From hierarchy h where h.NodeID = @parentid

IF ( @parentidexists IS NOT NULL)
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	declare @parenttreelevel int, @newnode int
	SELECT @parenttreelevel = TreeLevel FROM hierarchy h WITH(UPDLOCK) WHERE h.nodeid = @parentid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'NewNode' = NULL
		RETURN @ErrorCode
	END

	declare @entryid int, @datecreated datetime, @forum int,@h2g2id int
	EXEC @ErrorCode = createguideentryinternal @displayname,  
	'<GUIDE>
<BODY>
</BODY>
</GUIDE>' , '<EXTRAINFO><TYPE ID="4001" NAME="category"/></EXTRAINFO>',6,1,3,NULL,NULL,@siteid,0, @guidetypeid, 
		@entryid OUTPUT, @datecreated OUTPUT, @forum OUTPUT,@h2g2id OUTPUT
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'NewNode' = NULL
		RETURN @ErrorCode
	END
	
	INSERT INTO hierarchy (ParentId,DisplayName,TreeLevel,SiteId, h2g2ID, LastUpdated)
		VALUES(@parentid, @displayname, @parenttreelevel+1, @siteid, @h2g2id, getDate())  
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'NewNode' = NULL
		RETURN @ErrorCode
	END

	SELECT @newnode = @@IDENTITY

	INSERT INTO ancestors (NodeID,AncestorId,TreeLevel) SELECT @newnode,AncestorId,TreeLevel FROM ancestors a WHERE a.nodeid = @parentid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'NewNode' = NULL
		RETURN @ErrorCode
	END

	INSERT INTO ancestors (NodeID,AncestorId,TreeLevel) VALUES(@newnode,@parentId,@parenttreelevel)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'NewNode' = NULL
		RETURN @ErrorCode
	END

	declare @nodemembers int
	SELECT @nodemembers = NodeMembers FROM hierarchy h WITH(UPDLOCK) WHERE h.nodeid=@parentid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'NewNode' = NULL
		RETURN @ErrorCode
	END
	
	IF (@nodemembers IS NOT NULL)
	BEGIN
		UPDATE hierarchy 
			Set NodeMembers = 1 + (SELECT NodeMembers from Hierarchy where nodeid=@parentid) WHERE nodeid=@parentid 
	END
	ELSE
	BEGIN
		UPDATE hierarchy
			Set NodeMembers = 1 WHERE nodeid=@parentid
	END

	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'NewNode' = NULL
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION
		
	SELECT 'NewNode' = @newnode
END
ELSE
BEGIN
	SELECT 'NewNode' = NULL
END

return(0)

*/