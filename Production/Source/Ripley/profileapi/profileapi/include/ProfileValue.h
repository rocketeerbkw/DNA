#ifndef PROFILEVALUE_H
#define PROFILEVALUE_H

#include <Str.h>
#include <string.h>
#include <assert.h>
#include <Attribute.h>
#include <ProfileCodeRef.h>
#include <Dll.h>


#define PV_SERVICE_NAME_HOLDER		"@"


/*******************************************************************************************
class CProfileValue
Author:		Igor Loboda
Created:	16/04/2003
Purpose:	stores user profile value information
*******************************************************************************************/

class DllExport CProfileValue
{
	private:
		bool m_bValueIsSet;
		bool m_bValidatedFlagIsSet;
		bool m_bPublicFlagIsSet;
		int m_iNeedsValidation;
		bool m_bHasValue;
		mutable CStr m_ConversionStr;
		int m_iMandatory;
		
	protected:
		CStr m_Name;
		mutable CStr m_NormalisedName;
		CStr m_Value;
		int m_iValue;
		double m_dValue;
		bool m_bPublic;
		bool m_bValidated;
		CStr m_ValidatedDate;
		enum {value_text, value_integer, value_date, value_boolean, value_decimal} m_ValueType;
	
		
	public:
		CProfileValue();
		CProfileValue(const CProfileValue& value);
		virtual ~CProfileValue() {;}
		virtual void Clear();
		
		const char* GetName() const;
		const char* GetName(const char* pServiceName) const;
		static const char* GetName(const char* pServiceName, CStr& attributeName);
		const char* GetTextValue() const;
		const char* GetDateValue() const;
		int GetIntegerValue() const;
		double GetDecimalValue() const;
		bool GetBooleanValue() const;
		bool GetIsValidated() const;
		bool GetIsPublic()	const;
		bool GetIsMandatory() const;
		bool GetIsOptional() const;
		bool GetIsValidationRequired() const;
		bool GetIsValidationOptional() const;
		const char* GetValidatedDate() const;
		bool GetHasValue() const;

		void SetName(const char* pName);
		void SetTextValue(const char* pValue);
		void SetDateValue(const char* pValue);
		void SetIntegerValue(int iValue);
		void SetBooleanValue(bool bValue);
		void SetDecimalValue(double dValue);
		void SetIsPublic(bool bPublic);
		void SetIsValidated(bool bValidated);
		void SetValidatedDate(const char* pValidatedDate);
		void SetNeedsValidation(int iNeedsValidation);
		void SetHasValue(bool bHasValue);
		void SetIsMandatory(int iIsMandatory);
		
		bool IsValueChanged() const;
		bool IsValidatedFlagChanged() const;
		bool IsPublicFlagChanged() const;
		
		static bool IsDataTypeText(const char* pType);
		static bool IsDataTypeInteger(const char* pType);
		static bool IsDataTypeDate(const char* pType);
		static bool IsDataTypeDecimal(const char* pType);
		static bool IsDataTypeBoolean(const char* pType);
		
		
	protected:
		bool IsString() const;
		bool IsLong() const;
		bool IsDouble() const;
};


/*******************************************************************************************
inline const char* CProfileValue::GetName() const
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Returns:	user profile attribute name
*******************************************************************************************/

inline const char* CProfileValue::GetName() const
{
	return m_Name;
}


/*******************************************************************************************
inline bool CProfileValue::GetHasValue() const
Author:		Igor Loboda
Created:	20/04/2003
Visibility:	public
Returns:	true if this object has attribute value in it == this value is present in
			the user's profile
*******************************************************************************************/

inline bool CProfileValue::GetHasValue() const
{
	return m_bHasValue;
}


/*******************************************************************************************
inline bool CProfileValue::GetIsValidationRequired() const
Author:		Igor Loboda
Created:	07/05/2003
Visibility:	public
Returns:	true if this attribute requires validation
*******************************************************************************************/

inline bool CProfileValue::GetIsValidationRequired() const
{
	return m_iNeedsValidation == NEEDS_VALIDATION_YES;
}


/*******************************************************************************************
inline bool CProfileValue::GetIsValidationOptional() const
Author:		Igor Loboda
Created:	28/07/2003
Visibility:	public
Returns:	true if this attribute requires validation
*******************************************************************************************/

inline bool CProfileValue::GetIsValidationOptional() const
{
	return m_iNeedsValidation == NEEDS_VALIDATION_OPTIONAL;
}


/*******************************************************************************************
inline const char* CProfileValue::GetValidatedDate() const
Author:		Igor Loboda
Created:	17/04/2003
Visibility:	public
Returns:	date when validated flag was last changed
*******************************************************************************************/

inline const char* CProfileValue::GetValidatedDate() const
{
	return m_ValidatedDate;
}


/*******************************************************************************************
inline CProfileValue::GetIsValidated(const char* pValue, bool bPublic, bool bValidated)
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Returns:	true if user profile attribute value is validated
*******************************************************************************************/

inline bool CProfileValue::GetIsValidated() const
{
	return m_bValidated;
}


/*******************************************************************************************
inline bool CProfileValue::GetIsMandatory() const
Author:		Igor Loboda
Created:	25/07/2003
Visibility:	public
Returns:	true if user profile attribute value is mandatory for given service
*******************************************************************************************/

inline bool CProfileValue::GetIsMandatory() const
{
	return m_iMandatory == MANDATORY_YES;
}


/*******************************************************************************************
inline bool CProfileValue::GetIsMandatory() const
Author:		Igor Loboda
Created:	25/07/2003
Visibility:	public
Returns:	true if user profile attribute value is mandatory for given service
*******************************************************************************************/

inline bool CProfileValue::GetIsOptional() const
{
	return m_iMandatory == MANDATORY_OPTIONAL;
}


/*******************************************************************************************
inline bool CProfileValue::GetIsPublic() const
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Returns:	true if user profile attribute value is visible to other users
*******************************************************************************************/

inline bool CProfileValue::GetIsPublic() const
{
	return m_bPublic;
}


/*******************************************************************************************
inline bool CProfileValue::IsValueChanged() const
Author:		Igor Loboda
Created:	24/04/2003
Visibility:	public
Returns:	true if value is provided for the user profile attribute
*******************************************************************************************/

inline bool CProfileValue::IsValueChanged() const
{
	return m_bValueIsSet;
}


/*******************************************************************************************
inline bool CProfileValue::IsValidatedFlagChanged() const
Author:		Igor Loboda
Created:	24/04/2003
Visibility:	public
Returns:	true if value for IsValidated flag is provided
*******************************************************************************************/

inline bool CProfileValue::IsValidatedFlagChanged() const
{
	return m_bValidatedFlagIsSet;
}


/*******************************************************************************************
inline bool CProfileValue::IsPublicFlagChanged() const
Author:		Igor Loboda
Created:	24/04/2003
Visibility:	public
Returns:	true if value for IsPublicFlag is provided
*******************************************************************************************/

inline bool CProfileValue::IsPublicFlagChanged() const
{
	return m_bPublicFlagIsSet;
}


#endif
