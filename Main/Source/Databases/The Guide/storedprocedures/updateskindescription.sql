CREATE PROCEDURE updateskindescription	@siteid int,
											@skinname varchar(255),
											@newdescription varchar(255),
											@useframes int = 0
As
UPDATE SiteSkins
	SET Description = @newdescription, UseFrames = @useframes
		WHERE SiteID = @siteid AND SkinName = @skinname
