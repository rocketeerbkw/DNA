CREATE TRIGGER trg_Threadmod_u ON ThreadMod
AFTER UPDATE 
AS
	-- When an items is completed - check if that forum should come out of fast mod
	IF UPDATE(DateCompleted)
	BEGIN
	
		declare @fmfforumid int
		select @fmfforumid = fmf.forumid
		from fastmodforums fmf
		inner join inserted i on i.forumid = fmf.forumid
		
		if @fmfforumid is null
		BEGIN 
			return 
		END
		
		-- get site option value
		--set @total = udf_getsiteoptionsetting(inserted.siteid, 'Moderation', 'MaxItemsInPriorityModeration')
		declare @total int
		SELECT @total = convert(int, Value)
		FROM dbo.SiteOptions so WITH (NOLOCK)
		inner join inserted i on i.siteid = so.siteid
		WHERE Section = 'Moderation'
		AND Name = 'MaxItemsInPriorityModeration'

		if @total is null
		BEGIN
			SELECT @total = convert(int, Value)
			FROM dbo.SiteOptions WITH (NOLOCK)
			WHERE Siteid = 0
			AND Section = 'Moderation'
			AND Name = 'MaxItemsInPriorityModeration'
		
		END		
		if @total = 0 or @total is null
		BEGIN	
			RETURN
		END

		-- remove from fast mod if there are more than allowed
		
		select @fmfforumId  = forumId
		from
		(
			select tm.forumid, count(*) as 'count'
			from threadmod tm
			inner join inserted i on i.forumid = tm.forumid
			where tm.datecompleted is not null
			group by tm.forumid
			having count(*) > @total
			
		) result
		if @fmfforumId  is null
		BEGIN	
			RETURN
		END
		
		delete from fastmodforums
		where forumid =@fmfforumId 

	END
