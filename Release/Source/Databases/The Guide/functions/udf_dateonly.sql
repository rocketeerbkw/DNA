create  function udf_dateonly(@datetime datetime)
returns datetime
as
    begin
		return dateadd(dd,0, datediff(dd,0,@datetime))
    end
