/* CREATION HISTORY    
NAME	-	gettermsbyforumidfromforums    
AUTHOR  -	Srihari    
PURPOSE -	Gets the terms list with the details    
*/    
    
/* MODIFICATION HISTORY    
MODIFIED BY -     
DATE		-     
PURPOSE		-     
*/    
    
CREATE PROCEDURE gettermsbyforumidfromforums    
 @forumid INT    
AS    
    
BEGIN       
 BEGIN TRY  

	  SELECT     
		 T.id        AS TermID      
	   , T.term       AS Term      
	   , TERMDETAILS.Reason
	   , TERMDETAILS.UpdatedDate
	   , TERMDETAILS.UserID
	  FROM Forums AS F      
	  INNER JOIN ForumTermMapping AS FTM ON F.ForumID = FTM.ForumID      
	  INNER JOIN TermsLookup AS T ON T.id = FTM.TermID 
	  INNER JOIN Sites AS S ON S.SiteID = F.SiteId     
	  CROSS APPLY (SELECT ISNULL(notes,'') Reason, ISNULL(updatedate,'') UpdatedDate,ISNULL(userid,0) UserID FROM TermsUpdateHistory 
						WHERE id=(SELECT MAX(updateid) FROM TermsByForumHistory WHERE termid = FTM.TermID AND modclassid = S.ModClassID)) TERMDETAILS
		
	  WHERE      
		F.ForumID = @forumId      
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