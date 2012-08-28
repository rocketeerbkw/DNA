/*
This script needs to be run on the BI database and NOT Newguide, as it requires certain BI tables

If you have any setting marked as 'Missing', you need to contact the moderation team to see
what the correct site percentage should be.

*/
select
	'BI Settings' = CASE WHEN cs.SiteID IS NULL THEN 'Missing!' ELSE 'Set' END,
	'NewGuIde Settings' = CASE WHEN rms.IsOn = 0 THEN 'Missing!' ELSE 'Set' END,
	s.shortname,
	s.urlname,
	cs.siteid,
	s.siteid,
	cs.*,
	'URL' = 'http://localhost/bbcv21/default.aspx?classmod=19&siteid=' + CAST(s.siteid as varchar)

from [guide6-1].theguide.dbo.RiskModerationState rms
left join dbo.current_setting cs on cs.siteid=rms.ID
inner join [guide6-1].theguide.dbo.sites s on s.siteid=rms.ID
where
	rms.idtype = 'S' and
	(
		rms.IsOn = 1 OR
		(
			rms.IsOn = 1 AND cs.SiteID IS NULL
		)
	)
order by cs.SiteID, s.siteid