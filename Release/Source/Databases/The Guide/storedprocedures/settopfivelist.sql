CREATE PROCEDURE settopfivelist	@siteid int,
									@groupname varchar(255),
									@groupdescription varchar(255),
									@h2g2id1 int = NULL,
									@h2g2id2 int = NULL,
									@h2g2id3 int = NULL,
									@h2g2id4 int = NULL,
									@h2g2id5 int = NULL,
									@h2g2id6 int = NULL,
									@h2g2id7 int = NULL,
									@h2g2id8 int = NULL,
									@h2g2id9 int = NULL,
									@h2g2id10 int = NULL,
									@h2g2id11 int = NULL,
									@h2g2id12 int = NULL,
									@h2g2id13 int = NULL,
									@h2g2id14 int = NULL,
									@h2g2id15 int = NULL,
									@h2g2id16 int = NULL,
									@h2g2id17 int = NULL,
									@h2g2id18 int = NULL,
									@h2g2id19 int = NULL,
									@h2g2id20 int = NULL
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

DELETE FROM TopFives WHERE SiteID = @siteid AND GroupName = @groupname
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id1)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id2)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id3)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id4)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id5)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id6)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id7)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id8)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id9)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id10)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id11)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id12)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id13)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id14)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id15)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id16)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id17)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id18)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id19)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, h2g2ID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id20)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

DELETE FROM TopFives WHERE SiteID = @siteid AND GroupName = @groupname AND h2g2ID IS NULL
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
