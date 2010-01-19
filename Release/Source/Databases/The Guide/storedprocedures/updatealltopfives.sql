CREATE PROCEDURE updatealltopfives
As
-- for h2g2
EXEC updatetopfiveforums 1
EXEC updatetopfiveleastviewed 1
EXEC updatetopfivemostrecent 1
EXEC updatetopfiveforums 1
-- for other sites?
EXEC updatetopfiveforums 2
EXEC updatetopfiveforums 4
EXEC updatetopfiveforums 5
EXEC updatetopfiveforums 6

