#ifndef ATTRIBUTE_H
#define ATTRIBUTE_H

#include <Str.h>
#include <SimpleTemplates.h>
#include <Dll.h>


#define NEEDS_VALIDATION_NO			1
#define NEEDS_VALIDATION_YES		2
#define NEEDS_VALIDATION_OPTIONAL	3
#define NEEDS_VALIDATION_NO_STR			"1"
#define NEEDS_VALIDATION_YES_STR		"2"
#define NEEDS_VALIDATION_OPTIONAL_STR	"3"


#define MANDATORY_NO		1
#define MANDATORY_YES		2
#define MANDATORY_OPTIONAL	3
#define MANDATORY_NO_STR		"1"
#define MANDATORY_YES_STR		"2"
#define MANDATORY_OPTIONAL_STR	"3"


/*******************************************************************************************
class CAttributeBase
Author:		Igor Loboda
Created:	28/05/2003
Purpose:	holds basic attribute information
*******************************************************************************************/

class DllExport CAttributeBase
{
	protected:
		CStr m_Name;
		CStr m_DataType;
		bool m_bLogChanges;
		bool m_bSystem;
				
	public:
		CAttributeBase();
		virtual ~CAttributeBase() {;}
		virtual void Clear();
		
		void SetName(const char* pName);
		void SetDataType(const char* pDataType);
		void SetLogChanges(bool bLog);
		void SetIsSystem(bool bSystem);
		
		const char* GetName() const;
		const char* GetDataType() const;
		bool GetLogChanges() const;
		bool GetIsSystem() const;
};


/*******************************************************************************************
inline bool CAttributeBase::GetIsSystem() const
Author:		Igor Loboda
Created:	28/05/2003
Visibility:	public
Returns:	true if the attribute is a system attribute
*******************************************************************************************/

inline bool CAttributeBase::GetIsSystem() const
{
	return m_bSystem;
}


/*******************************************************************************************
inline const char* CAttributeBase::GetName() const
Author:		Igor Loboda
Created:	28/05/2003
Visibility:	public
Returns:	attribute name
*******************************************************************************************/

inline const char* CAttributeBase::GetName() const
{
	return m_Name;
}


/*******************************************************************************************
inline const char* CAttributeBase::GetDataType() const
Author:		Igor Loboda
Created:	28/05/2003
Visibility:	public
Returns:	attribute data type. see DATA_TYPE
*******************************************************************************************/

inline const char* CAttributeBase::GetDataType() const
{
	return m_DataType;
}


/*******************************************************************************************
inline bool CAttributeBase::GetLogChanges() const
Author:		Igor Loboda
Created:	28/05/2003
Visibility:	public
Returns:	returns if changes of the value of this attribute should be logged
*******************************************************************************************/

inline bool CAttributeBase::GetLogChanges() const
{
	return m_bLogChanges;
}


/*******************************************************************************************
class CAttribute : public CAttributeBase
Author:		Igor Loboda
Created:	28/05/2003
Purpose:	holds basic attribute information and an attribute description
*******************************************************************************************/

class DllExport CAttribute : public CAttributeBase
{
	protected:
		CStr m_Description;
				
	public:
		CAttribute();
		void Clear();
		
		void SetDescription(const char* pDescription);
		const char* GetDescription() const;
};


/*******************************************************************************************
inline const char* CAttribute::GetDescription() const
Author:		Igor Loboda
Created:	28/05/2003
Visibility:	public
Returns:	attribute description
*******************************************************************************************/

inline const char* CAttribute::GetDescription() const
{
	return m_Description;
}


/*******************************************************************************************
class CAttributes : public CSimplePtrList <CAttribute>
Author:		Igor Loboda
Created:	28/05/2003
Purpose:	holds a list of pointers to CAttribute object
*******************************************************************************************/

class DllExport CAttributes : public CSimplePtrList <CAttribute>
{
};


/*******************************************************************************************
class CServiceAttribute : public CAttributeBase
Author:		Igor Loboda
Created:	28/05/2003
Purpose:	Holds basic attribute information and service specific attribute information
*******************************************************************************************/

class DllExport CServiceAttribute : public CAttributeBase
{
	protected:
		int m_iMandatory;
		int m_iNeedsValidation;
		bool m_bProvider;
		
	public:
		CServiceAttribute();
		void Clear();
		
		void SetIsMandatory(int iIsMandatory);
		void SetNeedsValidation(int iNeedsValidation);
		void SetIsProvider(bool bProvider);
		
		bool GetIsMandatory() const;
		bool GetIsOptional() const;
		bool GetIsValidationRequired() const;
		bool GetIsValidationOptional() const;
		bool GetIsProvider() const;
		
		static bool IsMandatoryFlagValueValid(int iMandatoryFlag);
		static bool IsNeedsValidationFlagValueValid(int iValidationFlag);
};


/*******************************************************************************************
inline bool CServiceAttribute::GetIsMandatory() const
Author:		Igor Loboda
Created:	25/07/2003
Visibility:	public
Returns:	true if user profile attribute value is mandatory for given service
*******************************************************************************************/

inline bool CServiceAttribute::GetIsMandatory() const
{
	return m_iMandatory == MANDATORY_YES;
}


/*******************************************************************************************
inline bool CServiceAttribute::GetIsMandatory() const
Author:		Igor Loboda
Created:	25/07/2003
Visibility:	public
Returns:	true if user profile attribute value is mandatory for given service
*******************************************************************************************/

inline bool CServiceAttribute::GetIsOptional() const
{
	return m_iMandatory == MANDATORY_OPTIONAL;
}


/*******************************************************************************************
inline bool CServiceAttribute::GetIsValidationRequired() const
Author:		Igor Loboda
Created:	07/05/2003
Visibility:	public
Returns:	true if this attribute requires validation
*******************************************************************************************/

inline bool CServiceAttribute::GetIsValidationRequired() const
{
	return m_iNeedsValidation == NEEDS_VALIDATION_YES;
}


/*******************************************************************************************
inline bool CServiceAttribute::GetIsValidationOptional() const
Author:		Igor Loboda
Created:	28/07/2003
Visibility:	public
Returns:	true if this attribute requires validation
*******************************************************************************************/

inline bool CServiceAttribute::GetIsValidationOptional() const
{
	return m_iNeedsValidation == NEEDS_VALIDATION_OPTIONAL;
}


/*******************************************************************************************
inline bool CServiceAttribute::GetIsProvider() const
Author:		Igor Loboda
Created:	28/05/2003
Visibility:	public
Returns:	true if the service is a provider for this attribute value
*******************************************************************************************/

inline bool CServiceAttribute::GetIsProvider() const
{
	return m_bProvider;
}


/*******************************************************************************************
class CServiceAttributes : public CSimplePtrList <CServiceAttribute>
Author:		Igor Loboda
Created:	28/05/2003
Purpose:	holds a list of pointer to CServiceAttribute objects
*******************************************************************************************/

class DllExport CServiceAttributes : public CSimplePtrList <CServiceAttribute>
{
};

#endif
