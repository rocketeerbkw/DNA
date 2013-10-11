CREATE PROCEDURE getemailbatchtosend @batchsize int, @maxretryattempts int
AS
DECLARE @QueueDate DateTime
SELECT @QueueDate = GETDATE()

EXEC openemailaddresskey;

WITH CTE_EmailsToSend AS
(
	SELECT 
		row_number() OVER ( ORDER BY Priority DESC, DateAdded ASC) as n,
		ID
	FROM dbo.EmailQueue
	WHERE DateQueued IS NULL AND DateSent IS NULL AND (RetryAttempts <= @maxretryattempts OR RetryAttempts IS NULL)
)

UPDATE dbo.EmailQueue SET DateQueued = @QueueDate WHERE ID IN
(
	SELECT
		ID
	FROM
		CTE_EmailsToSend
	WHERE
		n < @batchsize
)

SELECT
	ID,
	'ToEmailAddress' = dbo.udf_decryptemailaddress(ToEmailAddress, ID),
	'FromEmailAddress' = dbo.udf_decryptemailaddress(FromEmailAddress, ID),
	'Subject' = dbo.udf_decrypttext(Subject, ID),
	'Body' = dbo.udf_decrypttext(Body, ID),
	Notes,
	Priority,
	DateQueued,
	DateSent,
	DateAdded,
	RetryAttempts
FROM
	dbo.EmailQueue
WHERE
	DateQueued = @QueueDate