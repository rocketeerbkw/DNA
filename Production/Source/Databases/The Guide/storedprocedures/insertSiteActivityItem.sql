CREATE PROCEDURE insertsiteactivityitem
	@type int
    ,@activitydata xml
    ,@datetime datetime
    ,@siteid int
    ,@userid int =0 -- user to attach the event to
AS
BEGIN

insert into SiteActivityItems
(type, activitydata, datetime, siteid)
values
(@type, @activitydata, @datetime, @siteid)

declare @id int
set @id = scope_identity()

-- user event off the site event
if @userid > 0
BEGIN
	declare @score smallint
	declare @override bit
	select @score = ues.score, @override = ues.overridescore
	from dbo.sites s
	inner join dbo.ModerationClass m on m.modclassid = s.modclassid
	inner join dbo.UserEventScore ues on ues.modclassid = m.modclassid
	where s.siteid=@siteid and ues.typeid=@type
--print '@score=' + convert(varchar(50), @score)
	
	declare @maxscore smallint
	select @maxscore = maxscore 
	from dbo.userreputationthreshold urpt
	inner join sites s on s.modclassid = urpt.modclassid
	where s.siteid=@siteid
--print '@maxscore=' + convert(varchar(50), @maxscore)
	--get current score
	declare @currentscore smallint
	set @currentscore =0
	select @currentscore = isnull(accumulativescore,0)
	from dbo.UserReputationScore urs
	inner join sites s on s.modclassid = urs.modclassid
	where userid=@userid
	and s.siteid=@siteid
--print '@currentscore=' + convert(varchar(50), @currentscore)

	declare @userscore smallint
	if @override = 1
	BEGIN
		set @userscore = @score
	END
	ELSE
	BEGIN
		set @userscore = @score + @currentscore
	END
	
	if @userscore > @maxscore
	begin
		set @userscore = @maxscore
	end
--print '@userscore=' + convert(varchar(50), @userscore)
	begin tran

	update dbo.userreputationscore
	set accumulativescore  = @userscore, lastupdated=getdate()
	where userid=@userid
	and modclassid= (select modclassid from sites where siteid=@siteid)
	
	if @@rowcount =0
	BEGIN
		insert into dbo.userreputationscore --(userid, modclassid, accumulativescore)
		select @userid, modclassid, @userscore, getdate()
		from sites where 
		siteid=@siteid
	END

	
	insert into dbo.UserSiteEvents --typeid, eventdate, siteid, modclassid,siteeventid, score, accumulativescore, userid
	select @type
		, @datetime
		, @siteid
		, m.modclassid
		, @id
		, ues.score
		, isnull(urs.accumulativescore, 0)
		, @userid
	from dbo.sites s
	inner join dbo.ModerationClass m on m.modclassid = s.modclassid
	inner join dbo.UserEventScore ues on ues.typeid = @type and m.modclassid=ues.modclassid
	left join dbo.userreputationscore urs on m.modclassid = urs.modclassid and urs.userid = @userid
	where s.siteid=@siteid
	
	commit
END
	
END