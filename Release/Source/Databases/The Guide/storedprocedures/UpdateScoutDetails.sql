/*
	Updates a users current scout details, or inserts some if there are none currently.
	Note that the user does not have to be a member of the scouts group - requiring this
	could cause problems when users were added and removed from the group.
*/

create procedure updatescoutdetails @userid int, @quota int, @interval varchar(50)
as

BEGIN TRANSACTION
DECLARE @ErrorCode INT, @rowcount int

-- first try to update existing record if there is one
update ScoutDetails set Quota = @quota, Interval = @interval
	where ScoutID = @userid
SELECT @ErrorCode = @@ERROR, @rowcount = @@ROWCOUNT
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- if this affected zero rows then there is no record for this user yet
-- so insert one
if (@rowcount = 0)
begin
	insert into ScoutDetails (ScoutID, Quota, Interval)
		values (@userid, @quota, @interval)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
end

COMMIT TRANSACTION

return (0)
