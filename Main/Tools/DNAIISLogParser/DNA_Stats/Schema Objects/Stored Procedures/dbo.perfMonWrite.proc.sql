CREATE PROCEDURE [dbo].[perfMonWrite] @date datetime, @machine_name varchar(50), @perf_type varchar(50), 
	@perf_instance varchar(50), @perf_counter varchar(50), @value real
AS
BEGIN
	SET NOCOUNT ON;
	
	--declare id variables
	declare @machine_nameid int
	declare @perf_typeid int
	declare @perf_instanceid int
	declare @perf_counterid int

	--call sps to return ID values
	exec perf_typeget @perf_type, @perf_typeid output
	exec machine_nameget @machine_name, @machine_nameid output
	exec perf_instanceget @perf_instance, @perf_instanceid output
	exec perf_counterget @perf_counter, @perf_counterid output
	
	
	-- do update
	update perfMon
	set
	value = @value
	where
	datetime = @date and perf_type = @perf_typeid and machine_name = @machine_nameid
	and perf_instance = @perf_instanceid and perf_counter = @perf_counterid

	--check if updated - otherwise insert
	if @@rowcount = 0
	BEGIN
		insert into perfMon	
		(datetime,perf_instance,perf_type,machine_name,perf_counter, value)
		values
		(@date,@perf_instanceid,@perf_typeid, @machine_nameid,@perf_counterid,@value)
	END
END


