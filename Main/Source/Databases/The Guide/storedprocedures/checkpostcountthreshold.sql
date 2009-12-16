create procedure checkpostcountthreshold @siteid int, @postcountthreshold int output
as
begin
	select @postcountthreshold = max (t.PostCountThreshold) 
	from
	(
		select cast(Value as int) as 'PostCountThreshold' 
		from SiteOptions WITH(NOLOCK)
		where Section = 'User' and Name = 'PostCountThreshold' and siteid = 0
		
		union all
		
		select cast(Value as int) as 'PostCountThreshold' 
		from SiteOptions WITH(NOLOCK)
		where Section = 'User' and Name = 'PostCountThreshold' and siteid = @siteid
	) as t
end