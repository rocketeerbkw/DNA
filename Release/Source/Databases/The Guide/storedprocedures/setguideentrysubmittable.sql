create procedure setguideentrysubmittable @h2g2id int, @value int
as

Update GuideEntries
Set Submittable = @value where h2g2id = @h2g2id
return (0)
