Select ss.name, s.shortname, Count(nm.modid) 
from NicknameMod nm
INNER JOIN Sites s ON s.siteid = nm.siteid
INNER JOIN ModerationClass ss ON ss.ModclassId = s.modclassid
WHERE Status = 0
GROUP BY ss.name, s.shortname
ORDER BY ss.name , Count(nm.modid) DESC
