CREATE PROCEDURE blobdelspecificbgcolour @blobid int, @bgcolour varchar(50)
AS

/* Search the "SkinColours" table for a colour name like the one requested.
TODO: It would be nice if bgcolour is a list, to build an appopriate bitfield. */

DECLARE @bitfield int

IF NOT (@bgcolour IS NULL)
BEGIN
SELECT @bitfield = bitfield FROM SkinColours WHERE Name = @bgcolour
END

/* Find the blobid requested. Clear the requested colour bit */

IF (@bitfield IS NOT NULL)
BEGIN
UPDATE blobs SET Colourbits = (blobs.Colourbits & (~@bitfield)) WHERE blobid = @blobid
END

