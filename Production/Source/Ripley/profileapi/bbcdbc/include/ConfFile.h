/******************
class CConfFile

Author:		Igor Loboda
Created:	5/08/02
Purpose:	This class could be used to read configuration file and to get a 
			configuration string from it and to cache the configuration file.
			Maximum file size allowed is 8191 bytes
*******************/

#ifndef CONFFILE_H
#define CONFFILE_H

#include <Dll.h>

#define CONFIG_FILE_BUFFER 8192
#define DEFAULT_FILE_NAME "etc/DBConnection.conf"

class CConfiguration;

class DllExport CConfFile
{
	private:
		char m_FileData[CONFIG_FILE_BUFFER];

	public:
		CConfFile(const char* pFileName) ;
		CConfFile() { m_FileData[0] = 0; }
		bool Load(const char* pFileName = DEFAULT_FILE_NAME);

		bool GetConfiguration(const char *connName, const char* connectMethod, CConfiguration& conf);
		bool GetConfiguration(const char *connName, unsigned int uiIndex, const char* connectMethod, CConfiguration& conf);
};

#endif
