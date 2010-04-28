CREATE FUNCTION udf_isusermemberofgroup ( @userid int, @siteid int, @groupname varchar(50))
RETURNS INT
AS
BEGIN
	IF EXISTS(
		SELECT     
			*
		FROM  dbo.Groups g 
		INNER JOIN dbo.GroupMembers gm ON g.GroupID = gm.GroupID
		WHERE  g.Name = @groupname AND gm.siteid = @siteid AND gm.UserID = @userid) 
	BEGIN
		RETURN 1
	END

	RETURN 0
END