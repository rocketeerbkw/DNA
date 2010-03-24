#pragma once

#include "TDVDateTime.h"
#include "xmlobject.h"

class CDateRangeValidation : public CXMLObject
{
public:
	CDateRangeValidation(CInputContext& inputContext);
	~CDateRangeValidation(void);

	enum ValidationResult
	{
		NOTVALIDATEDYET,
		VALID,
		STARTDATE_INVALID,
		ENDDATE_INVALID,
		STARTDATE_EQUALS_ENDDATE,
		STARTDATE_GREATERTHAN_ENDDATE,
		TIMEINTERVAL_INVALID,
		FUTURE_STARTDATE,
		FUTURE_ENDDATE
	};

	CDateRangeValidation::ValidationResult ValidateDateRange(CTDVDateTime StartDate, CTDVDateTime EndDate, int TimeInterval = 1, bool ErrorOnFutureDates = true, bool ErrorOnInvalidTimeInterval = true, bool bValidateTimeInterval = false);

	CTDVDateTime GetStartDate()	{ return m_StartDate;}
	CTDVDateTime GetEndDate()	{ return m_EndDate;}
	int			 GetTimeInterval()	{ return m_TimeInterval;}

	CDateRangeValidation::ValidationResult GetLastValidationResult() { return m_LastValidationRes; }

	CDateRangeValidation::ValidationResult SetLastValidationResult(CDateRangeValidation::ValidationResult res);

private:
	CTDVDateTime m_StartDate;
	CTDVDateTime m_EndDate;
	int m_TimeInterval;

	CDateRangeValidation::ValidationResult m_LastValidationRes;
};
