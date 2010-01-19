CREATE PROCEDURE getservicebrokerconversationinfo
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