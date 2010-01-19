#ifndef CODE_H
#define CODE_H

#include <Str.h>
#include <SimpleTemplates.h>
#include <Dll.h>


/*********************************************************************************
class CCode
Author:		Igor Loboda
Created:	7/1/2003
Purpose:	code description (see code_ref table)
*********************************************************************************/

class DllExport CCode
{
	protected:
		CStr m_Code;
		CStr m_CodeDesc;
		
	public:
		CCode(const char* pCode, const char* pCodeDesc);
		const char* GetCode() const;
		const char* GetDescription() const;
};


/*********************************************************************************
inline const char* CCode::GetCode(CStr& code) const
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	code code
*********************************************************************************/

inline const char* CCode::GetCode() const
{
	return m_Code;
}


/*********************************************************************************
inline const char* CCode::GetDescription() const
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	code description
*********************************************************************************/

inline const char* CCode::GetDescription() const
{
	return m_CodeDesc;
}


/*********************************************************************************
class CCodes
Author:		Igor Loboda
Created:	7/1/2003
Purpose:	Keeps list of codes from code_ref.
*********************************************************************************/

class DllExport CCodes : public CSimplePtrList<CCode>
{
};

#endif
