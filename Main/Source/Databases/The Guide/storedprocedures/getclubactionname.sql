create procedure getclubactionname @actiontype int, @actionname varchar(255) OUTPUT
as
	select @actionname = CASE WHEN ActionName IS NOT NULL THEN ActionName ELSE 'unknown' END
		FROM ClubActionNames WHERE ActionType = @actiontype
return 0