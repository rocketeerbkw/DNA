/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/

#include "stdafx.h"
#include "DateRangeValidation.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

CDateRangeValidation::CDateRangeValidation(CInputContext& inputContext) : CXMLObject(inputContext), m_TimeInterval(0)
{
	m_LastValidationRes = CDateRangeValidation::NOTVALIDATEDYET;
}

CDateRangeValidation::~CDateRangeValidation(void)
{
}


/*********************************************************************************

	ValidationResult CDateRangeValidation::ValidateDateRange(CTDVDateTime StartDate, CTDVDateTime EndDate, int TimeInterval = 1, bool ErrorOnFutureDates = false, bool ErrorOnInvalidTimeInterval = true, bool bCreateEndDate = true, bool bValidateTimeInterval = false)

		Author:		Mark Howitt
		Created:	18/01/2007
		Inputs:		CTDVDateTime StartDate - The start date for the range
					CTDVDateTime EndDate - The end date for the range
					int TimeInterval - An interval of time within the range.
						e.g. A day in the month of may = 1, A week in the month of may = 7.
					bool ErrorOnFutreDates - A flag that states that you want to force an error on futre dates
					bool ErrorOnInvalidTimeInterval - A flag that states whether you want to error on invalid time intervals
					bool bCreateEndDate - A flag to say that we are needed to create the end date and make it a day later than the given start date
		Outputs:	-
		Returns:	The validation result
		Purpose:	Checks to make sure the supplied date range is valid

*********************************************************************************/
CDateRangeValidation::ValidationResult CDateRangeValidation::ValidateDateRange(CTDVDateTime StartDate, CTDVDateTime EndDate, int TimeInterval, bool ErrorOnFutureDates, bool ErrorOnInvalidTimeInterval, bool bValidateTimeInterval)
{
	// Set the member variables to the supplied values;
	m_StartDate = StartDate;
	m_EndDate = EndDate;
	m_TimeInterval = TimeInterval;

	// Check to make sure the start date is valid
	if (!m_StartDate.GetStatus())
	{
		SetDNALastError("CDateRangeValidation::ValidateDateRange","StartDateInvalid","Start date is invalid");
		return SetLastValidationResult(STARTDATE_INVALID);
	}

	// Check to make sure the end date is valid
	if (!m_EndDate.GetStatus())
	{
		SetDNALastError("CDateRangeValidation::ValidateDateRange","EndDateInvalid","End date is invalid");
		return SetLastValidationResult(ENDDATE_INVALID);
	}

	// Check to see if the dates are within valid datetime ranges for the database. 
    if (!m_StartDate.IsWithinDBSmallDateTimeRange())
    {
		// Invalid information given
        SetDNALastError("CDateRangeValidation::ValidateDateRange","StartDateInvalid","Start date is invalid");
		return SetLastValidationResult(STARTDATE_INVALID);
    }

	if (!m_EndDate.IsWithinDBSmallDateTimeRange())
	{
		SetDNALastError("CDateRangeValidation::ValidateDateRange","EndDateInvalid","End date is invalid");
		return SetLastValidationResult(ENDDATE_INVALID);
	}

	// Now check to see if we're worried about fututre dates
	if (ErrorOnFutureDates)
	{
		// Check to see if the start date is in the future
		CTDVDateTime CurrentDate(COleDateTime::GetCurrentTime());
		if (m_StartDate > CurrentDate)
		{
			SetDNALastError("CDateRangeValidation::ValidateDateRange","StartDateInTheFuture","Start date is in the future");
			return SetLastValidationResult(FUTURE_STARTDATE);
		}

		// Now check to see if the end date is in the future
		if (m_EndDate > CurrentDate)
		{
			SetDNALastError("CDateRangeValidation::ValidateDateRange","EndDateInTheFuture","End date is in the future");
			return SetLastValidationResult(FUTURE_ENDDATE);
		}
	}

	// Check tyo make sure the start date is not the same as the end date
	if (m_StartDate == m_EndDate)
	{
		SetDNALastError("CDateRangeValidation::ValidateDateRange","StartDateEqualsEndDate","Start date equals end date");
		return SetLastValidationResult(STARTDATE_EQUALS_ENDDATE);
	}

	// Check tomake sure that the start date is before the end date
	if (m_StartDate > m_EndDate)
	{
		SetDNALastError("CDateRangeValidation::ValidateDateRange","StartDateGreaterThanEndDate","Start date greater than end date");
		return SetLastValidationResult(STARTDATE_GREATERTHAN_ENDDATE);
	}

	// If dealing with fuzzy dates
	if (m_TimeInterval < 1 && bValidateTimeInterval)
	{ 
		SetDNALastError("CDateRangeValidation::ValidateDateRange","Timeinterval invalid","The timeinterval is less than 1.");
		return SetLastValidationResult(TIMEINTERVAL_INVALID);
	}

	// Check to see if we want invalid time intervals as errors
	if (ErrorOnInvalidTimeInterval)
	{
		// Check to make sure the interval is smaller or equal to the difference in dates
		int ElapsedDaysDiff = (int)(m_EndDate.m_dt - m_StartDate.m_dt);
		if (ElapsedDaysDiff < TimeInterval)
		{
			SetDNALastError("CDateRangeValidation::ValidateDateRange","TimeIntervalInvalid","Time interval invalid for date range");
			return SetLastValidationResult(TIMEINTERVAL_INVALID);
		}
	}

	// Make sure the last dna error gets removed.
	ClearError();

	// Got here? valid date range and interval
	return SetLastValidationResult(VALID);
}

/*********************************************************************************

	CDateRangeValidation::ValidationResult CDateRangeValidation::SetLastValidationResult(CDateRangeValidation::ValidationResult res)

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		A result code
		Outputs:	-
		Returns:	The same code that's passed in
		Purpose:	Helper func for storing the last validation result the class has made

*********************************************************************************/

CDateRangeValidation::ValidationResult CDateRangeValidation::SetLastValidationResult(CDateRangeValidation::ValidationResult res)
{
	m_LastValidationRes = res;
	return m_LastValidationRes;
}
