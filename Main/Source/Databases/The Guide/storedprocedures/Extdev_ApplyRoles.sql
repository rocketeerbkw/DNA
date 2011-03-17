
CREATE Procedure extdev_applyroles @prefix varchar(10)= 'test'
As

--add editor to all sites
declare @editorId int
select @editorId = userid from users where loginname= @prefix+'_editor'
print @prefix+'_editor:' +  cast(@editorId as varchar(10))
declare @editorgroup int
select @editorgroup = GroupID FROM Groups WHERE Name = 'Editor'
if @editorgroup is null or @editorId is null
BEGIN
	RAISERROR('Missing editor id',16,1);
END
ELSE
BEGIN
	delete from groupmembers where userid=@editorId
	insert into groupmembers
	select @editorId, @editorgroup, siteid
	from sites
END

--add moderator to all sites
declare @modId int
select @modId = userid from users where loginname= @prefix+'_moderator'
print @prefix+'_moderator:' +  cast(@modId as varchar(10))
declare @moderatorgroup int
select @moderatorgroup = GroupID FROM Groups WHERE Name = 'Moderator'
if @modId is null or @moderatorgroup is null
BEGIN
	RAISERROR('Missing moderate id',16,1);
END
ELSE
BEGIN
	delete from groupmembers where userid=@modId
	insert into groupmembers
	select @modId, @moderatorgroup, siteid
	from sites
END

--add superuser to all sites
declare @superId int
select @superId = userid from users where loginname= @prefix+'_superuser'
print @prefix+'_superuser:' +  cast(@superId as varchar(10))
if @superId is null 
BEGIN
	RAISERROR('Missing superuser id',16,1);
END
ELSE
BEGIN
	update users 
	set status=2
	where userid= @superId
END


--add normal to all sites
declare @normalId int
select @normalId = userid from users where loginname= @prefix+'_normal'
print @prefix+'_normal:' +  cast(@normalId as varchar(10))
if @normalId is null 
BEGIN
	RAISERROR('Missing @normalId',16,1);
END
ELSE
BEGIN
	update users 
	set status=1
	where userid= @normalId
END

--add notable to all sites
declare @noteId int
select @noteId = userid from users where loginname= @prefix+'_notable'
print @prefix+'_notable:' +  cast(@noteId as varchar(10))
declare @notablegroup int
select @notablegroup = GroupID FROM Groups WHERE Name = 'Notables'
if @noteId is null or @notablegroup is null
BEGIN
	RAISERROR('Missing notable id',16,1);
END
ELSE
BEGIN
	delete from groupmembers where userid=@noteId
	insert into groupmembers
	select @noteId, @notablegroup, siteid
	from sites
END

--add deactivated to all sites
declare @deactivatedId int
select @deactivatedId = userid from users where loginname= @prefix+'_deactivated'
print @prefix+'_deactivated:' +  cast(@deactivatedId as varchar(10))
if @deactivatedId is null 
BEGIN
	RAISERROR('Missing @deactivatedId',16,1);
END
ELSE
BEGIN
	update users 
	set status=0
	where userid= @deactivatedId
END

--add banned to all sites
declare @banned int
select @banned = userid from users where loginname= @prefix+'_banned'
print @prefix+'_banned:' +  cast(@banned as varchar(10))
if @banned is null 
BEGIN
	RAISERROR('Missing @banned',16,1);
END
ELSE
BEGIN
	delete from preferences where userid=@banned
	insert into preferences
	(Userid, siteid, agreedterms, prefstatus)
	select @banned, siteid, 1, 4
	from sites
END

--add premod to all sites
declare @premod int
select @premod = userid from users where loginname= @prefix+'_premod'
print @prefix+'_premod:' +  cast(@premod as varchar(10))
if @premod is null 
BEGIN
	RAISERROR('Missing @premod',16,1);
END
ELSE
BEGIN
	delete from preferences where userid=@premod
	insert into preferences
	(Userid, siteid, agreedterms, prefstatus)
	select @premod, siteid, 1, 1
	from sites
END

--add premod to all sites
declare @postmod int
select @postmod = userid from users where loginname= @prefix+'_postmod'
print @prefix+'_postmod:' +  cast(@postmod as varchar(10))
if @postmod is null 
BEGIN
	RAISERROR('Missing @postmod',16,1);
END
ELSE
BEGIN
	delete from preferences where userid=@postmod
	insert into preferences
	(Userid, siteid, agreedterms, prefstatus)
	select @postmod, siteid, 1, 2
	from sites
END