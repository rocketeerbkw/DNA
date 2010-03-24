/*
	Gets all the details on a particular posting that are likely
	to be required
*/

create procedure fetchpostdetails @postid int
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select	'PostID' = TE.EntryID, TE.ThreadID, TE.ForumID,
		TE.UserID, U.Username, U.FirstNames, U.LastName, U.Area, U.Status, U.TaxonomyNode, 'Journal' = J.ForumID, U.Active, P.SiteSuffix, P.Title,
		TE.DatePosted, TE.BlobID, TE.PostIndex,
		TE.Subject, TE.Text, TE.Hidden, F.SiteID, 
		tip.IPAddress, tip.BBCUID, 
		case when cf.url is null then '' else cf.url end as 'HOSTPAGEURL'
from ThreadEntries TE
inner join Users U on U.UserID = TE.UserID
inner join Forums F on F.ForumID = TE.ForumID
left join ThreadEntriesIPAddress tip ON tip.EntryID = @postid
left join Preferences P on (P.UserID = U.UserID) AND (P.SiteID = F.SiteID)
INNER JOIN Journals J on J.UserID = U.UserID and J.SiteID = F.SiteID
left outer join CommentForums CF on CF.forumid = F.ForumID
where TE.EntryID = @postid
return (0)
