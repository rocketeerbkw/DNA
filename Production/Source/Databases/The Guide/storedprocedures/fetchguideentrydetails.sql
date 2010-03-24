/*
	Fetchs the summary details on a particular article
	i.e. all the fields from GuideEntries plus the Editor's UserName
	Does NOT get the text of the entry currently
*/

create procedure fetchguideentrydetails @h2g2id int
as
select	G.*
from GuideEntries G
where G.H2G2ID = @h2g2id
return (0)