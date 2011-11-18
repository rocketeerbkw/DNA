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

	-- get score for event
	select @score = ues.score, @override = ues.overridescore
	from dbo.sites s
	--inner join dbo.ModerationClass m on m.modclassid = s.modclassid
	inner join dbo.UserEventScore ues on ues.modclassid = 1 --m.modclassid
	where s.siteid=@siteid and ues.typeid=@type

	-- get maxscore for class
	declare @maxscore smallint
	select @maxscore = maxscore 
	from dbo.userreputationthreshold urpt
	inner join sites s on s.modclassid = urpt.modclassid
	where s.siteid=@siteid

	--get current score
	declare @currentscore smallint
	set @currentscore =0
	select @currentscore = isnull(accumulativescore,0)
	from dbo.UserReputationScore urs
	inner join sites s on s.modclassid = 1 --urs.modclassid
	where userid=@userid
	and s.siteid=@siteid

	-- determine new user score...
	declare @userscore smallint
	if @override = 1
	BEGIN
		set @userscore = @score
	END
	ELSE
	BEGIN
		set @userscore = @score + @currentscore
		-- adhere to max score if not an override
		if @userscore > @maxscore
		begin
			set @userscore = @maxscore
		end
	END

	begin tran

	-- update/insert score
	update dbo.userreputationscore
	set accumulativescore  = @userscore, lastupdated=getdate()
	where userid=@userid
	and modclassid= 1 --(select modclassid from sites where siteid=@siteid)
	
	if @@rowcount =0
	BEGIN
		insert into dbo.userreputationscore (userid, modclassid, accumulativescore)
		select @userid, 1, @userscore, getdate()
		from sites where 
		siteid=@siteid
	END

	insert into dbo.UserSiteEvents (typeid, eventdate, siteid, modclassid,siteeventid, score, accumulativescore, userid)
	select @type
		, @datetime
		, @siteid
		, 1 --m.modclassid
		, @id
		, @score
		, @userscore
		, @userid
	from dbo.sites s
	inner join dbo.ModerationClass m on m.modclassid = s.modclassid
	left join dbo.userreputationscore urs on urs.modclassid = 1 and urs.userid = @userid
	where s.siteid=@siteid
	
	commit
END
	
END