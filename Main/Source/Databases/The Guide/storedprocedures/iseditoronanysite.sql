create procedure iseditoronanysite @userid int
as
begin
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	IF EXISTS ( SELECT * FROM dbo.Users WHERE UserID = @UserID AND Status = 2 )
	BEGIN
		SELECT count = 1
		RETURN
	END
	select count(*) as 'count' from groupmembers where groupid = (select groupid from Groups where Name = 'EDITOR')
	and userid = @userid
end