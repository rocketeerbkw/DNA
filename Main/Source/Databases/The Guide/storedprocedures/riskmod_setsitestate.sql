/*
	riskmod_setsitestate

	Sets the site's risk mod state.  

	It only sets params that are set to non-null values
	e.g.
		-- This will only change the state of PublishMethod, and leave the IsOn setting unchanged
		EXEC riskmod_setsitestate 1, NULL, 'b'
*/
CREATE PROCEDURE riskmod_setsitestate @siteid int, @ison bit = null, @publishmethod char(1) = null
AS
	IF EXISTS(SELECT * FROM RiskModerationState WHERE IdType='S' AND Id=@siteid)
	BEGIN
		UPDATE RiskModerationState
			SET IsOn          = ISNULL(@ison,IsOn), 
				PublishMethod = ISNULL(@publishmethod,PublishMethod)
			WHERE IdType='S' AND Id=@siteid
	END
	ELSE
	BEGIN
		INSERT RiskModerationState(IdType,Id,IsOn,PublishMethod) VALUES('S',@siteid,ISNULL(@ison,0), ISNULL(@publishmethod,'A'))
	END
