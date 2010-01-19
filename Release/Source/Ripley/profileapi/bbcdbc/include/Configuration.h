#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <stdlib.h>
#include <Dll.h>

/******************
class CConfiguration

Author:		Igor Loboda
Created:	5/08/02
Purpose:	This class provides access to configuration information. It is fed with
			configuration string 
			(e.g.host=,user=asds,passwd=fsad,db=fsdb,port=,socket=/tmp/mysql.IRIS.sock,logerr=yes,logfile=log/DBConnection.err)
			by calling SetConfStr.
			It contains pairs of key-value separated by comma. If value is not specified it
			is treated as empty string. (e.g. port = "")
			The configuration string is stored in the internal buffer. Methods like
			Get and GetInt take the key as a parameter and return value of that key.
*******************/

class DllExport CConfiguration
{
	protected:
	char* m_pConfStr;
	int m_iStrLen;

	public:
	CConfiguration(){m_pConfStr = NULL; m_iStrLen = 0;};
	~CConfiguration();
	void SetConfStr(const char* pConf, int len = -1);
	const char* Get(const char* key) const;
	bool GetInt(const char* key, int& number) const;
};

#endif
