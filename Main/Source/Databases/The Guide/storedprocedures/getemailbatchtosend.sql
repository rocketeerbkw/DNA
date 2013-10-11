CREATE PROCEDURE getemailbatchtosend @batchsize int
AS
DECLARE @QueueDate DateTime
SELECT @QueueDate = GETDATE()

EXEC openemailaddresskey;

WITH CTE_EmailsToSend AS
(
	SELECT 
		row_number() OVER ( ORDER BY Priority DESC, DateAdded ASC) as n,
		ID,
		ToEmailAddress,
		FromEmailAddress,
		Subject,
		Body,
		Notes,
		Priority,
		DateQueued
	FROM dbo.EmailQueue
	WHERE DateQueued IS NULL AND DateSent IS NULL
)

UPDATE dbo.EmailQueue SET DateQueued = @QueueDate WHERE ID IN
(
	SELECT
		ID
	FROM
		CTE_EmailsToSend
	WHERE
		n < @batchsize
)SELECT
	ID,
	'ToEmailAddress' = dbo.udf_decryptemailaddress(ToEmailAddress, ID),
	'FromEmailAddress' = dbo.udf_decryptemailaddress(FromEmailAddress, ID),
	'Subject' = dbo.udf_decrypttext(Subject, ID),
	'Body' = dbo.udf_decrypttext(Body, ID),
	Notes,
	Priority,
	DateQueued
FROM
	dbo.EmailQueue
WHERE
	DateQueued = @QueueDate

	