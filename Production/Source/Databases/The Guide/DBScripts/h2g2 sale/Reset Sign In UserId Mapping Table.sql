truncate table dbo.SignInUserIDMapping

SET IDENTITY_INSERT dbo.SignInUserIDMapping ON

insert dbo.SignInUserIDMapping (DnaUserId,SSOUserId,IdentityUserID)
select userid,null,userid from dbo.users

SET IDENTITY_INSERT dbo.SignInUserIDMapping OFF

declare @max int
select @max = max(userid)+1 from users
DBCC CHECKIDENT ('SignInUserIDMapping', RESEED,@max);
DBCC CHECKIDENT ('SignInUserIDMapping', NORESEED); -- check

select * from dbo.SignInUserIDMapping
