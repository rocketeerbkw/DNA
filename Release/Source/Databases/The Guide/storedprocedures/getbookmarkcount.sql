/*********************************************************************************

	CREATE PROCEDURE getbookmarkcount	@h2g2id int AS
	Author:		Steven Francis
	Created:	11/12/2007
	Inputs:		h2g2ID - the article id
	Outputs:	
	Returns:	Bookmark Count
	Purpose:	Gets the link count for a given article (h2g2id)
*********************************************************************************/
CREATE PROCEDURE getbookmarkcount @h2g2id int
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @ErrorCode INT
	DECLARE @EntryID INT

	SELECT COUNT(*) AS 'BookmarkCount' 
	FROM dbo.Links l WITH (NOLOCK)
	WHERE l.DestinationID = @h2g2id 
	IF (@ErrorCode <> 0)
	BEGIN
		RETURN @ErrorCode
	END
	
