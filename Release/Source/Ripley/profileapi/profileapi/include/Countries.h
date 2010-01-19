#ifndef COUNTRIES_H
#define COUNTRIES_H

#include <Str.h>
#include <SimpleTemplates.h>
#include <Dll.h>

/*******************************************************************************************
class CCountry
Author:		Igor Loboda
Created:	20/06/2005
Purpose:	holds country information
*******************************************************************************************/

class DllExport CCountry
{
	private:
		CStr m_sName;
		CStr m_sShortName;
		int m_iId;

	public:
		CCountry();
		void Clear();
		
		const char* GetName() const { return m_sName; }
		const char* GetShortName() const { return m_sShortName; }
		int GetId() const { return m_iId; }
	
		void SetId(int iId);
		void SetName(const char* pName);
		void SetShortName(const char* pShortName);
};


/*******************************************************************************************
class CCountries
Author:		Igor Loboda
Created:	20/06/2005
Purpose:	holds list of countries 
*******************************************************************************************/

class DllExport CCountries : public CSimplePtrMap<int, CCountry>
{
};

#endif
