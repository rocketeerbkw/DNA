CREATE PROCEDURE blobgetspecificbgcolours @blobid int

AS

/* Return a list of all specific background colours that this blob supports */

SELECT c.name as Name
FROM SkinColours c LEFT JOIN
    blobs b ON (c.bitfield & b.colourbits)!=0
WHERE blobid = @blobid
