CREATE PROCEDURE getmoderatingclassbyuser @userid int
as

DECLARE @groupid INT
SELECT @groupid = groupid FROM Groups WHERE name = 'editor'

declare @issuperuser bit
select @issuperuser =1 from users where userid=@userid and status=2

select ModClassID
from ModerationClassMembers cm 
where groupid = @groupid and (@issuperuser =1 or UserID = @userid )

