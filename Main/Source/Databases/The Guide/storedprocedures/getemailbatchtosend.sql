CREATE PROCEDURE getemailbatchtosend @batchsize int
AS
EXEC openemailaddresskey;

WITH CTE_EmailsToSend AS
(
	SELECT 
		row_number() OVER ( ORDER BY Priority DESC, ID DESC) as n,
		ID,
		ToEmailAddress,
		FromEmailAddress,
		Subject,
		Body,
		Notes,
		Priority,
		DateQueued
	FROM dbo.EmailQueue
)
SELECT
	'ToEmailAddress' = dbo.udf_decryptemailaddress(ToEmailAddress, ID),
	'FromEmailAddress' = dbo.udf_decryptemailaddress(FromEmailAddress, ID),
	'Subject' = dbo.udf_decrypttext(Subject, ID),
	'Body' = dbo.udf_decrypttext(Body, ID),
	Notes,
	Priority,
	DateQueued
FROM
	CTE_EmailsToSend
WHERE
	n < @batchsize
	