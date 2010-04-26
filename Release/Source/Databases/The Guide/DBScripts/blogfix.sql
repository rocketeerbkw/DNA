begin tran
/*
	Rename the pm & ipm blogs back to the correct naming convention
*/
update sites set urlname = 'blog51old' where urlname = 'blog51' -- 112
update sites set urlname = 'blog96old' where urlname = 'blog96' -- 99
update sites set urlname = 'blog51' where urlname = 'pmblog'    -- 79
update sites set urlname = 'blog96' where urlname = 'ipmblog'   -- 81
update sites set urlname = 'blog251' where urlname = 'blog241'  -- 234 

/*
	Backup and get site ids for the forums
*/
--drop table commentforumscloned
select * into commentforumscloned from CommentForums

--drop table forumsiteidupdate
select	ForumID = ForumID,
		oldsiteid = siteid,
		correcturlname = 'blog' + REPLACE (SUBSTRING (SUBSTRING (UID, 13, 1000), 0, 4), '_', ''),
		newsiteid = null
		into forumsiteidupdate
			from CommentForums
			where UID like 'movabletype[_]%' and siteid in ( select siteid from sites where urlname in ('blog51','blog96') )

update forumsiteidupdate set newsiteid = s.siteid from sites s where s.urlname = forumsiteidupdate.correcturlname
delete from forumsiteidupdate where newsiteid is NULL or oldsiteid = newsiteid

/*
	Tidy up existing forums
*/
UPDATE commentforums set UID = UID + '_OLD' where forumid in
(
	select forumid from commentforums where uid in 
	(
		select 'movabletype' + SUBSTRING (UID,13,1000) as s from commentforums
			where UID like 'movabletype[_]%'
				and siteid in ( select siteid from sites where urlname in ('blog51','blog96') )
	)
)

/*
	Rename all comment forum UIDs to the movabletype### format
*/
update commentforums set UID = 'movabletype' + SUBSTRING (UID,13,1000)
	where UID like 'movabletype[_]%'
		and siteid in ( select siteid from sites where urlname in ('blog51','blog96') )

/*
	Update the siteid for the forums that are incorrectly in the pmblogs site
*/
update commentforums set siteid = s.siteid from forumsiteidupdate fsu
inner join Sites s on s.URLName = fsu.correcturlname
where commentforums.ForumID = fsu.forumid 

update forums set siteid = s.siteid from forumsiteidupdate fsu
inner join Sites s on s.URLName = fsu.correcturlname
where forums.ForumID = fsu.forumid 

select	cf.forumid,
		'NewUID' = cf.UID,
		'OldUID' = cfc.UID,
		'NewSiteID' = cf.siteid,
		'OldSiteID' = fu.oldsiteid,
		'Forums SiteID' = f.siteid
	from commentforums cf
		join commentforumscloned cfc on cfc.forumid = cf.forumid
		join forumsiteidupdate fu on fu.forumid = cf.forumid
		join Forums f on f.forumid = fu.forumid

-- Get all the preferences for users that don't exist on the new sites
--drop table preferencesfix
select * into PreferencesFix from
(
	-- All users that don't have a preference for the forums new site
	select distinct te.userid, fsu.newsiteid, fsu.oldsiteid from threadentries te
	join forumsiteidupdate fsu on fsu.forumid = te.forumid
	where not exists (select * from preferences p where p.userid=te.userid and p.siteid=fsu.newsiteid)
)
as tofix

select 'CreateUserSQL' = 'exec createnewuserfromuserid ' + cast(u.userid as varchar) + ', ''' + u.username + ''', ''' + u.email + ''', ' + cast(pf.newsiteid as varchar) + ', null, null, null'
	from PreferencesFix pf
	inner join users u on pf.userid=u.userid

/*
************ SELECT AND RUN ALL THE CreateUserSQL STATEMENTS ************

update dbo.preferences set dbo.preferences.autosinbin = p.autosinbin, dbo.preferences.agreedterms = p.agreedterms, dbo.preferences.datejoined = p.datejoined
from
(
	select * from preferences
) as p
inner join PreferencesFix pf on pf.userid = p.userid and pf.oldsiteid = p.siteid
where pf.userid = dbo.preferences.userid and dbo.preferences.siteid = pf.newsiteid
*/

--commit tran
--rollback tran

--select * from commentforums where siteid in ( select siteid from sites where urlname in ('blog51','blog96') ) and uid not like 'movabletype51[_]%'and uid not like 'movabletype96[_]%'
