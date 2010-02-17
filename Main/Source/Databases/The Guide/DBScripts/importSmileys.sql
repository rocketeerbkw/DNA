-- This Script imports the smilys from SmileyList.txt to Smiletys table.
-- The script empties the Smileys table before importing the smileys !
-- Please alter the path to SmileyList as necessary.
CREATE TABLE #smileylist ( shorthand NVARCHAR(100), [name] NVARCHAR(100) )

BULK
 
INSERT #smileylist

FROM 'c:\Inetpub\wwwroot\h2g2\SmileyList.txt'

WITH

(

FIELDTERMINATOR = ' ',

ROWTERMINATOR = '\n'

)


TRUNCATE TABLE Smileys
INSERT INTO Smileys ( [name], tag )
SELECT LTRIM(RTRIM([name])), LTRIM(RTRIM(shorthand)) FROM #smileylist
DROP TABLE #smileyList

