CREATE PROCEDURE settopfiveforumlist	@siteid int,
										@groupname varchar(255),
										@groupdescription varchar(255),
										@h2g2id1 int = NULL, @threadid1 int = NULL,
										@h2g2id2 int = NULL, @threadid2 int = NULL,
										@h2g2id3 int = NULL, @threadid3 int = NULL,
										@h2g2id4 int = NULL, @threadid4 int = NULL,
										@h2g2id5 int = NULL, @threadid5 int = NULL,
										@h2g2id6 int = NULL, @threadid6 int = NULL,
										@h2g2id7 int = NULL, @threadid7 int = NULL,
										@h2g2id8 int = NULL, @threadid8 int = NULL,
										@h2g2id9 int = NULL, @threadid9 int = NULL,
										@h2g2id10 int = NULL, @threadid10 int = NULL,
										@h2g2id11 int = NULL, @threadid11 int = NULL,
										@h2g2id12 int = NULL, @threadid12 int = NULL,
										@h2g2id13 int = NULL, @threadid13 int = NULL,
										@h2g2id14 int = NULL, @threadid14 int = NULL,
										@h2g2id15 int = NULL, @threadid15 int = NULL,
										@h2g2id16 int = NULL, @threadid16 int = NULL,
										@h2g2id17 int = NULL, @threadid17 int = NULL,
										@h2g2id18 int = NULL, @threadid18 int = NULL,
										@h2g2id19 int = NULL, @threadid19 int = NULL,
										@h2g2id20 int = NULL, @threadid20 int = NULL
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

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id1, CASE WHEN @threadid1 = 0 THEN NULL ELSE @threadid1 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id2, CASE WHEN @threadid2 = 0 THEN NULL ELSE @threadid2 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id3, CASE WHEN @threadid3 = 0 THEN NULL ELSE @threadid3 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id4, CASE WHEN @threadid4 = 0 THEN NULL ELSE @threadid4 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id5, CASE WHEN @threadid5 = 0 THEN NULL ELSE @threadid5 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id6, CASE WHEN @threadid6 = 0 THEN NULL ELSE @threadid6 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id7, CASE WHEN @threadid7 = 0 THEN NULL ELSE @threadid7 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id8, CASE WHEN @threadid8 = 0 THEN NULL ELSE @threadid8 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id9, CASE WHEN @threadid9 = 0 THEN NULL ELSE @threadid9 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id10, CASE WHEN @threadid10 = 0 THEN NULL ELSE @threadid10 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id11, CASE WHEN @threadid11 = 0 THEN NULL ELSE @threadid11 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id12, CASE WHEN @threadid12 = 0 THEN NULL ELSE @threadid12 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id13, CASE WHEN @threadid13 = 0 THEN NULL ELSE @threadid13 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id14, CASE WHEN @threadid14 = 0 THEN NULL ELSE @threadid14 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id15, CASE WHEN @threadid15 = 0 THEN NULL ELSE @threadid15 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id16, CASE WHEN @threadid16 = 0 THEN NULL ELSE @threadid16 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id17, CASE WHEN @threadid17 = 0 THEN NULL ELSE @threadid17 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id18, CASE WHEN @threadid18 = 0 THEN NULL ELSE @threadid18 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id19, CASE WHEN @threadid19 = 0 THEN NULL ELSE @threadid19 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID)
	VALUES(@groupname, @groupdescription, @siteid, @h2g2id20, CASE WHEN @threadid20 = 0 THEN NULL ELSE @threadid20 END)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

DELETE FROM TopFives WHERE SiteID = @siteid AND GroupName = @groupname AND ForumID IS NULL
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
