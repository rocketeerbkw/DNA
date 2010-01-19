#ifndef WIN32

#ifndef DIRSCANER
#define DIRSCANER

#include <string>
#include <stack>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <errno.h>

using namespace std;

namespace bbc
{
	
	/********************************************************************************* 
	class CDirInfo

	Author:		Igor Loboda
	Created:	4/10/02
	Purpose:	Directory information Container
	*********************************************************************************/ 
	class CDirInfo
	{
		public:
			string m_Name;
			DIR* m_pDIR;
			
		public:
			CDirInfo(DIR* pDIR, const char* name)
			{
				m_pDIR = pDIR;
				m_Name = name;
			}
	};

	/********************************************************************************* 
	class CDirScanner

	Author:		Igor Loboda
	Created:	4/10/02
	Purpose:	Facilitates recursive scaning of directories and search for files with 
				certain extensions and it was search in just one flat directory. First, 
				set list of extensions. Every extension must have semicolon before it and 
				after it (e.g. ";.h;.cc;.c;.cpp;"). Second, call FindFirst method to get the
				first file from the directory structure. Third, call FindNext method to
				get the other files from directory structure one by one.
	*********************************************************************************/ 
	class CDirScanner
	{
		protected:
			string m_Ext;		
			typedef stack<CDirInfo*> CDIRStack;
			CDIRStack m_DirStack;

		public:
			CDirScanner(const char* pExt);
			~CDirScanner();
			bool FindNext(string& foundDir, string& foundName);
			bool FindFirst(const char* pStartDir, string& foundDir, string& foundName);
			virtual bool ConformsPattern(const char* name);
	
		private:
			bool Find(const char* pStartDir, const char* pSubDir, string& foundDir, string& foundName);
			bool Find(DIR* pDIR, const char* pDirName, string& foundDir, string& foundName, bool takeFromStack = false);
			void PushDir(DIR* pDir, const char* name);
			void PopDir();
	};

}
#endif

#endif //not WIN32
