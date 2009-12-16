/*
	Updates a users current sub details, or inserts some if there are none currently.
	Note that the user does not have to be a member of the subs group - requiring this
	could cause problems when users were added and removed from the group.
*/

create procedure updatesubdetails @userid int, @quota int
as
-- first try to update existing record if there is one
update SubDetails set Quota = @quota
where SubEditorID = @userid
-- if this affected zero rows then there is no record for this user yet
-- so insert one
if (@@rowcount = 0)
begin
	insert into SubDetails (SubEditorID, Quota)
	values (@userid, @quota)
end
return (0)
