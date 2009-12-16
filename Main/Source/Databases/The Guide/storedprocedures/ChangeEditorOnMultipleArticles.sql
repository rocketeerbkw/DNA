CREATE PROCEDURE changeeditoronmultiplearticles
	@neweditorid int,
	@id0 int = null,
	@id1 int = null,
	@id2 int = null,
	@id3 int = null,
	@id4 int = null,
	@id5 int = null,
	@id6 int = null,
	@id7 int = null,
	@id8 int = null,
	@id9 int = null,
	@id10 int = null,
	@id11 int = null,
	@id12 int = null,
	@id13 int = null,
	@id14 int = null,
	@id15 int = null,
	@id16 int = null,
	@id17 int = null,
	@id18 int = null,
	@id19 int = null,
	@id20 int = null,
	@id21 int = null,
	@id22 int = null,
	@id23 int = null,
	@id24 int = null,
	@id25 int = null,
	@id26 int = null,
	@id27 int = null,
	@id28 int = null,
	@id29 int = null,
	@id30 int = null,
	@id31 int = null,
	@id32 int = null,
	@id33 int = null,
	@id34 int = null,
	@id35 int = null,
	@id36 int = null,
	@id37 int = null,
	@id38 int = null,
	@id39 int = null,
	@id40 int = null,
	@id41 int = null,
	@id42 int = null,
	@id43 int = null,
	@id44 int = null,
	@id45 int = null,
	@id46 int = null,
	@id47 int = null,
	@id48 int = null,
	@id49 int = null
AS

DECLARE @ErrorCode INT

-- update editor on selected articles
update GuideEntries
set Editor = @neweditorid
where EntryID IN (@id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
				  @id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
				  @id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
				  @id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
				  @id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49)

SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
	RETURN @ErrorCode


-- delete all old editing permissions
DELETE GuideEntryPermissions 
FROM GuideEntryPermissions gep WITH(INDEX=IX_GuideEntryPermissions)
	INNER JOIN GuideEntries g ON gep.h2g2ID=g.h2g2ID
WHERE g.EntryID IN (@id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
					@id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
					@id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
					@id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
					@id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49)

SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
	RETURN @ErrorCode

-- Add new editor to the permissions table
INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, Priority, CanRead, CanWrite, CanChangePermissions) 
	SELECT g.h2g2ID, ut.TeamID, 1, 1, 1, 1 
	FROM Users u, GuideEntries g, UserTeams ut
	WHERE u.UserId = @neweditorid 
		AND g.EntryID IN (@id0, @id1, @id2, @id3, @id4, @id5, @id6, @id7, @id8, @id9,
						  @id10,@id11,@id12,@id13,@id14,@id15,@id16,@id17,@id18,@id19,
						  @id20,@id21,@id22,@id23,@id24,@id25,@id26,@id27,@id28,@id29,
						  @id30,@id31,@id32,@id33,@id34,@id35,@id36,@id37,@id38,@id39,
						  @id40,@id41,@id42,@id43,@id44,@id45,@id46,@id47,@id48,@id49)
		AND ut.UserID = u.UserID AND ut.SiteID = g.SiteID

SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
	RETURN @ErrorCode

-- all's well
RETURN 0