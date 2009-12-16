CREATE PROCEDURE getimagemetadata @imageid int
AS

SELECT ImageID, UserID, Description, Mime FROM ImageLibrary WHERE ImageID = @imageid;
