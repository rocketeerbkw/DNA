CREATE PROCEDURE updaterecentsearch @siteid int, @type int, @searchterm varchar(1024)
AS

DECLARE @Id INT
DECLARE @Count INT
DECLARE @Max INT
SET @MAX = 10

SELECT @Id = SearchId, @count = [Count] FROM RECENTSEARCH WHERE SiteID = @siteID AND SearchType = @type AND Term = @searchterm
IF NOT @Id IS NULL 
BEGIN 
	--Found a matching search - update time stamp and the count (avoid the case for count ever being NULL)
	UPDATE RECENTSEARCH SET Stamp = CURRENT_TIMESTAMP, [Count] = ISNULL(@Count,1) + 1 WHERE SearchID = @ID
END
ELSE
BEGIN
	--This statement will set ID to the last record - ie the oldest
	SELECT @ID = SEARCHID FROM RECENTSEARCH WHERE SITEID = @siteID ORDER BY STAMP DESC
	
	IF @@ROWCOUNT >= @MAX
	BEGIN
		--Update oldest search with new search
		UPDATE RECENTSEARCH SET TERM = @searchterm, STAMP = CURRENT_TIMESTAMP, SEARCHTYPE = @type,[Count] = 1 WHERE SEARCHID = @ID
	END
	ELSE
	BEGIN
		--Insert new search
		INSERT INTO RECENTSEARCH(SITEID,TERM,SEARCHTYPE,[Count]) VALUES(@siteID,@searchterm,@type,1)
	END
END
