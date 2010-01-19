CREATE PROCEDURE getbinarypath  @blobid int,
                                   @bgcolour varchar(50) = NULL

AS

/* Search the "SkinColours" table for a colour name like the one requested,
  returning a bitfield value in the range 0 - 2^31 */

DECLARE @bitfield int

IF NOT (@bgcolour IS NULL)
BEGIN
SELECT @bitfield = bitfield FROM SkinColours WHERE Name = @bgcolour
END

/* Find the blobid requested. If it's got the requested colour bit set,
   then stuff the colour name into the path after the first '\',
   e.g. blobs\128 -> blobs\white\128. 
   If there isn't a slash, then the path is returned unmodified,
   e.g. blobs128 -> blobs128					  */

SELECT blobid, mimetype, ServerName,
   'Path' = CASE 
	  WHEN (Colourbits & @bitfield) = @bitfield AND (CHARINDEX('\',Path)>0) THEN STUFF(Path, CHARINDEX('\',Path) ,1 ,'\'+@bgcolour+'\')
   	  ELSE Path
	END
FROM blobs 
WHERE blobid = @blobid

