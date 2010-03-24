CREATE Procedure submittedqueuesize
As
	
SELECT 'cnt' = COUNT(*) FROM GuideEntries WITH(NOLOCK) WHERE Status = 4