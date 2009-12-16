/*********************************************************************************

	CREATE PROCEDURE pollgetarticleauthorid @pollid int

	Author:		James Pullicino
	Created:	21/02/2005
	Inputs:		h2g2 id of page
	Outputs:	"Editor" field is author ID
	Returns:	-
	Purpose:	Gets author id of an article
*********************************************************************************/
CREATE PROCEDURE pollgetarticleauthorid @h2g2id int as
select Editor from dbo.GuideEntries where h2g2ID=@h2g2id