-- Changes site name 'soup' to 'comedysoup'
-- After this script has run, change the skin folder name to 'comedysoup'

DECLARE @siteid INT
SELECT @siteid=siteid FROM sites WHERE urlname='soup'

IF @siteid IS NULL
BEGIN
	PRINT 'Already converted'
	SELECT @siteid=siteid FROM sites WHERE urlname='comedysoup'
	
	SELECT * FROM sites WHERE siteid=@siteid
	SELECT * FROM siteskins WHERE siteid=@siteid
	
	RETURN
END

BEGIN TRANSACTION

-- Change the urlname an default skin for the site
UPDATE sites SET urlname='comedysoup', defaultskin='comedysoup'
	WHERE siteid=@siteid
IF @@ERROR <> 0
BEGIN
	PRINT 'error'
	ROLLBACK TRANSACTION
	RETURN
END

-- Add the new skin for this site.
-- The old skin is left in, allowing you to test without doing the file rename immediately
INSERT INTO siteskins (siteid,skinname,description,Useframes) VALUES (@siteid,'comedysoup','Comedy Soup',0)
IF @@ERROR <> 0
BEGIN
	PRINT 'error'
	ROLLBACK TRANSACTION
	RETURN
END

-- Update all the user pref entries to use the new skin by default
UPDATE preferences SET prefskin='comedysoup' WHERE siteid=@siteid
IF @@ERROR <> 0
BEGIN
	PRINT 'error'
	ROLLBACK TRANSACTION
	RETURN
END

COMMIT TRANSACTION

-- Show the new states
SELECT * FROM sites WHERE siteid=@siteid
SELECT * FROM siteskins WHERE siteid=@siteid

SELECT top 1 * FROM preferences WHERE siteid=@siteid
