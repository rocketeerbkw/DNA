CREATE PROCEDURE getboardpromoelementlocations @boardpromoelementid int
AS
BEGIN
	SELECT te.TopicID, te.DefaultBoardPromoID FROM dbo.Topics te WITH(NOLOCK)
	WHERE te.BoardPromoID = @boardpromoelementid OR te.DefaultBoardPromoID = @boardpromoelementid
END