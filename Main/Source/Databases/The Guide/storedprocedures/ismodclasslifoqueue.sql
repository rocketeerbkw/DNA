CREATE PROCEDURE ismodclasslifoqueue @modclassid INT
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

	SELECT case when ItemRetrievalType=1 then 1 else 0 end as LIFOQueue 
	FROM ModerationClass WHERE ModClassID = @modclassid