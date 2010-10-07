/*
	riskmoderation_getsitestate

	Returns the site's risk mod state.  
	If the site doesn't have a status, NULL is returned for both OUTPUT vars
*/
CREATE PROCEDURE riskmod_getsitestate @siteid INT,@ison BIT OUTPUT, @publishmethod CHAR(1) OUTPUT
AS
	-- Set the input vars to NULL, so they are returned as NULL if the site does not have a risk mod state row
	SELECT @ison = NULL, @publishmethod = NULL

	-- Look up the site's risk mod state
	SELECT @ison = IsOn, @publishmethod = PublishMethod
		FROM dbo.RiskModerationState
		WHERE IdType='S' AND Id=@siteid
