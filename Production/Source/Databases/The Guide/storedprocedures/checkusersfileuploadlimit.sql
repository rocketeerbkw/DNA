/*********************************************************************************

	create procedure checkusersfileuploadlimit @filelength int, @userid int
	
	Author:		Steven Francis
	Created:	17/01/2006
	Inputs:		int iFileLength, 
				int iCurrentUserID
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to check the users upload limit 
	            against the new file size (in essence to allow the upload or not)
	
*********************************************************************************/
CREATE PROCEDURE checkusersfileuploadlimit @filelength int, @userid int
AS
BEGIN

DECLARE @UPLOADLIMIT int
DECLARE @TotalUploadSize int
DECLARE @WithinLimit bit
DECLARE @NextLimitStartDate DateTime

SELECT @UPLOADLIMIT = 10485760 

SELECT @TotalUploadSize = SUM (ISNULL(FileSize, 0))
FROM MediaAsset 
WHERE OwnerID = @userid AND DATEDIFF(Week, DateCreated, getdate()) < 1

IF (ISNULL(@TotalUploadSize, 0) + @filelength) < @UPLOADLIMIT
	SELECT @WithinLimit = 1
ELSE
	SELECT @WithinLimit = 0

--Get the start of the next limit ie Monday coming
SELECT @NextLimitStartDate = DATEADD(Week, DATEDIFF(Week, 0, getdate()) + 1, 0)

SELECT ISNULL(@TotalUploadSize, 0) 'TotalUploadSize', @WithinLimit 'WithinLimit', @NextLimitStartDate 'NextLimitStartDate'

END

