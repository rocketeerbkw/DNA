/*
	Fetches a random article of the given status value, avoiding users
	homepages
	Useful for e.g. the random entry button
*/

create procedure fetchrandomarticle
	@siteid int,
	@status1 int,
	@status2 int = null,
	@status3 int = null,
	@status4 int = null,
	@status5 int = null
as
-- variables to store the results from the cursor in

declare @Editor int
declare @EntryID int
declare @h2g2ID int
declare @Subject varchar(255)
declare @DateCreated datetime
declare @Pos int

-- first select a random position from the first to last of the entries
-- which have the specified status
select top 1 @EntryID = EntryID, @h2g2ID=h2g2id, @Subject=subject, @Editor=Editor, @DateCreated=DateCreated
			from GuideEntries G WITH(NOLOCK)
			where G.Type < 1001
				and G.Hidden is null
				and G.SiteID = @siteid
				and G.Status in (@status1, @status2, @status3, @status4, @status5)
			order by rand(checksum(newid()))

select 'EntryID' = @EntryID, 'h2g2ID' = @h2g2ID, 'Subject' = @Subject, 'Editor' = @Editor, 'DateCreated' = @DateCreated,
	'EditorName'			= u.UserName, 
	'EditorFirstNames'		= u.FirstNames, 
	'EditorLastName'		= u.LastName, 
	'EditorArea'			= u.Area, 
	'EditorStatus'			= u.Status, 
	'EditorTaxonomyNode'	= u.TaxonomyNode, 
	'EditorJournal'			= J.ForumID, 
	'EditorActive'			= u.Active,
	'EditorTitle'			= p.Title,
	'EditorSiteSuffix'		= p.SiteSuffix
FROM Users u
left join Preferences p ON p.UserID = u.UserID AND p.SiteID = @siteid
inner join Journals J ON J.UserID = u.UserID and J.SiteID = @siteid
where u.UserID = @Editor

return (0)
