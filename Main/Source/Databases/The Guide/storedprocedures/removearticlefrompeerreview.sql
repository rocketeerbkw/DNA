Create Procedure removearticlefrompeerreview @h2g2id int
As

declare @success int
set @success = 0

declare @checkid int
select @checkid = H2G2ID from reviewforummembers r where r.h2g2id = @h2g2id
if (@checkid is not NULL)
BEGIN 
	Delete reviewforummembers where h2g2id = @h2g2id
	set @success = 1 
END
ELSE
BEGIN
	set @success = 0 
END

Select 'Success' = @success

return (0)