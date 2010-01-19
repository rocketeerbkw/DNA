
/*********************************************************************************
	create procedure getpollresults @pollid int 

	Author:		James Pullicino
	Created:	07/01/2005
	Inputs:		ID of Poll for which I want results
	Outputs:	Returns count of votes for each response grouped by status of user
	Returns:	-
	Purpose:	Gets voting results of a poll
*********************************************************************************/
create procedure getpollresults @pollid int 
AS
select Visible, Response, count(Response) AS "count" 
	from VoteMembers WITH(NOLOCK)
		where VoteID = @pollid 
			GROUP BY Response, Visible 
				ORDER BY Visible ASC

