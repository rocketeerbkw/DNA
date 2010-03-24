CREATE Procedure freshestarticles @siteid int, @show int = 10000, @skip int =0
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	;WITH freshentries AS
	(
		SELECT h2g2ID, ROW_NUMBER() OVER(ORDER BY DateCreated DESC) n
		FROM GuideEntries 
		WHERE siteid = @siteid
			AND Status in (1,3)
			AND Type < 1000
			AND Hidden IS NULL
	)
		SELECT GE.h2g2ID, 
				Status, 
				DateCreated,
				'Subject' = 
					CASE 
					WHEN Subject IS NULL OR Subject = '' 
						THEN 'No subject' 
						ELSE Subject 
					END ,
					ExtraInfo
		FROM freshentries FE
		inner join GuideEntries GE on FE.h2g2ID = GE.h2g2ID
		WHERE (FE.n > @skip AND FE.n <=(@skip+@show))
		ORDER BY DateCreated DESC