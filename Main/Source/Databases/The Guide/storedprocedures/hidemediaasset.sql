/*********************************************************************************

	create procedure hidemediaasset @mediaassetid int, @hiddenstatus int as

	Author:		Steven Francis
	Created:	30/03/2006
	Inputs:		@mediaassetid - ID of Media Asset to hide
				@hiddenstatus - Hidden Status
	Outputs:	
	Purpose:	Updates the Hidden flag for the media asset
	
*********************************************************************************/

CREATE PROCEDURE hidemediaasset @mediaassetid int, @hiddenstatus int = null AS
	UPDATE dbo.MediaAsset SET Hidden = @hiddenstatus
	WHERE ID = @mediaassetid