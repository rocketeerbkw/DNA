CREATE PROCEDURE addskintosite	@siteid int,
									@skinname varchar(255),
									@description varchar(255),
									@useframes int
As
IF EXISTS(SELECT * FROM SiteSkins WHERE SkinName = @skinname AND SiteID=@siteid)
BEGIN
	SELECT 'Result' = 1
END
ELSE
BEGIN
	INSERT INTO SiteSkins (SiteID, SkinName, Description, UseFrames)
		VALUES(@siteid, @skinname, @description, @useframes)
	SELECT 'Result' = 0
END