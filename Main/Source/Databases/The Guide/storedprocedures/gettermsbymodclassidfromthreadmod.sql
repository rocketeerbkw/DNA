
/* CREATION HISTORY
NAME	-	gettermsbymodidfromthreadmod
AUTHOR  -   Srihari
PURPOSE	-	Gets the terms list with the details
*/

/* MODIFICATION HISTORY
MODIFIED BY -	
DATE		-	
PURPOSE		-	
*/

CREATE PROCEDURE gettermsbymodidfromthreadmod
	@modId INT
AS

BEGIN   
 BEGIN TRY  
  
  SELECT DISTINCT 
   T.id        AS TermID  
   , T.term       AS Term  
   , (CASE   
	  WHEN TUH.notes IS NULL THEN ''
	  ELSE CAST(TUH.notes AS NVARCHAR(MAX))
	 END) AS Reason
   , (CASE
	  WHEN TUH.updatedate IS NULL THEN ''
      ELSE TUH.updatedate
	 END) AS UpdatedDate
   , (CASE 
	  WHEN TUH.userid IS NULL THEN 0
	  ELSE TUH.userid
	  END) AS UserID
  FROM ThreadMod AS TM  
  INNER JOIN ModTermMapping AS MTM ON TM.ModID = MTM.ModID  
  INNER JOIN TermsLookup AS T ON T.id = MTM.TermID  
  LEFT JOIN TermsByModClassHistory AS TMCH ON tmch.termid = MTM.TermID  
  LEFT JOIN TermsUpdateHistory AS TUH ON TMCH.updateid = TUH.id  
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