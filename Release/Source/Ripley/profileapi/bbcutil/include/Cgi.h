#ifndef WIN32

#ifndef CGI_H
#define CGI_H

#include <map>
#include <sstream.h>
#include <string>

using namespace std;

namespace bbc
{
	/********************************************************************************* 
	class CCgi
	
	Author:		Igor Loboda
	Created:	4/10/02
	Purpose:	Facilitates query string handling. Ment to be used by CGI c++ scripts.
	*********************************************************************************/ 
	
	class CCgi
	{
		protected:
			typedef map<string, string> ParamsMap;
			ParamsMap m_Params;
			stringstream m_Query;
			
		public:
			CCgi();
			bool GetParam(const char* pParamName, string& value);
	};
}

#endif

#endif //WIN32
