CREATE PROCEDURE getservicebrokertransmissionqueueinfo
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; /* MUST NOT LOCK TABLES */

	select	tq.from_service_name, tq.to_service_name, tq.service_contract_name, tq.transmission_status
	  from	sys.transmission_queue tq;

RETURN @@ERROR