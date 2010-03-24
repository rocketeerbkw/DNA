CREATE PROCEDURE getservicebrokerserviceinfo
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; /* MUST NOT LOCK TABLES */

	SELECT	s.name 'ServiceName' , 
			sq.name 'QueueName' , 
			sq.activation_procedure, 
			dp.name 'EXEC_AS', 
			sq.is_activation_enabled, 
			sq.is_receive_enabled, 
			sq.is_enqueue_enabled, 
			sq.is_retention_enabled
	  FROM	sys.services s
			inner join sys.service_queues sq on s.service_queue_id = sq.object_id
			left join sys.database_principals dp on sq.execute_as_principal_id = dp.principal_id
	 WHERE	sq.is_ms_shipped = 0
	 ORDER  BY sq.object_id;

RETURN @@ERROR