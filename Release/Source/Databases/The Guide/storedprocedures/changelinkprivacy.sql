create procedure changelinkprivacy @linkid int, @private int
as
UPDATE Links SET Private = @private WHERE LinkID = @linkid