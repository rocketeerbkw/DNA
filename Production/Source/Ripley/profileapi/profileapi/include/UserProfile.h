#ifndef USERPROFILE_H
#define USERPROFILE_H

#include <ProfileValue.h>
#include <SimpleTemplates.h>
#include <Dll.h>


/*******************************************************************************************
class CUserProfile : public CSimplePtrMap<CStr, CProfileValue>
Author:		Igor Loboda
Created:	18/03/2003
Purpose:	holds user profile - map of attribute names to attribute values
*******************************************************************************************/

class DllExport CUserProfile : public CSimplePtrMap<CStr, CProfileValue>
{
	public:
		const CProfileValue* GetValue(const char* pAttributeName) const;
		CProfileValue* GetValue(const char* pAttributeName);
		bool SetValue(CProfileValue*);
};

#endif
