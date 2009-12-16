/*
Adds a new node to the hierarchy and updates the ancestry to refelct the changes
*/

CREATE PROCEDURE addnodetohierarchyinternal @parentid int, @displayname varchar(255), @siteid int, @nodeid int OUTPUT
As

--declare @existingdisplayname varchar(255)

--SELECT @existingdisplayname = DisplayName From hierarchy h where h.DisplayName = @displayname and h.SiteID = @siteid

declare @guidetypeid	int
SELECT @guidetypeid = Id FROM GuideEntryTypes where Name = 'categorypage'


-- The internal version will allow a new node with no parent for createnewsite

	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	declare @parenttreelevel int, @newnode int
	SELECT @parenttreelevel = TreeLevel FROM hierarchy h WITH(UPDLOCK) WHERE h.nodeid = @parentid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT @nodeid = NULL
		RETURN @ErrorCode
	END

	IF @parenttreelevel IS NULL
	BEGIN
		select @parenttreelevel = -1
	END
	declare @entryid int,@datecreated datetime, @forum int,@h2g2id int, @FoundDuplicate tinyint
	EXEC @ErrorCode = createguideentryinternal @displayname,  
	'<GUIDE>
<BODY>
</BODY>
</GUIDE>' , '<EXTRAINFO><TYPE ID="4001" NAME="category"/></EXTRAINFO>',6,1,3,NULL,NULL,@siteid,0, @guidetypeid, 
		@entryid OUTPUT,@datecreated OUTPUT, @forum OUTPUT,@h2g2id OUTPUT, @FoundDuplicate OUTPUT
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT @nodeid = NULL
		RETURN @ErrorCode
	END
	
	declare @typeid int
	-- get the parent type use it for setting the new node type
	SELECT @typeid = Type from Hierarchy where NodeID = @parentid
	IF (@typeid IS NULL)
	BEGIN
		select @typeid = 1
	END
	
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT @nodeid = NULL
		RETURN @ErrorCode
	END
		
	INSERT INTO hierarchy (ParentId,DisplayName,TreeLevel,SiteId, h2g2ID, NodeMembers, NodeAliasMembers, ArticleMembers, ClubMembers, Type)
		VALUES(@parentid, @displayname, @parenttreelevel+1, @siteid, @h2g2id, 0,0,0,0, @typeid)  
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT @nodeid = NULL
		RETURN @ErrorCode
	END

	SELECT @newnode = @@IDENTITY

	IF @parentid IS NOT NULL
	BEGIN
		INSERT INTO ancestors (NodeID,AncestorId,TreeLevel) SELECT @newnode,AncestorId,TreeLevel FROM ancestors a WHERE a.nodeid = @parentid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT @nodeid = NULL
			RETURN @ErrorCode
		END

		INSERT INTO ancestors (NodeID,AncestorId,TreeLevel) VALUES(@newnode,@parentId,@parenttreelevel)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT @nodeid = NULL
			RETURN @ErrorCode
		END
	
		declare @nodemembers int
		SELECT @nodemembers = NodeMembers FROM hierarchy h WITH(UPDLOCK) WHERE h.nodeid=@parentid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT @nodeid = NULL
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
			SELECT @nodeid = NULL
			RETURN @ErrorCode
		END
	END
	COMMIT TRANSACTION
		
	SELECT @nodeid = @newnode

return(0)

