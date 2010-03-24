Create Procedure catscontainingarticle @h2g2id int, @section varchar(255) = NULL
As
IF @section = '' 
	SELECT @section = NULL

SELECT c.UniqueName, c.CategoryID 
	FROM CategoryMembers m 
	INNER JOIN Category c ON c.CategoryID = m.CategoryID
	WHERE m.h2g2ID = @h2g2id AND (m.Section = @section OR (m.Section IS NULL AND @section IS NULL))
	return (0)