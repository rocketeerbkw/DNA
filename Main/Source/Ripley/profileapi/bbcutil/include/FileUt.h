#ifndef WIN32

#ifndef FILEUT_H
#define FILEUT_H

#include <string>
#include <libgen.h>

using namespace std;

namespace bbc
{
	/********************************************************************************* 
	class CFileUt
	
	Author:		Igor Loboda
	Created:	4/10/02
	Purpose:	Files and directories utilities.
	*********************************************************************************/ 
	class CFileUt
	{
		public:
			static bool GetAbsolutePath(const char* pRelativePath, string& absolutePath);
			static bool RemoveDir(const char* pDirName);
			static bool CopyFile(const char* pSrcDir, const char* pSrcFile, const char* pDestDir);
			static bool MakeDir(const char* pDir, mode_t mode);
	};

}
	
#endif

#endif //not WIN32
