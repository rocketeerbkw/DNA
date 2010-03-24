create procedure movelink @linkid int, @newgroup varchar(50)
as
UPDATE Links SET Type = @newgroup WHERE LinkID = @linkid
