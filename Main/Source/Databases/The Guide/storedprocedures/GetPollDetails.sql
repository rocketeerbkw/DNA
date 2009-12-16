
/*********************************************************************************

	create procedure getpolldetails @pollid int as

	Author:		James Pullicino
	Created:	13/01/2005
	Inputs:		@PollID - ID of poll to load
	Outputs:	Returns the poll type
	Purpose:	Get properties of a poll, such as its type
	
*********************************************************************************/

create procedure getpolldetails @pollid int as
	select Type, ResponseMin, ResponseMax, AllowAnonymousRating from votes where VoteID = @pollid
