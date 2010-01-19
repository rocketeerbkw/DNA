create procedure checkpremodduration @siteid int, @premodduration int output
as
begin
	select @premodduration = max (t.PreModDuration) 
	from
	(
		select cast(Value as int) as 'PreModDuration' 
		from SiteOptions WITH(NOLOCK) where 
		Section = 'User' and Name = 'PreModDuration' and siteid = 0
		
		union all
		
		select cast(Value as int) as 'PreModDuration' 
		from SiteOptions WITH(NOLOCK) where 
		Section = 'User' and Name = 'PreModDuration' and siteid = @siteid
	) as t
end