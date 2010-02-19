-- The purpose of this script is to set the value of the Nickname Moderation Status Site Option.
-- The Nickname Moderation Status should deffault in the first instance to the value of the site moderation status.

INSERT INTO SiteOptions  ( SiteId, [Name], Section, [Value], so.[Type], Description )
SELECT s.siteid, so.[name], so.section, 2 as [value], so.[type], so.description
FROM Sites s 
INNER JOIN SiteOptions so ON so.siteid = 0 AND so.[name]='NicknameModerationStatus' AND so.section='Moderation'
LEFT JOIN SiteOptions so2 ON so2.Name = 'NicknameModerationStatus' AND so2.section = 'Moderation' AND so2.siteid = s.siteid
WHERE s.PreModeration = 1 AND so2.siteid IS NULL

INSERT INTO SiteOptions  ( SiteId, [Name], Section, [Value], so.[Type], Description )
SELECT s.siteid, so.[name], so.section, 1 as [value] , so.[type], so.description
FROM Sites s 
INNER JOIN SiteOptions so ON so.siteid = 0 AND so.[name]='NicknameModerationStatus' AND so.section='Moderation'
LEFT JOIN SiteOptions so2 ON so2.Name = 'NicknameModerationStatus' AND so2.section = 'Moderation' AND so2.siteid = s.siteid
WHERE PreModeration = 0 AND UnModerated = 0 AND so2.siteid IS NULL

select * from siteoptions where name = 'NicknameModerationStatus'
order by siteid
