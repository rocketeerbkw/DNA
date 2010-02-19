/* Service information */
/* Moved to storedprocedures project */
CREATE PROCEDURE GetServiceBrokerServiceInfo
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; /* MUST NOT LOCK TABLES */

	SELECT	s.name 'ServiceName' , 
			sq.name 'QueueName' , 
			sq.activation_procedure, 
			dp.name 'EXEC AS', 
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

/* Conversation information */
/* Moved to storedprocedures project */
CREATE PROCEDURE GetServiceBrokerConversationInfo
AS
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; /* MUST NOT LOCK TABLES */

	SELECT	ce.conversation_handle, 
			ce.is_initiator, 
			s.name as 'local_service',
			ce.far_service, 
			sc.name 'contract', 
			ce.state_desc
	  FROM	sys.conversation_endpoints ce
			LEFT JOIN sys.services s ON ce.service_id = s.service_id
			LEFT JOIN sys.service_contracts sc ON ce.service_contract_id = sc.service_contract_id;

RETURN @@ERROR


/* Queue information */ 
/* Moved to storedprocedures project */
CREATE PROCEDURE GetServiceBrokerTransmissionQueueInfo
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; /* MUST NOT LOCK TABLES */

	select	tq.from_service_name, tq.to_service_name, tq.service_contract_name, tq.transmission_status
	  from	sys.transmission_queue tq;

RETURN @@ERROR


----------------------------------------------

EXEC GetServiceBrokerServiceInfo;
EXEC GetServiceBrokerConversationInfo;
EXEC GetServiceBrokerTransmissionQueueInfo; 

/* Zeitgeist specific queue information */
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; /* MUST NOT LOCK TABLES */
select 'Send Zeitgeist Event Queue' AS 'QueueName', message_type_name, status, count(*) 'count'
  from [//bbc.co.uk/dna/SendZeitgeistEventQueue]
 group by message_type_name, status; 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; /* MUST NOT LOCK TABLES */
select 'Receive Zeitgeist Event Queue' AS 'QueueName', message_type_name, status, count(*) 'count'
  from [//bbc.co.uk/dna/ReceiveZeitgeistEventQueue]
 group by message_type_name, status; 