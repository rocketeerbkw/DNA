declare @siteid int

set @siteid = (select siteid from sites where shortname = 'england')

update guideentries set forumid = (select ForumID
                                      from GuideEntries 
                                      where EntryID = 
        (select EntryID from KeyArticles where siteid = @siteid and articlename = 'threadsearchphrase'))
        where h2g2id = (select h2g2ID 
                from Topics 
                where TopicStatus = 0 
        and siteID = @siteid)