BEGIN TRANSACTION 

--Remove any default skins that are not the site default
DELETE ss
FROM SiteSkins ss
INNER JOIN Sites s ON s.siteid = ss.siteid
WHERE ss.SkinName = 'Default' AND ss.SkinName != s.DefaultSkin

-- Update the default skin of all sites to default skin
UPDATE SiteSkins  
SET SkinName = 'default'
FROM SiteSkins sk
INNER JOIN Sites s ON s.siteid = sk.siteid AND s.DefaultSkin = sk.SkinName

-- Update site skins with default skin for h2g2.
UPDATE SiteSkins  
SET SkinName = DefaultSkin
FROM SiteSkins sk
INNER JOIN Sites s ON s.siteid = sk.siteid AND s.urlname = 'h2g2' AND sk.SkinName = 'default'

-- Update site skins with default skin for cbbc.
UPDATE SiteSkins  
SET SkinName = DefaultSkin
FROM SiteSkins sk
INNER JOIN Sites s ON s.siteid = sk.siteid AND s.urlname = 'cbbc' AND sk.SkinName = 'default'

-- Update site skins with default skin for 1xtra.
UPDATE SiteSkins  
SET SkinName = s.DefaultSkin
FROM SiteSkins sk
INNER JOIN Sites s ON s.siteid = sk.siteid AND s.urlname = '1xtra' AND sk.SkinName = 'default'


-- Give all Sites a skin set of vanilla
-- UPDATE Sites SET SkinSet = 'vanilla' 

-- Setup sites that have a skinset defined.
UPDATE Sites SET SkinSet = 'boards' WHERE DefaultSkin = 'boards'
UPDATE Sites SET SkinSet = 'acs' WHERE DefaultSkin='acs'
UPDATE Sites SET SkinSet = 'h2g2' where urlname = 'h2g2'
UPDATE Sites SET SkinSet = 'collective' WHERE urlname = 'collective'
UPDATE Sites SET SkinSet = 'filmnetwork' WHERE urlname = 'filmnetwork'
UPDATE Sites SET SkinSet = '606' WHERE urlname = '606'
UPDATE Sites SET SkinSet = 'moderation' WHERE urlname = 'moderation'
UPDATE Sites SET SkinSet = 'memoryshare' WHERE urlname = 'memoryshare'
UPDATE Sites SET SkinSet = 'sciencefictionlife' WHERE urlname = 'mysciencefictionlife'
UPDATE Sites SET SkinSet = 'boards' WHERE urlname = '1xtra'
UPDATE Sites SET SkinSet = 'comedysoup' WHERE urlname = 'comedysoup'
UPDATE Sites SET SkinSet = 'england' WHERE urlname = 'england'
UPDATE Sites SET SkinSet = 'onthefuture' WHERE urlname = 'onthefuture'
UPDATE Sites SET SkinSet = 'britishfilm' WHERE urlname = 'britishfilm'

-- Add XML Skin for sites that have an xml skin in their skinset.
INSERT INTO SiteSkins( SiteId, SkinName, Description, UseFrames)
SELECT s.SiteId, 'xml', 'xml', 0
FROM Sites s 
LEFT JOIN SiteSkins ss ON ss.siteid = s.siteid AND ss.skinname = 'xml'
WHERE s.SkinSet IN ( 'boards', 'h2g2', 'collective', 'filmnetwork', '606','memoryshare','sciencefictionlife')
AND ss.skinname is null

-- Set all sites default skin to default.
UPDATE Sites SET DefaultSkin = 'default'

-- Override for sites where default skin is not default.
UPDATE Sites SET DefaultSkin = '1xtra' WHERE urlname = '1xtra'
UPDATE Sites SET DefaultSkin = 'cbbc' WHERE urlname = 'cbbc'
UPDATE Sites SET DefaultSkin = 'brunel' WHERE urlname = 'h2g2'

-- Update User Preferences ensuring user pref skins are valid
UPDATE Preferences
SET PrefSkin = s.DefaultSkin
FROM Preferences p
INNER JOIN sites s ON s.siteid = p.siteid
LEFT JOIN SiteSkins sk ON sk.skinname = p.prefskin AND sk.SiteId = s.SiteId
WHERE sk.SkinName IS NULL

-- Clear up vanilla skins added for blog sites.
-- It is not necessary to specify vanilla as an optional skin.
-- The vanilla skin is part of the fallback behaviour
DELETE ss
FROM SiteSkins ss
INNER JOIN Sites s ON s.siteid = ss.siteid
WHERE ss.skinname != s.defaultskin and (ss.skinname = 'vanilla' or ss.skinname='vanilla-json')

COMMIT TRANSACTION




