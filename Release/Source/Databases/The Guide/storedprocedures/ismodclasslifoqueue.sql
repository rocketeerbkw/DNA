CREATE PROCEDURE ismodclasslifoqueue @modclassid INT
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

	SELECT LIFOQueue FROM ModerationClass WHERE ModClassID = @modclassid