#ifndef CONSTANTS_H
#define CONSTANTS_H

#ifdef WIN32
	#define DEFAULT_CONFIG_FILE			"etc\\DBConnection.conf"
#else
	#define DEFAULT_CONFIG_FILE			"etc/DBConnection.conf"
#endif

#define CUD_ID_LENGTH 32

#define ADMIN_COOKIE_NAME                     "ADM-UID"
#define ADMIN_COOKIE_LIFE_TIME		60 * 60				//one hour in seconds


#endif
