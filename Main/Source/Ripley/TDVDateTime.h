#if !defined(_TDVDateTime_Header_File__INCLUDED_)
#define _TDVDateTime_Header_File__INCLUDED_

#include <afxdisp.h>
#include "TDVString.h"

class CTDVDateTime : public COleDateTime
{
public:
	CTDVDateTime();
	~CTDVDateTime();
	CTDVDateTime(int NumSeconds);
	CTDVDateTime(const FILETIME& filetime);
    CTDVDateTime(const SYSTEMTIME& systemtime);
	CTDVDateTime(const COleDateTime& dValue);
	CTDVDateTime(int Year, int Month, int Day, int Hour, int Minute, int Second);

    bool GetRelativeDateLocal(CTDVString& sResult) const;
    bool GetRelativeDate(CTDVString& sResult) const;

public:
	bool GetStatus() const;
	bool SetFromString(const TDVCHAR* pDateString);
	bool GetAsXML(CTDVString& sResult, bool bIncludeRelative = false) const;
	
	int DaysElapsed();
	virtual int GetHour() const;
	virtual int GetMinute() const;
	bool IsWithinDBSmallDateTimeRange(); 
	bool IsWithinDBDateTimeRange(); 
	
	// Gets the current TDVDateTime as a DataBase Compatible string
	bool GetAsString(CTDVString& sDateTime, bool bCompact=false);

	static bool IsStringValidDDMMYYYYFormat(CTDVString s);
};

#endif