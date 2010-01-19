#ifndef PROFILE_ERROR_MESSAGE_H
#define PROFILE_ERROR_MESSAGE_H

#define PEN_DB_ERROR						1
#define PEN_CANT_READ_CONF_FILE				2
#define PEM_CANT_READ_CONF_FILE				"Can not read db configuration file"
#define PEN_OBJECT_NOT_INITIALISED 			3
#define PEM_OBJECT_NOT_INITIALISED			"Initialise() method must be called before any other methods"
#define PEN_CANNOT_CONNECT_TO_DB			4
#define PEM_CANNOT_CONNECT_TO_DB			"Can not connect to profile database"
#define PEN_CODE_NOT_FOUND					5
#define PEM_CODE_NOT_FOUND					"Given code not found"
#define PEN_CONNECTION_CLOSED				6
#define PEM_CONNECTION_CLOSED				"Connection to profile database is closed"
#define PEN_SERVICE_NOT_FOUND				7
#define PEM_SERVICE_NOT_FOUND				"Service \"%s\" not found"
#define PEN_SERVICE_NOT_SET					8
#define PEM_SERVICE_NOT_SET					"Service has not been set and operation requires it"
#define PEN_USER_NOT_FOUND					9
#define PEM_USER_NOT_FOUND					"User not found"
#define PEN_INVALID_PARAM					10
#define PEM_INVALID_PARAM					"Invalid parameter"
#define PEN_USER_PASSWORD_INCORRECT			11
#define PEM_USER_PASSWORD_INCORRECT			"Password incorrect for the user"
#define PEN_INVALID_COOKIE					12
#define PEM_INVALID_COOKIE					"The cookie has an invalid structure"
#define PEN_ATTRIBUTE_VALUE_NOT_FOUND		13
#define PEM_ATTRIBUTE_VALUE_NOT_FOUND		"User profile attribute value \"%s\" not found"
#define PEN_NOT_REGED_FOR_ATT				14
#define PEM_NOT_REGED_FOR_ATT				"Attribute \"%s\" does not exist or service \"%s\" is not registered to use the attribute"
#define PEN_NOT_PROVIDER					15
#define PEM_NOT_PROVIDER					"The service \"%s\" is not provider for attribute \"%s\": the service can't change attribute value, visibility or validity"
#define PEN_SET_METHOD_INVALID				16
#define PEM_SET_METHOD_INVALID				"Can't use SET statements to update master database. Replication will not work."
#define PEN_NO_DATA_PROVIDED				17
#define PEM_NO_DATA_PROVIDED				"Data is not provided"
#define PEN_NOT_FOUND						18
#define PEM_NOT_FOUND						"Not found"
#define PEN_WARNINGCODE_NOTFOUND			19
#define PEM_WARNINGCODE_NOTFOUND			"Warning code \"%s\" not found"
#define PEN_USER_NOT_AUTHENTICATED			20
#define PEM_USER_NOT_AUTHENTICATED			"Call SetUser method before calling this method"
#define PEN_SAME_USER						21
#define PEM_SAME_USER						"The requested user is the same as the current one."
#define PEN_REQUEST_NOT_FOUND				22
#define PEM_REQUEST_NOT_FOUND				"User to user request not found: it does not exist or is " \
											"closed (responded) or the current user is not a destination user"
#define PEN_SCRATCHPAD_NOT_FOUND			23
#define PEM_SCRATCHPAD_NOT_FOUND			"Scratchpad entry \"%s\" not found"							
#define PEN_ACCESS_DENIED					24
#define PEM_ACCESS_DENIED					"The current service's access to the method is denied"
#define PEN_NOT_ADMIN_USER					25
#define PEM_NOT_ADMIN_USER					"The user is not AdminUser"
#define PEN_ADMIN_USER_NOT_AUTHENTICATED	26
#define PEM_ADMIN_USER_NOT_AUTHENTICATED	"Admin user is not set"
#define PEN_INTERNAL_ERROR					27
#define PEM_INTERNAL_ERROR					"Internal error"
#define PEN_COOKIE_EXPIRED					28
#define PEM_COOKIE_EXPIRED					"Cookie expired"
#define PEN_PASSWORD_CONSTRAINTS			29
#define PEM_PASSWORD_CONSTRAINTS			"Password contraints check failed"
#define PEN_CANT_ENCRYPT_PASSWORD			30
#define PEM_CANT_ENCRYPT_PASSWORD			"Can't encrypt password"
#define PEN_USER_NAME_TAKEN					31
#define PEM_USER_NAME_TAKEN					"User name \"%s\" already taken"
#define PEN_SERVICE_TYPE					32
#define PEM_SERVICE_TYPE					"Operation can't be performed for this type of service (Secure/non secure)"

#define PEN_ATTRIBUTE_NOT_FOUND				34
#define PEM_ATTRIBUTE_NOT_FOUND				"Attribute \"%s\" not found"
#define PEN_ALREADY_INITIALISED				35
#define PEM_ALREADY_INITIALISED				"The object is already initialised"
#define PEN_MESSAGE_NOT_FOUND				36
#define PEM_MESSAGE_NOT_FOUND				"Message not found"
#define PEN_TRANSACTION_PENDING				37
#define PEM_TRANSACTION_PENDING				"Transaction pending"
#define PEN_SYMBOL_RESERVED					38
#define PEM_SYMBOL_RESERVED					"Symbol is reserved"
#define PEN_USERNAME_CONSTRAINTS			39
#define PEM_USERNAME_CONSTRAINTS			"User name \"%s\" contraints check failed"
#define PEN_USER_NOT_REGISTERED_FOR_SERVICE	40
#define PEM_USER_NOT_REGISTERED_FOR_SERVICE	"User is not registered for the service"
#define PEN_COOKIE_INVALIDATED				41
#define PEM_COOKIE_INVALIDATED				"Cookie invalidated"
#define PEN_ALREADY_REGISTERED				42
#define PEM_ALREADY_REGISTERED				"Already registered"
#define PEN_TOO_OLD							43
#define PEM_TOO_OLD							"User is too old for the service"
#define PEN_TOO_YOUNG						44
#define PEM_TOO_YOUNG						"User is too young for the service"
#define PEN_MEMORY							45
#define PEM_MEMORY							"Memory allocation error"


//all derived libraries should define their error codes to be unsigned long numbers greater than 
//PEN_MAX. This is to ensure that error codes will not clash with error codes defined in 
//Profile Api. All number less or equal to PEN_MAX are served and should not be used 
//by derived libraries.

#define PEN_MAX								500		

#endif
