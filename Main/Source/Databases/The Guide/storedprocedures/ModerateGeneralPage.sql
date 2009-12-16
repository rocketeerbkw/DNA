create procedure moderategeneralpage @modid int, @status int, @notes varchar(2000), 
										@referto int, @referredby int
as
-- if @referto is zero then this is the same as it being null
if @referto = 0 set @referto = null

declare @DateReferred datetime
declare @DateCompleted datetime
declare @DateLocked datetime

if @status = 2
begin
	select @DateReferred = getdate()
	select @DateLocked = getdate()
	select @DateCompleted = null
end
else if @status = 0
begin
	select @DateReferred = null, @DateCompleted = null
	select @DateLocked = null
end
else
begin
	select @DateLocked = null
	select @DateReferred = null
	select @DateCompleted = getdate()
end
-- make sure we don't overwrite any existing dates
update GeneralMod
set	Status = @status,
	Notes = @notes,
	DateReferred = isnull(@DateReferred, DateReferred),
	DateLocked = isnull(@DateLocked, DateLocked),
	DateCompleted = isnull(@DateCompleted, DateCompleted),
	LockedBy = case when @status = 2 then @referto else LockedBy end,
	ReferredBy = case when @status = 2 then @referredby else ReferredBy end
where ModID = @modid

return (0)
