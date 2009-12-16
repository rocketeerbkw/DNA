/*
	Fetchs the summary details on a particular article
	i.e. all the fields from GuideEntries plus the Editor's UserName
	Does NOT get the text of the entry currently
*/

create procedure fetcharticledetails @entryid int
as
select	G.*, 'EditorName' = U.UserName
from GuideEntries G
inner join Users U on U.UserID = G.Editor
where G.EntryID = @entryid
return (0)
