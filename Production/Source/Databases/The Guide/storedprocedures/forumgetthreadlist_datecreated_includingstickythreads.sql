create procedure forumgetthreadlist_datecreated_includingstickythreads		@forumid int, 
													@firstindex int, 
													@lastindex int, 
													@threadcount int, 
													@forumpostcount int,
													@canread int, 
													@canwrite int, 
													@siteid int, 
													@threadcanread int, 
													@threadcanwrite int, 
													@alertinstantly int,
													@moderationstatus int,
													@notablesgroup int
as
			declare @threadlastupdate datetime
			select @threadlastupdate = max(lastupdated)
			from threads
			where forumid = @forumid
			
			declare @forumlastupdate datetime
			select @forumlastupdate = ISNULL(max(lastupdated),cast(convert(char(10),getdate(),121) AS datetime))
			FROM dbo.ForumLastUpdated
			where forumid = @forumid
			
			SELECT	t.ThreadID, 
					FirstSubject, 
					JournalOwner, 
					t.LastPosted, 
					'ThreadCount' = @threadcount,
					f.SiteID,
					'CanRead' = @canread,
					'CanWrite' = @canwrite,
					'ThreadCanRead' = @threadcanread,
					'ThreadCanWrite' = @threadcanwrite,
					'ThisCanRead' = t.CanRead,
					'ThisCanWrite' = t.CanWrite,
					'ModerationStatus' = @moderationstatus,
					'FirstPostText' = te.text,
					'FirstPostEntryID' = te.EntryID,
					'FirstPosting' = te.DatePosted,
					'FirstPostUserID' = u.UserID,
					'FirstPostIdentityUserID' = siuidm.IdentityUserID,
					'FirstPostUserName' = u.UserName,
					'FirstPostIdentityUserName'	= u.LoginName, 
					'FirstPostFirstNames' = u.FirstNames,
					'FirstPostLastName' = u.LastName,
					'FirstPostNotableUser' = CASE WHEN gm.UserID IS NOT NULL THEN 1 ELSE 0 END,
					'FirstPostStyle' = te.PostStyle,
					'FirstPostTitle' = p.Title,
					'FirstPostSiteSuffix' = p.SiteSuffix,
					'FirstPostHidden' = te.Hidden,
					'FirstPostArea' = u.Area,
					'FirstPostStatus' = u.Status,
					'FirstPostTaxonomyNode' = u.TaxonomyNode,
					'FirstPostJournal' = j.ForumID,
					'FirstPostActive' = u.Active,
					'LastPostEntryID' = te1.EntryID,
					'LastPostUserID' = u1.UserID,
					'LastPostIdentityUserID' = siuidm1.IdentityUserID,
					'LastPostUserName' = u1.UserName,
					'LastPostIdentityUserName'	= u1.LoginName, 
					'LastPostFirstNames' = u1.FirstNames,
					'LastPostLastName' = u1.LastName,
					'LastPostNotableUser' = CASE WHEN gm1.UserID IS NOT NULL THEN 1 ELSE 0 END,
					'LastPostStyle' = te1.PostStyle,
					'LastPostTitle' = p1.Title,
					'LastPostSiteSuffix' = p1.SiteSuffix,
					'LastPostText' = te1.text,
					'LastPostHidden' = te1.Hidden,
					'LastPostArea' = u1.Area,
					'LastPostStatus' = u1.Status,
					'LastPostTaxonomyNode' = u1.TaxonomyNode,
					'LastPostJournal' = u1.Journal,
					'LastPostActive' = u1.Active,
					'cnt' = te1.PostIndex + 1,
					'ForumPostCount' = @forumpostcount,
					t.type,
					t.eventdate,
					'AlertInstantly' = @alertinstantly,
					'ThreadLastUpdated' = @threadlastupdate,
					'ForumLastUpdated' = @forumlastupdate,
					'IsSticky' = CASE WHEN st.sortby IS NULL THEN 0 ELSE 1 END
					
				FROM (
					select ThreadID , rownumber id 
					from (
						select tr.ThreadID, ROW_NUMBER() over (order by sst.sortby desc, DateCreated desc) as rownumber 
						FROM Threads tr WITH(NOLOCK) 
						LEFT JOIN StickyThreads sst WITH(NOLOCK) ON sst.forumid = tr.ForumID AND sst.threadid = tr.ThreadID
						where tr.ForumID = @forumid AND VisibleTo IS NULL
						) t 
						where rownumber between @firstindex+1 and @lastindex+1
				) tt
				INNER JOIN Threads t WITH(NOLOCK) ON tt.ThreadID = t.ThreadID
				INNER JOIN Forums f WITH(NOLOCK) ON f.ForumID = t.ForumID
				INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.Threadid = t.ThreadID AND te.PostIndex = 0
				INNER JOIN Users u WITH(NOLOCK) ON u.UserID = te.UserID
				LEFT JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
				LEFT JOIN Preferences p WITH(NOLOCK) ON u.UserID = p.UserID AND f.SiteID = p.SiteID
				INNER JOIN ThreadEntries te1 WITH(NOLOCK) ON te1.ThreadID = t.ThreadID AND te1.PostIndex = (SELECT top 1 PostIndex FROM ThreadEntries tex WITH(NOLOCK) WHERE tex.ThreadID = t.ThreadID ORDER BY PostIndex DESC) 
				INNER JOIN Users u1 WITH(NOLOCK) ON u1.UserID = te1.UserID
				LEFT JOIN SignInUserIDMapping siuidm1 WITH(NOLOCK) ON u1.UserID = siuidm1.DnaUserID
				LEFT JOIN Preferences p1 WITH(NOLOCK) ON u1.UserID = p1.UserID AND f.SiteID = p1.SiteID
				LEFT JOIN GroupMembers gm WITH(NOLOCK) ON gm.UserID = te.UserID AND gm.SiteID = f.SiteID AND gm.GroupID = @notablesgroup
				LEFT JOIN GroupMembers gm1 WITH(NOLOCK) ON gm1.UserID = te1.UserID AND gm1.SiteID = f.SiteID AND gm1.GroupID = @notablesgroup
				LEFT JOIN Journals J with(nolock) on j.userid = u.UserID and j.siteid = f.siteid
				LEFT JOIN StickyThreads st WITH(NOLOCK) ON st.forumid = t.ForumID AND st.threadid = t.ThreadID
		--	WHERE
			--AND t.ForumID = @forumid
		--	VisibleTo IS NULL
			ORDER BY tt.id ASC


