CREATE PROCEDURE getbreakandparabreakarticles
AS
SELECT h2g2id,subject,datecreated,siteid FROM guideentries
	where (siteid=9 or siteid=15) and 
	      (text like '%<BREAK%' or text like '%<PARABREAK%')
