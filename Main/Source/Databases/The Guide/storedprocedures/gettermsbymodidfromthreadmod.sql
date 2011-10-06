
/* CREATION HISTORY
NAME	-	gettermsbymodidfromthreadmod
AUTHOR  -   Srihari
PURPOSE	-	Gets the terms list with the details
*/

/* MODIFICATION HISTORY
MODIFIED BY -	Srihari
DATE		-	16-AUG-2011
PURPOSE		-	Used CROSS APPLY to get the latest term updates
*/

CREATE PROCEDURE gettermsbymodidfromthreadmod
	@modid INT
AS

BEGIN   
 BEGIN TRY  
  
  SELECT     
	T.id        AS TermID      
	, T.term       AS Term      
	,TERMDETAILS.Reason
	,TERMDETAILS.UpdatedDate
	,TERMDETAILS.UserID
	,u.username
  FROM ThreadMod AS TM      
  INNER JOIN ModTermMapping AS MTM ON TM.ModID = MTM.ModID      
  INNER JOIN TermsLookup AS T ON T.id = MTM.TermID 
  INNER JOIN Sites AS S ON S.SiteID = TM.SiteId     
	CROSS APPLY (SELECT ISNULL(notes,'') Reason, ISNULL(updatedate,'') UpdatedDate,ISNULL(userid,0) UserID FROM TermsUpdateHistory 
					WHERE id=(SELECT MAX(updateid) FROM TermsByModClassHistory WHERE termid=MTM.TermID AND modclassid = S.ModClassID)) TERMDETAILS  
	INNER JOIN users u on u.userid = TERMDETAILS.UserID
  WHERE  
   TM.ModID = @modId  
  ORDER BY T.term ASC  
  
 END TRY  
  
 BEGIN CATCH  
  
  DECLARE @ErrorMessage NVARCHAR(MAX);  
  DECLARE @ErrorSeverity INT;  
  DECLARE @ErrorState INT;  
  
  SELECT   
   @ErrorMessage = ERROR_MESSAGE(),  
   @ErrorSeverity = ERROR_SEVERITY(),  
   @ErrorState = ERROR_STATE();  
  
      
  RAISERROR (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  
  
 END CATCH  
  
END
