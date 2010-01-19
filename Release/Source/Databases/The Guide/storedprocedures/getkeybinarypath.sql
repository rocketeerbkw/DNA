CREATE Procedure getkeybinarypath @blobname varchar(50),
                                     @bgcolour varchar(50) = NULL

As

/* Search the "SkinColours" table for a colour name like the one requested,
  returning a bitfield value in the range 0 - 2^31 */

Declare @bitfield int

If NOT (@bgcolour IS NULL)
Begin
Select @bitfield = bitfield From SkinColours Where Name = @bgcolour
End

/* Find the blobid requested. If it's got the requested colour bit set,
   then stuff the colour name into the path after the first '\',
   e.g. blobs\128 -> blobs\white\128. 
   If there isn't a slash, then the path is returned unmodified,
   e.g. blobs128 -> blobs128					  */

Select Top 1 b.blobid, b.mimetype, b.ServerName,
   'Path' = Case
          When (b.Colourbits & @bitfield) = @bitfield AND
(Charindex('\',b.Path)>0)
Then Stuff(b.Path, Charindex('\',b.Path) ,1 ,'\'+@bgcolour+'\')
          Else b.Path
        End
From blobs b Inner Join KeyBlobs k On k.blobid = b.blobid
Where k.blobname = @blobname AND k.DateActive <= Getdate()
Order By DateActive Desc



