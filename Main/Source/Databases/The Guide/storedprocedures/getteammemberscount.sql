CREATE  PROCEDURE getteammemberscount @iteamid int, @iinlastnoofdays int = 0
AS
BEGIN
DECLARE @Totalmembers int
DECLARE @NewMembers int
SELECT @TotalMembers = COUNT(*) From TeamMembers WHERE TeamID = @iteamid 
SELECT @NewMembers = COUNT(*) From TeamMembers WHERE TeamID = @iteamid AND (DateJoined > getdate() - @iinlastnoofdays)
SELECT 'TotalMembers' = @TotalMembers, 'NewMembers' = @NewMembers
END
