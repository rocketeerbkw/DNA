CREATE PROCEDURE fetchedithistory @entryid int, @action int = NULL
AS
IF (@action IS NULL)
 SELECT EntryID, UserID, DatePerformed, Action, Comment 
  FROM EditHistory
   WHERE EntryID = @entryid
    ORDER BY DatePerformed
ELSE
 SELECT EntryID, UserID, DatePerformed, Action, Comment 
  FROM EditHistory
   WHERE EntryID = @entryid AND Action = @action
    ORDER BY DatePerformed
