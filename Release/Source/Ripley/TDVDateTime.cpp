/*
Implementation file for CTDVDateTime object
*/


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
#include ".\tdvdatetime.h"
#include ".\tdvassert.h"
#include "TimeZoneManager.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

/* Construction
*/

CTDVDateTime::CTDVDateTime()
{
}

CTDVDateTime::~CTDVDateTime()
{
}

CTDVDateTime::CTDVDateTime(const COleDateTime& dValue) : COleDateTime(dValue)
{
}

CTDVDateTime::CTDVDateTime(int Year, int Month, int Day, int Hour, int Minute, int Second) : COleDateTime(Year, Month, Day, Hour, Minute, Second)
{
	// No further initialisation
}

/********************************************************************************
 * Constructor
 * Inititialise from windows SYSTEMTIME structure
 ********************************************************************************/
CTDVDateTime::CTDVDateTime(const SYSTEMTIME& systemtime) : COleDateTime(systemtime)
{

}

CTDVDateTime::CTDVDateTime(const FILETIME& filetime) : COleDateTime(filetime)
{

}

CTDVDateTime::CTDVDateTime(int NumSeconds)
{
	*this = CTDVDateTime::GetCurrentTime();
	*this -= COleDateTimeSpan(0,0,0,NumSeconds);
}


/*********************************************************************************

	bool CTDVDateTime::SetFromString(const TDVCHAR* pDate)

		Author:		Someone
        Created:	02/08/2004
        Inputs:		pDate - The string that you want to initialise this object with!
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Initialises the object from a string.
					The string should be in the following format...
                    
					YYYYMMDDHHMMSS

*********************************************************************************/
bool CTDVDateTime::SetFromString(const TDVCHAR* pDate)
{
	// Check to make sure we have a string of the right length
	CTDVString sDate(pDate);
	if (sDate.GetLength() != 14)
	{
		TDVASSERT(false,"CTDVDateTime::SetFromString() pDate is not the correct length to convert!!!");
		return false;
	}

	// Now parse the string for the time info
	int year = atoi(sDate.Mid(0,4));
	int month = atoi(sDate.Mid(4,2));
	int day = atoi(sDate.Mid(6,2));
	int hour = atoi(sDate.Mid(8,2));
	int minute = atoi(sDate.Mid(10,2));
	int second = atoi(sDate.Mid(12,2));
	*this = CTDVDateTime(year,month,day,hour,minute,second);

	return true;
}


bool CTDVDateTime::GetAsXML(CTDVString& sResult, bool bIncludeRelative) const
{
	try
	{
		if (GetYear() >= 1900)
		{
		    sResult = "<DATE";
		    sResult << (LPCSTR)Format(" DAYNAME='%A'");
		    sResult << (LPCSTR)Format(" SECONDS='%S'");
		    sResult << (LPCSTR)Format(" MINUTES='%M'");
		    sResult << (LPCSTR)Format(" HOURS='%H'");
		    sResult << (LPCSTR)Format(" DAY='%d'");
		    sResult << (LPCSTR)Format(" MONTH='%m'");
		    sResult << (LPCSTR)Format(" MONTHNAME='%B'");
		    sResult << (LPCSTR)Format(" YEAR='%Y'");
		    sResult << (LPCSTR)Format(" SORT='%Y%m%d%H%M%S'");
		    
		    if (bIncludeRelative)
		    {
			    CTDVString sRelative;
			    GetRelativeDate(sRelative);
			    sResult << " RELATIVE='" << sRelative << "'";
		    }
            sResult << ">";

            //Add Local Time   
            SYSTEMTIME l,utc;
            GetAsSystemTime(utc);
            CTimeZoneManager::GetTimeZoneManager()->ConvertToLocalTime(utc,l);
            CTDVDateTime local(l);

            sResult << "<LOCAL";
            sResult << (LPCSTR)local.Format(" DAYNAME='%A'");
		    sResult << (LPCSTR)local.Format(" SECONDS='%S'");
		    sResult << (LPCSTR)local.Format(" MINUTES='%M'");
		    sResult << (LPCSTR)local.Format(" HOURS='%H'");
		    sResult << (LPCSTR)local.Format(" DAY='%d'");
		    sResult << (LPCSTR)local.Format(" MONTH='%m'");
		    sResult << (LPCSTR)local.Format(" MONTHNAME='%B'");
		    sResult << (LPCSTR)local.Format(" YEAR='%Y'");
		    sResult << (LPCSTR)local.Format(" SORT='%Y%m%d%H%M%S'");

            if (bIncludeRelative)
		    {
                //Relative times worked out in GMT but resultultant date is converted to local
			    CTDVString sRelative;
			    GetRelativeDateLocal(sRelative);
			    sResult << " RELATIVE='" << sRelative << "'";
		    }

		    sResult << "></LOCAL></DATE>";
		}
		else
		{
			sResult="<DATE DAYNAME='Monday' SECONDS='0' MINUTES='0' HOURS='0' DAY='31' MONTH='12' MONTHNAME='December' YEAR='1899' SORT='18991231000000' RELATIVE='Unknown'>";
            sResult << "<LOCAL DAYNAME='Monday' SECONDS='0' MINUTES='0' HOURS='0' DAY='31' MONTH='12' MONTHNAME='December' YEAR='1899' SORT='18991231000000' RELATIVE='Unknown'></LOCAL></DATE>";
		}
	}
	catch(...)
	{
		return false;
	}

	return true;
}

bool CTDVDateTime::GetRelativeDate(CTDVString& sResult) const
{
    //Gets current time based on settings of local machine.
	COleDateTime curTime = COleDateTime::GetCurrentTime();
	COleDateTimeSpan Difference = curTime - (COleDateTime)(*this);

	// Now do all the relative stuff
	int iTotalSeconds = (int)Difference.GetTotalSeconds();
	int iTotalMinutes = (int)Difference.GetTotalMinutes();
	int iTotalHours = (int)Difference.GetTotalHours();
	int iTotalDays = (int)Difference.GetTotalDays();
	
	if (iTotalSeconds < 60)
	{
		sResult << "Just Now";
	}
	else if (iTotalMinutes < 60)
	{
		if (iTotalMinutes == 1)
		{
			sResult << "1 Minute Ago";
		}
		else
		{
			sResult << iTotalMinutes 
					<< " Minutes Ago";
		}
	}

	else if (iTotalHours < 24)
	{
		if (iTotalHours == 1)
		{
			sResult << "1 Hour Ago";
		}
		else
		{
			sResult << iTotalHours
					<< " Hours Ago";
		}
	}

	else
	{
		long numdays = iTotalDays;
		if (numdays <= 1)
		{
			sResult << "Yesterday";
		}
		else if (numdays < 7)
		{
			sResult << numdays
					<< " Days Ago";
		}
		else if (numdays < 14)
		{
			sResult << "Last Week";
		}
		else if (numdays < 42)
		{
			long numweeks = numdays / 7;
			sResult << numweeks
					<< " Weeks Ago";
		}
		else
		{

			//sResult << "Over a year ago";
			sResult += (LPCSTR)Format("%b %#d, %Y");
		}
	}
	return true;
}

/*********************************************************************************
CTDVDateTime::GetRelativeDateLocal
Author:		Martin Robb
Created:	08/05/2008
Purpose:	GetRelativeDateLocal() .
            Works out relative dates . The time differences should be conducted in UTC
            Only the resultant date is converted to local time.
            However COleDateTime::GetCurrentTime() uses users current settings so OK
            where BST is not applied but could be error prone when BST is set on local machine.
*********************************************************************************/
bool CTDVDateTime::GetRelativeDateLocal(CTDVString& sResult) const
{
    //Gets current time based on settings of local machine.
	COleDateTime curTime = COleDateTime::GetCurrentTime();
	COleDateTimeSpan Difference = curTime - (COleDateTime)(*this);

	// Now do all the relative stuff
	int iTotalSeconds = (int)Difference.GetTotalSeconds();
	int iTotalMinutes = (int)Difference.GetTotalMinutes();
	int iTotalHours = (int)Difference.GetTotalHours();
	int iTotalDays = (int)Difference.GetTotalDays();
	
	if (iTotalSeconds < 60)
	{
		sResult << "Just Now";
	}
	else if (iTotalMinutes < 60)
	{
		if (iTotalMinutes == 1)
		{
			sResult << "1 Minute Ago";
		}
		else
		{
			sResult << iTotalMinutes 
					<< " Minutes Ago";
		}
	}

	else if (iTotalHours < 24)
	{
		if (iTotalHours == 1)
		{
			sResult << "1 Hour Ago";
		}
		else
		{
			sResult << iTotalHours
					<< " Hours Ago";
		}
	}

	else
	{
		long numdays = iTotalDays;
		if (numdays <= 1)
		{
			sResult << "Yesterday";
		}
		else if (numdays < 7)
		{
			sResult << numdays
					<< " Days Ago";
		}
		else if (numdays < 14)
		{
			sResult << "Last Week";
		}
		else if (numdays < 42)
		{
			long numweeks = numdays / 7;
			sResult << numweeks
					<< " Weeks Ago";
		}
		else
		{
            //Display Date as local date
            SYSTEMTIME utc, l;
            GetAsSystemTime(utc);
            CTimeZoneManager::GetTimeZoneManager()->ConvertToLocalTime(utc,l);
            COleDateTime local(l);
			sResult += (LPCSTR)local.Format("%b %#d, %Y");
		}
	}
	return true;
}


/*********************************************************************************

	int CTDVDateTime::DaysElapsed()

	Author:		Dharmesh Raithatha
	Created:	11/6/01
	Inputs:		-
	Outputs:	-
	Returns:	the number of days that have elapsed from the given date
	Purpose:	Calculates the number of days that have elapsed from the current 
				date and the present date. Days are in whole numbers.

*********************************************************************************/

int CTDVDateTime::DaysElapsed()
{
	COleDateTime curTime = COleDateTime::GetCurrentTime();
	COleDateTimeSpan Difference = curTime - (COleDateTime)(*this);
	return  (int)Difference.GetTotalDays();
}

/*********************************************************************************

	bool CTDVDateTime::GetStatus() const

	Author:		Mark Howitt
	Created:	28/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if the date is valid, false if the date is either NULL or invalid.
	Purpose:	Checks to make sure the current date object is valid to use.

*********************************************************************************/

bool CTDVDateTime::GetStatus() const
{
	return (COleDateTime::GetStatus() == COleDateTime::valid);
}

// Gets the current TDVDateTime as a DataBase Compatible string
// If bCompact is true, it returns the dateTime without separators, i.e. YYYYMMDDHHMMSS
bool CTDVDateTime::GetAsString(CTDVString& sDateTime, bool bCompact)
{
	// Get all the different parts of the datetime
	int iYear = GetYear();
	int iMonth = GetMonth();
	int iDay = GetDay();
	int iHour = GetHour();
	int iMinutes = GetMinute();
	int iSeconds = GetSecond();

	// Put the Date into the string, starting with the year
	sDateTime.Empty();
    sDateTime << iYear;
	if (!bCompact)
	{
		sDateTime << "-";
	}

	// Now get the month, If this is 1 - 9 then we need to add an extra 0!
	if (iMonth < 10)
	{
		sDateTime << "0";
	}
	sDateTime << iMonth;
	if (!bCompact)
	{
		sDateTime << "-";
	}

	// Now get the Day, If this is 1 - 9 then we need to add an extra 0!
	if (iDay < 10)
	{
		sDateTime << "0";
	}
	sDateTime << iDay;
	if (!bCompact)
	{
		sDateTime << " ";
	}

	// Now get the Hour
	if (iHour < 10)
	{
		sDateTime << "0";
	}
	sDateTime << iHour;
	if (!bCompact)
	{
		sDateTime << ":";
	}
	
	// Now the minutes
	if (iMinutes < 10)
	{
		sDateTime << "0";
	}
	sDateTime << iMinutes;
	if (!bCompact)
	{
		sDateTime << ":";
	}

	// Now the seconds
	if (iSeconds < 10)
	{
		sDateTime << "0";
	}
	sDateTime << iSeconds;
	if (!bCompact)
	{
		sDateTime << ".000";
	}

	// We don't bother with the milli seconds!
	return true;
}
// returns the output from COLeDateTime::GetHour()
int CTDVDateTime::GetHour() const
{
	return COleDateTime::GetHour();
}

// returns the output from COLeDateTime::GetMinute()
int CTDVDateTime::GetMinute() const
{
	return COleDateTime::GetMinute();
}
/*********************************************************************************

	bool CTDVDateTime::IsWithinDBSmallDateTimeRange()

	Author:		James Conway
	Created:	10/10/2007
	Inputs:		-
	Outputs:	-
	Returns:	true if the date within range, otherwise false.
	Purpose:	Checks to make sure the current date object is within database SmallDateTime range.

*********************************************************************************/
bool CTDVDateTime::IsWithinDBSmallDateTimeRange()
{
	COleDateTime minDBSmallDateTime(1900, 1, 1, 0, 0, 0); 
	COleDateTime maxDBSmallDateTime(2079, 6, 6, 0, 0, 0); 

	if (*this < minDBSmallDateTime)
	{
		return false;
	}

	if (*this > maxDBSmallDateTime)
	{
		return false;
	}

	return true; 
}
/*********************************************************************************

	bool CTDVDateTime::IsWithinDBDateTimeRange()

	Author:		James Conway
	Created:	10/10/2007
	Inputs:		-
	Outputs:	-
	Returns:	true if the date within range, otherwise false.
	Purpose:	Checks if current date object is within database DateTime range.

*********************************************************************************/
bool CTDVDateTime::IsWithinDBDateTimeRange()
{
	COleDateTime minDBDateTime(1753, 1, 1, 0, 0, 0); 
	COleDateTime maxDBDateTime(9999, 12, 31, 0, 0, 0); 

	if (*this < minDBDateTime)
	{
		return false;
	}

	if (*this > maxDBDateTime)
	{
		return false;
	}

	return true; 
}
/*********************************************************************************

	bool CTDVDateTime::IsStringValidDDMMYYYYFormat(CTDVString s)

	Author:		James Conway
	Created:	10/10/2007
	Inputs:		-
	Outputs:	-
	Returns:	true if the date is of an acceptable format, otherwise false.
	Purpose:	Rudimentary test to see if string is likely to be of form dd/mm/yyyy - further validation should be done elsewhere.

*********************************************************************************/
bool CTDVDateTime::IsStringValidDDMMYYYYFormat(CTDVString s)
{
	// TODO: improve this validation - I don't have time to do it now. 
	int iIndex = s.ReverseFind('/');
	CTDVString sYYYY = s.Mid(iIndex + 1);
	if (sYYYY.GetLength() != 4) // year must be 4 characters
	{
		return false; 
	}

	return true; 
}


