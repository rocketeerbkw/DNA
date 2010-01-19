#ifndef INCLAUSE_H
#define INCLAUSE_H

#include <Str.h>
#include <SimpleTemplates.h>
#include <Dll.h>


/*******************************************************************************************
class CInClause : public CSimpleSet<CStr>
Author:		Igor Loboda
Created:	22/04/2003
Purpose:	User this class to specify a list of attribute names in order to be able to address
			a specific subset of user profile attributes more than one attribute and less than
			all user profile attributes.
*******************************************************************************************/

class DllExport CInClause : public CSimpleSet<CStr>
{
	protected:
		CStr m_NamesForSql;
	
	public:
		CInClause(const char* pNames);
		const char* GetSql();
};



#endif
