CREATE PROCEDURE contentsignifgettypedecrementforsite 
@siteid int, 
@typename varchar(50),
@decrement int OUTPUT
AS

Declare @ErrorCode int

Select @decrement = cstd.Decrement from dbo.ContentSignifTypeDecrement cstd
JOIN dbo.ContentSignifType cst on cstd.TypeID = cst.Type
Where cst.TypeName = @typename and cstd.SiteID = @siteid

SELECT @ErrorCode=@@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
